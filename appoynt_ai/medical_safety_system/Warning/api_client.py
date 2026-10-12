import requests
from typing import List, Dict, Any, Optional

# =====================================================================
# Dynamic Drug & Clinical Knowledge Base (Fallback & Enhancement)
# =====================================================================

DRUG_DATABASE: Dict[str, Dict[str, Any]] = {
    "amoxil": {
        "trade_name": "Amoxil",
        "active_ingredients": ["amoxicillin"],
        "drug_class": "penicillin",
        "category": "antibiotic",
        "alternatives": ["Zithromax", "Klabax", "Cefzil"]
    },
    "augmentin": {
        "trade_name": "Augmentin",
        "active_ingredients": ["amoxicillin", "clavulanate"],
        "drug_class": "penicillin",
        "category": "antibiotic",
        "alternatives": ["Zithromax", "Klabax", "Cefzil"]
    },
    "voltaren": {
        "trade_name": "Voltaren",
        "active_ingredients": ["diclofenac"],
        "drug_class": "nsaid",
        "category": "analgesic_antiinflammatory",
        "alternatives": ["Panadol", "Celebrex", "Tylenol"]
    },
    "brufen": {
        "trade_name": "Brufen",
        "active_ingredients": ["ibuprofen"],
        "drug_class": "nsaid",
        "category": "analgesic_antiinflammatory",
        "alternatives": ["Panadol", "Celebrex", "Tylenol"]
    },
    "advil": {
        "trade_name": "Advil",
        "active_ingredients": ["ibuprofen"],
        "drug_class": "nsaid",
        "category": "analgesic_antiinflammatory",
        "alternatives": ["Panadol", "Celebrex", "Tylenol"]
    },
    "aspirin": {
        "trade_name": "Aspirin",
        "active_ingredients": ["acetylsalicylic acid"],
        "drug_class": "nsaid",
        "category": "analgesic_antiinflammatory",
        "alternatives": ["Panadol", "Tylenol"]
    },
    "panadol": {
        "trade_name": "Panadol",
        "active_ingredients": ["paracetamol"],
        "drug_class": "analgesic",
        "category": "analgesic_antiinflammatory",
        "alternatives": ["Tylenol"]
    },
    "tylenol": {
        "trade_name": "Tylenol",
        "active_ingredients": ["paracetamol"],
        "drug_class": "analgesic",
        "category": "analgesic_antiinflammatory",
        "alternatives": ["Panadol"]
    },
    "celebrex": {
        "trade_name": "Celebrex",
        "active_ingredients": ["celecoxib"],
        "drug_class": "cox2_inhibitor",
        "category": "analgesic_antiinflammatory",
        "alternatives": ["Panadol", "Tylenol"]
    },
    "zithromax": {
        "trade_name": "Zithromax",
        "active_ingredients": ["azithromycin"],
        "drug_class": "macrolide",
        "category": "antibiotic",
        "alternatives": ["Klabax", "Cefzil"]
    },
    "klabax": {
        "trade_name": "Klabax",
        "active_ingredients": ["clarithromycin"],
        "drug_class": "macrolide",
        "category": "antibiotic",
        "alternatives": ["Zithromax", "Cefzil"]
    },
    "cefzil": {
        "trade_name": "Cefzil",
        "active_ingredients": ["cefprozil"],
        "drug_class": "cephalosporin",
        "category": "antibiotic",
        "alternatives": ["Zithromax", "Klabax"]
    },
    "lipitor": {
        "trade_name": "Lipitor",
        "active_ingredients": ["atorvastatin"],
        "drug_class": "statin",
        "category": "lipid_lowering",
        "alternatives": ["Crestor", "Zetia"]
    },
    "crestor": {
        "trade_name": "Crestor",
        "active_ingredients": ["rosuvastatin"],
        "drug_class": "statin",
        "category": "lipid_lowering",
        "alternatives": ["Lipitor", "Zetia"]
    },
    "glucophage": {
        "trade_name": "Glucophage",
        "active_ingredients": ["metformin"],
        "drug_class": "biguanide",
        "category": "antidiabetic",
        "alternatives": ["Januvia", "Jardiance"]
    },
    "lasix": {
        "trade_name": "Lasix",
        "active_ingredients": ["furosemide"],
        "drug_class": "loop_diuretic",
        "category": "antihypertensive_diuretic",
        "alternatives": ["Aldactone"]
    }
}

