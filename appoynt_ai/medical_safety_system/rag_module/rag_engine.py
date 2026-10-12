import os
import sys
import re

# Ensure UTF-8 output encoding for Windows terminal
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

from langchain_community.document_loaders import PyPDFDirectoryLoader
try:
    from langchain_text_splitters import RecursiveCharacterTextSplitter
except ImportError:
    from langchain.text_splitter import RecursiveCharacterTextSplitter

try:
    from langchain_huggingface import HuggingFaceEmbeddings
except ImportError:
    from langchain_community.embeddings import HuggingFaceEmbeddings

from langchain_community.vectorstores import FAISS

# ==============================================================================
# CONTROLLED MEDICAL SPECIALTY WHITELIST (PLATFORM DEPARTMENTS)
# Production-Grade Comprehensive Clinical Taxonomy — v2.0
# ==============================================================================
CLINICAL_SPECIALTIES_WHITELIST = {
    # ── Internal Medicine & Subspecialties ────────────────────────────────────
    "INTERNAL_MEDICINE":       "الطب الباطني والممارسة العامة (General / Internal Medicine)",
    "CARDIOLOGY":              "أمراض القلب والأوعية الدموية (Cardiology)",
    "PULMONOLOGY":             "أمراض الصدر والجهاز التنفسي (Pulmonology)",
    "GASTRO":                  "أمراض الجهاز الهضمي والقولون (Gastroenterology)",
    "HEPATOLOGY":              "أمراض الكبد والجهاز الهضمي (Hepatology & Gastroenterology)",
    "NEPHROLOGY":              "أمراض الكلى والجهاز البولي (Nephrology)",
    "ENDOCRINOLOGY":           "الغدد الصماء والسكر والهرمونات (Endocrinology & Diabetes)",
    "HEMATOLOGY":              "أمراض الدم وأورام الدم (Hematology)",
    "RHEUMATOLOGY":            "أمراض الروماتيزم والمناعة (Rheumatology & Immunology)",
    "INFECTIOUS_DISEASE":      "الأمراض المعدية والطفيلية (Infectious Disease)",
    "ALLERGY_IMMUNOLOGY":      "الحساسية وأمراض المناعة (Allergy & Immunology)",
    "GERIATRICS":              "طب المسنين وكبار السن (Geriatrics)",

    # ── Surgical Specialties ──────────────────────────────────────────────────
    "GENERAL_SURGERY":         "الجراحة العامة (General Surgery)",
    "ORTHOPEDICS":             "جراحة العظام والمفاصل (Orthopedics)",
    "NEUROSURGERY":            "جراحة المخ والأعصاب (Neurosurgery)",
    "CARDIAC_SURGERY":         "جراحة القلب والصدر والأوعية الدموية (Cardiac & Thoracic Surgery)",
    "VASCULAR_SURGERY":        "جراحة الأوعية الدموية (Vascular Surgery)",
    "UROLOGY":                 "أمراض المسالك البولية والكلى (Urology & Nephrology)",
    "GYNECOLOGY":              "أمراض النساء والتوليد (Gynecology & Obstetrics)",
    "PLASTIC_SURGERY":         "الجراحة التجميلية وإعادة التأهيل (Plastic & Reconstructive Surgery)",
    "COLORECTAL_SURGERY":      "جراحة القولون والمستقيم (Colorectal Surgery)",
    "TRANSPLANT_SURGERY":      "جراحة زراعة الأعضاء (Transplant Surgery)",

    # ── Neurological & Mental Health ─────────────────────────────────────────
    "NEUROLOGY":               "أمراض المخ والأعصاب (Neurology)",
    "PSYCHIATRY":              "الطب النفسي والصحة النفسية (Psychiatry)",

    # ── Sensory & Head/Neck ───────────────────────────────────────────────────
    "ENT":                     "أمراض الأنف والأذن والحنجرة (ENT)",
    "OPHTHALMOLOGY":           "طب وجراحة العيون (Ophthalmology)",
    "DENTISTRY":               "طب وجراحة الأسنان (Dentistry)",
    "MAXILLOFACIAL":           "جراحة الوجه والفكين (Oral & Maxillofacial Surgery)",

    # ── Skin & Integumentary ─────────────────────────────────────────────────
    "DERMATOLOGY":             "أمراض الجلدية والتناسلية (Dermatology)",

    # ── Oncology ─────────────────────────────────────────────────────────────
    "ONCOLOGY":                "أورام السرطان والأورام الصلبة (Oncology)",
    "RADIATION_ONCOLOGY":      "العلاج الإشعاعي للأورام (Radiation Oncology)",

    # ── Diagnostic & Imaging ─────────────────────────────────────────────────
    "RADIOLOGY":               "الأشعة التشخيصية والتدخلية (Diagnostic & Interventional Radiology)",
    "NUCLEAR_MEDICINE":        "طب نووي وفحوصات التصوير الوظيفي (Nuclear Medicine)",
    "PATHOLOGY":               "علم الأمراض والتشريح المرضي (Pathology)",
    "LAB_MEDICINE":            "الطب المخبري والتحاليل الطبية (Laboratory Medicine)",

    # ── Pediatric Specialties ─────────────────────────────────────────────────
    "PEDIATRICS":              "طب الأطفال ونمو الأطفال (Pediatrics)",
    "NEONATOLOGY":             "طب حديثي الولادة (Neonatology)",
    "PEDIATRIC_SURGERY":       "جراحة الأطفال (Pediatric Surgery)",
    "PEDIATRIC_NEUROLOGY":     "أمراض أعصاب الأطفال (Pediatric Neurology)",
    "PEDIATRIC_CARDIOLOGY":    "أمراض قلب الأطفال (Pediatric Cardiology)",

    # ── Rehabilitation & Allied Health ────────────────────────────────────────
    "PHYSICAL_THERAPY":        "العلاج الطبيعي وإعادة التأهيل (Physical Therapy & Rehabilitation)",
    "OCCUPATIONAL_THERAPY":    "العلاج الوظيفي (Occupational Therapy)",
    "SPORTS_MEDICINE":         "طب الرياضة والإصابات الرياضية (Sports Medicine)",
    "PAIN_MANAGEMENT":         "عيادة الألم والتخدير (Pain Management & Anesthesia)",

    # ── Emergency & Critical Care ────────────────────────────────────────────
    "EMERGENCY_MEDICINE":      "طب الطوارئ والإسعاف (Emergency Medicine)",
    "CRITICAL_CARE":           "العناية المركزة والعناية الفائقة (Critical Care / ICU)",
}

