"""
==========================================================
File Name          : router.py
Module             : smart_referral_care (Task 3)
Description        : FastAPI APIRouter exposing prescription analysis and
                     doctor referral endpoints.
                     Extracted from app_api.py for unified server integration.
==========================================================
"""

import sys
import logging
from pathlib import Path

from fastapi import APIRouter, HTTPException, status

_MODULE_DIR = Path(__file__).resolve().parent
if str(_MODULE_DIR) not in sys.path:
    sys.path.insert(0, str(_MODULE_DIR))

from schemas import (
    PrescriptionAnalysisRequest,
    PrescriptionAnalysisResponse,
    ReferralRequest,
    ReferralResponse,
)
from patient_care_service import process_prescription_analysis
from doctor_referral_service import process_doctor_recommendation

logger = logging.getLogger("SmartReferralCareAI")
router = APIRouter()


# ==========================================================
# Endpoints
# The router is mounted at root (""), so full paths are used:
#   POST /api/prescriptions/analyze
#   POST /api/referrals/recommend-doctors
# ==========================================================
@router.post("/api/prescriptions/analyze", response_model=PrescriptionAnalysisResponse, summary="Analyze Prescription")
def analyze_prescription(request: PrescriptionAnalysisRequest):
    """
    POST /api/prescriptions/analyze

    Parses complex prescription data into a warm, patient-friendly explanation
    with medication schedule, safety warnings, and lifestyle/dietary guidance.
    """
    if not request.prescription_id or not request.prescription_id.strip():
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="The 'prescription_id' field cannot be empty.")
    if not request.diagnosis or not request.diagnosis.strip():
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="The 'diagnosis' field cannot be empty.")
    if request.patient_age <= 0 or request.patient_age > 120:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="The 'patient_age' must be between 1 and 120.")
    if not request.medications:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="The 'medications' list cannot be empty.")
    for idx, med in enumerate(request.medications):
        if not med.drug_name or not med.drug_name.strip():
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"Medication at index {idx} must have a non-empty 'drug_name'.")

    try:
        logger.info(f"Processing prescription analysis: {request.prescription_id}")
        return process_prescription_analysis(request)
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error analyzing prescription: {e}", exc_info=True)
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Internal error: {str(e)}")


@router.post("/api/referrals/recommend-doctors", response_model=ReferralResponse, summary="Recommend Doctors")
def recommend_doctors(request: ReferralRequest):
    """
    POST /api/referrals/recommend-doctors

    Analyzes physician examination notes using LLM to extract sub-specialty
    and urgency, then ranks available specialists using multi-criteria scoring.
    """
    if not request.patient.patient_id or not request.patient.patient_id.strip():
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="The 'patient.patient_id' field cannot be empty.")
    if not request.patient.location_zone or not request.patient.location_zone.strip():
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="The 'patient.location_zone' field cannot be empty.")
    if not request.patient.insurance_provider or not request.patient.insurance_provider.strip():
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="The 'patient.insurance_provider' field cannot be empty.")
    if not request.clinical_note or not request.clinical_note.strip():
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="The 'clinical_note' field cannot be empty.")

    try:
        logger.info(f"Processing doctor referral for patient: {request.patient.patient_id}")
        return process_doctor_recommendation(request)
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in doctor referral: {e}", exc_info=True)
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Internal error: {str(e)}")