# Active Ingredient to Drug Class Mapping
INGREDIENT_CLASS_MAP: Dict[str, str] = {
    "amoxicillin": "penicillin",
    "ampicillin": "penicillin",
    "penicillin": "penicillin",
    "clavulanate": "beta_lactamase_inhibitor",
    "diclofenac": "nsaid",
    "ibuprofen": "nsaid",
    "naproxen": "nsaid",
    "ketoprofen": "nsaid",
    "indomethacin": "nsaid",
    "acetylsalicylic acid": "nsaid",
    "aspirin": "nsaid",
    "celecoxib": "cox2_inhibitor",
    "paracetamol": "analgesic",
    "acetaminophen": "analgesic",
    "azithromycin": "macrolide",
    "clarithromycin": "macrolide",
    "erythromycin": "macrolide",
    "cefprozil": "cephalosporin",
    "cephalexin": "cephalosporin",
    "ceftriaxone": "cephalosporin",
    "atorvastatin": "statin",
    "rosuvastatin": "statin",
    "simvastatin": "statin",
    "metformin": "biguanide",
    "furosemide": "loop_diuretic",
    "warfarin": "anticoagulant"
}

# Contraindication Rules for Active Ingredients / Drug Classes vs Chronic Diseases
DISEASE_CONTRAINDICATIONS: Dict[str, List[Dict[str, Any]]] = {
    "peptic ulcer": [
        {"class": "nsaid", "reason": "NSAIDs cause gastric mucosal injury and severe GI bleeding."},
        {"ingredient": "aspirin", "reason": "Aspirin increases risk of ulceration and gastrointestinal hemorrhage."}
    ],
    "gastritis": [
        {"class": "nsaid", "reason": "NSAIDs exacerbate gastric irritation and mucosal breakdown."}
    ],
    "asthma": [
        {"class": "nsaid", "reason": "NSAIDs can trigger severe bronchospasm in NSAID-sensitive asthma patients."}
    ],
    "renal failure": [
        {"class": "nsaid", "reason": "NSAIDs impair renal blood flow and worsen acute/chronic kidney disease."},
        {"ingredient": "metformin", "reason": "Metformin poses risk of lactic acidosis in severe renal impairment."}
    ],
    "kidney disease": [
        {"class": "nsaid", "reason": "NSAIDs reduce glomerular filtration rate and exacerbate kidney damage."}
    ],
    "hypertension": [
        {"class": "nsaid", "reason": "NSAIDs cause sodium/water retention and elevate blood pressure."}
    ],
    "heart failure": [
        {"class": "nsaid", "reason": "NSAIDs induce fluid retention and exacerbate cardiac overload."}
    ],
    "liver disease": [
        {"ingredient": "paracetamol", "reason": "High-dose acetaminophen/paracetamol poses risk of hepatotoxicity."}
    ]
}


# =====================================================================
# 1. Drugs Dataset API
# =====================================================================
class DrugsDatasetAPI:
    """
    Resolves any Trade Name -> Active Ingredient(s) and metadata dynamically.
    Integrates RxNorm API with fallback to internal knowledge base.
    """
    @staticmethod
    def get_active_ingredients(trade_name: str) -> List[str]:
        clean_name = trade_name.strip()
        if not clean_name:
            return []
        
        # Check local DB first for instant, accurate resolution
        lower_name = clean_name.lower()
        if lower_name in DRUG_DATABASE:
            return DRUG_DATABASE[lower_name]["active_ingredients"]
        
        # Try Live RxNorm API
        try:
            url = f"https://rxnav.nlm.nih.gov/REST/rxcui.json?name={clean_name}"
            res = requests.get(url, timeout=3)
            if res.status_code == 200:
                id_group = res.json().get("idGroup", {})
                rxnorm_ids = id_group.get("rxnormId", [])
                if rxnorm_ids:
                    rxcui = rxnorm_ids[0]
                    ing_url = f"https://rxnav.nlm.nih.gov/REST/rxcui/{rxcui}/allrelated.json"
                    ing_res = requests.get(ing_url, timeout=3)
                    if ing_res.status_code == 200:
                        concept_groups = ing_res.json().get("allRelatedGroup", {}).get("conceptGroup", [])
                        ingredients = []
                        for group in concept_groups:
                            if group.get("tty") == "IN":
                                for concept in group.get("conceptProperties", []):
                                    ingredients.append(concept["name"].lower())
                        if ingredients:
                            return ingredients
        except Exception:
            pass

        # Fallback substring / ingredient check
        for known_drug, info in DRUG_DATABASE.items():
            if known_drug in lower_name or lower_name in known_drug:
                return info["active_ingredients"]
        
        # Return cleaned input if no match found
        return [lower_name]

    @staticmethod
    def get_drug_class(ingredient_or_trade: str) -> str:
        clean = ingredient_or_trade.lower().strip()
        if clean in DRUG_DATABASE:
            return DRUG_DATABASE[clean]["drug_class"]
        return INGREDIENT_CLASS_MAP.get(clean, "unknown")


