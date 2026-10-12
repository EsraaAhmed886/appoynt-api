"""
==========================================================
File Name          : doctor_referral_service.py
Module             : Smart Referral & Patient Care AI
Description        : Service layer for Doctor Referral Recommendation.
                     Contains Mock Doctor database, LLM referral indicator extraction,
                     and Multi-Criteria Doctor Ranking & Scoring engine.
==========================================================
"""

import os
import json
import logging
from typing import List, Dict, Any

try:
    from .schemas import PatientInfo, ReferralRequest, ScoredDoctorRecommendation, ReferralResponse
except ImportError:
    from schemas import PatientInfo, ReferralRequest, ScoredDoctorRecommendation, ReferralResponse

logger = logging.getLogger("SmartReferralCareAI")

# Mock Doctors Database representing registered specialists
MOCK_DOCTORS_DATABASE = [
    {
        "doctor_id": "doc-101",
        "name": "Dr. Ahmed Mansour",
        "primary_specialty": "Cardiology",
        "sub_specialty": "Interventional Cardiology",
        "accepted_insurance": ["AXA", "MetLife", "Allianz", "Bupa"],
        "location_zone": "Dokki",
        "next_available_slot_hours": 12
    },
    {
        "doctor_id": "doc-102",
        "name": "Dr. Mona El-Sayed",
        "primary_specialty": "Cardiology",
        "sub_specialty": "Electrophysiology",
        "accepted_insurance": ["MetLife", "Allianz", "GlobeMed"],
        "location_zone": "Nasr City",
        "next_available_slot_hours": 24
    },
    {
        "doctor_id": "doc-103",
        "name": "Dr. Hassan Farag",
        "primary_specialty": "Cardiology",
        "sub_specialty": "General Cardiology",
        "accepted_insurance": ["AXA", "NextCare"],
        "location_zone": "Maadi",
        "next_available_slot_hours": 48
    },
    {
        "doctor_id": "doc-104",
        "name": "Dr. Tarek Zaki",
        "primary_specialty": "Endocrinology",
        "sub_specialty": "Pediatric Endocrinology",
        "accepted_insurance": ["AXA", "MetLife", "GlobeMed"],
        "location_zone": "Dokki",
        "next_available_slot_hours": 18
    },
    {
        "doctor_id": "doc-105",
        "name": "Dr. Rania Abdelrahman",
        "primary_specialty": "Orthopedic Surgery",
        "sub_specialty": "Sports Medicine & Joint Replacement",
        "accepted_insurance": ["Allianz", "Bupa", "AXA"],
        "location_zone": "Heliopolis",
        "next_available_slot_hours": 36
    },
    {
        "doctor_id": "doc-106",
        "name": "Dr. Khaled Soliman",
        "primary_specialty": "Neurology",
        "sub_specialty": "Stroke & Neurovascular Surgery",
        "accepted_insurance": ["AXA", "MetLife", "Allianz"],
        "location_zone": "Maadi",
        "next_available_slot_hours": 6
    },
    {
        "doctor_id": "doc-107",
        "name": "Dr. Youssef Nabil",
        "primary_specialty": "Pulmonology",
        "sub_specialty": "Interventional Pulmonology",
        "accepted_insurance": ["AXA", "MetLife", "GlobeMed", "NextCare"],
        "location_zone": "Nasr City",
        "next_available_slot_hours": 24
    },
    {
        "doctor_id": "doc-108",
        "name": "Dr. Salma Fouad",
        "primary_specialty": "Gastroenterology",
        "sub_specialty": "Hepatology & Advanced Endoscopy",
        "accepted_insurance": ["Allianz", "MetLife", "Bupa"],
        "location_zone": "Dokki",
        "next_available_slot_hours": 72
    },
    {
        "doctor_id": "doc-109",
        "name": "Dr. Sherif Ibrahim",
        "primary_specialty": "Nephrology",
        "sub_specialty": "Renal Transplantation & Dialysis",
        "accepted_insurance": ["AXA", "Bupa", "GlobeMed"],
        "location_zone": "New Cairo",
        "next_available_slot_hours": 16
    },
    {
        "doctor_id": "doc-110",
        "name": "Dr. Dina Hamdy",
        "primary_specialty": "Dermatology",
        "sub_specialty": "Cosmetic & Surgical Dermatology",
        "accepted_insurance": ["MetLife", "NextCare"],
        "location_zone": "Mohandessin",
        "next_available_slot_hours": 48
    }
]


