from typing import List, Dict, Any

def generate_clinical_alert(conflicts: List[Dict[str, Any]]) -> Dict[str, Any]:
    """
    Generates a structured Clinical Advisory Report JSON based on identified safety conflicts.
    """
    if not conflicts:
        return {
            "status": "SAFE",
            "has_conflict": False,
            "total_conflicts": 0,
            "message": "Prescription is safe. No allergy, chronic condition, or food conflicts detected.",
            "alerts": [],
            "recommendation": "Prescription verified safe to proceed."
        }

    alerts_list = []
    for c in conflicts:
        alerts_list.append({
            "drug": c.get("drug"),
            "conflict_type": c.get("conflict_type"),
            "conflicting_ingredient": c.get("conflicting_ingredient"),
            "details": c.get("details"),
            "alternatives": c.get("alternatives", [])
        })

    return {
        "status": "DANGER",
        "has_conflict": True,
        "total_conflicts": len(conflicts),
        "message": f"CRITICAL SAFETY WARNING: Identified {len(conflicts)} potential risk conflict(s) in prescription.",
        "alerts": alerts_list,
        "recommendation": "Review patient profile and consider substituting prescribed trade drug(s) with verified safe alternatives."
    }

if __name__ == "__main__":
    dummy_conflict = [{
        "drug": "Amoxil",
        "conflict_type": "DRUG-ALLERGY CROSS SENSITIVITY",
        "conflicting_ingredient": "amoxicillin",
        "details": "Prescribed drug 'Amoxil' contains 'amoxicillin', matching patient's penicillin allergy.",
        "alternatives": ["Zithromax", "Klabax"]
    }]
    
    print("Test Clinical Advisory Report:")
    print(generate_clinical_alert(dummy_conflict))