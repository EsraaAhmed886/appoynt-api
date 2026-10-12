import streamlit as st
import requests

# Page setup
st.set_page_config(
    page_title="CDSS - Clinical Decision Support System",
    page_icon="🩺",
    layout="wide",
    initial_sidebar_state="collapsed"
)

# Custom High-End Dark Theme CSS Styling
st.markdown("""
<style>
    @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap');

    html, body, [class*="css"] {
        font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
    }

    /* Hide default sidebar completely */
    [data-testid="stSidebar"] {
        display: none;
    }
    
    /* Main Layout container tweaks */
    .block-container {
        padding-top: 1.5rem;
        padding-bottom: 3rem;
        max-width: 1200px;
    }

    /* Header Banner Styling */
    .cdss-header {
        background: linear-gradient(135deg, #0F172A 0%, #1E293B 50%, #1E3A8A 100%);
        padding: 2rem 2.5rem;
        border-radius: 16px;
        color: #FFFFFF;
        box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.4);
        margin-bottom: 1.5rem;
        border: 1px solid #334155;
    }
    
    .cdss-header-title {
        font-size: 2.2rem;
        font-weight: 800;
        letter-spacing: -0.025em;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        color: #F8FAFC;
    }

    .cdss-header-subtitle {
        font-size: 1.05rem;
        color: #94A3B8;
        margin-top: 0.5rem;
        font-weight: 500;
    }

    /* Form Container Base (Refined Dark Slate Card) */
    [data-testid="stForm"] {
        border: 1px solid #334155 !important;
        border-radius: 16px !important;
        background: #1E293B !important;
        box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3) !important;
        padding: 1.75rem !important;
        margin-bottom: 2rem !important;
    }

    /* High-Contrast Bright Labels for Form Inputs */
    [data-testid="stForm"] label,
    [data-testid="stWidgetLabel"],
    [data-testid="stWidgetLabel"] p,
    [data-testid="stWidgetLabel"] label,
    .stTextInput label,
    .stTextArea label,
    div[data-testid="stWidgetLabel"] label p,
    div[data-testid="stWidgetLabel"] p {
        color: #F8FAFC !important;
        font-weight: 700 !important;
        font-size: 0.95rem !important;
        margin-bottom: 0.35rem !important;
    }

    /* Dark Text Input Fields Styling */
    .stTextInput input, .stTextArea textarea {
        color: #FFFFFF !important;
        background-color: #0F172A !important;
        border: 1px solid #334155 !important;
        border-radius: 8px !important;
        font-weight: 500 !important;
    }

    .stTextInput input:focus, .stTextArea textarea:focus {
        border-color: #3B82F6 !important;
        box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.25) !important;
        background-color: #0F172A !important;
        color: #FFFFFF !important;
    }

    .stTextInput input::placeholder, .stTextArea textarea::placeholder {
        color: #94A3B8 !important;
        font-weight: 400 !important;
    }

    /* Helper and Caption Text inside Form */
    [data-testid="stInputHelp"], .stCaption, [data-testid="stForm"] p {
        color: #94A3B8 !important;
        font-weight: 500 !important;
    }

    /* Section Headers & Descriptions */
    .card-section-title {
        font-size: 1.25rem;
        font-weight: 800;
        color: #F8FAFC !important;
        margin-bottom: 0.25rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .card-section-desc {
        font-size: 0.875rem;
        color: #94A3B8 !important;
        margin-bottom: 1.25rem;
    }

    /* Primary Submit Button Styling */
    div.stButton > button[kind="primary"], button[data-testid="stBaseButton-primary"] {
        background: linear-gradient(135deg, #2563EB 0%, #1D4ED8 100%) !important;
        color: #FFFFFF !important;
        font-weight: 700 !important;
        font-size: 1.05rem !important;
        padding: 0.75rem 1.5rem !important;
        border-radius: 10px !important;
        border: none !important;
        box-shadow: 0 4px 14px rgba(37, 99, 235, 0.4) !important;
        transition: all 0.2s ease !important;
    }

    div.stButton > button[kind="primary"]:hover {
        transform: translateY(-1px);
        box-shadow: 0 6px 18px rgba(37, 99, 235, 0.55) !important;
    }

    /* Metric Cards (Dark Slate) */
    .metric-container {
        background: #1E293B;
        border: 1px solid #334155;
        border-radius: 12px;
        padding: 1.25rem;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        text-align: center;
    }

    .metric-value {
        font-size: 1.75rem;
        font-weight: 800;
        color: #F8FAFC;
        margin-top: 0.25rem;
    }

    .metric-label {
        font-size: 0.85rem;
        font-weight: 600;
        color: #94A3B8;
        text-transform: uppercase;
        letter-spacing: 0.05em;
    }

    /* Status Banners */
    .status-banner-safe {
        background-color: #064E3B;
        border: 1px solid #059669;
        border-left: 6px solid #10B981;
        border-radius: 12px;
        padding: 1.25rem 1.5rem;
        color: #ECFDF5;
        margin-bottom: 1.5rem;
    }

    .status-banner-danger {
        background-color: #450A0A;
        border: 1px solid #991B1B;
        border-left: 6px solid #EF4444;
        border-radius: 12px;
        padding: 1.25rem 1.5rem;
        color: #FEF2F2;
        margin-bottom: 1.5rem;
    }

    /* Conflict Report Alert Cards */
    .conflict-card {
        background: #1E293B;
        border: 1px solid #475569;
        border-radius: 14px;
        padding: 1.5rem;
        margin-bottom: 1.25rem;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3);
    }

    .conflict-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1rem;
        padding-bottom: 0.75rem;
        border-bottom: 1px solid #334155;
    }

    .conflict-title {
        font-size: 1.1rem;
        font-weight: 700;
        color: #F8FAFC;
    }

    /* Badges & Pills */
    .badge-pill {
        display: inline-block;
        padding: 0.25rem 0.75rem;
        border-radius: 9999px;
        font-size: 0.8rem;
        font-weight: 700;
        letter-spacing: 0.02em;
    }

    .badge-danger {
        background-color: #7F1D1D;
        color: #FCA5A5;
        border: 1px solid #991B1B;
    }

    .badge-drug {
        background-color: #1E3A8A;
        color: #93C5FD;
        border: 1px solid #1D4ED8;
    }

    .badge-ing {
        background-color: #581C87;
        color: #E9D5FF;
        border: 1px solid #7E22CE;
    }

    .alt-pill {
        display: inline-block;
        background-color: #064E3B;
        color: #6EE7B7;
        border: 1px solid #059669;
        padding: 0.35rem 0.85rem;
        border-radius: 8px;
        font-weight: 700;
        font-size: 0.9rem;
        margin-right: 0.5rem;
        margin-top: 0.25rem;
    }

    .details-box {
        background-color: #0F172A;
        border: 1px solid #334155;
        border-radius: 8px;
        padding: 0.85rem 1rem;
        font-size: 0.95rem;
        color: #F1F5F9;
        margin-bottom: 1rem;
        line-height: 1.5;
    }

    .extracted-pill {
        display: inline-block;
        background-color: #0F172A;
        color: #E2E8F0;
        border: 1px solid #334155;
        padding: 0.25rem 0.65rem;
        border-radius: 6px;
        font-weight: 600;
        font-size: 0.85rem;
        margin-right: 0.4rem;
    }
</style>
""", unsafe_allow_html=True)