class LLMReferralExtractionEngine:
    """
    Analyzes clinical examination notes to extract sub-specialty requirements,
    triage urgency level, and a concise clinical referral synthesis.
    """

    @staticmethod
    def extract_referral_indicators(clinical_note: str) -> Dict[str, str]:
        openai_key = os.getenv("OPENAI_API_KEY")
        gemini_key = os.getenv("GEMINI_API_KEY") or os.getenv("GOOGLE_API_KEY")

        prompt = f"""You are a Senior Medical Triage AI Specialist.
Analyze the following clinical examination notes and extract key referral indicators:

Clinical Note:
"{clinical_note}"

Return ONLY a valid JSON object with the following fields:
{{
  "extracted_sub_specialty": "Exact target sub-specialty (e.g. Interventional Cardiology, Pediatric Endocrinology, Stroke & Neurovascular Surgery, Sports Medicine & Joint Replacement, Interventional Pulmonology, Hepatology & Advanced Endoscopy, Renal Transplantation & Dialysis, Cosmetic & Surgical Dermatology, Electrophysiology)",
  "urgency_level": "Routine" | "Urgent" | "Stat",
  "clinical_summary": "Brief clinical synthesis of why referral is necessary"
}}
"""

        if openai_key:
            try:
                import urllib.request
                req_data = json.dumps({
                    "model": "gpt-4o-mini",
                    "messages": [{"role": "user", "content": prompt}],
                    "response_format": {"type": "json_object"},
                    "temperature": 0.2
                }).encode("utf-8")

                req = urllib.request.Request(
                    "https://api.openai.com/v1/chat/completions",
                    data=req_data,
                    headers={
                        "Content-Type": "application/json",
                        "Authorization": f"Bearer {openai_key}"
                    },
                    method="POST"
                )
                with urllib.request.urlopen(req, timeout=10) as response:
                    res_body = json.loads(response.read().decode("utf-8"))
                    content = res_body["choices"][0]["message"]["content"]
                    return json.loads(content)
            except Exception as e:
                logger.warning(f"OpenAI extraction failed, falling back to NLP domain engine: {e}")

        if gemini_key:
            try:
                import urllib.request
                url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={gemini_key}"
                req_data = json.dumps({
                    "contents": [{"parts": [{"text": prompt}]}],
                    "generationConfig": {"response_mime_type": "application/json"}
                }).encode("utf-8")

                req = urllib.request.Request(
                    url,
                    data=req_data,
                    headers={"Content-Type": "application/json"},
                    method="POST"
                )
                with urllib.request.urlopen(req, timeout=10) as response:
                    res_body = json.loads(response.read().decode("utf-8"))
                    content = res_body["candidates"][0]["content"]["parts"][0]["text"]
                    return json.loads(content)
            except Exception as e:
                logger.warning(f"Gemini extraction failed, falling back to NLP domain engine: {e}")

        return cls._nlp_domain_triage_fallback(clinical_note)

    @classmethod
    def _nlp_domain_triage_fallback(cls, note: str) -> Dict[str, str]:
        text_lower = note.lower()

        if any(term in text_lower for term in ["stat", "emergency", "critical", "severe acute", "unstable", "troponin", "st elevation", "stroke", "anaphylaxis", "respiratory distress"]):
            urgency = "Stat"
        elif any(term in text_lower for term in ["urgent", "acute", "worsening", "high risk", "uncontrolled", "persistent", "exacerbation"]):
            urgency = "Urgent"
        else:
            urgency = "Routine"

        sub_specialty = "General Internal Medicine"
        if any(term in text_lower for term in ["cardio", "chest pain", "angina", "troponin", "coronary", "st elevation", "catheter", "pci", "infarct"]):
            sub_specialty = "Interventional Cardiology"
        elif any(term in text_lower for term in ["arrhythmia", "palpitation", "afib", "flutter", "pacemaker", "electrophysiology"]):
            sub_specialty = "Electrophysiology"
        elif any(term in text_lower for term in ["stroke", "seizure", "neurovascular", "numbness", "paralysis", "aphasia"]):
            sub_specialty = "Stroke & Neurovascular Surgery"
        elif any(term in text_lower for term in ["pediatric endocrin", "child diabetes", "growth hormone", "juvenile diabetes"]):
            sub_specialty = "Pediatric Endocrinology"
        elif any(term in text_lower for term in ["diabetes", "hba1c", "thyroid", "adrenal", "endocrin"]):
            sub_specialty = "Pediatric Endocrinology" if "child" in text_lower or "pediatric" in text_lower else "General Endocrinology"
        elif any(term in text_lower for term in ["joint", "knee", "acl", "meniscus", "sports", "fracture", "ortho", "bone"]):
            sub_specialty = "Sports Medicine & Joint Replacement"
        elif any(term in text_lower for term in ["lung", "copd", "asthma", "pulmonary", "bronchitis", "wheezing", "hypoxia", "interventional pulmon"]):
            sub_specialty = "Interventional Pulmonology"
        elif any(term in text_lower for term in ["liver", "hepatitis", "jaundice", "endoscopy", "crohn", "colitis", "gastro"]):
            sub_specialty = "Hepatology & Advanced Endoscopy"
        elif any(term in text_lower for term in ["kidney", "renal", "creatinine", "egfr", "proteinuria", "dialysis", "transplant"]):
            sub_specialty = "Renal Transplantation & Dialysis"
        elif any(term in text_lower for term in ["skin", "rash", "eczema", "psoriasis", "lesion", "derm"]):
            sub_specialty = "Cosmetic & Surgical Dermatology"

        summary = f"Patient presenting with symptoms requiring specialist evaluation in {sub_specialty} under {urgency} clinical priority."
        return {
            "extracted_sub_specialty": sub_specialty,
            "urgency_level": urgency,
            "clinical_summary": summary
        }


