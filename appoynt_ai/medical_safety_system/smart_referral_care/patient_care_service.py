"""
==========================================================
File Name          : patient_care_service.py
Module             : Smart Referral & Patient Care AI
Description        : Service layer for Prescription Analysis and Patient Care AI.
                     Handles LLM orchestration, structured prompt generation, and
                     warm, patient-friendly explanation generation.
==========================================================
"""

import os
import json
import logging
from typing import Dict, Any

try:
    from .schemas import PrescriptionAnalysisRequest, PrescriptionAnalysisResponse
except ImportError:
    from schemas import PrescriptionAnalysisRequest, PrescriptionAnalysisResponse

logger = logging.getLogger("SmartReferralCareAI")


class LLMAnalysisEngine:
    """
    LLM Wrapper and Structured Prompt Generator for prescription interpretation.
    Supports API integrations (OpenAI / Gemini) with an intelligent fallback generator.
    """

    @staticmethod
    def _generate_structured_prompt(request: PrescriptionAnalysisRequest) -> str:
        meds_text = "\n".join([
            f"- {med.drug_name}: Dosage={med.dosage}, Frequency={med.frequency}, Duration={med.duration}, Notes={med.instructions or 'None'}"
            for med in request.medications
        ])

        prompt = f"""You are an empathetic, expert Clinical Pharmacist and Patient Care AI Assistant.
Analyze the following prescription for a {request.patient_age}-year-old patient with diagnosis: "{request.diagnosis}".

Medications Prescribed:
{meds_text}

Provide a warm, patient-friendly explanation and lifestyle companion guide. Return ONLY a valid JSON object matching the following structure:

{{
  "patient_explanation": {{
    "summary": "Warm and reassuring explanation of the condition and care plan...",
    "medication_schedule": [
      {{
        "drug_name": "Drug Name",
        "dosage": "500mg",
        "timing": "Morning with breakfast",
        "plain_instruction": "Take 1 pill after morning meal with water"
      }}
    ],
    "plain_instructions": [
      "Plain step-by-step instruction 1",
      "Plain step-by-step instruction 2"
    ],
    "safety_warnings": [
      "Safety warning 1",
      "Safety warning 2"
    ]
  }},
  "lifestyle_companion": {{
    "dietary_advice": [
      "Dietary tip 1",
      "Dietary tip 2"
    ],
    "hydration_advice": [
      "Hydration guideline 1"
    ],
    "physical_activity_recommendations": [
      "Activity recommendation 1",
      "Activity recommendation 2"
    ],
    "preventive_tips": [
      "Preventive tip 1",
      "Preventive tip 2"
    ]
  }}
}}
"""
        return prompt

    @classmethod
    def analyze_prescription(cls, request: PrescriptionAnalysisRequest) -> Dict[str, Any]:
        openai_key = os.getenv("OPENAI_API_KEY")
        gemini_key = os.getenv("GEMINI_API_KEY") or os.getenv("GOOGLE_API_KEY")

        if openai_key:
            try:
                import urllib.request
                prompt = cls._generate_structured_prompt(request)
                req_data = json.dumps({
                    "model": "gpt-4o-mini",
                    "messages": [{"role": "user", "content": prompt}],
                    "response_format": {"type": "json_object"},
                    "temperature": 0.3
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
                logger.warning(f"OpenAI API call failed, falling back to structured generator: {e}")

        if gemini_key:
            try:
                import urllib.request
                prompt = cls._generate_structured_prompt(request)
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
                logger.warning(f"Gemini API call failed, falling back to structured generator: {e}")

        return cls._intelligent_fallback_generator(request)

    @classmethod
    def _intelligent_fallback_generator(cls, request: PrescriptionAnalysisRequest) -> Dict[str, Any]:
        diagnosis = request.diagnosis.strip()
        age = request.patient_age
        meds = request.medications

        med_schedules = []
        plain_instr = []
        safety_warns = []

        for idx, med in enumerate(meds, start=1):
            d_name = med.drug_name.strip()
            dosage = med.dosage.strip()
            freq = med.frequency.strip()
            dur = med.duration.strip()
            extra = f" ({med.instructions.strip()})" if med.instructions else ""

            timing = "Morning & Evening"
            freq_lower = freq.lower()
            if "once" in freq_lower or "daily" in freq_lower:
                timing = "Once daily (Morning)"
            elif "twice" in freq_lower or "12" in freq_lower:
                timing = "Morning (with breakfast) and Evening (with dinner)"
            elif "thrice" in freq_lower or "8" in freq_lower or "3" in freq_lower:
                timing = "Morning, Afternoon, and Night (every 8 hours)"
            elif "night" in freq_lower or "bed" in freq_lower:
                timing = "At bedtime"

            instruction_str = f"Take {dosage} of {d_name} {freq.lower()} for {dur}.{extra}"
            med_schedules.append({
                "drug_name": d_name,
                "dosage": dosage,
                "timing": timing,
                "plain_instruction": instruction_str
            })

            plain_instr.append(f"Medication {idx}: Take {d_name} ({dosage}) strictly as prescribed for {dur}.")

            d_name_lower = d_name.lower()
            if any(term in d_name_lower for term in ["amoxicillin", "cipro", "azithro", "augmentin", "cef", "antibiotic"]):
                safety_warns.append(f"Complete the full {dur} course of {d_name} even if you feel better earlier.")
                safety_warns.append(f"Contact your healthcare provider if you experience persistent diarrhea, rash, or allergic reactions while taking {d_name}.")
            elif any(term in d_name_lower for term in ["ibuprofen", "aspirin", "naproxen", "paracetamol", "acetaminophen", "panadol"]):
                safety_warns.append(f"Take {d_name} with food or milk to prevent stomach discomfort. Do not exceed maximum daily limits.")
            elif any(term in d_name_lower for term in ["metformin", "gliclazide", "insulin"]):
                safety_warns.append(f"Monitor blood glucose levels regularly while taking {d_name} and carry a fast-acting sugar source.")
            else:
                safety_warns.append(f"Do not stop or alter your dosage of {d_name} without consulting your doctor.")

        if age >= 65:
            safety_warns.append("As a precaution for older adults, stand up slowly after sitting to prevent dizziness or fall hazards.")
        safety_warns.append("Store all medications in a cool, dry place out of direct heat and reach of children.")

        med_names = ", ".join([m.drug_name for m in meds])
        summary = (
            f"Hello! Your treatment plan for {diagnosis} includes {len(meds)} prescribed medication(s): {med_names}. "
            f"With consistent administration over the recommended timeframe and supportive care, "
            f"you are on the right path toward recovery and optimal health."
        )

        dietary_advice = [
            f"Eat a well-balanced diet rich in fresh vegetables, lean proteins, and whole grains to support recovery from {diagnosis}.",
            "Avoid high-sodium processed foods and limit excessive refined sugars."
        ]

        hydration_advice = [
            "Drink at least 2.0 to 2.5 liters of clean water daily to stay hydrated and facilitate drug absorption and kidney function.",
            "Limit alcoholic beverages and excessive caffeine while taking prescribed treatment."
        ]

        if age >= 65:
            physical_activity = [
                "Engage in gentle stretching and balance-friendly indoor walking as comfortable.",
                "Prioritize ample rest intervals between daily activities."
            ]
        else:
            physical_activity = [
                "Engage in light to moderate walking for 15-30 minutes daily as tolerated.",
                "Ensure adequate rest and 7-8 hours of sleep each night to help your body heal."
            ]

        preventive_tips = [
            "Follow up with your primary physician or specialist if symptoms persist or worsen.",
            "Keep a daily medication log or phone reminder to ensure on-time doses.",
            "Monitor key vital signs (such as body temperature or blood pressure) as advised by your clinic."
        ]

        return {
            "patient_explanation": {
                "summary": summary,
                "medication_schedule": med_schedules,
                "plain_instructions": plain_instr,
                "safety_warnings": safety_warns
            },
            "lifestyle_companion": {
                "dietary_advice": dietary_advice,
                "hydration_advice": hydration_advice,
                "physical_activity_recommendations": physical_activity,
                "preventive_tips": preventive_tips
            }
        }


def process_prescription_analysis(request: PrescriptionAnalysisRequest) -> PrescriptionAnalysisResponse:
    """Orchestrates prescription analysis request and returns validated response."""
    raw_result = LLMAnalysisEngine.analyze_prescription(request)
    response_payload = {
        "prescription_id": request.prescription_id,
        "patient_explanation": raw_result.get("patient_explanation", {}),
        "lifestyle_companion": raw_result.get("lifestyle_companion", {})
    }
    return PrescriptionAnalysisResponse(**response_payload)
