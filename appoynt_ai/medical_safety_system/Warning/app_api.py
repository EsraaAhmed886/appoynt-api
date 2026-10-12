import os
import sys
from typing import List, Dict, Any, Optional
from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

# Ensure current directory is in sys.path for importing Task1 modules
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
if CURRENT_DIR not in sys.path:
    sys.path.insert(0, CURRENT_DIR)

from nlp_extractor import extract_drugs_from_prescription
from safety_engine import check_safety_conflicts
from advisory_generator import generate_clinical_alert

app = FastAPI(
    title="Prescription Safety Analysis API (Task 1)",
    description="FastAPI backend integrating NLP extraction, safety conflict checks, and clinical advisory generation.",
    version="1.0.0"
)

# CORS Middleware allowing all origins
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Pydantic Schemas
class PatientProfile(BaseModel):
    allergies: List[str] = Field(default_factory=list, description="List of patient drug allergies")
    chronic_diseases: List[str] = Field(default_factory=list, description="List of chronic medical conditions")
    dietary_intake: List[str] = Field(default_factory=list, description="List of regular dietary items")


class AnalysisRequest(BaseModel):
    text: str = Field(..., description="Prescription text or medical report to analyze")
    patient_profile: Optional[PatientProfile] = Field(default_factory=PatientProfile, description="Optional patient medical profile")


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


@app.get("/")
def root():
    return {
        "status": "ONLINE",
        "service": "Prescription Safety Analysis API (Task 1)",
        "version": "1.0.0",
        "endpoint": "/api/analyze"
    }


@app.get("/health")
def health():
    return {"status": "healthy"}


@app.post("/api/analyze", response_model=AnalysisResponse)
def analyze_prescription(request: AnalysisRequest):
    if not request.text or not request.text.strip():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="The 'text' field cannot be empty."
        )

    try:
        # 1. Extract Trade Drugs from prescription text using Task1 NLP Extractor
        extracted_drugs = extract_drugs_from_prescription(request.text)

        # 2. Extract patient profile dictionary
        profile_dict = (
            request.patient_profile.model_dump()
            if request.patient_profile
            else {"allergies": [], "chronic_diseases": [], "dietary_intake": []}
        )

        # 3. Process through safety engine
        conflicts = check_safety_conflicts(extracted_drugs, profile_dict)

        # 4. Generate structured clinical alert advisory report
        alert_report = generate_clinical_alert(conflicts)
        alert_report["extracted_drugs"] = extracted_drugs

        return AnalysisResponse(**alert_report)

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Internal error processing analysis request: {str(e)}"
        )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app_api:app", host="0.0.0.0", port=8000, reload=True)