class DoctorScoringEngine:
    """
    Multi-Criteria Doctor Recommendation Scoring Algorithm (100 Points Total):
    1. Insurance In-Network Match (35 Points)
    2. Sub-Specialty Exactness (30 Points)
    3. Urgency & Availability Window (20 Points)
    4. Geographical Proximity (15 Points)
    """

    @classmethod
    def score_and_rank_doctors(
        cls,
        patient: PatientInfo,
        extracted_sub_specialty: str,
        urgency_level: str,
        doctors: List[Dict[str, Any]]
    ) -> List[ScoredDoctorRecommendation]:
        scored_recommendations: List[ScoredDoctorRecommendation] = []

        patient_ins_clean = patient.insurance_provider.strip().lower()
        patient_loc_clean = patient.location_zone.strip().lower()
        extracted_sub_clean = extracted_sub_specialty.strip().lower()

        for doc in doctors:
            doctor_id = doc["doctor_id"]
            name = doc["name"]
            primary_spec = doc["primary_specialty"]
            sub_spec = doc["sub_specialty"]
            doc_ins_list = [ins.strip().lower() for ins in doc.get("accepted_insurance", [])]
            doc_loc_clean = doc["location_zone"].strip().lower()
            slot_hours = doc["next_available_slot_hours"]

            # 1. Insurance In-Network Match (Weight: 35%)
            is_in_network = patient_ins_clean in doc_ins_list
            ins_score = 35.0 if is_in_network else 0.0

            # 2. Sub-Specialty Exactness (Weight: 30%)
            doc_sub_clean = sub_spec.strip().lower()
            doc_prim_clean = primary_spec.strip().lower()

            if doc_sub_clean == extracted_sub_clean or extracted_sub_clean in doc_sub_clean or doc_sub_clean in extracted_sub_clean:
                sub_spec_score = 30.0
                match_type = "Exact Sub-Specialty Match"
            elif doc_prim_clean in extracted_sub_clean or any(word in extracted_sub_clean for word in doc_prim_clean.split()):
                sub_spec_score = 15.0
                match_type = "Primary Specialty Match"
            else:
                sub_spec_score = 0.0
                match_type = "Specialty Mismatch"

            # 3. Urgency & Availability Window (Weight: 20%)
            urgency_clean = urgency_level.strip().capitalize()
            if urgency_clean in ["Urgent", "Stat"]:
                if slot_hours <= 24:
                    urgency_score = 20.0
                elif slot_hours <= 48:
                    urgency_score = 14.0
                else:
                    urgency_score = 5.0
            else:  # Routine
                if slot_hours <= 72:
                    urgency_score = 20.0
                else:
                    urgency_score = 10.0

            # 4. Geographical Proximity (Weight: 15%)
            if doc_loc_clean == patient_loc_clean:
                geo_score = 15.0
                geo_match = f"In Patient Zone ({doc['location_zone']})"
            else:
                geo_score = 5.0
                geo_match = f"Nearby Zone ({doc['location_zone']})"

            # Calculate Total Match Score
            total_score = round(ins_score + sub_spec_score + urgency_score + geo_score, 1)

            # Generate Human-Readable Referral Reasoning
            reason_parts = []
            if is_in_network:
                reason_parts.append(f"In-network with {patient.insurance_provider} (+35 pts)")
            else:
                reason_parts.append(f"Out-of-network for {patient.insurance_provider} (0 pts)")

            reason_parts.append(f"{match_type} in {sub_spec} (+{int(sub_spec_score)} pts)")
            reason_parts.append(f"Available slot within {slot_hours}h for {urgency_clean} care (+{int(urgency_score)} pts)")
            reason_parts.append(f"{geo_match} (+{int(geo_score)} pts)")

            referral_reasoning = f"{'; '.join(reason_parts)}. Total match score: {total_score}%."

            scored_recommendations.append(
                ScoredDoctorRecommendation(
                    doctor_id=doctor_id,
                    name=name,
                    primary_specialty=primary_spec,
                    sub_specialty=sub_spec,
                    match_score=total_score,
                    is_in_network=is_in_network,
                    location_zone=doc["location_zone"],
                    next_available_slot_hours=slot_hours,
                    referral_reasoning=referral_reasoning
                )
            )

        scored_recommendations.sort(key=lambda d: d.match_score, reverse=True)
        return scored_recommendations


def process_doctor_recommendation(request: ReferralRequest) -> ReferralResponse:
    """Orchestrates doctor referral extraction and scoring, returning ReferralResponse."""
    extracted_data = LLMReferralExtractionEngine.extract_referral_indicators(request.clinical_note)
    extracted_sub_spec = extracted_data.get("extracted_sub_specialty", "General Internal Medicine")
    urgency_level = extracted_data.get("urgency_level", "Routine")
    clinical_summary = extracted_data.get("clinical_summary", "Specialist referral recommended.")

    if urgency_level not in ["Routine", "Urgent", "Stat"]:
        urgency_level = "Routine"

    ranked_doctors = DoctorScoringEngine.score_and_rank_doctors(
        patient=request.patient,
        extracted_sub_specialty=extracted_sub_spec,
        urgency_level=urgency_level,
        doctors=MOCK_DOCTORS_DATABASE
    )

    return ReferralResponse(
        extracted_sub_specialty=extracted_sub_spec,
        urgency_level=urgency_level,
        clinical_summary=clinical_summary,
        recommended_doctors=ranked_doctors
    )