# =====================================================================
# 2. Allergies Dataset API
# =====================================================================
class AllergiesDatasetAPI:
    """
    Checks active-ingredient cross-sensitivity and drug-allergy conflicts.
    """
    @staticmethod
    def check_allergy_conflict(
        prescribed_drug: str,
        prescribed_ingredients: List[str],
        allergy_input: str
    ) -> Optional[Dict[str, Any]]:
        allergy_clean = allergy_input.strip()
        if not allergy_clean:
            return None

        # Resolve allergy entry (whether Trade Name or Active Ingredient) to active ingredients
        allergy_ingredients = DrugsDatasetAPI.get_active_ingredients(allergy_clean)
        allergy_classes = [DrugsDatasetAPI.get_drug_class(ing) for ing in allergy_ingredients]
        allergy_classes.append(DrugsDatasetAPI.get_drug_class(allergy_clean))

        prescribed_classes = [DrugsDatasetAPI.get_drug_class(ing) for ing in prescribed_ingredients]
        prescribed_classes.append(DrugsDatasetAPI.get_drug_class(prescribed_drug))

        # Check 1: Direct Active Ingredient Match
        for p_ing in prescribed_ingredients:
            for a_ing in allergy_ingredients:
                if p_ing == a_ing or (len(p_ing) > 3 and (p_ing in a_ing or a_ing in p_ing)):
                    return {
                        "is_conflict": True,
                        "conflict_type": "DRUG-ALLERGY INGREDIENT MATCH",
                        "conflicting_ingredient": p_ing,
                        "details": f"CRITICAL: Patient allergy to '{allergy_clean}' ({a_ing}) directly matches prescribed '{prescribed_drug}' ({p_ing})."
                    }

        # Check 2: Cross-Sensitivity by Drug Class (e.g. Penicillins, NSAIDs)
        for p_cls in prescribed_classes:
            for a_cls in allergy_classes:
                if p_cls != "unknown" and p_cls == a_cls:
                    matched_ing = ", ".join(prescribed_ingredients)
                    return {
                        "is_conflict": True,
                        "conflict_type": "DRUG-ALLERGY CROSS SENSITIVITY",
                        "conflicting_ingredient": f"Class: {p_cls.upper()} ({matched_ing})",
                        "details": f"CRITICAL CROSS-SENSITIVITY: Patient allergy to '{allergy_clean}' shares the pharmacological class '{p_cls.upper()}' with prescribed '{prescribed_drug}'."
                    }

        # Check 3: Text substring match on trade names/ingredients (e.g. 'amox' in both)
        p_str = f"{prescribed_drug} {' '.join(prescribed_ingredients)}".lower()
        a_str = f"{allergy_clean} {' '.join(allergy_ingredients)}".lower()

        patterns = ["amox", "penicillin", "ceph", "sulfa", "statin"]
        for pat in patterns:
            if pat in p_str and pat in a_str:
                return {
                    "is_conflict": True,
                    "conflict_type": "DRUG-ALLERGY CROSS SENSITIVITY",
                    "conflicting_ingredient": f"Pattern Match ({pat})",
                    "details": f"CRITICAL: Prescribed '{prescribed_drug}' shares active component family ({pat}) with allergy '{allergy_clean}'."
                }

        return None


