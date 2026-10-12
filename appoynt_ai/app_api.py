"""
==========================================================
File Name          : app_api.py
Description        : FastAPI REST API Integration Server for Clinical AI Chatbot (RAG Engine)
Dependencies       : fastapi, uvicorn, pydantic, rag_engine
==========================================================
"""

import os
import sys
import importlib.util

# Ensure medical_safety_system/rag_module directory is in Python path for importing rag_engine
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
RAG_MODULE_DIR = os.path.join(CURRENT_DIR, "medical_safety_system", "rag_module")
RAG_API_PATH = os.path.join(RAG_MODULE_DIR, "app_api.py")

if RAG_MODULE_DIR not in sys.path:
    sys.path.insert(0, RAG_MODULE_DIR)

# Dynamically import rag_module/app_api.py under alias 'rag_module_app_api' to prevent circular import / shadowing
try:
    spec = importlib.util.spec_from_file_location("rag_module_app_api", RAG_API_PATH)
    if spec is None or spec.loader is None:
        raise ImportError(f"Could not load module spec for {RAG_API_PATH}")
    
    rag_module_api = importlib.util.module_from_spec(spec)
    sys.modules["rag_module_app_api"] = rag_module_api
    spec.loader.exec_module(rag_module_api)

    # Re-export core attributes from rag_module/app_api.py
    app = rag_module_api.app
    ChatRequest = rag_module_api.ChatRequest
    ChatResponse = rag_module_api.ChatResponse
    get_rag_engine = rag_module_api.get_rag_engine

except Exception as e:
    raise ImportError(f"Failed to dynamically load RAG module app_api from {RAG_API_PATH}: {e}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app_api:app", host="0.0.0.0", port=8000, reload=True)