# Session state initialization for inputs
if "allergies_val" not in st.session_state:
    st.session_state.allergies_val = ""
if "chronic_val" not in st.session_state:
    st.session_state.chronic_val = ""
if "diet_val" not in st.session_state:
    st.session_state.diet_val = ""
if "prescription_val" not in st.session_state:
    st.session_state.prescription_val = ""
if "backend_url" not in st.session_state:
    st.session_state.backend_url = "http://127.0.0.1:8000/check-prescription"

# 1. Clean Main Header with Icon, Title, and Subtitle
st.markdown("""
<div class="cdss-header">
    <div class="cdss-header-title">
        <span>🩺</span> Clinical Decision Support System (CDSS)
    </div>
    <div class="cdss-header-subtitle">
        Real-time Active-Ingredient Prescription Safety Engine & Alternative Recommender
    </div>
</div>
""", unsafe_allow_html=True)

# Quick Test Presets Bar (Main View Top)
with st.expander("⚡ Quick Test Presets & Advanced Settings", expanded=False):
    col_preset_title, col_p1, col_p2, col_p3, col_p4 = st.columns([1.5, 1.2, 1.2, 1.2, 1.2])
    col_preset_title.write("**Quick Test Scenarios:**")
    
    if col_p1.button("Preset 1: Allergy"):
        st.session_state.allergies_val = "Augmentin"
        st.session_state.chronic_val = ""
        st.session_state.diet_val = ""
        st.session_state.prescription_val = "Rx: Take Amoxil 500mg capsules twice daily for 7 days."
        st.rerun()

    if col_p2.button("Preset 2: Ulcer"):
        st.session_state.allergies_val = ""
        st.session_state.chronic_val = "Peptic Ulcer"
        st.session_state.diet_val = ""
        st.session_state.prescription_val = "Prescribed Voltaren 75mg tablets once daily after meals."
        st.rerun()

    if col_p3.button("Preset 3: Food"):
        st.session_state.allergies_val = ""
        st.session_state.chronic_val = ""
        st.session_state.diet_val = "Grapefruit"
        st.session_state.prescription_val = "Rx: Lipitor 20mg once daily at bedtime."
        st.rerun()

    if col_p4.button("Reset Form"):
        st.session_state.allergies_val = ""
        st.session_state.chronic_val = ""
        st.session_state.diet_val = ""
        st.session_state.prescription_val = ""
        st.rerun()
        
    st.markdown("---")
    st.session_state.backend_url = st.text_input("Backend API Endpoint URL:", value=st.session_state.backend_url)

