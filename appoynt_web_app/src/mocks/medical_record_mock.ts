/*
 * File Name: medical_record_mock.ts
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - @/types/medical_record
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Realistic offline mock datasets for clinical consultation scenarios, ICD-10 catalogues, medication formulary, diagnostic test menus, and patient medical histories.
 */

import {
  MedicalRecord,
  PatientSummary,
  MedicalHistoryItem,
  Icd10CatalogItem,
  MedicationCatalogItem,
  TestCatalogItem,
} from "@/types/medical_record";

export const MOCK_PATIENT_SUMMARY: PatientSummary = {
  patientId: "PAT-88219",
  fullName: "Sarah Jenkins",
  avatarUrl: "/images/profile_icon.jpeg",
  gender: "Female",
  dateOfBirth: "1988-04-12",
  calculatedAge: 38,
  phone: "+1 (555) 234-5678",
  email: "sarah.jenkins@example.com",
  bloodType: "A+",
  activeAllergies: [
    {
      name: "Penicillin",
      severity: "SEVERE",
      reaction: "Anaphylaxis, Urticaria",
    },
    {
      name: "Sulfonamides (Sulfa)",
      severity: "MODERATE",
      reaction: "Cutaneous Rash, Pruritus",
    },
  ],
  chronicConditions: [
    {
      id: "cc-01",
      name: "Type 2 Diabetes Mellitus",
      icd10Code: "E11.9",
      diagnosedYear: "2021",
      status: "CONTROLLED",
    },
    {
      id: "cc-02",
      name: "Essential Hypertension",
      icd10Code: "I10",
      diagnosedYear: "2019",
      status: "ACTIVE",
    },
    {
      id: "cc-03",
      name: "Bronchial Asthma",
      icd10Code: "J45.909",
      diagnosedYear: "2015",
      status: "CONTROLLED",
    },
  ],
};

export const MOCK_NOT_STARTED_RECORD: MedicalRecord = {
  recordId: "REC-2026-0001",
  appointmentId: "apt-101",
  patientId: "PAT-88219",
  doctorId: "DOC-001",
  doctorName: "Dr. Nada Khan",
  clinicId: "CLN-01",
  clinicName: "General Medicine Clinic",
  consultationDate: "2026-08-18",
  status: "NOT_STARTED",
  currentStep: 1,
  displayState: "NOT_STARTED",
  clinicalOutcome: "CONFIRMED_DIAGNOSIS",
  primaryDiagnosis: null,
  secondaryDiagnoses: [],
  clinicalNotes: "",
  medications: [],
  testsOrdered: [],
  attachments: [],
  isLocked: false,
  hasUnsavedChanges: false,
  lastSavedAtUtc: null,
  finalizedAtUtc: null,
  version: 1,
};

export const MOCK_DRAFT_RECORD: MedicalRecord = {
  recordId: "REC-2026-0002",
  appointmentId: "apt-102",
  patientId: "PAT-88219",
  doctorId: "DOC-001",
  doctorName: "Dr. Nada Khan",
  clinicId: "CLN-01",
  clinicName: "General Medicine Clinic",
  consultationDate: "2026-08-18",
  status: "DRAFT",
  currentStep: 2,
  displayState: "DRAFT_STEP_2",
  clinicalOutcome: "CONFIRMED_DIAGNOSIS",
  primaryDiagnosis: {
    code: "I10",
    name: "Essential (primary) hypertension",
    category: "Cardiovascular",
    description: "High blood pressure without identifiable secondary cause.",
    isPrimary: true,
  },
  secondaryDiagnoses: [
    {
      code: "E11.9",
      name: "Type 2 diabetes mellitus without complications",
      category: "Endocrine",
      description: "Non-insulin-dependent diabetes mellitus.",
    },
  ],
  clinicalNotes:
    "Patient presents with persistent morning headaches and elevated home BP readings (145/92 mmHg on average). Heart sounds normal S1/S2 without murmurs. No peripheral edema noted. Advised DASH diet and low sodium intake.",
  medications: [
    {
      id: "med-1",
      medicationName: "Amlodipine Besylate",
      dosageAmount: 5,
      dosageUnit: "mg",
      frequency: "Once daily",
      isOngoing: true,
      route: "Oral",
      instructions: "Take in the morning with or without food.",
    },
    {
      id: "med-2",
      medicationName: "Amoxicillin Trihydrate",
      dosageAmount: 500,
      dosageUnit: "mg",
      frequency: "Three times daily",
      isOngoing: false,
      durationValue: 7,
      durationUnit: "Days",
      route: "Oral",
      instructions: "Take with meals for upper respiratory symptoms.",
      allergyConflict: {
        allergen: "Penicillin",
        severity: "SEVERE",
      },
    },
  ],
  testsOrdered: [
    {
      id: "test-1",
      testCatalogId: "t-101",
      testName: "Comprehensive Metabolic Panel (CMP)",
      type: "Laboratory",
      priority: "Routine",
      status: "Ordered",
      orderedOn: "2026-08-18",
      clinicalNotes: "Evaluate renal baseline before titration.",
    },
  ],
  attachments: [],
  isLocked: false,
  hasUnsavedChanges: false,
  lastSavedAtUtc: "2026-08-18T10:15:00Z",
  finalizedAtUtc: null,
  version: 1,
};

