"""
==========================================================
File Name          : main.py
Description        : Unified FastAPI entry point for the Healthcare AI API.
                     Combines all three modules:
                       - Task 1 (Warning): Prescription Safety Analysis
                       - Task 2 (RAG Module): Medical Chatbot / Clinical RAG
                       - Task 3 (Smart Referral Care): Prescription Analysis & Doctor Referral
                     Designed for production deployment on Render with Docker.
==========================================================
"""

import sys
import logging
from pathlib import Path

# ---------------------------------------------------------------------------
# Ensure each sub-module directory is on the Python path so their local
# imports (e.g.  "from rag_engine import …") resolve correctly at runtime,
# regardless of the working directory used by the container.
# ---------------------------------------------------------------------------
ROOT_DIR = Path(__file__).resolve().parent
for sub in ("Warning", "rag_module", "smart_referral_care"):
    sub_path = str(ROOT_DIR / sub)
    if sub_path not in sys.path:
        sys.path.insert(0, sub_path)

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# ---------------------------------------------------------------------------
# Import routers from each sub-module
# ---------------------------------------------------------------------------
from Warning.router import router as safety_router                    # /api/analyze
from rag_module.router import router as rag_router                    # /api/chat
from smart_referral_care.router import router as referral_router      # /api/prescriptions & /api/referrals

# ---------------------------------------------------------------------------
# Configure root logger
# ---------------------------------------------------------------------------
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger("HealthcareAI")

# ---------------------------------------------------------------------------
# FastAPI Application
# ---------------------------------------------------------------------------
app = FastAPI(
    title="Healthcare AI API",
    description=(
        "Unified Healthcare AI backend powering three clinical modules:\n"
        "- **Safety Analysis** (`/api/analyze`): NLP-driven prescription safety checker.\n"
        "- **Medical Chatbot** (`/api/chat`): Multi-turn RAG clinical consultation engine.\n"
        "- **Smart Referral Care** (`/api/prescriptions`, `/api/referrals`): "
        "Prescription explainer & intelligent doctor referral."
    ),
    version="2.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

# ---------------------------------------------------------------------------
# CORS Middleware — allow all origins for Flutter/React/Web frontends
# ---------------------------------------------------------------------------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ---------------------------------------------------------------------------
# Mount routers with their respective prefixes
# ---------------------------------------------------------------------------
app.include_router(safety_router,   prefix="/api/analyze",   tags=["Safety Analysis (Task 1)"])
app.include_router(rag_router,      prefix="/api/chat",      tags=["Medical Chatbot (Task 2)"])
app.include_router(referral_router, prefix="",               tags=["Smart Referral Care (Task 3)"])


# ---------------------------------------------------------------------------
# Root health-check endpoint
# ---------------------------------------------------------------------------
@app.get("/", tags=["Health"])
def root_health():
    """Root health check — confirms the unified API is up and running."""
    return {
        "status": "healthy",
        "service": "Healthcare AI API",
        "version": "2.0.0",
        "docs": "/docs",
        "modules": {
            "safety_analysis": "/api/analyze",
            "medical_chatbot": "/api/chat",
            "prescription_analysis": "/api/prescriptions/analyze",
            "doctor_referral": "/api/referrals/recommend-doctors",
        },
    }


# ---------------------------------------------------------------------------
# Local dev entry-point
# ---------------------------------------------------------------------------
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
