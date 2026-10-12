"""
==========================================================
File Name          : router.py
Module             : rag_module (Task 2) - Medical Chatbot / Clinical RAG
Description        : FastAPI APIRouter exposing chat consultation endpoints.
                     Extracted from app_api.py for unified server integration.
                     FAISS index path is resolved dynamically via pathlib so it
                     loads correctly inside Docker/Linux containers.
==========================================================
"""

import sys
import uuid
import re
from pathlib import Path
from typing import Optional, Dict, List, Any

from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel, Field

# Ensure this module's directory is on the path for rag_engine import
_MODULE_DIR = Path(__file__).resolve().parent
if str(_MODULE_DIR) not in sys.path:
    sys.path.insert(0, str(_MODULE_DIR))

from rag_engine import MedicalPDFRAG, is_arabic_text

router = APIRouter()

# ==========================================================
# Global RAG Engine singleton & In-Memory Session Storage
# ==========================================================
rag_engine_instance: Optional[MedicalPDFRAG] = None
sessions_db: Dict[str, Dict[str, Any]] = {}


def get_rag_engine() -> MedicalPDFRAG:
    """Lazy initializer / singleton getter for MedicalPDFRAG instance."""
    global rag_engine_instance
    if rag_engine_instance is None:
        print("[RAG Router] Initializing MedicalPDFRAG engine...")
        # Pass explicit absolute paths so Docker containers find them reliably
        rag_engine_instance = MedicalPDFRAG(
            docs_dir=str(_MODULE_DIR / "docs"),
            index_dir=str(_MODULE_DIR / "faiss_index"),
        )
    return rag_engine_instance


# ==========================================================
# Pydantic Schemas
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


# ==========================================================
# Helper: specialty extraction
# ==========================================================
def extract_specialty_recommendation(
    response_text: str,
    search_query: str,
    snippets: List[Dict[str, Any]],
    is_ar: bool,
    engine: MedicalPDFRAG,
) -> Optional[str]:
    """Extracts or deduces the recommended medical specialty from the response text."""
    match_ar = re.search(r'-\s*\*\*التخصص:\*\*\s*([^\n]+)', response_text) or \
               re.search(r'\*\*التخصص:\*\*\s*([^\n]+)', response_text)
    if match_ar:
        return re.sub(r'^\**|\**$', '', match_ar.group(1).strip()).strip()

    match_en = re.search(r'-\s*\*\*Specialty:\*\*\s*([^\n]+)', response_text) or \
               re.search(r'\*\*Specialty:\*\*\s*([^\n]+)', response_text)
    if match_en:
        return re.sub(r'^\**|\**$', '', match_en.group(1).strip()).strip()

    try:
        combined_context = " ".join([s.get("content", "") for s in snippets])
        deduced = engine._deduce_specialty_from_rag_context(search_query, combined_context, is_ar)
        if isinstance(deduced, dict) and "specialty" in deduced:
            return deduced["specialty"]
    except Exception as err:
        print(f"[Specialty Extraction Warning] {err}")

    return None


# ==========================================================
# Endpoints
# The router is mounted at /api/chat, so paths here are
# relative — POST / -> POST /api/chat
# ==========================================================
@router.post("/", response_model=ChatResponse, summary="Clinical Consultation Chat Turn")
async def chat_endpoint(request: ChatRequest):
    """
    POST /api/chat

    Accepts user prompt and optional session_id, forwards through the
    MedicalPDFRAG pipeline, and returns the clinical response, deduced
    specialty recommendation, session metadata, and source snippets.
    """
    if not request.user_prompt or not request.user_prompt.strip():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="user_prompt cannot be empty.",
        )

    engine = get_rag_engine()

    raw_sid = request.session_id.strip() if request.session_id else ""
    session_id = raw_sid if raw_sid else str(uuid.uuid4())

    if session_id not in sessions_db:
        sessions_db[session_id] = {"messages": [], "user_turns": 0}

    session = sessions_db[session_id]
    session["user_turns"] += 1
    user_input = request.user_prompt.strip()

    try:
        turn_result = engine.chat_turn(
            messages_history=session["messages"],
            current_user_input=user_input,
            user_turn_count=session["user_turns"],
        )

        resp_text = turn_result.get("response_text", "")
        snippets = turn_result.get("snippets", [])
        is_final = turn_result.get("is_final", False)
        search_query = turn_result.get("search_query", user_input)
        is_ar = turn_result.get("is_arabic", False)
        is_out_of_scope = turn_result.get("is_out_of_scope", False)

        session["messages"].append({"role": "user", "content": user_input, "snippets": []})
        session["messages"].append({"role": "assistant", "content": resp_text, "snippets": snippets})

        if is_out_of_scope or not is_final:
            specialty = None
        else:
            specialty = turn_result.get("specialty") or extract_specialty_recommendation(
                response_text=resp_text,
                search_query=search_query,
                snippets=snippets,
                is_ar=is_ar,
                engine=engine,
            )

        return ChatResponse(
            response=resp_text,
            specialty=specialty,
            session_id=session_id,
            snippets=snippets,
            is_final=is_final,
            user_turns=session["user_turns"],
        )

    except Exception as e:
        print(f"[RAG Router Error] Session {session_id}: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An error occurred while processing the request: {str(e)}",
        )


@router.get("/{session_id}", summary="Get Session Details")
async def get_session_details(session_id: str):
    """GET /api/chat/{session_id} — Retrieves conversation history for a session."""
    if session_id in sessions_db:
        session = sessions_db[session_id]
        return {
            "session_id": session_id,
            "user_turns": session.get("user_turns", 0),
            "messages": session.get("messages", []),
            "total_messages": len(session.get("messages", [])),
        }
    raise HTTPException(status_code=404, detail="Session ID not found.")


@router.get("/", summary="List Active Sessions")
async def list_active_sessions():
    """GET /api/chat — Lists all active consultation session IDs and turn counts."""
    return {
        "active_sessions_count": len(sessions_db),
        "sessions": [
            {
                "session_id": sid,
                "user_turns": sdata.get("user_turns", 0),
                "message_count": len(sdata.get("messages", [])),
            }
            for sid, sdata in sessions_db.items()
        ],
    }


@router.delete("/{session_id}", summary="Reset Session")
async def reset_session(session_id: str):
    """DELETE /api/chat/{session_id} — Deletes consultation history for a session."""
    if session_id in sessions_db:
        del sessions_db[session_id]
        return {"status": "success", "message": f"Session {session_id} reset successfully."}
    raise HTTPException(status_code=404, detail="Session ID not found.")
