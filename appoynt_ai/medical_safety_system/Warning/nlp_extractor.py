import re
import spacy
from api_client import DRUG_DATABASE

try:
    nlp = spacy.load("en_core_web_sm")
except Exception:
    nlp = None

IGNORED_WORDS = {
    "patient", "prescribed", "take", "daily", "twice", "thrice", "once",
    "mg", "g", "ml", "mg/day", "for", "days", "weeks", "tablet", "tablets",
    "capsule", "capsules", "syrup", "injection", "oral", "sig", "bid", "tid",
    "qid", "po", "prn", "dose", "dosage", "every", "hours", "with", "after",
    "before", "food", "water", "and", "or", "the", "a", "an", "rx"
}

def extract_drugs_from_prescription(prescription_text: str) -> list[str]:
    """
    Dynamically extracts trade-name drugs from raw prescription text
    using a hybrid strategy: Lexicon matching, spaCy NER, and Regex capitalization.
    """
    if not prescription_text or not prescription_text.strip():
        return []

    text = prescription_text.strip()
    extracted_drugs = set()

    # 1. Lexicon Matching against known Trade Names & Active Ingredients
    text_lower = text.lower()
    for known_drug, details in DRUG_DATABASE.items():
        trade_name = details.get("trade_name", known_drug)
        # Word boundary match for trade name or known drug key
        pattern = r'\b' + re.escape(known_drug) + r'\b'
        if re.search(pattern, text_lower):
            extracted_drugs.add(trade_name)
        
        # Check active ingredients matching in text
        for ing in details.get("active_ingredients", []):
            ing_pattern = r'\b' + re.escape(ing) + r'\b'
            if re.search(ing_pattern, text_lower):
                extracted_drugs.add(trade_name)

    # 2. spaCy NER (if available)
    if nlp is not None:
        try:
            doc = nlp(text)
            for ent in doc.ents:
                clean_ent = ent.text.strip().strip(",.;:-")
                if (
                    clean_ent
                    and clean_ent.lower() not in IGNORED_WORDS
                    and not clean_ent.isdigit()
                    and len(clean_ent) > 2
                ):
                    # Filter out purely numeric entities
                    if not re.match(r'^\d+(\.\d+)?\s*(mg|g|ml)?$', clean_ent, re.IGNORECASE):
                        extracted_drugs.add(clean_ent.capitalize())
        except Exception:
            pass

    # 3. Capitalized Word Extraction
    words = re.findall(r'\b[A-Za-z0-9\-/]+\b', text)
    for word in words:
        clean_word = word.strip(",.;:-")
        if (
            clean_word
            and clean_word[0].isupper()
            and clean_word.lower() not in IGNORED_WORDS
            and not clean_word.isdigit()
            and len(clean_word) > 2
        ):
            # Exclude numbers with units like 500mg
            if not re.match(r'^\d+(mg|g|ml)?$', clean_word, re.IGNORECASE):
                extracted_drugs.add(clean_word.capitalize())

    return list(extracted_drugs)

if __name__ == "__main__":
    sample_text = "Prescribed Amoxil 500mg twice daily and Voltaren 75mg for pain."
    print("Extracted Drugs:", extract_drugs_from_prescription(sample_text))