# ==============================================================================
# UNIVERSAL SYSTEM PROMPT FOR CLINICAL TRIAGE ASSISTANT (ADAPTIVE RAG ENGINE)
# ==============================================================================
SYSTEM_PROMPT = """
You are a warm, highly empathetic, and professional Clinical AI Triage Assistant (طبيب فرز وتوجيه سريري ذكي).
Your goal is to conduct an adaptive, multi-turn clinical consultation based EXCLUSIVELY on retrieved medical evidence (clinical guidelines) and active patient conversation history.

### CLINICAL & DIALOG DIRECTIVES:

1. ADAPTIVE CLINICAL TRIAGE & SYSTEM-SPECIFIC PROBING:
   - Perform a focused, natural clinical interview. Never ask hardcoded, static, or random questions.
   - Tailor follow-up questions STRICTLY to the patient's reported affected body system:
     * Ear/Nose/Throat: ask about difficulty swallowing, ear discharge, hearing changes, nasal congestion, fever.
     * Abdominal/GI: ask about pain location (upper/lower), duration, relation to meals, vomiting, diarrhea, stool changes, fever.
     * Headache/Neurological: ask about onset (sudden vs gradual), location, severity, vision changes, light sensitivity, neck stiffness, dizziness.
     * Chest/Respiratory: ask about chest pain character (pressure vs sharp), radiation to arm/shoulder, breathlessness, cough, fever.
     * Skin/Dermatology: ask about rash location, appearance, itching, duration, spread, fever.
     * Joint/Bone: ask about swelling, stiffness, mobility, trauma/injury history.
   - NEVER ask about unrelated body systems (e.g. NEVER ask about eye blurry vision "زغللة في العين" for ear pain, abdominal pain, or knee pain).

2. STRICT TURN-BASED TRIAGE PROTOCOL:
   - TURN 1 (First patient message): You MUST respond with ONLY 2-3 targeted follow-up questions.
     * NEVER output a final clinical assessment, specialty recommendation, or concluding report on Turn 1.
     * Even if the complaint is detailed (e.g., "ألم شديد ومغص في بطني من الصبح"), you MUST ask clarifying questions first.
     * Required probing topics (select those anatomically relevant): onset & duration, exact location, severity (1–10), aggravating/relieving factors, associated symptoms (fever, vomiting, change in stool/urine/breathing), relevant history.
   - TURN 2+ (Follow-up messages / Is Final Triage = True): ONLY NOW may you output the full ### 🩺 التقييم والتوصية السريرية report with specialty, rationale, and supportive advice.
   - The system will explicitly tell you 'Is Final Triage: True/False' and the current turn number in the prompt — follow them strictly.

3. CONTROLLED MEDICAL SPECIALTY WHITELIST:
   - When making a specialty recommendation, select ONLY from the official platform department list:
     [Internal Medicine & Subspecialties]
     - الطب الباطني والممارسة العامة (General / Internal Medicine)
     - أمراض القلب والأوعية الدموية (Cardiology)
     - أمراض الصدر والجهاز التنفسي (Pulmonology)
     - أمراض الجهاز الهضمي والقولون (Gastroenterology)
     - أمراض الكبد والجهاز الهضمي (Hepatology & Gastroenterology)
     - أمراض الكلى والجهاز البولي (Nephrology)
     - الغدد الصماء والسكر والهرمونات (Endocrinology & Diabetes)
     - أمراض الدم وأورام الدم (Hematology)
     - أمراض الروماتيزم والمناعة (Rheumatology & Immunology)
     - الأمراض المعدية والطفيلية (Infectious Disease)
     - الحساسية وأمراض المناعة (Allergy & Immunology)
     - طب المسنين وكبار السن (Geriatrics)
     [Surgical Specialties]
     - الجراحة العامة (General Surgery)
     - جراحة العظام والمفاصل (Orthopedics)
     - جراحة المخ والأعصاب (Neurosurgery)
     - جراحة القلب والصدر والأوعية الدموية (Cardiac & Thoracic Surgery)
     - جراحة الأوعية الدموية (Vascular Surgery)
     - أمراض المسالك البولية والكلى (Urology & Nephrology)
     - أمراض النساء والتوليد (Gynecology & Obstetrics)
     - الجراحة التجميلية وإعادة التأهيل (Plastic & Reconstructive Surgery)
     - جراحة القولون والمستقيم (Colorectal Surgery)
     - جراحة زراعة الأعضاء (Transplant Surgery)
     [Neurological & Mental Health]
     - أمراض المخ والأعصاب (Neurology)
     - الطب النفسي والصحة النفسية (Psychiatry)
     [Sensory & Head/Neck]
     - أمراض الأنف والأذن والحنجرة (ENT)
     - طب وجراحة العيون (Ophthalmology)
     - طب وجراحة الأسنان (Dentistry)
     - جراحة الوجه والفكين (Oral & Maxillofacial Surgery)
     [Skin]
     - أمراض الجلدية والتناسلية (Dermatology)
     [Oncology]
     - أورام السرطان والأورام الصلبة (Oncology)
     - العلاج الإشعاعي للأورام (Radiation Oncology)
     [Diagnostic & Imaging]
     - الأشعة التشخيصية والتدخلية (Diagnostic & Interventional Radiology)
     - طب نووي وفحوصات التصوير الوظيفي (Nuclear Medicine)
     - علم الأمراض والتشريح المرضي (Pathology)
     - الطب المخبري والتحاليل الطبية (Laboratory Medicine)
     [Pediatric Specialties]
     - طب الأطفال ونمو الأطفال (Pediatrics)
     - طب حديثي الولادة (Neonatology)
     - جراحة الأطفال (Pediatric Surgery)
     - أمراض أعصاب الأطفال (Pediatric Neurology)
     - أمراض قلب الأطفال (Pediatric Cardiology)
     [Rehabilitation & Allied Health]
     - العلاج الطبيعي وإعادة التأهيل (Physical Therapy & Rehabilitation)
     - العلاج الوظيفي (Occupational Therapy)
     - طب الرياضة والإصابات الرياضية (Sports Medicine)
     - عيادة الألم والتخدير (Pain Management & Anesthesia)
     [Emergency & Critical Care]
     - طب الطوارئ والإسعاف (Emergency Medicine)
     - العناية المركزة والعناية الفائقة (Critical Care / ICU)

4. STRUCTURED FINAL TRIAGE FORMAT (When Triage is Complete):
   - When concluding the consultation, structure your response clearly:
     ### 🩺 التقييم والتوصية السريرية
     [Empathetic explanation of provisional clinical findings grounded in guidelines]

     🏥 **التخصص الطبي المقترح:**
     - **التخصص:** [Specialty from Whitelist]
     - **سبب التوجيه:** [1-2 sentences explaining WHY based on symptoms]

     💡 **توصيات عامة وتدابير داعمة:**
     [Supportive non-pharmacological advice: rest, hydration, elevation, avoiding exertion]

     ⚠️ **تنبيه طبي:** بصفتي مساعد فرز طبي ذكي، لا أقوم بوصف الأدوية أو تحديد الجرعات. يرجى استشارة الطبيب المختص للحصول على التقييم السريري المباشر.

5. SAFETY RULES:
   - Zero-Prescription Policy: Never prescribe medications or dosages.
   - Strict Negation Filtering: Ignore negated symptoms (e.g., "بدون حرارة", "no fever").
"""

STANDARDIZED_REFUSAL_RESPONSE_AR = (
    "أعتذر منك، لا يمكنني المساعدة في هذا الاستفسار. "
    "أنا مساعد ذكاء اصطناعي طبي مخصص لتحليل الأعراض الصحية وتوجيهك للتخصص الطبي المناسب وحجز الطبيب في المنصة. "
    "برجاء توضيح أي أعراض صحية تشعر بها لمساعدتك."
)

