"""
==========================================================
File Name          : app_api.py
Description        : FastAPI REST API Server for Clinical AI Chatbot (RAG Engine)
Dependencies       : fastapi, uvicorn, pydantic, rag_engine
==========================================================
"""

import os
import sys
import uuid
import re
from typing import Optional, Dict, List, Any
from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

# Ensure local directory is in Python path for importing rag_engine
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
if CURRENT_DIR not in sys.path:
    sys.path.insert(0, CURRENT_DIR)

# Import RAG Engine pipeline (Pure RAG engine without GUI/Streamlit dependencies)
try:
    from rag_engine import MedicalPDFRAG, is_arabic_text
except ImportError as e:
    raise ImportError(f"Failed to import rag_engine from {CURRENT_DIR}: {e}")


# ==========================================================
# 1. Setup FastAPI Application & CORS Middleware
# ==========================================================
app = FastAPI(
    title="Medical Safety System — Clinical RAG Backend API",
    description="RESTful API for Clinical AI Assistant powering multi-turn RAG consultation and specialty referral.",
    version="1.0.0"
)

# Enable CORS middleware for all origins to allow Flutter/React/Web frontend integration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ==========================================================
# 2. Define Request & Response Schemas
# ==========================================================
class ChatRequest(BaseModel):
    user_prompt: str = Field(..., description="User symptom description or clinical follow-up answer")
    session_id: Optional[str] = Field(None, description="Optional session ID for multi-turn conversation tracking")

    model_config = {
        "json_schema_extra": {
            "example": {
                "user_prompt": "أعاني من ألم في الأذن ونغزات بالزور عند البلع",
                "session_id": "c1f7b8a2-93e4-4d82-b714-82a1290fa112"
            }
        }
    }


class ChatResponse(BaseModel):
    response: str = Field(..., description="Generated clinical response from RAG pipeline")
    specialty: Optional[str] = Field(None, description="Recommended medical specialty")
    session_id: str = Field(..., description="Active session ID for tracking consultation history")
    snippets: List[Dict[str, Any]] = Field(default=[], description="Retrieved PDF source evidence snippets")
    is_final: bool = Field(default=False, description="Flag indicating if consultation assessment is final")
    user_turns: int = Field(..., description="Current user turn count for this consultation session")

    model_config = {
        "json_schema_extra": {
            "example": {
                "response": "### 🩺 التقييم والتوصية السريرية\n\nألف سلامة عليك...",
                "specialty": "أمراض الأنف والأذن والحنجرة (ENT)",
                "session_id": "c1f7b8a2-93e4-4d82-b714-82a1290fa112",
                "snippets": [
                    {
                        "source": "MSF Clinical Guidelines.pdf",
                        "page": 45,
                        "content": "Acute otitis media clinical protocols..."
                    }
                ],
                "is_final": True,
                "user_turns": 2
            }
        }
    }


# ==========================================================
# 3. Global RAG Engine & In-Memory Session Storage
# ==========================================================
rag_engine_instance: Optional[MedicalPDFRAG] = None
sessions_db: Dict[str, Dict[str, Any]] = {}


def get_rag_engine() -> MedicalPDFRAG:
    """Lazy initializer / singleton getter for MedicalPDFRAG instance."""
    global rag_engine_instance
    if rag_engine_instance is None:
        print("[API Startup] Initializing MedicalPDFRAG engine...")
        rag_engine_instance = MedicalPDFRAG()
    return rag_engine_instance


@app.on_event("startup")
def startup_event():
    """Pre-load FAISS vector store and embeddings on FastAPI startup."""
    try:
        get_rag_engine()
        print("[API Startup] Medical Safety RAG Engine loaded successfully.")
    except Exception as e:
        print(f"[API Startup Error] Could not initialize RAG Engine: {e}")


def extract_specialty_recommendation(
    response_text: str, 
    search_query: str, 
    snippets: List[Dict[str, Any]], 
    is_ar: bool,
    engine: MedicalPDFRAG
) -> Optional[str]:
    """
    Extracts or deduces the recommended medical specialty from the response text
    or directly from RAG context using pure vector deduction.
    """
    # 1. Regex check for explicit markdown formatting in response_text
    match_ar = re.search(r'-\s*\*\*التخصص:\*\*\s*([^\n]+)', response_text) or re.search(r'\*\*التخصص:\*\*\s*([^\n]+)', response_text)
    if match_ar:
        clean_spec = match_ar.group(1).strip()
        clean_spec = re.sub(r'^\**|\**$', '', clean_spec).strip()
        return clean_spec

    match_en = re.search(r'-\s*\*\*Specialty:\*\*\s*([^\n]+)', response_text) or re.search(r'\*\*Specialty:\*\*\s*([^\n]+)', response_text)
    if match_en:
        clean_spec = match_en.group(1).strip()
        clean_spec = re.sub(r'^\**|\**$', '', clean_spec).strip()
        return clean_spec

    # 2. Dynamic RAG specialty deduction from vector search context if not explicitly formatted in turn text
    try:
        combined_context = " ".join([s.get("content", "") for s in snippets])
        deduced = engine._deduce_specialty_from_rag_context(search_query, combined_context, is_ar)
        if isinstance(deduced, dict) and "specialty" in deduced:
            return deduced["specialty"]
    except Exception as err:
        print(f"[Specialty Extraction Warning] Fallback deduction error: {err}")

    return None