export const MOCK_FINALIZED_RECORD: MedicalRecord = {
  recordId: "REC-2026-0003",
  appointmentId: "apt-103",
  patientId: "PAT-88219",
  doctorId: "DOC-001",
  doctorName: "Dr. Nada Khan",
  clinicId: "CLN-01",
  clinicName: "General Medicine Clinic",
  consultationDate: "2026-08-10",
  status: "FINALIZED",
  currentStep: 3,
  displayState: "FINALIZED_CLEAN",
  clinicalOutcome: "CONFIRMED_DIAGNOSIS",
  primaryDiagnosis: {
    code: "J06.9",
    name: "Acute upper respiratory infection, unspecified",
    category: "Respiratory",
    description: "Infection of the upper respiratory tract.",
    isPrimary: true,
  },
  secondaryDiagnoses: [],
  clinicalNotes:
    "Patient presented with rhinitis, sore throat, and mild fever (38.1°C). Clear lungs bilaterally. Advised oral hydration, rest, and antipyretics as needed.",
  medications: [
    {
      id: "med-3",
      medicationName: "Paracetamol (Acetaminophen)",
      dosageAmount: 500,
      dosageUnit: "mg",
      frequency: "As Needed",
      isOngoing: false,
      durationValue: 5,
      durationUnit: "Days",
      route: "Oral",
      instructions: "Take 1-2 tablets every 6 hours for fever or body aches.",
    },
  ],
  testsOrdered: [],
  attachments: [
    {
      id: "att-1",
      fileName: "Lab_CBC_Results_20260810.pdf",
      fileSize: 345000,
      fileType: "application/pdf",
      uploadedAt: "2026-08-10T11:20:00Z",
      fileUrl: "#",
    },
  ],
  isLocked: true,
  hasUnsavedChanges: false,
  lastSavedAtUtc: "2026-08-10T11:30:00Z",
  finalizedAtUtc: "2026-08-10T11:30:00Z",
  version: 1,
};

export const MOCK_PRIOR_VISITS: MedicalHistoryItem[] = [
  {
    recordId: "REC-2026-0003",
    appointmentId: "apt-103",
    visitDate: "2026-08-10",
    doctorName: "Dr. Nada Khan",
    clinicName: "General Medicine Clinic",
    primaryDiagnosisCode: "J06.9",
    primaryDiagnosisName: "Acute upper respiratory infection",
    status: "FINALIZED",
    hasAmendments: false,
    outcome: "Confirmed Diagnosis",
  },
  {
    recordId: "REC-2026-0004",
    appointmentId: "apt-095",
    visitDate: "2026-05-14",
    doctorName: "Dr. Tarek Youssef",
    clinicName: "Cardiology Center",
    primaryDiagnosisCode: "I10",
    primaryDiagnosisName: "Essential (primary) hypertension",
    status: "FINALIZED",
    hasAmendments: true,
    outcome: "Confirmed Diagnosis",
  },
  {
    recordId: "REC-2026-0005",
    appointmentId: "apt-081",
    visitDate: "2026-02-20",
    doctorName: "Dr. Mona Fikry",
    clinicName: "Allergy & Immunology Clinic",
    primaryDiagnosisCode: "T78.40XA",
    primaryDiagnosisName: "Allergy, unspecified, initial encounter",
    status: "FINALIZED",
    hasAmendments: false,
    outcome: "Confirmed Diagnosis",
  },
  {
    recordId: "REC-2025-0012",
    appointmentId: "apt-064",
    visitDate: "2025-11-05",
    doctorName: "Dr. Karim Samy",
    clinicName: "General Medicine Clinic",
    primaryDiagnosisCode: "Z00.00",
    primaryDiagnosisName: "General adult medical examination without abnormal findings",
    status: "FINALIZED",
    hasAmendments: false,
    outcome: "No Illness Detected",
  },
];

