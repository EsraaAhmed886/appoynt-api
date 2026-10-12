from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import List, Dict, Any

from nlp_extractor import extract_drugs_from_prescription
from safety_engine import check_safety_conflicts
from advisory_generator import generate_clinical_alert

app = FastAPI(
    title="Clinical Decision Support System (CDSS) AI Engine",
    description="Dynamic API-driven pipeline for prescription safety verification and alternative medication recommendations.",
    version="2.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class PatientProfile(BaseModel):
    allergies: List[str] = Field(default_factory=list, description="Patient known drug allergies or active ingredients")
    chronic_diseases: List[str] = Field(default_factory=list, description="Patient chronic medical conditions")
    dietary_intake: List[str] = Field(default_factory=list, description="Patient regular dietary items")

class PrescriptionRequest(BaseModel):
    prescription_text: str = Field(..., description="Doctor written prescription text containing brand/trade drug names")
    patient_profile: PatientProfile = Field(default_factory=PatientProfile)

@app.get("/")
def root():
    return {
        "status": "ONLINE",
        "system": "Clinical Decision Support System (CDSS)",
        "endpoint": "/check-prescription"
    }

@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.post("/check-prescription")
def check_prescription_endpoint(request: PrescriptionRequest):
    try:
        # 1. Extract Trade Drugs dynamically from prescription text
        extracted_drugs = extract_drugs_from_prescription(request.prescription_text)
        
        # 2. Check Safety Conflicts (Active ingredients, allergies, chronic diseases, food)
        profile_dict = request.patient_profile.model_dump()
        conflicts = check_safety_conflicts(extracted_drugs, profile_dict)
        
        # 3. Generate Clinical Decision Report
        alert_report = generate_clinical_alert(conflicts)
        
        # 4. Attach extracted trade drugs list to response
        alert_report["extracted_drugs"] = extracted_drugs
        
        return alert_report

    except Exception as e:
        print(f"Error processing prescription request in main.py: {e}")
        return {
            "status": "UNKNOWN_ERROR",
            "has_conflict": False,
            "total_conflicts": 0,
            "message": f"Internal process notice: {str(e)}",
            "alerts": [],
            "extracted_drugs": [],
            "recommendation": "Engine fallback active. Please review prescription manually."
        }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)