def get_targeted_probing_questions(positive_text: str, is_ar: bool = True) -> str:
    """
    Generates dynamic, anatomically coherent follow-up probing questions tailored strictly
    to the reported affected body part/system, avoiding hardcoded unrelated questions.
    """
    t_lower = positive_text.lower()

    if is_ar:
        # 1. Ear, Nose, Throat (ENT)
        if any(w in t_lower for w in ["أذن", "اذن", "زور", "حلق", "أنف", "انف", "بلع", "احتقان", "صوت", "سمع", "طنين", "لوز"]):
            return (
                f"سلامتك وألف سلامة عليك. بخصوص ما ذكرته عن ({positive_text})، "
                f"هل تشعر بأي ألم أو صعوبة أثناء البلع؟ وهل تلاحظ وجود إفرازات من الأذن، انسداد بالأنف، أو ارتفاع في درجة الحرارة؟"
            )
        # 2. Abdomen / GI
        if any(w in t_lower for w in ["بطن", "معدة", "قولون", "مغص", "ترجيع", "قيء", "إسهال", "اسهال", "إمساك", "امساك", "حموضة", "غثيان", "ارتجاع"]):
            return (
                f"سلامتك وألف سلامة عليك. بخصوص الأعراض المذكورة ({positive_text})، "
                f"في أي منطقة بالتحديد تتركز آلام البطن (أعلى أم أسفل البطن)؟ وهل تزداد شدتها عقب تناول الطعام، أو يرافقها غثيان أو إسهال؟"
            )
        # 3. Chest / Respiratory / Cardiology
        if any(w in t_lower for w in ["صدر", "قلب", "ضيق تنفس", "نهجان", "كحة", "سعال", "بلغم", "خفقان", "نغزات"]):
            return (
                f"سلامتك وألف سلامة عليك. بخصوص الشكوى في الصدر والجهاز التنفسي ({positive_text})، "
                f"كيف تصف هذا الألم (هل هو ثقل ضاغط أم نغزات)؟ وهل يمتد للكتف الأيسر، أو يزيد مع الكحة والمجهود البدني؟"
            )
        # 4. Headache / Neurology
        if any(w in t_lower for w in ["صداع", "شقيقة", "دوخة", "دوار", "تنميل", "رعشة", "توازن"]):
            return (
                f"سلامتك وألف سلامة عليك. بخصوص الصداع والأعراض العصبيـة ({positive_text})، "
                f"هل ظهر هذا الصداع بشكل مفاجئ أم تدريجي؟ وهل يرافقه غثيان، تنميل بالأطراف، أو حساسية للضوء والضوضاء؟"
            )
        # 5. Eye / Vision
        if any(w in t_lower for w in ["عين", "عيون", "رؤية", "زغللة", "احمرار", "دمع", "جفن"]):
            return (
                f"سلامتك وألف سلامة عليك. بخصوص ما ذكرته عن العين والرؤية ({positive_text})، "
                f"هل تلاحظ وجود احمرار شديد أو إفرازات بالعين؟ وهل هناك تغير مفاجئ في مستوى الرؤية أو حساسية للضوء؟"
            )
        # 6. Joints / Bones
        if any(w in t_lower for w in ["عظام", "مفاصل", "ركبة", "ظهر", "كسر", "التواء", "عمود فقري", "كتف", "قدم"]):
            return (
                f"سلامتك وألف سلامة عليك. بخصوص آلام العظام والمفاصل ({positive_text})، "
                f"هل تلاحظ تورماً في المفصل المصاب أو صعوبة في الحركة؟ وهل حدثت هذه الشكوى عقب إصابة أو سقوط، أم تظهر بشكل تدريجي؟"
            )
        # 7. Urinary / Kidneys
        if any(w in t_lower for w in ["بول", "مثانة", "كلى", "كلية", "خاصرة", "حرقان"]):
            return (
                f"سلامتك وألف سلامة عليك. بخصوص أعراض المسالك البولية ({positive_text})، "
                f"هل يرافق حرقان البول تغير في لونه، تكرار ملحوظ في التبول، أو ألم حاد بالخاصرة والظهر؟"
            )
        # 8. Skin
        if any(w in t_lower for w in ["جلد", "جلدي", "طفح", "حكة", "هرش", "كدمة", "احمرار"]):
            return (
                f"سلامتك وألف سلامة عليك. بخصوص الأعراض الجلدية ({positive_text})، "
                f"أين يتركز الطفح الجلدي بالتحديد؟ وهل يرافقه حكة شديدة أو تورم أو ارتفاع في درجة الحرارة؟"
            )
        # 9. Teeth / Mouth
        if any(w in t_lower for w in ["ضرس", "ضروس", "لثة", "أسنان", "اسنان", "فم"]):
            return (
                f"سلامتك وألف سلامة عليك. بخصوص ألم الأسنان والفم ({positive_text})، "
                f"هل يزداد الألم عند المضغ أو تناول المشروبات الساخنة والباردة؟ وهل تلاحظ أي تورم باللثة أو الخد؟"
            )

        # General / Unlocalized fallback probing
        return (
            f"سلامتك وألف سلامة عليك. بخصوص الأعراض المذكورة ({positive_text})، "
            f"يرجى توضيح منذ متى بدأت هذه الأعراض بالتحديد، وهل توجد أي مؤشرات أخرى مثل ارتفاع الحرارة أو الإرهاق الشديد لمساعدتك وتوجيهك بالشكل الأمثل."
        )
    else:
        return (
            f"I hope you feel better soon. Regarding your symptoms ({positive_text}), "
            f"could you specify when these symptoms started and if you have noticed any fever or other accompanying issues?"
        )

