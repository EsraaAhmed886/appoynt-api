"""
==========================================================
File Name          : app_api.py
Module             : Smart Referral & Patient Care AI
Description        : Lightweight FastAPI REST API Application powering:
                     1. Prescription Analysis & Patient Care AI
                     2. Smart Clinical Doctor Referral Engine
Dependencies       : fastapi, uvicorn, pydantic
==========================================================
"""

import os
import sys
import logging
from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware

# Ensure module import paths support direct script execution and uvicorn module loading
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
PARENT_DIR = os.path.dirname(CURRENT_DIR)
if CURRENT_DIR not in sys.path:
    sys.path.insert(0, CURRENT_DIR)
if PARENT_DIR not in sys.path:
    sys.path.insert(0, PARENT_DIR)

# Handle relative and absolute imports gracefully
try:
    from .schemas import (
        PrescriptionAnalysisRequest,
        PrescriptionAnalysisResponse,
        ReferralRequest,
        ReferralResponse
    )
    from .patient_care_service import process_prescription_analysis
    from .doctor_referral_service import process_doctor_recommendation
except ImportError:
    from schemas import (
        PrescriptionAnalysisRequest,
        PrescriptionAnalysisResponse,
        ReferralRequest,
        ReferralResponse
    )
    from patient_care_service import process_prescription_analysis
    from doctor_referral_service import process_doctor_recommendation

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("SmartReferralCareAI")


# ==========================================================
# 1. Setup FastAPI Application & CORS Middleware
# ==========================================================
app = FastAPI(
    title="Smart Referral & Patient Care AI API",
    description=(
        "Modular AI feature service providing prescription analysis and smart clinical doctor referral recommendations "
        "powered by clinical LLM extraction and multi-criteria scoring."
    ),
    version="1.1.0"
)

# CORS Middleware allowing all origins
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ==========================================================
# 2. API Endpoints
# ==========================================================
@app.get("/health")
def health_check():
    """Returns service status 'ok' and service name."""
    return {
        "status": "ok",
        "service": "Smart Referral & Patient Care AI API",
        "service_name": "Smart Referral & Patient Care AI"
    }


@app.post("/api/prescriptions/analyze", response_model=PrescriptionAnalysisResponse)
def analyze_prescription(request: PrescriptionAnalysisRequest):
    """
    Parses complex prescription data into a warm, patient-friendly explanation with
    medication schedule, safety warnings, and lifestyle/dietary guidance.
    """
    if not request.prescription_id or not request.prescription_id.strip():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="The 'prescription_id' field cannot be empty."
        )

    if not request.diagnosis or not request.diagnosis.strip():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="The 'diagnosis' field cannot be empty."
        )

    if request.patient_age <= 0 or request.patient_age > 120:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="The 'patient_age' must be a valid integer between 1 and 120."
        )

    if not request.medications:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="The 'medications' list cannot be empty. At least one medication item is required."
        )

    for idx, med in enumerate(request.medications):
        if not med.drug_name or not med.drug_name.strip():
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Medication item at index {idx} must have a non-empty 'drug_name'."
            )

    try:
        logger.info(f"Processing prescription analysis for prescription ID: {request.prescription_id}")
        return process_prescription_analysis(request)

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error analyzing prescription: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An internal error occurred while analyzing the prescription: {str(e)}"
        )


@app.post("/api/referrals/recommend-doctors", response_model=ReferralResponse)
def recommend_doctors(request: ReferralRequest):
    """
    Analyzes attending physician examination notes using LLM to extract target sub-specialty
    and urgency, then ranks available specialists using multi-criteria scoring.
    """
    if not request.patient.patient_id or not request.patient.patient_id.strip():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="The 'patient.patient_id' field cannot be empty."
        )

    if not request.patient.location_zone or not request.patient.location_zone.strip():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="The 'patient.location_zone' field cannot be empty."
        )

    if not request.patient.insurance_provider or not request.patient.insurance_provider.strip():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="The 'patient.insurance_provider' field cannot be empty."
        )

    if not request.clinical_note or not request.clinical_note.strip():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="The 'clinical_note' field cannot be empty."
        )

    try:
        logger.info(f"Processing doctor referral recommendation for patient ID: {request.patient.patient_id}")
        return process_doctor_recommendation(request)

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error executing doctor referral recommendation: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An internal error occurred while generating doctor recommendations: {str(e)}"
        )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app_api:app", host="0.0.0.0", port=8001, reload=True)
