# ==========================================================
# File Description
# ==========================================================
# File Name          : app.py
# Author             : Habiba Ezat Abdeltawab, Sohila Mohammed
# Date of Creation   : 07-07-2026
# Version            : 1.0.0
# Dependencies       : streamlit, pandas, numpy, joblib
# Last Modified      : Habiba Ezat - 17-07-2026 01:35
# Description        : Streamlit Web Application for Medical Appointment
#                      No-Show Prediction using Optimized LightGBM + RFE (13 Features).
# ==========================================================

# ==========================================================
# Import Libraries
# ==========================================================
import joblib
import numpy as np
import pandas as pd
import streamlit as st

# ==========================================================
# Global Constants
# ==========================================================
PAGE_TITLE = "Medical Appointment No-Show Prediction"
PAGE_ICON = "🏥"
LAYOUT = "wide"
MODEL_PATH = "lgbm_rfe_model.pkl"

MIN_AGE = 0
MAX_AGE = 120
DEFAULT_AGE = 30

MIN_WAITING_DAYS = 0
MAX_WAITING_DAYS = 180
DEFAULT_WAITING_DAYS = 0

MIN_DISEASE_COUNT = 0
MAX_DISEASE_COUNT = 3
DEFAULT_DISEASE_COUNT = 0

# ==========================================================
# Configure Streamlit Page
# ==========================================================
st.set_page_config(
    page_title=PAGE_TITLE,
    page_icon=PAGE_ICON,
    layout=LAYOUT
)

# ==========================================================
# Load Model
# ==========================================================
@st.cache_resource
def load_model():
    """
    Load trained LightGBM production model.
    """
    try:
        prediction_model = joblib.load(MODEL_PATH)
        return prediction_model
    except FileNotFoundError:
        st.error("Model file was not found.")
        return None

prediction_model = load_model()

# ==========================================================
# Custom CSS (Preserving Original UI/UX Design)
# ==========================================================
st.markdown("""
<style>
.main {
    background-color: #F7FAFC;
}
.title {
    font-size: 38px;
    font-weight: bold;
    color: #0F4C81;
    text-align: center;
    margin-bottom: 5px;
}
.subtitle {
    font-size: 18px;
    color: #555555;
    text-align: center;
    margin-bottom: 30px;
}
.card {
    background: white;
    padding: 20px;
    border-radius: 15px;
    box-shadow: 0px 4px 15px rgba(0,0,0,0.08);
    margin-bottom: 20px;
}
.metric-card {
    background: #EAF6FF;
    padding: 18px;
    border-radius: 12px;
    text-align: center;
}
</style>
""", unsafe_allow_html=True)

# ==========================================================
# Header
# ==========================================================
st.markdown(
    "<div class='title'>🏥 Medical Appointment No-Show Prediction</div>",
    unsafe_allow_html=True
)

st.markdown(
    "<div class='subtitle'>Artificial Intelligence System for Predicting Patient Attendance</div>",
    unsafe_allow_html=True
)

st.divider()

# ==========================================================
# Dashboard Status Metrics
# ==========================================================
col1, col2, col3 = st.columns(3)

with col1:
    st.markdown(
        """
        <div class='metric-card'>
        <h3>🤖 Model</h3>
        <h2>LightGBM</h2>
        </div>
        """,
        unsafe_allow_html=True
    )

with col2:
    st.markdown(
        """
        <div class='metric-card'>
        <h3>🎯 Feature Selection</h3>
        <h2>RFE</h2>
        </div>
        """,
        unsafe_allow_html=True
    )

with col3:
    st.markdown(
        """
        <div class='metric-card'>
        <h3>⚖️ Imbalance</h3>
        <h2>Class Weights</h2>
        </div>
        """,
        unsafe_allow_html=True
    )

st.divider()

# ==========================================================
# Patient Information Form
# ==========================================================
st.subheader("📋 Patient Information")

left_column, right_column = st.columns(2)

with left_column:
    patient_age = st.number_input(
        label="Patient Age",
        min_value=MIN_AGE,
        max_value=MAX_AGE,
        value=DEFAULT_AGE
    )

    gender_option = st.selectbox(
        label="Gender",
        options=["Female", "Male"]
    )

    waiting_days = st.number_input(
        label="Waiting Days",
        min_value=MIN_WAITING_DAYS,
        max_value=MAX_WAITING_DAYS,
        value=DEFAULT_WAITING_DAYS
    )
    
    scholarship_option = st.selectbox(
        label="Scholarship (Bolsa Família)",
        options=["No", "Yes"]
    )