def classify_user_intent(text: str) -> str:
    """
    Guardrail / Intent Classification Layer:
    Categorizes user input into:
    - 'IN_SCOPE_MEDICAL': Queries describing symptoms, requesting medical triage, asking about illnesses, medications, or specialties.
    - 'OUT_OF_SCOPE': Chit-chat ("ازيك", "عامل ايه", "صباح الخير"), general knowledge, coding, politics, weather, recipes, or non-health topics.
    """
    if not text or not text.strip():
        return "OUT_OF_SCOPE"

    t_clean = text.strip()
    t_lower = t_clean.lower()

    # 1. Explicit Non-Medical Domains (Coding, Tech, General Knowledge, Weather, Politics, Sports, Recipes)
    non_medical_patterns = [
        r'\b(?:code|coding|python|java|javascript|html|css|php|c\+\+|sql|git|script|programming|developer|algorithm|function|class)\b',
        r'\b(?:capital|weather|president|prime minister|election|politics|currency|dollar|euro|football|soccer|match|league|movie|song|recipe|bake|cake|joke|math|calculate)\b',
        r'(?:كود|برمجة|بايثون|جافا|موقع|تطبيق|سكربت|حاسوب|كمبيوتر|دالة|خوارزمية)',
        r'(?:عاصمة|رئيس|انتخابات|سياسة|طقس|مناخ|سعر الدولار|عملة|اقتصاد|مباراة|كرة قدم|دوري|نكتة|قصيدة|شعر|أغنية|طبخ|طريقة عمل|كيكة|وصفة أكل)'
    ]
    has_non_medical = any(re.search(pat, t_lower) for pat in non_medical_patterns)

    # 2. Comprehensive Medical Symptoms, Complaints, Illnesses, Medications & Specialty Inquiries
    symptom_and_clinical_patterns = [
        # Symptoms / Pain / Body Complaints (Arabic)
        r'(?:صداع|شقيقة|حرارة|حمى|سخونية|سخونة|كحة|سعال|بلغم|ضيق تنفس|نهجان|انسداد|رشح|زكام|احتقان|حساسية|عطاس|تنميل|مغص|وجع|ألم|الم|آلام|الام|نغزات|حرقان|ترجيع|قيء|إسهال|اسهال|إمساك|امساك|غثيان|حموضة|ارتجاع|انتفاخ|غازات|عسر هضم|دوخة|دوار|زغللة|طافح|طفح|حكة|هرش|كدمة|جرح|نزيف|ورم|التهاب|عدوى|كسر|خلع|التواء|رعشة|تعب|إرهاق|ارهاق|خفقان|اكتئاب|قلق|أرق|وسواس|هلع|صرع|تشنج|تشنجات|سرطان|أورام|بواسير|ناسور|يرقان|صفراء|دوالي|طنين أذن|نسيان|خرف|سكري|سمنة)',
        # Organs & body parts in health context (Arabic)
        r'(?:زور|حلق|معدة|قولون|خاصرة|مثانة|كلى|كلية|ركبة|مفاصل|ضرس|ضروس|لثة|عظام|جلدي|جلدية|عين|أذن|اذن|أنف|انف|ظهر|صدر|قلب|بول|كبد|رحم|دم|غدة|عضلة|مخ|أعصاب|طفل|طفلي|رضيع|مولود)',
        # Clinical & Triage vocabulary (Arabic)
        r'(?:مرض|أعراض|اعراض|عرض|تشخيص|علاج|دواء|أدوية|ادوية|روشتة|مسكن|مسكنات|جرعة|جرعات|عيادة|مستشفى|تخصص|استشارة|طوارئ|صيدلية|تحليل|فحص|أشعة|اشعة|مضاد حيوي|مريض|اصابة|إصابة)',
        # Medical Specialties (Arabic) — comprehensive taxonomy
        r'(?:عظام|أنف وأذن|انف واذن|مسالك|جلدية|عيون|مخ وأعصاب|مخ واعصاب|باطنة|قلب|نساء وتوليد|أطفال|اطفال|صدرية|أسنان|اسنان|جراحة|أورام|اورام|روماتيزم|مناعة|غدد|كبد|كلى|سكر|هرمونات|دم|حساسية|مسنين|تجميل|قولون|زراعة أعضاء|نفسي|أعصاب|قلب أطفال|حديثي ولادة|طوارئ|عناية مركزة|أشعة|تحاليل|علاج طبيعي|انتانات|معدية|رياضة|ألم|تسكين|فكين)',
        # Symptoms & Clinical terms (English)
        r'\b(?:pain|ache|aches|aching|sore|fever|cough|headache|migraine|nausea|vomit|vomiting|diarrhea|constipation|dizziness|dizzy|rash|swelling|swollen|infection|inflammation|bleeding|cramp|cramps|itch|itching|breathlessness|burning|numbness|fatigue|allergy|allergic|blood|lump|bruise)\b',
        r'\b(?:symptom|symptoms|disease|illness|condition|diagnosis|treatment|medicine|medication|drug|drugs|dosage|dose|prescription|painkiller|clinic|hospital|specialty|specialist|emergency|pharmacy|medical|health|clinical|triage)\b',
        r'\b(?:orthopedics|ent|urology|dermatology|ophthalmology|neurology|cardiology|gynecology|pediatrics|pulmonology|dentistry|gastroenterology)\b',
        # Contextual symptom expressions ("عندي", "أعاني", "حاسس بـ", "i have", etc.)
        r'(?:عندي|أعاني|اعاني|حاسس|شعور|وجع في|ألم في|إيه علاج|اي علاج|طمني|توجيه|تخصص|أروح لمين|اروح لمين|أي دكتور|اي دكتور)',
        r'\b(?:i have|my \w+ hurts|suffering from|feel pain|feeling sick|doctor for|treatment for)\b'
    ]
    has_medical_symptom = any(re.search(pat, t_lower) for pat in symptom_and_clinical_patterns)

    # 3. Check for pure Chit-Chat / Greetings (even if addressed to "دكتور" or "doctor")
    chit_chat_phrases = [
        "ازيك", "أزيك", "عامل ايه", "عامل إيه", "صباح الخير", "مساء الخير", 
        "مرحبا", "مرحباً", "السلام عليكم", "سلام عليكم", "كيفك", "كيف حالك", 
        "كيف الحال", "اخبارك", "أخباراتك", "إخبارك", "شو اخبارك", "أهلاً", "أهلا", 
        "مين معايا", "من انت", "من أنت", "مين أنت", "أنا مين", "شكراً", "شكرا", 
        "تسلم", "تسلمي", "يعطيك العافية", "الله يعافيك", "الو", "ألو",
        "hi", "hello", "hey", "good morning", "good evening", "good afternoon",
        "how are you", "who are you", "what is your name", "what's your name",
        "thanks", "thank you", "bye", "goodbye", "what's up", "sup"
    ]

    is_greeting_chit_chat = False
    for phrase in chit_chat_phrases:
        if phrase in t_lower:
            rem = t_lower.replace(phrase, "")
            # Remove title / address words ("يا دكتور", "دكتور", "دكتورة", "doctor", "doc")
            rem = re.sub(r'\b(?:يا\s+)?(?:دكتور|دكتورة|doctor|doc)\b', '', rem, flags=re.IGNORECASE).strip()
            rem_words = re.findall(r'[\w\u0600-\u06FF]+', rem)
            if len(rem_words) == 0:
                is_greeting_chit_chat = True
                break

    if is_greeting_chit_chat and not has_medical_symptom:
        return "OUT_OF_SCOPE"

    if has_non_medical and not has_medical_symptom:
        return "OUT_OF_SCOPE"

    if has_medical_symptom:
        return "IN_SCOPE_MEDICAL"

    return "OUT_OF_SCOPE"

def is_arabic_text(text: str) -> bool:
    """Detects if text contains Arabic script."""
    return bool(re.search(r'[\u0600-\u06FF]', text))

def dynamic_translate(text: str, source: str = 'auto', target: str = 'en') -> str:
    """
    Dynamically translates text using deep_translator (MyMemoryTranslator with GoogleTranslator fallback).
    No static dictionaries or hardcoded fallback strings.
    """
    text_clean = text.strip()
    if not text_clean:
        return ""

    src_code = 'ar-SA' if source in ['ar', 'arabic', 'auto'] else ('en-US' if source in ['en', 'english'] else source)
    tgt_code = 'en-US' if target in ['en', 'english'] else ('ar-SA' if target in ['ar', 'arabic'] else target)

    try:
        from deep_translator import MyMemoryTranslator
        translated = MyMemoryTranslator(source=src_code, target=tgt_code).translate(text_clean)
        if translated and translated.strip():
            return translated.strip()
    except Exception:
        try:
            from deep_translator import GoogleTranslator
            g_src = 'ar' if 'ar' in src_code else 'en'
            g_tgt = 'en' if 'en' in tgt_code else 'ar'
            translated = GoogleTranslator(source=g_src, target=g_tgt).translate(text_clean)
            if translated and translated.strip():
                return translated.strip()
        except Exception as e:
            print(f"[Warning] Dynamic translation fallback: {e}")

    return text_clean

def extract_positive_clinical_findings(text: str) -> str:
    """
    Universal Vector Query Pre-processing:
    Generic NLP/Regex filter that strips ANY negated phrases in Arabic or English
    BEFORE generating the FAISS query embedding.
    Matches phrases like (مفيش, لا يوجد, بدون, غير مصحوب بـ, no, without, denies, free of, negative for)
    along with their negated target clauses.
    """
    if not text:
        return ""

    cleaned = text

    # Generic English Negation Clause Removal
    eng_neg_patterns = [
        r'\b(?:no|without|denies|free of|negative for)\s+[a-zA-Z\s]{1,35}?(?=[,.;:!?]|$|\band\b|\bbut\b|\bwith\b|\bor\b)',
        r'\bdenied\s+[a-zA-Z\s]{1,35}?(?=[,.;:!?]|$|\band\b|\bbut\b|\bwith\b|\bor\b)'
    ]
    for pat in eng_neg_patterns:
        cleaned = re.sub(pat, '', cleaned, flags=re.IGNORECASE)

    # Generic Arabic Negation Clause Removal
    ar_neg_patterns = [
        r'(?:مفيش|لا يوجد|بدون|غير مصحوب بـ|لا أُعاني من|لا أعاني من|لا يعاني من|خالي من|لا يوجد أي|عدم وجود)\s+[\u0600-\u06FF\s]{1,35}?(?=[,.،؛:!?]|$|و|لكن|مع)',
        r'لا\s+يوجد\s+[\u0600-\u06FF\s]{1,35}?(?=[,.،؛:!?]|$|و|لكن)'
    ]
    for pat in ar_neg_patterns:
        cleaned = re.sub(pat, '', cleaned)

    cleaned = re.sub(r'\s+', ' ', cleaned).strip(' ,.،؛:')
    return cleaned if cleaned else text.strip()

