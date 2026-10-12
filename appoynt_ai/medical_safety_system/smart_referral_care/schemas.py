"""
==========================================================
File Name          : schemas.py
Module             : Smart Referral & Patient Care AI
Description        : Pydantic Data Models and Schemas for Prescription Analysis
                     and Smart Doctor Referral Engine.
==========================================================
"""

from typing import List, Optional
from pydantic import BaseModel, Field


# ==========================================================
# 1. Prescription Analysis Schemas (Task 1)
# ==========================================================
class PrescriptionItem(BaseModel):
    drug_name: str = Field(..., description="Name of the prescribed medication")
    dosage: str = Field(..., description="Dosage or strength of medication (e.g. '500mg', '1 tablet')")
    frequency: str = Field(..., description="Dosing frequency (e.g. 'Twice daily', 'Every 8 hours')")
    duration: str = Field(..., description="Treatment duration (e.g. '7 days', '1 month')")
    instructions: Optional[str] = Field(None, description="Special intake instructions (e.g. 'Take after food')")


class PrescriptionAnalysisRequest(BaseModel):
    prescription_id: str = Field(..., description="Unique identification code for the prescription")
    diagnosis: str = Field(..., description="Primary clinical diagnosis or condition")
    patient_age: int = Field(..., description="Age of the patient in years")
    medications: List[PrescriptionItem] = Field(..., description="List of prescribed medication items")


class MedicationScheduleItem(BaseModel):
    drug_name: str = Field(..., description="Name of the medication")
    dosage: str = Field(..., description="Dosage for each intake")
    timing: str = Field(..., description="Recommended timing schedule (e.g. 'Morning after breakfast')")
    plain_instruction: str = Field(..., description="Simplified instruction in plain, friendly language")


class PatientExplanation(BaseModel):
    summary: str = Field(..., description="Warm, reassuring plain-language summary of the condition and overall care plan")
    medication_schedule: List[MedicationScheduleItem] = Field(..., description="Simplified daily medication administration schedule")
    plain_instructions: List[str] = Field(..., description="Clear step-by-step patient instructions for taking treatment safely")
    safety_warnings: List[str] = Field(..., description="Important safety alerts, side-effect warnings, and precautions")


class LifestyleCompanion(BaseModel):
    dietary_advice: List[str] = Field(..., description="Dietary advice tailored to diagnosis and prescribed medications")
    hydration_advice: List[str] = Field(..., description="Hydration guidelines for optimal recovery")
    physical_activity_recommendations: List[str] = Field(..., description="Safe physical activity, exercise, and rest recommendations")
    preventive_tips: List[str] = Field(..., description="Preventive health care and wellness suggestions")


class PrescriptionAnalysisResponse(BaseModel):
    prescription_id: str = Field(..., description="Matching prescription ID from request")
    patient_explanation: PatientExplanation = Field(..., description="Patient explanation summary, schedule, plain instructions, safety warnings")
    lifestyle_companion: LifestyleCompanion = Field(..., description="Dietary/hydration advice, activity recommendations, and preventive tips")


# ==========================================================
# 2. Doctor Referral Engine Schemas (Task 2)
# ==========================================================
class PatientInfo(BaseModel):
    patient_id: str = Field(..., description="Unique patient identifier")
    location_zone: str = Field(..., description="Patient geographical zone (e.g. 'Dokki', 'Nasr City', 'Maadi')")
    insurance_provider: str = Field(..., description="Patient insurance provider name (e.g. 'AXA', 'MetLife', 'Allianz')")


class ReferralRequest(BaseModel):
    patient: PatientInfo = Field(..., description="Patient demographic and insurance details")
    clinical_note: str = Field(..., description="Attending physician examination notes or clinical diagnosis report")
    preferred_appointment_window_hours: Optional[int] = Field(default=48, description="Preferred appointment window in hours")


class ScoredDoctorRecommendation(BaseModel):
    doctor_id: str = Field(..., description="Unique doctor ID")
    name: str = Field(..., description="Doctor's full name")
    primary_specialty: str = Field(..., description="Primary medical specialty")
    sub_specialty: str = Field(..., description="Sub-specialty or focus area")
    match_score: float = Field(..., description="Overall match percentage score (0.0 to 100.0)")
    is_in_network: bool = Field(..., description="Whether doctor accepts patient's insurance network")
    location_zone: str = Field(..., description="Doctor clinic / hospital location zone")
    next_available_slot_hours: int = Field(..., description="Hours until next available appointment slot")
    referral_reasoning: str = Field(..., description="Clinical and logistical justification for recommendation")


class ReferralResponse(BaseModel):
    extracted_sub_specialty: str = Field(..., description="Clinical sub-specialty extracted from examination note")
    urgency_level: str = Field(..., description="Triage urgency classification ('Routine', 'Urgent', or 'Stat')")
    clinical_summary: str = Field(..., description="Brief synthesis explaining reason for referral")
    recommended_doctors: List[ScoredDoctorRecommendation] = Field(..., description="Ranked list of doctor recommendations")