with right_column:
    sms_option = st.selectbox(
        label="SMS Reminder",
        options=["No", "Yes"]
    )

    handcap_option = st.selectbox(
        label="Handicap Status",
        options=["No", "Yes"]
    )

    disease_count = st.number_input(
        label="Disease Count (Hypertension, Diabetes, Alcoholism)",
        min_value=MIN_DISEASE_COUNT,
        max_value=MAX_DISEASE_COUNT,
        value=DEFAULT_DISEASE_COUNT
    )

# ==========================================================
# Appointment Information Form
# ==========================================================
st.subheader("📅 Appointment Information")

day_column_1, day_column_2 = st.columns(2)

days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday","Sunday"]

with day_column_1:
    appointment_day = st.selectbox(
        label="Appointment Day",
        options=days
    )

with day_column_2:
    scheduled_day = st.selectbox(
        label="Scheduled Day (Booking Day)",
        options=days
    )

predict_button = st.button(
    label="🔮 Predict",
    use_container_width=True
)

if predict_button:
    if prediction_model is not None:

        # ==========================================================
        # Encode Input Categorical Features
        # ==========================================================
        gender_encoded = 0 if gender_option == "Female" else 1
        sms_encoded = 1 if sms_option == "Yes" else 0
        handcap_encoded = 1 if handcap_option == "Yes" else 0
        scholarship_encoded = 1 if scholarship_option == "Yes" else 0

        # ==========================================================
        # Initialize Production Features Structure (13 Selected Features)
        # ==========================================================
        features = {
            "Gender": gender_encoded,
            "Age": patient_age,
            "Scholarship": scholarship_encoded,
            "Handcap": handcap_encoded,
            "SMS_received": sms_encoded,
            "WaitingDays": waiting_days,
            "DiseaseCount": disease_count,
            "AppDay_Friday": 0,
            "AppDay_Monday": 0,
            "AppDay_Tuesday": 0,
            "AppDay_Wednesday": 0,
            "SchDay_Thursday": 0,
            "SchDay_Tuesday": 0
        }

        # Set specific active appointment and scheduled weekday feature flags
        appointment_feature = f"AppDay_{appointment_day}"
        scheduled_feature = f"SchDay_{scheduled_day}"

        # If the selected day is among the important features chosen by RFE, activate it.
        # Otherwise, it stays 0 (mathematically correct for omitted dummy variables).
        if appointment_feature in features:
            features[appointment_feature] = 1

        if scheduled_feature in features:
            features[scheduled_feature] = 1

        # ==========================================================
        # Create Dataframe and Predict
        # ==========================================================
        input_dataframe = pd.DataFrame([features])
        
        # Ensure exact column sorting matching the serialized LightGBM model signature
        model_features = prediction_model.feature_name_
        input_dataframe = input_dataframe[model_features]

        # Model Inference
        prediction = prediction_model.predict(input_dataframe)[0]
        probabilities = prediction_model.predict_proba(input_dataframe)[0]

        show_probability = probabilities[0]
        no_show_probability = probabilities[1]
        confidence = np.max(probabilities)

        # ==========================================================
        # Display Prediction Results
        # ==========================================================
        st.divider()
        st.subheader("Prediction Result")

        if prediction == 0:
            st.success("✅ Prediction: Patient will ATTEND the appointment.")
        else:
            st.error("❌ Prediction: Patient is likely to MISS the appointment.")

        st.write("### Prediction Confidence")
        st.progress(float(confidence))
        st.metric(
            label="Confidence",
            value=f"{confidence * 100:.2f}%"
        )

        col_show, col_no_show = st.columns(2)
        with col_show:
            st.metric(
                label="Attendance Probability",
                value=f"{show_probability * 100:.2f}%"
            )
        with col_no_show:
            st.metric(
                label="No-Show Probability",
                value=f"{no_show_probability * 100:.2f}%"
            )

        # ==========================================================
        # Actionable Recommendations
        # ==========================================================
        st.divider()
        st.subheader("Recommendation")

        if prediction == 0:
            st.info(
                """
                The patient is expected to attend the appointment.
                
                **Recommended Actions:**
                
                • Keep the appointment confirmed.
                
                • Send the regular reminder message.
                
                • No additional intervention is required.
                """
            )
        else:
            st.warning(
                """
                The patient has a high risk of missing the appointment.
                
                **Recommended Actions:**
                
                • Contact the patient before the appointment.
                
                • Send an additional reminder.
                
                • Confirm attendance by phone if possible.
                
                • Consider offering another available time slot.
                """
            )

        with st.expander("Input Features Used"):
            st.dataframe(input_dataframe)

    else:
        st.error("Prediction model could not be loaded.")

st.divider()
st.caption(
    "Developed using LightGBM + Recursive Feature Elimination (RFE)"
)