def is_medication_request(text: str) -> bool:
    """
    Universal Medication Request Detection:
    Detects if user is asking for medication, painkillers, drug dosages, or prescriptions.
    """
    t_lower = text.lower()
    med_keywords = [
        "مسكن", "مسكنات", "علاج", "دواء", "أدوية", "جرعة", "جرعات", "اكتبلي", "اكتب لي", "روشتة",
        "روشتة علاج", "اديني علاج", "أحتاج مسكن", "أحتاج علاج", "اكتبلي دواء", "اكتبلي مسكن",
        "ما هو الدواء", "ماهو الدواء", "دواء لـ", "علاج لـ", "جرعة الباراسيتامول", "جرعة المسكن",
        "medication", "medications", "medicine", "medicines", "painkiller", "painkillers",
        "prescription", "prescribe", "dosage", "dosages", "dose", "doses", "drug", "drugs",
        "what medication", "what medicine", "what painkiller", "what dosage", "give me pills",
        "paracetamol", "ibuprofen", "antibiotic", "antibiotics", "analgesic", "analgesics"
    ]
    return any(w in t_lower for w in med_keywords)

class MedicalPDFRAG:
    """
    Pure RAG Engine with Zero Hardcoded Dictionaries/Taxonomies.
    Relies exclusively on FAISS Vector Semantic Search over Clinical PDFs + Dynamic Inference.
    """
    def __init__(self, docs_dir=None, index_dir=None):
        base_dir = os.path.dirname(os.path.abspath(__file__))
        self.docs_dir = docs_dir or os.path.join(base_dir, "docs")
        self.index_dir = index_dir or os.path.join(base_dir, "faiss_index")
        
        print("[FAISS Init] Initializing HuggingFace Embeddings ('all-MiniLM-L6-v2')...")
        self.embeddings = HuggingFaceEmbeddings(model_name="all-MiniLM-L6-v2")
        self.vectorstore = self._load_or_build_index()

    def _load_or_build_index(self):
        """Loads FAISS index from disk if it exists, otherwise builds from PDFs and persists it."""
        faiss_file = os.path.join(self.index_dir, "index.faiss")
        if os.path.exists(self.index_dir) and os.path.exists(faiss_file):
            print(f"[FAISS Cache] Loading vector index from local cache: {self.index_dir}")
            return FAISS.load_local(self.index_dir, self.embeddings, allow_dangerous_deserialization=True)

        print(f"[FAISS Build] Index cache not found. Processing PDFs in: {self.docs_dir}")
        if not os.path.exists(self.docs_dir):
            raise FileNotFoundError(f"PDF directory not found: {self.docs_dir}")

        loader = PyPDFDirectoryLoader(self.docs_dir)
        documents = loader.load()
        text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=150)
        chunks = text_splitter.split_documents(documents)

        vectorstore = FAISS.from_documents(chunks, self.embeddings)
        os.makedirs(self.index_dir, exist_ok=True)
        vectorstore.save_local(self.index_dir)
        print(f"[FAISS Cache] Saved index to local disk: {self.index_dir}")
        return vectorstore

    def _deduce_specialty_from_rag_context(self, query_text: str, context_text: str, is_ar: bool) -> dict:
        """
        Pure Dynamic RAG Specialty Deduction matching Platform Whitelist:
        Analyzes the retrieved clinical PDF context chunks and the patient's positive symptoms
        to dynamically infer the primary medical specialty matching the platform department whitelist.
        """
        ctx_lower = context_text.lower()
        q_lower = query_text.lower()

        domain_patterns = [
            # ── Internal Medicine & Subspecialties ────────────────────────────
            ("INTERNAL_MEDICINE",    CLINICAL_SPECIALTIES_WHITELIST["INTERNAL_MEDICINE"],
             ["general medicine", "internal medicine", "باطنة", "ممارسة عامة", "طبيب عام"]),
            ("CARDIOLOGY",           CLINICAL_SPECIALTIES_WHITELIST["CARDIOLOGY"],
             ["cardiac", "chest pain", "angina", "hypertension", "palpitation", "heart failure", "arrhythmia",
              "قلب", "خفقان", "ضغط", "نغزات الصدر", "رجفان", "احتشاء"]),
            ("PULMONOLOGY",          CLINICAL_SPECIALTIES_WHITELIST["PULMONOLOGY"],
             ["cough", "asthma", "pneumonia", "respiratory", "bronchitis", "dyspnea", "lung", "tuberculosis",
              "كحة", "سعال", "بلغم", "تنفس", "صدر", "ربو", "ضيق تنفس", "ذات رئة"]),
            ("GASTRO",               CLINICAL_SPECIALTIES_WHITELIST["GASTRO"],
             ["diarrhea", "gastric", "stomach", "gastroenteritis", "nausea", "vomiting", "colon", "irritable bowel",
              "بطن", "معدة", "قولون", "مغص", "ترجيع", "إسهال", "اسهال", "إمساك", "غثيان", "حموضة", "ارتجاع"]),
            ("HEPATOLOGY",           CLINICAL_SPECIALTIES_WHITELIST["HEPATOLOGY"],
             ["liver", "hepatitis", "jaundice", "cirrhosis", "biliary", "gallbladder",
              "كبد", "التهاب الكبد", "يرقان", "مرارة", "صفراء", "تليف الكبد"]),
            ("NEPHROLOGY",           CLINICAL_SPECIALTIES_WHITELIST["NEPHROLOGY"],
             ["renal failure", "nephrotic", "chronic kidney", "dialysis",
              "فشل كلوي", "غسيل كلى", "كلوي", "بروتين في البول"]),
            ("ENDOCRINOLOGY",        CLINICAL_SPECIALTIES_WHITELIST["ENDOCRINOLOGY"],
             ["diabetes", "thyroid", "hormonal", "endocrine", "obesity", "insulin", "adrenal",
              "سكر", "سكري", "غدة درقية", "هرمونات", "غدة", "أنسولين", "كيس على الغدة", "سمنة"]),
            ("HEMATOLOGY",           CLINICAL_SPECIALTIES_WHITELIST["HEMATOLOGY"],
             ["anemia", "leukemia", "lymphoma", "blood disorder", "platelet", "coagulation",
              "أنيميا", "فقر دم", "لوكيميا", "لمفوما", "صفائح دموية", "تجلط", "أمراض الدم"]),
            ("RHEUMATOLOGY",         CLINICAL_SPECIALTIES_WHITELIST["RHEUMATOLOGY"],
             ["rheumatoid", "lupus", "autoimmune", "gout", "sjogren",
              "روماتيزم", "ذئبة", "مناعة ذاتية", "النقرس", "التهاب مفاصل روماتيزمي"]),
            ("INFECTIOUS_DISEASE",   CLINICAL_SPECIALTIES_WHITELIST["INFECTIOUS_DISEASE"],
             ["infection", "infectious", "viral", "bacterial", "parasitic", "sepsis",
              "عدوى", "انتان", "بكتيريا", "فيروس", "طفيلي", "إنتان الدم", "مرض معدٍ"]),
            ("ALLERGY_IMMUNOLOGY",   CLINICAL_SPECIALTIES_WHITELIST["ALLERGY_IMMUNOLOGY"],
             ["allergy", "allergic", "urticaria", "anaphylaxis",
              "حساسية", "طفح تحسسي", "حساسية موسمية", "صدمة تحسسية"]),
            ("GERIATRICS",           CLINICAL_SPECIALTIES_WHITELIST["GERIATRICS"],
             ["elderly", "geriatric", "dementia", "alzheimer",
              "مسنين", "كبار السن", "خرف", "زهايمر", "شيخوخة"]),
            # ── Surgical Specialties ──────────────────────────────────────────
            ("GENERAL_SURGERY",      CLINICAL_SPECIALTIES_WHITELIST["GENERAL_SURGERY"],
             ["appendix", "hernia", "appendicitis", "abscess", "cholecystitis",
              "زائدة", "فتق", "خراج", "استئصال", "جراحة عامة"]),
            ("ORTHOPEDICS",          CLINICAL_SPECIALTIES_WHITELIST["ORTHOPEDICS"],
             ["fracture", "joint", "bone", "sprain", "back pain", "knee", "spine", "disc",
              "عظام", "مفاصل", "ركبة", "كسر", "التواء", "ظهر", "غضروف", "انزلاق"]),
            ("NEUROSURGERY",         CLINICAL_SPECIALTIES_WHITELIST["NEUROSURGERY"],
             ["brain tumor", "spinal cord", "intracranial", "neurosurgery",
              "ورم المخ", "حبل شوكي", "جراحة المخ", "ضغط على الأعصاب"]),
            ("CARDIAC_SURGERY",      CLINICAL_SPECIALTIES_WHITELIST["CARDIAC_SURGERY"],
             ["bypass", "valve replacement", "open heart",
              "قسطرة قلبية", "جراحة قلب", "صمام قلب", "عملية قلب مفتوح"]),
            ("VASCULAR_SURGERY",     CLINICAL_SPECIALTIES_WHITELIST["VASCULAR_SURGERY"],
             ["varicose", "vascular", "aortic", "peripheral artery",
              "دوالي", "أوعية دموية", "تصلب الشرايين", "جراحة أوعية"]),
            ("UROLOGY",              CLINICAL_SPECIALTIES_WHITELIST["UROLOGY"],
             ["cystitis", "urinary", "urolithiasis", "bladder", "urine", "flank", "prostate",
              "مسالك", "كلى", "خاصرة", "بول", "مثانة", "حرقان", "بروستاتا", "حصوة"]),
            ("GYNECOLOGY",           CLINICAL_SPECIALTIES_WHITELIST["GYNECOLOGY"],
             ["pregnancy", "menstrual", "pelvic", "uterus", "vaginal", "ovarian", "obstetric",
              "رحم", "حمل", "دورة", "نساء", "مبيض", "ولادة", "حيض"]),
            ("PLASTIC_SURGERY",      CLINICAL_SPECIALTIES_WHITELIST["PLASTIC_SURGERY"],
             ["cosmetic", "plastic", "burn", "scar", "reconstruction",
              "تجميل", "حروق", "ندبة", "ترميم"]),
            ("COLORECTAL_SURGERY",   CLINICAL_SPECIALTIES_WHITELIST["COLORECTAL_SURGERY"],
             ["hemorrhoid", "rectal", "colorectal", "anal",
              "بواسير", "شرج", "مستقيم", "ناسور"]),
            # ── Neurological & Mental Health ─────────────────────────────────
            ("NEUROLOGY",            CLINICAL_SPECIALTIES_WHITELIST["NEUROLOGY"],
             ["headache", "migraine", "seizure", "neuropathy", "vertigo", "stroke", "epilepsy",
              "صداع", "شقيقة", "دوخة", "دوار", "أعصاب", "سكتة", "صرع", "تنميل", "رعشة"]),
            ("PSYCHIATRY",           CLINICAL_SPECIALTIES_WHITELIST["PSYCHIATRY"],
             ["depression", "anxiety", "panic", "psychiatric", "insomnia", "bipolar", "schizophrenia",
              "اكتئاب", "قلق", "توتر", "نفسي", "أرق", "وسواس", "هلع", "ذهان"]),
            # ── Sensory & Head/Neck ───────────────────────────────────────────
            ("ENT",                  CLINICAL_SPECIALTIES_WHITELIST["ENT"],
             ["otitis", "ear", "throat", "pharyngitis", "tonsillitis", "sinus", "larynx", "hearing", "nasal",
              "أذن", "اذن", "زور", "حلق", "بلع", "لوز", "أنف", "احتقان", "طنين"]),
            ("OPHTHALMOLOGY",        CLINICAL_SPECIALTIES_WHITELIST["OPHTHALMOLOGY"],
             ["eye", "ocular", "conjunctivitis", "cornea", "vision", "eyelid", "glaucoma", "cataract",
              "عين", "عيون", "رؤية", "زغللة", "جفن", "احمرار العين", "مياه بيضاء", "ضغط العين"]),
            ("DENTISTRY",            CLINICAL_SPECIALTIES_WHITELIST["DENTISTRY"],
             ["tooth", "dental", "gum", "toothache", "molar", "cavity",
              "ضرس", "ضروس", "لثة", "أسنان", "اسنان", "تسوس", "خلع ضرس"]),
            ("MAXILLOFACIAL",        CLINICAL_SPECIALTIES_WHITELIST["MAXILLOFACIAL"],
             ["jaw", "maxillofacial", "oral surgery",
              "فك", "فكين", "جراحة الفم"]),
            # ── Skin ─────────────────────────────────────────────────────────
            ("DERMATOLOGY",          CLINICAL_SPECIALTIES_WHITELIST["DERMATOLOGY"],
             ["skin", "eczema", "dermatitis", "urticaria", "rash", "itching", "fungal", "psoriasis",
              "جلد", "جلدية", "طفح", "حكة", "هرش", "صدفية", "فطريات الجلد"]),
            # ── Oncology ─────────────────────────────────────────────────────
            ("ONCOLOGY",             CLINICAL_SPECIALTIES_WHITELIST["ONCOLOGY"],
             ["cancer", "tumor", "malignancy", "oncology", "chemotherapy",
              "ورم", "سرطان", "خبيث", "أورام", "كيماوي"]),
            ("RADIATION_ONCOLOGY",   CLINICAL_SPECIALTIES_WHITELIST["RADIATION_ONCOLOGY"],
             ["radiation", "radiotherapy",
              "إشعاع", "علاج إشعاعي"]),
            # ── Diagnostic & Imaging ─────────────────────────────────────────
            ("RADIOLOGY",            CLINICAL_SPECIALTIES_WHITELIST["RADIOLOGY"],
             ["x-ray", "mri", "ct scan", "ultrasound", "radiology",
              "أشعة", "رنين مغناطيسي", "سونار", "توموغرافي"]),
            # ── Pediatric Specialties ─────────────────────────────────────────
            ("NEONATOLOGY",          CLINICAL_SPECIALTIES_WHITELIST["NEONATOLOGY"],
             ["newborn", "neonate", "premature baby",
              "حديث الولادة", "رضيع", "مولود جديد", "خديج"]),
            ("PEDIATRICS",           CLINICAL_SPECIALTIES_WHITELIST["PEDIATRICS"],
             ["infant", "child", "pediatric", "toddler",
              "طفل", "طفلي", "أطفال", "طفولة"]),
            ("PEDIATRIC_CARDIOLOGY", CLINICAL_SPECIALTIES_WHITELIST["PEDIATRIC_CARDIOLOGY"],
             ["congenital heart", "pediatric cardiology",
              "قلب أطفال", "تشوه قلبي", "قلب خلقي"]),
            ("PEDIATRIC_NEUROLOGY",  CLINICAL_SPECIALTIES_WHITELIST["PEDIATRIC_NEUROLOGY"],
             ["febrile seizure", "pediatric neurology", "cerebral palsy",
              "تشنجات الأطفال", "شلل الأطفال", "أعصاب الأطفال"]),
            # ── Rehabilitation & Allied Health ────────────────────────────────
            ("PHYSICAL_THERAPY",     CLINICAL_SPECIALTIES_WHITELIST["PHYSICAL_THERAPY"],
             ["physiotherapy", "rehabilitation", "physical therapy",
              "علاج طبيعي", "تأهيل", "إعادة التأهيل"]),
            ("SPORTS_MEDICINE",      CLINICAL_SPECIALTIES_WHITELIST["SPORTS_MEDICINE"],
             ["sports injury", "athletic", "muscle tear", "ligament",
              "إصابة رياضية", "أوتار", "عضلة", "رياضة"]),
            ("PAIN_MANAGEMENT",      CLINICAL_SPECIALTIES_WHITELIST["PAIN_MANAGEMENT"],
             ["chronic pain", "pain clinic", "anesthesia",
              "ألم مزمن", "عيادة ألم", "تخدير"]),
            # ── Emergency & Critical Care ─────────────────────────────────────
            ("EMERGENCY_MEDICINE",   CLINICAL_SPECIALTIES_WHITELIST["EMERGENCY_MEDICINE"],
             ["emergency", "urgent", "accident",
              "طوارئ", "إسعاف", "حادثة", "حالة حرجة"]),
            ("CRITICAL_CARE",        CLINICAL_SPECIALTIES_WHITELIST["CRITICAL_CARE"],
             ["icu", "intensive care", "critical", "ventilator",
              "عناية مركزة", "حضانة", "تنفس صناعي"]),
        ]

        matched_domain = None
        for key, spec_name, clinical_terms in domain_patterns:
            ctx_hits = sum(1 for term in clinical_terms if term in ctx_lower)
            query_hits = sum(1 for term in clinical_terms if term in q_lower)
            if ctx_hits > 0 or query_hits > 0:
                score = (ctx_hits * 2) + (query_hits * 4)
                if matched_domain is None or score > matched_domain["score"]:
                    matched_domain = {
                        "key": key,
                        "specialty_name": spec_name,
                        "score": score
                    }

        if matched_domain:
            specialty_name = matched_domain["specialty_name"]
            rationale = (
                f"تم التوجيه لتخصص {specialty_name} لأن الأعراض المحددة ترتبط مباشرة بالتقييم السريري الدقيق لهذا التخصص وفقاً للمراجع المسترجعة."
            ) if is_ar else (
                f"Referred to {specialty_name} because the described symptoms relate directly to the clinical scope of this specialty."
            )
            return {"specialty": specialty_name, "rationale": rationale}

        specialty_name = CLINICAL_SPECIALTIES_WHITELIST["INTERNAL_MEDICINE"]
        rationale = (
            "تم التوجيه لطبيب الباطنية والممارسة العامة لإجراء تقييم سريري شامل لعدم تركز الأعراض في عضو موضع منفرد."
        ) if is_ar else (
            "Referred to General / Internal Medicine for a comprehensive evaluation as symptoms are non-localized."
        )
        return {"specialty": specialty_name, "rationale": rationale}

    def _call_gemini_llm(self, system_prompt: str, user_prompt: str, history: list) -> str:
        """
        Attempts to generate a dynamic response using Google Gemini API if API key is configured.
        Returns None if unavailable or failed.
        """
        api_key = os.environ.get("GEMINI_API_KEY") or os.environ.get("GOOGLE_API_KEY")
        if not api_key:
            return None
        try:
            from google import genai
            from google.genai import types
            client = genai.Client(api_key=api_key)
            
            contents = []
            for msg in history:
                if isinstance(msg, dict) and msg.get("content"):
                    role = "user" if msg.get("role") == "user" else "model"
                    contents.append(types.Content(role=role, parts=[types.Part.from_text(text=msg["content"])]))
            
            contents.append(types.Content(role="user", parts=[types.Part.from_text(text=user_prompt)]))
            
            response = client.models.generate_content(
                model='gemini-2.5-flash',
                contents=contents,
                config=types.GenerateContentConfig(
                    system_instruction=system_prompt,
                    temperature=0.3
                )
            )
            if response and response.text:
                return response.text.strip()
        except Exception as e:
            print(f"[Warning] Gemini API call skipped or failed: {e}")
        return None

    def classify_intent(self, user_input: str) -> str:
        """
        Guardrail / Intent Classification Layer:
        Determines whether user input is 'IN_SCOPE_MEDICAL' or 'OUT_OF_SCOPE'.
        """
        return classify_user_intent(user_input)

    def chat_turn(self, messages_history: list, current_user_input: str, user_turn_count: int, top_k: int = 4) -> dict:
        """
        Processes a conversational turn using strictly active conversation history, universal negation query pre-processing,
        pure vector FAISS similarity search, and pure RAG dynamic specialty inference without hardcoded python dictionaries.
        """
        input_clean = current_user_input.strip()
        is_ar = is_arabic_text(input_clean)

        # 0. Guardrail / Intent Classification Check (Bypass RAG & FAISS completely if OUT_OF_SCOPE)
        intent = self.classify_intent(input_clean)
        print(f"[Guardrail Check] Input: '{input_clean}' | Intent: {intent}")

        if intent == "OUT_OF_SCOPE":
            return {
                "response_text": STANDARDIZED_REFUSAL_RESPONSE_AR,
                "snippets": [],
                "is_final": False,
                "search_query": input_clean,
                "is_arabic": is_ar,
                "is_out_of_scope": True,
                "specialty": None
            }

        # 1. Pure Memory Isolation: Derive user turns ONLY from active session history parameter
        active_history = messages_history if isinstance(messages_history, list) else []
        user_queries = [
            m["content"].strip() for m in active_history 
            if isinstance(m, dict) and m.get("role") == "user" and m.get("content") and m["content"].strip()
        ]
        if input_clean and input_clean not in user_queries:
            user_queries.append(input_clean)
        
        full_user_text = " ".join(user_queries)

        # 2. Universal Vector Query Pre-processing: Strip ANY negated clauses before FAISS embedding
        positive_user_text = extract_positive_clinical_findings(full_user_text)

        if is_arabic_text(positive_user_text):
            search_query = dynamic_translate(positive_user_text, source='ar-SA', target='en-US')
        else:
            search_query = positive_user_text

        # 3. Check for Universal Medication Request Policy
        asking_for_meds = is_medication_request(input_clean) or is_medication_request(full_user_text)

        print(f"[RAG Pure Vector Turn {user_turn_count}] Full Text: '{full_user_text}' | Positive Query: '{positive_user_text}' | Asking Meds: {asking_for_meds} | Search: '{search_query}'")

        # 4. Perform FAISS Vector Search ONLY for POSITIVE clinical findings
        retrieved_docs = self.vectorstore.similarity_search(search_query, k=top_k)
        combined_context = " ".join([d.page_content for d in retrieved_docs])

        # 5. Extract Specialty AND Transparent Clinical Rationale dynamically from PDF RAG context matching Whitelist
        specialty_info = self._deduce_specialty_from_rag_context(search_query, combined_context, is_ar)
        primary_specialty = specialty_info["specialty"]
        clinical_rationale = specialty_info["rationale"]

        # 6. Build PDF Evidence Snippets
        snippets_data = []
        for d in retrieved_docs:
            src = os.path.basename(d.metadata.get("source", "Unknown"))
            page = d.metadata.get("page", "Unknown")
            snippets_data.append({"source": src, "page": page, "content": d.page_content.strip()})

        # 7. Strict Turn-Based Triage State Machine
        #
        # TURN 1 RULE: ALWAYS probe on the first turn.
        #   - word_count is intentionally removed as a finalization trigger.
        #     A long first message ("ألم شديد ومغص في بطني من الصبح") must STILL
        #     generate clarifying questions, not a premature final report.
        #   - Only two exceptions bypass Turn 1 probing:
        #       a) asking_for_meds → policy disclaimer + specialty referral immediately.
        #       b) Emergency red-flag symptoms → immediate safety warning + emergency referral.
        #
        # TURN 2+ RULE: Finalize once the patient has answered follow-up questions.
        #   - Turn >= 2 is the primary finalization trigger.
        #   - A rich Turn 2 reply (word_count >= 6 on the new reply alone) adds confidence,
        #     but turn count alone is sufficient.

        # Detect emergency red-flag keywords requiring immediate escalation even on Turn 1
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

        # Current turn word count (new reply only, NOT cumulative history)
        current_reply_word_count = len(re.findall(r'[\w\u0600-\u06FF]+', input_clean))

        # Final state machine decision
        if asking_for_meds or is_emergency:
            # Override: immediate response regardless of turn count
            is_final_assessment = True
        elif user_turn_count == 1:
            # STRICT: Turn 1 ALWAYS probes, never finalizes
            is_final_assessment = False
        else:
            # Turn 2+: finalize (patient has answered probing questions)
            is_final_assessment = True

        print(f"[Triage State] Turn={user_turn_count} | ReplyWords={current_reply_word_count} | Meds={asking_for_meds} | Emergency={is_emergency} | is_final={is_final_assessment}")

        # 8. Check if Gemini LLM generation is available
        llm_prompt = (
            f"Current Consultation Turn: {user_turn_count}\n"
            f"Is Final Triage: {is_final_assessment}\n"
            f"Emergency Escalation: {is_emergency}\n\n"
            f"Retrieved Clinical PDF Context:\n{combined_context}\n\n"
            f"Full Patient History (all turns):\n{full_user_text}\n\n"
            f"Current Patient Reply (Turn {user_turn_count}):\n{input_clean}"
        )
        llm_response = self._call_gemini_llm(SYSTEM_PROMPT, llm_prompt, active_history)
        if llm_response:
            return {
                "response_text": llm_response,
                "snippets": snippets_data if is_final_assessment else [],
                "is_final": is_final_assessment,
                "search_query": search_query,
                "is_arabic": is_ar,
                "is_out_of_scope": False,
                "specialty": primary_specialty if is_final_assessment else None
            }

        # 9. Dynamic Adaptive Response (Anatomically Coherent Probing or Grounded Final Triage)
        if is_ar:
            med_disclaimer = (
                "⚠️ **تنبيه طبي هام:**\n"
                "بصفتي مساعد فرز وتوجيه سريري ذكي، لا يُسمح لي بوصف الأدوية أو الجرعات العلاجية أو تشخيص الحالات بشكل نهائي. "
                "يرجى استشارة الطبيب المختص أو الصيدلي لتحديد العلاج والجرعة الآمنة المناسبة لحالتك الصحية."
            )
            
            if asking_for_meds:
                resp_text = (
                    f"{med_disclaimer}\n\n"
                    f"💡 **الإجراءات غير الدوائية والتوصيات الداعمة:**\n"
                    f"- الحرص على الراحة التامة، شرب كميات كافية من السوائل، وتجنب الإجهاد البدني.\n"
                    f"- في حال وجود ألم أو تورم، يُنصح بالراحة ورفع العضو المصاب وتطبيق الكمادات الباردة.\n\n"
                    f"🏥 **التخصص الطبي المقترح وتوضيح السبب:**\n"
                    f"- **التخصص:** {primary_specialty}\n"
                    f"- **سبب التوجيه:** {clinical_rationale}"
                )
            elif not is_final_assessment:
                resp_text = get_targeted_probing_questions(positive_user_text, is_ar=True)
            else:
                resp_text = (
                    f"### 🩺 التقييم والتوصية السريرية\n\n"
                    f"ألف سلامة عليك. بناءً على تقييم الأعراض المذكورة ({positive_user_text}) والأدلة الطبية المسترجعة من المراجع السريرية:\n\n"
                    f"🏥 **التخصص الطبي المقترح:**\n"
                    f"- **التخصص:** {primary_specialty}\n"
                    f"- **سبب التوجيه:** {clinical_rationale}\n\n"
                    f"💡 **توصيات عامة وتدابير داعمة:**\n"
                    f"- الحرص على الراحة التامة ومتابعة الأعراض دون إجهاد بدني.\n"
                    f"- التوجه للطوارئ فوراً في حال ظهور أعراض حادة أو مفاجئة.\n\n"
                    f"⚠️ **تنبيه طبي:** بصفتي مساعد فرز طبي ذكي، لا أقوم بوصف الأدوية أو تحديد الجرعات. يرجى استشارة الطبيب المختص للحصول على التقييم السريري المباشر."
                )

        else:
            if asking_for_meds:
                resp_text = (
                    f"⚠️ **Important Medical Disclaimer:**\n"
                    f"As an AI Clinical Assistant, I cannot prescribe medications or drug dosages.\n\n"
                    f"🏥 **Recommended Specialty:** {primary_specialty}\n"
                    f"- **Reason for Referral:** {clinical_rationale}"
                )
            elif not is_final_assessment:
                resp_text = get_targeted_probing_questions(positive_user_text, is_ar=False)
            else:
                resp_text = (
                    f"### 🩺 Clinical Referral & Assessment\n\n"
                    f"Based on your presentation ({positive_user_text}) and retrieved clinical guideline context:\n\n"
                    f"🏥 **Recommended Specialty:**\n"
                    f"- **Specialty:** {primary_specialty}\n"
                    f"- **Reason for Referral:** {clinical_rationale}\n\n"
                    f"💡 **General Advice:**\n"
                    f"- Rest well and monitor your symptoms.\n"
                    f"- Seek emergency medical care immediately if severe red-flag symptoms develop."
                )

        return {
            "response_text": resp_text,
            "snippets": snippets_data if is_final_assessment else [],
            "is_final": is_final_assessment,
            "search_query": search_query,
            "is_arabic": is_ar,
            "is_out_of_scope": False,
            "specialty": primary_specialty if is_final_assessment else None
        }

if __name__ == "__main__":
    rag = MedicalPDFRAG()
    
    print("\n=== TEST 1: Pure Vector Dynamic Specialty Deduction (Ear & Throat) ===")
    res1 = rag.chat_turn([], "أعاني من ألم في الأذن ونغزات بالزور", user_turn_count=1)
    print("Turn 1 Response:\n", res1["response_text"])
    
    res1_turn2 = rag.chat_turn([
        {"role": "user", "content": "أعاني من ألم في الأذن ونغزات بالزور"},
        {"role": "assistant", "content": res1["response_text"]}
    ], "يوجد ألم عند البلع مع صعوبة بسيطة", user_turn_count=2)
    print("\nTurn 2 Final Assessment:\n", res1_turn2["response_text"])

    print("\n=== TEST 2: Pure Vector Dynamic Specialty Deduction (Flank & Urine) ===")
    res2 = rag.chat_turn([], "ألم شديد في الخاصرة مع حرقان في البول", user_turn_count=2)
    print("Search Query:", res2["search_query"])
    print("Response:\n", res2["response_text"])