# =====================================================================
# 3. Chronic Diseases API
# =====================================================================
class ChronicDiseasesAPI:
    """
    Checks contraindications between active ingredients / drug classes and chronic conditions.
    """
    @staticmethod
    def check_disease_contraindication(
        prescribed_drug: str,
        prescribed_ingredients: List[str],
        disease_input: str
    ) -> Optional[Dict[str, Any]]:
        disease_clean = disease_input.strip().lower()
        if not disease_clean:
            return None

        # Try Live OpenFDA Label API first
        try:
            url = f"https://api.fda.gov/drug/label.json?search=openfda.brand_name:'{prescribed_drug}'&limit=1"
            res = requests.get(url, timeout=3)
            if res.status_code == 200:
                result = res.json().get("results", [])[0]
                fda_text = " ".join(result.get("contraindications", []) + result.get("warnings", [])).lower()
                if disease_clean in fda_text:
                    return {
                        "is_conflict": True,
                        "conflict_type": "CHRONIC DISEASE CONTRAINDICATION (FDA)",
                        "conflicting_ingredient": f"Condition: {disease_input}",
                        "details": f"FDA CONTRAINDICATION: Official label for '{prescribed_drug}' warns against use in patients with '{disease_input}'."
                    }
        except Exception:
            pass

        # Check clinical contraindications rule base
        prescribed_classes = [DrugsDatasetAPI.get_drug_class(ing) for ing in prescribed_ingredients]
        prescribed_classes.append(DrugsDatasetAPI.get_drug_class(prescribed_drug))

        for known_disease, rules in DISEASE_CONTRAINDICATIONS.items():
            if known_disease in disease_clean or disease_clean in known_disease:
                for rule in rules:
                    req_class = rule.get("class")
                    req_ing = rule.get("ingredient")

                    if req_class and req_class in prescribed_classes:
                        return {
                            "is_conflict": True,
                            "conflict_type": "CHRONIC DISEASE CONTRAINDICATION",
                            "conflicting_ingredient": f"Condition: {disease_input} | Class: {req_class.upper()}",
                            "details": f"CONTRAINDICATION: Prescribed '{prescribed_drug}' ({req_class.upper()}) is contraindicated for patient condition '{disease_input}'. {rule['reason']}"
                        }
                    
                    if req_ing and any(req_ing in ing for ing in prescribed_ingredients):
                        return {
                            "is_conflict": True,
                            "conflict_type": "CHRONIC DISEASE CONTRAINDICATION",
                            "conflicting_ingredient": f"Condition: {disease_input} | Ingredient: {req_ing}",
                            "details": f"CONTRAINDICATION: Prescribed '{prescribed_drug}' ({req_ing}) is contraindicated for '{disease_input}'. {rule['reason']}"
                        }

        return None


# =====================================================================
# 4. Side Effects / Alternatives API
# =====================================================================
class AlternativesAPI:
    """
    Queries safe alternative trade-name medications containing active ingredients
    that DO NOT conflict with the patient's specific profile (allergies or chronic diseases).
    """
    @staticmethod
    def get_safe_alternatives(
        prescribed_drug: str,
        prescribed_ingredients: List[str],
        patient_profile: Dict[str, Any]
    ) -> List[str]:
        lower_name = prescribed_drug.strip().lower()
        allergies = patient_profile.get("allergies", [])
        diseases = patient_profile.get("chronic_diseases", [])

        # Candidate pool based on therapeutic category
        candidate_pool: List[str] = []
        if lower_name in DRUG_DATABASE:
            candidate_pool = DRUG_DATABASE[lower_name]["alternatives"].copy()
        
        # General fallbacks by category
        p_class = DrugsDatasetAPI.get_drug_class(prescribed_drug)
        if not candidate_pool:
            if p_class in ["nsaid", "cox2_inhibitor"]:
                candidate_pool = ["Panadol", "Tylenol", "Celebrex"]
            elif p_class in ["penicillin", "macrolide", "cephalosporin"]:
                candidate_pool = ["Zithromax", "Klabax", "Cefzil"]
            elif p_class == "statin":
                candidate_pool = ["Crestor", "Zetia"]
            else:
                candidate_pool = ["Panadol Extra", "Paracetamol 500mg"]

        safe_alternatives = []

        for candidate in candidate_pool:
            cand_ingredients = DrugsDatasetAPI.get_active_ingredients(candidate)
            is_safe = True

            # Check candidate against patient allergies
            for allergy in allergies:
                allergy_conflict = AllergiesDatasetAPI.check_allergy_conflict(
                    candidate, cand_ingredients, allergy
                )
                if allergy_conflict:
                    is_safe = False
                    break

            if not is_safe:
                continue

            # Check candidate against patient chronic diseases
            for disease in diseases:
                disease_conflict = ChronicDiseasesAPI.check_disease_contraindication(
                    candidate, cand_ingredients, disease
                )
                if disease_conflict:
                    is_safe = False
                    break

            if is_safe and candidate.lower() != lower_name:
                safe_alternatives.append(candidate)

        if not safe_alternatives:
            safe_alternatives = ["Consult prescribing physician for custom non-conflicting formulation"]

        return list(set(safe_alternatives))


# Standalone function aliases for backwards compatibility
def get_active_ingredients(drug_name: str) -> List[str]:
    return DrugsDatasetAPI.get_active_ingredients(drug_name)

def get_safe_alternatives(drug_name: str, patient_profile: Optional[Dict[str, Any]] = None) -> List[str]:
    if patient_profile is None:
        patient_profile = {}
    ingredients = DrugsDatasetAPI.get_active_ingredients(drug_name)
    return AlternativesAPI.get_safe_alternatives(drug_name, ingredients, patient_profile)


if __name__ == "__main__":
    test_drug = "Amoxil"
    print(f"Active ingredients for {test_drug}:", DrugsDatasetAPI.get_active_ingredients(test_drug))

    