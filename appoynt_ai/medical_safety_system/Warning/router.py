"""
==========================================================
File Name          : router.py
Module             : Warning (Task 1) - Prescription Safety Analysis
Description        : FastAPI APIRouter exposing the safety analysis endpoint.
                     Extracted from app_api.py for unified server integration.
==========================================================
"""

import sys
from pathlib import Path
from typing import List, Optional

from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel, Field

# Ensure this module's directory is on the path
_MODULE_DIR = Path(__file__).resolve().parent
if str(_MODULE_DIR) not in sys.path:
    sys.path.insert(0, str(_MODULE_DIR))

from nlp_extractor import extract_drugs_from_prescription
from safety_engine import check_safety_conflicts
from advisory_generator import generate_clinical_alert

router = APIRouter()


# ==========================================================
# Pydantic Schemas
# ==========================================================
class PatientProfile(BaseModel):
    allergies: List[str] = Field(default_factory=list, description="List of patient drug allergies")
    chronic_diseases: List[str] = Field(default_factory=list, description="List of chronic medical conditions")
    dietary_intake: List[str] = Field(default_factory=list, description="List of regular dietary items")


class AnalysisRequest(BaseModel):
    text: str = Field(..., description="Prescription text or medical report to analyze")
    patient_profile: Optional[PatientProfile] = Field(
        default_factory=PatientProfile,
        description="Optional patient medical profile"
    )


class ConflictAlert(BaseModel):
    drug: Optional[str] = Field(None, description="Trade drug name involved in the conflict")
    conflict_type: Optional[str] = Field(None, description="Category of conflict (e.g. Allergy, Disease, Food)")
    conflicting_ingredient: Optional[str] = Field(None, description="Active ingredient or condition matched")
    details: Optional[str] = Field(None, description="Clinical description of the warning")
    alternatives: List[str] = Field(default_factory=list, description="Recommended safe alternatives")


class AnalysisResponse(BaseModel):
    status: str = Field(..., description="Overall safety status (SAFE or DANGER)")
    has_conflict: bool = Field(..., description="Whether any conflicts were identified")
    total_conflicts: int = Field(..., description="Total count of detected safety conflicts")
    message: str = Field(..., description="Summary clinical message")
    extracted_drugs: List[str] = Field(default_factory=list, description="Extracted trade drug entities from text")
    alerts: List[ConflictAlert] = Field(default_factory=list, description="Detailed safety advisory warnings")
    recommendation: str = Field(..., description="Clinical action recommendation")


# ==========================================================
# Endpoints
# The router is mounted at /api/analyze, so paths here are
# relative — POST / maps to POST /api/analyze
# ==========================================================
@router.post("/", response_model=AnalysisResponse, summary="Analyze Prescription Safety")
def analyze_prescription(request: AnalysisRequest):
    """
    POST /api/analyze

    Extracts trade-name drugs from prescription text, checks for allergy,
    chronic disease, and food interaction conflicts, then returns a structured
    clinical advisory report.
    """
    if not request.text or not request.text.strip():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="The 'text' field cannot be empty.",
        )

    try:
        extracted_drugs = extract_drugs_from_prescription(request.text)

        profile_dict = (
            request.patient_profile.model_dump()
            if request.patient_profile
            else {"allergies": [], "chronic_diseases": [], "dietary_intake": []}
        )

        conflicts = check_safety_conflicts(extracted_drugs, profile_dict)
        alert_report = generate_clinical_alert(conflicts)
        alert_report["extracted_drugs"] = extracted_drugs

        return AnalysisResponse(**alert_report)

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Internal error processing analysis request: {str(e)}",
        )