# 2. Main Form wrapping Patient Profile + Doctor Prescription Intake
with st.form(key="cdss_main_form"):
    # Patient Profile Section Header
    st.markdown("""
    <div class="card-section-title">
        <span>👤</span> Patient Health Profile
    </div>
    <div class="card-section-desc">
        Input patient background data to cross-evaluate against prescribed trade drugs.
    </div>
    """, unsafe_allow_html=True)

    # 3 Columns for Patient Profile side-by-side
    col_allergies, col_chronic, col_diet = st.columns(3)

    with col_allergies:
        allergies_input = st.text_input(
            "🚫 Drug Allergies",
            value=st.session_state.allergies_val,
            placeholder="e.g. Augmentin, Penicillin, Aspirin",
            help="Brand or active ingredient names (comma-separated)",
            key="allergies_input_key"
        )

    with col_chronic:
        chronic_input = st.text_input(
            "🩺 Chronic Conditions",
            value=st.session_state.chronic_val,
            placeholder="e.g. Peptic Ulcer, Asthma, Hypertension",
            help="Known medical conditions (comma-separated)",
            key="chronic_input_key"
        )

    with col_diet:
        diet_input = st.text_input(
            "🥗 Dietary Intake",
            value=st.session_state.diet_val,
            placeholder="e.g. Spinach, Grapefruit, Dairy",
            help="Regular food/drink items (comma-separated)",
            key="diet_input_key"
        )

    st.markdown("<br>", unsafe_allow_html=True)

    # Doctor Prescription Intake Section
    st.markdown("""
    <div class="card-section-title">
        <span>📝</span> Doctor Prescription Intake
    </div>
    <div class="card-section-desc">
        Paste or type clinical text containing trade/brand drug names for automated active ingredient extraction & safety verification.
    </div>
    """, unsafe_allow_html=True)

    prescription_text = st.text_area(
        "📝 Prescription Clinical Text",
        value=st.session_state.prescription_val,
        placeholder="e.g. Prescribed Amoxil 500mg capsules twice daily for 7 days or Voltaren 75mg tablets once daily...",
        height=140,
        key="prescription_text_key"
    )

    st.markdown("<br>", unsafe_allow_html=True)

    # Single Primary Form Submit Button
    check_submitted = st.form_submit_button(
        "🔍 Run Clinical Safety & Alternative Verification",
        type="primary",
        use_container_width=True
    )

