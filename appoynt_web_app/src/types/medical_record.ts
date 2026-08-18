/*
 * File Name: medical_record.ts
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: TypeScript domain definitions and interfaces for the medical record consultation lifecycle including patient summaries, ICD-10 diagnostics, prescription regimens, test orders, and versioned audit histories.
 */

export type MedicalRecordStatus = "NOT_STARTED" | "DRAFT" | "FINALIZED";

export type ClinicalOutcome =
  | "CONFIRMED_DIAGNOSIS"
  | "NO_ILLNESS_DETECTED"
  | "DIAGNOSIS_PENDING";

export type DisplayState =
  | "NOT_STARTED"
  | "DRAFT_STEP_1"
  | "DRAFT_STEP_2"
  | "DRAFT_STEP_3"
  | "FINALIZED_CLEAN"
  | "FINALIZED_WITH_AMENDMENTS";

export interface PatientAllergy {
  name: string;
  severity: "MILD" | "MODERATE" | "SEVERE";
  reaction?: string;
}

export interface PatientChronicCondition {
  id: string;
  name: string;
  icd10Code?: string;
  diagnosedYear?: string;
  status?: "ACTIVE" | "CONTROLLED";
}

export interface PatientSummary {
  patientId: string;
  fullName: string;
  avatarUrl?: string;
  gender: "Male" | "Female" | string;
  dateOfBirth: string; // ISO 8601 YYYY-MM-DD
  calculatedAge: number;
  phone?: string;
  email?: string;
  bloodType?: string;
  activeAllergies: PatientAllergy[];
  chronicConditions?: PatientChronicCondition[];
}

export interface DiagnosisItem {
  code: string; // ICD-10 Code
  name: string;
  category?: string;
  description?: string;
  isPrimary?: boolean;
}

export interface MedicationItem {
  id: string;
  medicationName: string;
  dosageAmount: number;
  dosageUnit: "mg" | "mL" | "tablet" | "capsule" | "drops" | "puff" | "patch" | "IU";
  frequency:
    | "Once daily"
    | "Twice daily"
    | "Three times daily"
    | "Four times daily"
    | "Every 8 hours"
    | "Every 12 hours"
    | "With meals"
    | "Before bed"
    | "As Needed";
  isOngoing: boolean;
  durationValue?: number;
  durationUnit?: "Days" | "Weeks" | "Months" | "Years";
  route:
    | "Oral"
    | "Topical"
    | "Inhalation"
    | "Intravenous"
    | "Intramuscular"
    | "Subcutaneous"
    | "Ophthalmic"
    | "Otic";
  instructions?: string;
  isIncomplete?: boolean;
  allergyConflict?: {
    allergen: string;
    severity: string;
  };
}

export type TestPriority = "Routine" | "Urgent" | "STAT";

export interface TestOrderItem {
  id: string;
  testCatalogId?: string;
  testName: string;
  type: "Laboratory" | "Radiology" | "Cardiology" | "Pathology" | string;
  priority: TestPriority;
  status: "Ordered" | "Sample Collected" | "Completed" | "Cancelled";
  orderedOn: string;
  clinicalNotes?: string;
}

export interface AttachmentItem {
  id: string;
  fileName: string;
  fileSize: number;
  fileType: string;
  uploadedAt: string;
  fileUrl: string;
}

export interface MedicalRecord {
  recordId: string;
  appointmentId: string;
  patientId: string;
  doctorId: string;
  doctorName?: string;
  clinicId?: string;
  clinicName?: string;
  consultationDate?: string;
  status: MedicalRecordStatus;
  currentStep: 1 | 2 | 3;
  displayState: DisplayState;
  clinicalOutcome: ClinicalOutcome;
  primaryDiagnosis: DiagnosisItem | null;
  secondaryDiagnoses: DiagnosisItem[];
  clinicalNotes: string;
  medications: MedicationItem[];
  testsOrdered: TestOrderItem[];
  attachments: AttachmentItem[];
  isLocked: boolean;
  hasUnsavedChanges: boolean;
  lastSavedAtUtc: string | null;
  finalizedAtUtc: string | null;
  version: number;
  amendmentNotes?: string;
}

export interface MedicalHistoryItem {
  recordId: string;
  appointmentId: string;
  visitDate: string;
  doctorName: string;
  clinicName?: string;
  primaryDiagnosisCode: string;
  primaryDiagnosisName: string;
  status: "FINALIZED" | "DRAFT";
  hasAmendments: boolean;
  outcome: string;
}

export interface Icd10CatalogItem {
  code: string;
  name: string;
  category: string;
  description?: string;
}

export interface MedicationCatalogItem {
  id: string;
  name: string;
  category: string;
  defaultUnit: MedicationItem["dosageUnit"];
  commonDosages: number[];
  allergenTag?: string;
}

export interface TestCatalogItem {
  id: string;
  name: string;
  category: string;
  commonType: string;
}

export interface DrugInteractionCheckResult {
  hasInteraction: boolean;
  severity?: "MILD" | "MODERATE" | "SEVERE";
  message?: string;
  interactions?: {
    drug1: string;
    drug2: string;
    severity: string;
    description: string;
  }[];
}
