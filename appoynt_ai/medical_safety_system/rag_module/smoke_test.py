"""
Turn-based triage state machine smoke test.
Tests is_final_assessment decisions WITHOUT loading FAISS.
"""
import sys, os, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from rag_engine import (
    classify_user_intent, extract_positive_clinical_findings,
    is_medication_request, get_targeted_probing_questions,
    CLINICAL_SPECIALTIES_WHITELIST
)

# ──────────────────────────────────────────────────────────────────────────────
# Inline the state machine logic (mirrors chat_turn without FAISS)
# ──────────────────────────────────────────────────────────────────────────────
def simulate_triage_state(input_clean: str, user_turn_count: int) -> dict:
    asking_for_meds = is_medication_request(input_clean)

    emergency_keywords_ar = [
        "ضيق تنفس حاد", "ألم صدر شديد", "فقدان وعي", "شلل", "نزيف حاد", "تشنج مفاجئ",
        "دم في البراز", "دم في البول", "فقدان الرؤية", "صداع رعدي", "ضغط دم حرج"
    ]
    emergency_keywords_en = [
        "severe chest pain", "can't breathe", "loss of consciousness", "paralysis",
        "severe bleeding", "sudden seizure", "blood in stool", "blood in urine",
        "sudden vision loss", "thunderclap headache"
    ]
    is_emergency = (
        any(kw in input_clean for kw in emergency_keywords_ar) or
        any(kw in input_clean.lower() for kw in emergency_keywords_en)
    )

    if asking_for_meds or is_emergency:
        is_final = True
    elif user_turn_count == 1:
        is_final = False
    else:
        is_final = True

    return {
        "is_final": is_final,
        "is_emergency": is_emergency,
        "asking_for_meds": asking_for_meds,
    }

# ──────────────────────────────────────────────────────────────────────────────
print("=" * 65)
print("TRIAGE STATE MACHINE TESTS")
print("=" * 65)

cases = [
    # (description, input_text, turn, expected_is_final)
    # ── Turn 1 MUST ALWAYS be False (probe) ───────────────────────────
    ("T1: vague abdominal pain (Arabic)",
     "عندي ألم شديد ومغص في بطني من الصبح", 1, False),
    ("T1: detailed chest symptoms",
     "عندي ألم في الصدر مع ضيق تنفس وكحة منذ أسبوع", 1, False),
    ("T1: ENT complaint",
     "أعاني من ألم في الأذن ونغزات بالزور", 1, False),
    ("T1: neurological complaint",
     "عندي صداع شديد وتنميل في اليد اليسرى", 1, False),
    ("T1: English complaint",
     "I have severe knee pain and swelling since yesterday", 1, False),
    # ── Turn 1 EXCEPTIONS (immediate response) ────────────────────────
    ("T1 EXCEPTION: medication request",
     "عايز مسكن للألم دلوقتي", 1, True),
    ("T1 EXCEPTION: emergency red-flag",
     "فقدان وعي مفاجئ وشلل في الجهة اليمنى", 1, True),
    ("T1 EXCEPTION: emergency EN",
     "severe chest pain radiating to my left arm", 1, True),
    # ── Turn 2+ MUST be True (finalize) ───────────────────────────────
    ("T2: follow-up answer after abdominal pain",
     "الألم في المنطقة العليا وبيزيد بعد الأكل ومعاه غثيان", 2, True),
    ("T2: follow-up answer after chest",
     "الألم ضاغط بيتمد للكتف وبيزيد مع المجهود", 2, True),
    ("T3: third turn detailed answer",
     "البارحة اشتدت الأعراض وارتفعت الحرارة لـ38.5", 3, True),
]

all_pass = True
for desc, text, turn, expected in cases:
    result = simulate_triage_state(text, turn)
    status = "PASS" if result["is_final"] == expected else "FAIL"
    if status == "FAIL":
        all_pass = False
    flag_info = ""
    if result["is_emergency"]: flag_info += " [EMERGENCY]"
    if result["asking_for_meds"]: flag_info += " [MEDS]"
    print(f"  [{status}] {desc}")
    print(f"         Turn={turn} | is_final={result['is_final']} (expected {expected}){flag_info}")

print()
print("State Machine:", "ALL PASSED ✓" if all_pass else "SOME FAILED ✗")

# ──────────────────────────────────────────────────────────────────────────────
print()
print("=" * 65)
print("PROBING QUESTION QUALITY TESTS (Turn 1 responses)")
print("=" * 65)

probing_cases = [
    ("Abdominal/GI", "ألم شديد ومغص في بطني من الصبح"),
    ("ENT", "ألم في الأذن ونغزات بالزور عند البلع"),
    ("Neurology", "صداع شديد وتنميل في اليد اليسرى"),
    ("Chest/Cardio", "ألم في الصدر مع ضيق تنفس"),
    ("Joints/Ortho", "ألم في الركبة وصعوبة في المشي"),
    ("Ophthalmology", "احمرار شديد في العين وزغللة في الرؤية"),
    ("Urology", "حرقان في البول مع ألم في الخاصرة"),
    ("Psychiatry", "اكتئاب شديد وأرق وقلق مستمر"),
]

for specialty_hint, text in probing_cases:
    q = get_targeted_probing_questions(text, is_ar=True)
    # Verify it does NOT contain final-report markers
    has_final_markers = any(marker in q for marker in ["### 🩺", "🏥 **التخصص", "توصيات عامة", "تنبيه طبي"])
    status = "PASS" if not has_final_markers else "FAIL"
    print(f"  [{status}] {specialty_hint:18} | Q: {q[:75]}...")

print()
print(f"Total whitelist specialties: {len(CLINICAL_SPECIALTIES_WHITELIST)}")