export const MOCK_ICD10_CATALOG: Icd10CatalogItem[] = [
  {
    code: "I10",
    name: "Essential (primary) hypertension",
    category: "Cardiovascular",
    description: "High blood pressure without identifiable secondary cause.",
  },
  {
    code: "E11.9",
    name: "Type 2 diabetes mellitus without complications",
    category: "Endocrine",
    description: "Non-insulin-dependent diabetes mellitus.",
  },
  {
    code: "J06.9",
    name: "Acute upper respiratory infection, unspecified",
    category: "Respiratory",
    description: "Infection of the upper respiratory tract.",
  },
  {
    code: "J45.909",
    name: "Unspecified asthma, uncomplicated",
    category: "Respiratory",
    description: "Chronic airway inflammatory disorder.",
  },
  {
    code: "K21.9",
    name: "Gastro-esophageal reflux disease without esophagitis",
    category: "Gastrointestinal",
    description: "Stomach acid flow back into the food pipe.",
  },
  {
    code: "G43.909",
    name: "Migraine, unspecified, not intractable",
    category: "Neurological",
    description: "Recurrent throbbing headache disorder.",
  },
  {
    code: "M54.50",
    name: "Low back pain, unspecified",
    category: "Musculoskeletal",
    description: "Pain or discomfort in the lumbar spinal region.",
  },
  {
    code: "F41.1",
    name: "Generalized anxiety disorder",
    category: "Psychiatric",
    description: "Excessive, persistent anxiety and worry.",
  },
  {
    code: "E78.5",
    name: "Hyperlipidemia, unspecified",
    category: "Endocrine",
    description: "Elevated lipid and lipoprotein levels in the blood.",
  },
  {
    code: "Z00.00",
    name: "General adult medical examination without abnormal findings",
    category: "Preventive",
    description: "Routine health wellness assessment.",
  },
];

export const MOCK_MEDICATION_CATALOG: MedicationCatalogItem[] = [
  {
    id: "cat-med-1",
    name: "Amoxicillin Trihydrate",
    category: "Antibiotics (Penicillins)",
    defaultUnit: "mg",
    commonDosages: [250, 500, 875],
    allergenTag: "Penicillin",
  },
  {
    id: "cat-med-2",
    name: "Amoxicillin / Clavulanate (Augmentin)",
    category: "Antibiotics (Penicillins)",
    defaultUnit: "mg",
    commonDosages: [625, 1000],
    allergenTag: "Penicillin",
  },
  {
    id: "cat-med-3",
    name: "Amlodipine Besylate",
    category: "Antihypertensives (Calcium Channel Blockers)",
    defaultUnit: "mg",
    commonDosages: [2.5, 5, 10],
  },
  {
    id: "cat-med-4",
    name: "Lisinopril",
    category: "Antihypertensives (ACE Inhibitors)",
    defaultUnit: "mg",
    commonDosages: [5, 10, 20, 40],
  },
  {
    id: "cat-med-5",
    name: "Metformin Hydrochloride",
    category: "Antidiabetics (Biguanides)",
    defaultUnit: "mg",
    commonDosages: [500, 850, 1000],
  },
  {
    id: "cat-med-6",
    name: "Atorvastatin Calcium",
    category: "Statins (Lipid Lowering)",
    defaultUnit: "mg",
    commonDosages: [10, 20, 40, 80],
  },
  {
    id: "cat-med-7",
    name: "Omeprazole",
    category: "Proton Pump Inhibitors",
    defaultUnit: "mg",
    commonDosages: [20, 40],
  },
  {
    id: "cat-med-8",
    name: "Paracetamol (Acetaminophen)",
    category: "Analgesics & Antipyretics",
    defaultUnit: "mg",
    commonDosages: [500, 1000],
  },
  {
    id: "cat-med-9",
    name: "Ibuprofen",
    category: "NSAIDs",
    defaultUnit: "mg",
    commonDosages: [200, 400, 600],
  },
  {
    id: "cat-med-10",
    name: "Azithromycin (Zithromax)",
    category: "Antibiotics (Macrolides)",
    defaultUnit: "mg",
    commonDosages: [250, 500],
  },
];

export const MOCK_TEST_CATALOG: TestCatalogItem[] = [
  {
    id: "t-101",
    name: "Complete Blood Count (CBC) with Differential",
    category: "Laboratory",
    commonType: "Hematology",
  },
  {
    id: "t-102",
    name: "Comprehensive Metabolic Panel (CMP)",
    category: "Laboratory",
    commonType: "Biochemistry",
  },
  {
    id: "t-103",
    name: "Lipid Panel (Total Cholesterol, HDL, LDL, Triglycerides)",
    category: "Laboratory",
    commonType: "Biochemistry",
  },
  {
    id: "t-104",
    name: "Hemoglobin A1c (HbA1c)",
    category: "Laboratory",
    commonType: "Endocrinology",
  },
  {
    id: "t-105",
    name: "Thyroid-Stimulating Hormone (TSH) with Reflex Free T4",
    category: "Laboratory",
    commonType: "Endocrinology",
  },
  {
    id: "t-106",
    name: "Chest X-Ray (PA and Lateral Views)",
    category: "Radiology",
    commonType: "Diagnostic X-Ray",
  },
  {
    id: "t-107",
    name: "12-Lead Electrocardiogram (ECG)",
    category: "Cardiology",
    commonType: "Electrophysiology",
  },
  {
    id: "t-108",
    name: "Abdominal Ultrasound",
    category: "Radiology",
    commonType: "Sonography",
  },
];