# 3. Results & Clinical Reports Container below Form
if check_submitted:
    allergies_list = [i.strip() for i in allergies_input.split(",") if i.strip()]
    chronic_list = [i.strip() for i in chronic_input.split(",") if i.strip()]
    diet_list = [i.strip() for i in diet_input.split(",") if i.strip()]

    if not prescription_text.strip():
        st.warning("⚠️ Please enter a prescription text to analyze.")
    else:
        with st.spinner("Analyzing active ingredients and cross-checking safety database..."):
            try:
                payload = {
                    "prescription_text": prescription_text,
                    "patient_profile": {
                        "allergies": allergies_list,
                        "chronic_diseases": chronic_list,
                        "dietary_intake": diet_list
                    }
                }

                response = requests.post(st.session_state.backend_url, json=payload, timeout=30)

                if response.status_code == 200:
                    data = response.json()
                    extracted = data.get("extracted_drugs", [])
                    status = data.get("status")
                    total_conflicts = data.get("total_conflicts", 0)
                    message = data.get("message", "")
                    recommendation = data.get("recommendation", "")
                    alerts = data.get("alerts", [])

                    st.markdown("### 📊 Clinical Decision Advisory Report")

                    # Metrics Summary Row
                    col_m1, col_m2, col_m3 = st.columns(3)

                    with col_m1:
                        status_color = "#10B981" if status == "SAFE" else "#EF4444"
                        status_label = "VERIFIED SAFE" if status == "SAFE" else "CRITICAL RISK"
                        st.markdown(f"""
                        <div class="metric-container">
                            <div class="metric-label">Safety Status</div>
                            <div class="metric-value" style="color: {status_color};">{status_label}</div>
                        </div>
                        """, unsafe_allow_html=True)

                    with col_m2:
                        st.markdown(f"""
                        <div class="metric-container">
                            <div class="metric-label">Conflicts Identified</div>
                            <div class="metric-value" style="color: {'#10B981' if total_conflicts == 0 else '#EF4444'};">{total_conflicts}</div>
                        </div>
                        """, unsafe_allow_html=True)

                    with col_m3:
                        drugs_html = "".join([f'<span class="extracted-pill">{d}</span>' for d in extracted]) if extracted else '<span style="color:#94A3B8;">None detected</span>'
                        st.markdown(f"""
                        <div class="metric-container">
                            <div class="metric-label">Extracted Trade Drugs</div>
                            <div style="margin-top: 0.5rem;">{drugs_html}</div>
                        </div>
                        """, unsafe_allow_html=True)

                    st.markdown("<br>", unsafe_allow_html=True)

                    # Status Banner & Recommendation
                    if status == "SAFE":
                        st.markdown(f"""
                        <div class="status-banner-safe">
                            <h4 style="margin:0; font-size:1.1rem; color:#6EE7B7;">✅ Prescription Safe for Patient</h4>
                            <p style="margin:0.35rem 0 0 0; font-size:0.95rem;">{message}</p>
                            <p style="margin:0.25rem 0 0 0; font-size:0.9rem; font-weight:600; color:#A7F3D0;">Recommendation: {recommendation}</p>
                        </div>
                        """, unsafe_allow_html=True)
                    else:
                        st.markdown(f"""
                        <div class="status-banner-danger">
                            <h4 style="margin:0; font-size:1.1rem; color:#FCA5A5;">🚨 {message}</h4>
                            <p style="margin:0.35rem 0 0 0; font-size:0.95rem; font-weight:600; color:#FECDD3;">Clinical Recommendation: {recommendation}</p>
                        </div>
                        """, unsafe_allow_html=True)

                        st.markdown("#### ⚠️ Conflict Analysis & Verified Safe Alternatives")

                        for idx, alert in enumerate(alerts, 1):
                            drug_name = alert.get("drug", "Unknown Drug")
                            conflict_type = alert.get("conflict_type", "SAFETY CONFLICT")
                            conflicting_ing = alert.get("conflicting_ingredient", "N/A")
                            details = alert.get("details", "")
                            alternatives = alert.get("alternatives", [])

                            alts_html = "".join([f'<span class="alt-pill">💊 {alt}</span>' for alt in alternatives]) if alternatives else '<span style="color:#94A3B8;">No direct alternatives mapped</span>'

                            st.markdown(f"""
                            <div class="conflict-card">
                                <div class="conflict-header">
                                    <div class="conflict-title">Conflict #{idx}: Prescribed <span class="badge-pill badge-drug">{drug_name}</span></div>
                                    <span class="badge-pill badge-danger">{conflict_type}</span>
                                </div>
                                <div style="margin-bottom: 0.75rem; font-size: 0.95rem; color: #CBD5E1;">
                                    <b>Active Ingredient Mapping:</b> <span class="badge-pill badge-ing">{conflicting_ing}</span>
                                </div>
                                <div class="details-box">
                                    <b>Clinical Breakdown:</b> {details}
                                </div>
                                <div>
                                    <div style="font-size: 0.9rem; font-weight: 700; color: #F8FAFC; margin-bottom: 0.35rem;">
                                        💡 Recommended Verified Safe Alternatives:
                                    </div>
                                    <div>{alts_html}</div>
                                </div>
                            </div>
                            """, unsafe_allow_html=True)

                else:
                    st.error(f"Backend API returned error code: {response.status_code}")

            except Exception as e:
                st.error("Could not connect to Backend server. Please make sure `python main.py` is running on port 8000.")