# ==========================================================
# 4. API Endpoints (Pure Backend Operations)
# ==========================================================
@app.get("/", tags=["Health"])
def root_health():
    """Root health check endpoint."""
    return {
        "status": "online",
        "service": "Medical Safety System REST API",
        "version": "1.0.0",
        "docs_url": "/docs"
    }


@app.post("/api/chat", response_model=ChatResponse, tags=["Consultation"])
async def chat_endpoint(request: ChatRequest):
    """
    POST /api/chat:
    Accepts user prompt and optional session_id, forwards through MedicalPDFRAG pipeline,
    and returns response, deduced specialty recommendation, session_id, snippets, and turn stats.
    """
    if not request.user_prompt or not request.user_prompt.strip():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="user_prompt cannot be empty."
        )

    engine = get_rag_engine()

    # Resolve session_id
    raw_sid = request.session_id.strip() if request.session_id else ""
    session_id = raw_sid if raw_sid else str(uuid.uuid4())

    # Fetch or create session state
    if session_id not in sessions_db:
        sessions_db[session_id] = {
            "messages": [],
            "user_turns": 0
        }

    session = sessions_db[session_id]
    session["user_turns"] += 1

    user_input = request.user_prompt.strip()

    try:
        # Run RAG turn
        turn_result = engine.chat_turn(
            messages_history=session["messages"],
            current_user_input=user_input,
            user_turn_count=session["user_turns"]
        )

        resp_text = turn_result.get("response_text", "")
        snippets = turn_result.get("snippets", [])
        is_final = turn_result.get("is_final", False)
        search_query = turn_result.get("search_query", user_input)
        is_ar = turn_result.get("is_arabic", False)
        is_out_of_scope = turn_result.get("is_out_of_scope", False)

        # Append messages to session history for context retention
        session["messages"].append({"role": "user", "content": user_input, "snippets": []})
        session["messages"].append({"role": "assistant", "content": resp_text, "snippets": snippets})

        # Extract specialty recommendation (Must be null for OUT_OF_SCOPE or ongoing probing turns)
        if is_out_of_scope or not is_final:
            specialty = None
        else:
            specialty = turn_result.get("specialty") or extract_specialty_recommendation(
                response_text=resp_text,
                search_query=search_query,
                snippets=snippets,
                is_ar=is_ar,
                engine=engine
            )

        return ChatResponse(
            response=resp_text,
            specialty=specialty,
            session_id=session_id,
            snippets=snippets,
            is_final=is_final,
            user_turns=session["user_turns"]
        )

    except Exception as e:
        print(f"[API Error] Error processing chat turn for session {session_id}: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An error occurred while processing the request: {str(e)}"
        )


@app.get("/api/chat/{session_id}", tags=["Consultation"])
async def get_session_details(session_id: str):
    """Retrieves active conversation history and session details for a given session_id."""
    if session_id in sessions_db:
        session = sessions_db[session_id]
        return {
            "session_id": session_id,
            "user_turns": session.get("user_turns", 0),
            "messages": session.get("messages", []),
            "total_messages": len(session.get("messages", []))
        }
    raise HTTPException(status_code=404, detail="Session ID not found.")


@app.get("/api/sessions", tags=["Consultation"])
async def list_active_sessions():
    """Lists all active consultation session IDs and turn counts."""
    return {
        "active_sessions_count": len(sessions_db),
        "sessions": [
            {
                "session_id": sid,
                "user_turns": sdata.get("user_turns", 0),
                "message_count": len(sdata.get("messages", []))
            }
            for sid, sdata in sessions_db.items()
        ]
    }


@app.delete("/api/chat/{session_id}", tags=["Consultation"])
async def reset_session(session_id: str):
    """Deletes/resets consultation history for a given session_id."""
    if session_id in sessions_db:
        del sessions_db[session_id]
        return {"status": "success", "message": f"Session {session_id} reset successfully."}
    raise HTTPException(status_code=404, detail="Session ID not found.")


# ==========================================================
# Server Execution Entry Point
# ==========================================================
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app_api:app", host="0.0.0.0", port=8000, reload=True)
