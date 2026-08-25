/*
 * File Name: medical_record_qa_test.ts
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - @/services/medical_record_validator
 *   - @/types/medical_record
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Automated clinical quality assurance test suite validating form constraints, duplicate ICD-10 diagnosis checks, clinical notes boundaries, drug allergy contraindication triggers, and finalization safety gates.
 */

import { ClinicalRecordValidator } from "../medical_record_validator";
import { DiagnosisItem, MedicationItem, AllergyItem, MedicalRecord } from "../../types/medical_record";

function runClinicalQATests() {
  let passedCount = 0;
  let failedCount = 0;

  function assert(condition: boolean, testName: string) {
    if (condition) {
      console.log(`  ✓ PASS: ${testName}`);
      passedCount++;
    } else {
      console.error(`  ✗ FAIL: ${testName}`);
      failedCount++;
    }
  }

  console.log("============================================================");
  console.log("CLINICAL WORKFLOW & VALIDATION QA TEST SUITE");
  console.log("============================================================");

  // 1. Primary Diagnosis Tests
  console.log("\n[Group 1: Primary Diagnosis Requirement]");
  const noPrimary = ClinicalRecordValidator.validateStep1(null, [], "Valid notes exceeding 10 characters");
  assert(!noPrimary.isValid, "Rejects null primary diagnosis");
  assert(noPrimary.errors.primaryDiagnosis === "Primary diagnosis is required", "Correct primary diagnosis error message");

  const validPrimary: DiagnosisItem = { code: "I10", title: "Essential Hypertension", isPrimary: true };
  const withPrimary = ClinicalRecordValidator.validateStep1(validPrimary, [], "Valid notes exceeding 10 characters");
  assert(withPrimary.isValid, "Accepts valid primary diagnosis");

  // 2. Duplicate Diagnosis Tests
  console.log("\n[Group 2: Duplicate Diagnosis Check]");
  const duplicateSecondary: DiagnosisItem[] = [
    { code: "I10", title: "Essential Hypertension", isPrimary: false },
  ];
  const duplicateResult = ClinicalRecordValidator.validateStep1(validPrimary, duplicateSecondary, "Valid notes exceeding 10 characters");
  assert(!duplicateResult.isValid, "Rejects secondary diagnosis matching primary code");
  assert(
    duplicateResult.errors.secondaryDiagnosis === "Secondary diagnosis must be different from primary",
    "Correct duplicate diagnosis error message"
  );

  const distinctSecondary: DiagnosisItem[] = [
    { code: "E11.9", title: "Type 2 Diabetes Mellitus", isPrimary: false },
  ];
  const distinctResult = ClinicalRecordValidator.validateStep1(validPrimary, distinctSecondary, "Valid notes exceeding 10 characters");
  assert(distinctResult.isValid, "Accepts distinct secondary diagnosis");

  // 3. Clinical Notes Boundary Tests
  console.log("\n[Group 3: Clinical Notes Character Boundaries]");
  const shortNotes = ClinicalRecordValidator.validateStep1(validPrimary, [], "Short");
  assert(!shortNotes.isValid, "Rejects clinical notes < 10 characters");
  assert(
    shortNotes.errors.clinicalNotes === "Please enter detailed notes (at least 10 characters)",
    "Correct minimum notes length error message"
  );

  const whitespaceNotes = ClinicalRecordValidator.validateStep1(validPrimary, [], "   1 2 3   ");
  assert(!whitespaceNotes.isValid, "Rejects whitespace-padded notes with < 10 non-whitespace characters");

  const validNotes = ClinicalRecordValidator.validateStep1(validPrimary, [], "Patient reports stable BP readings over the past 2 weeks.");
  assert(validNotes.isValid, "Accepts clinical notes with >= 10 characters");

  // 4. Clinical Safety & Allergy Contraindication Triggers
  console.log("\n[Group 4: Drug Allergy Contraindication Triggers]");
  const patientAllergies: AllergyItem[] = [
    { id: "alg-1", name: "Penicillin", severity: "SEVERE" },
    { id: "alg-2", name: "Shellfish", severity: "MODERATE" },
  ];

  const amoxicillinMed: MedicationItem[] = [
    {
      id: "med-1",
      medicationName: "Amoxicillin",
      dosageAmount: 500,
      dosageUnit: "mg",
      frequency: "Three times daily",
      isOngoing: false,
      durationValue: 7,
      durationUnit: "Days",
      route: "Oral",
    },
  ];

  const contraindications = ClinicalRecordValidator.evaluateContraindications(amoxicillinMed, patientAllergies);
  assert(contraindications.length === 1, "Detects Penicillin allergy contraindication when Amoxicillin is prescribed");
  assert(contraindications[0].allergen === "Penicillin", "Identifies matching allergen (Penicillin)");
  assert(contraindications[0].severity === "SEVERE", "Identifies severity level (SEVERE)");

  const safeMed: MedicationItem[] = [
    {
      id: "med-2",
      medicationName: "Amlodipine",
      dosageAmount: 5,
      dosageUnit: "mg",
      frequency: "Once daily",
      isOngoing: true,
      route: "Oral",
    },
  ];

  const safeContraindications = ClinicalRecordValidator.evaluateContraindications(safeMed, patientAllergies);
  assert(safeContraindications.length === 0, "Confirms zero contraindications for safe medication (Amlodipine)");

  // 5. Finalization Safety Gate Tests
  console.log("\n[Group 5: Finalization Safety Gate]");
  const mockRecord: MedicalRecord = {
    recordId: "REC-TEST-1",
    appointmentId: "APT-TEST-1",
    patientId: "PAT-TEST-1",
    doctorName: "Dr. Nada Khan",
    clinicName: "Cardiology",
    consultationDate: "2026-08-20",
    status: "DRAFT",
    displayState: "DRAFT",
    currentStep: 3,
    clinicalOutcome: "FOLLOW_UP_REQUIRED",
    primaryDiagnosis: validPrimary,
    secondaryDiagnoses: [],
    clinicalNotes: "Comprehensive cardiology examination completed. Patient stable.",
    medications: amoxicillinMed,
    testsOrdered: [],
  };

  const finalizationBlocked = ClinicalRecordValidator.validateForFinalization(mockRecord, patientAllergies, false);
  assert(!finalizationBlocked.isValid, "Blocks finalization when active contraindication exists without override acknowledgment");

  const finalizationAllowed = ClinicalRecordValidator.validateForFinalization(mockRecord, patientAllergies, true);
  assert(finalizationAllowed.isValid, "Allows finalization when contraindication has explicit acknowledgment");

  console.log("\n============================================================");
  console.log(`TOTAL TESTS: ${passedCount + failedCount} | PASSED: ${passedCount} | FAILED: ${failedCount}`);
  console.log("============================================================\n");

  if (failedCount > 0) {
    throw new Error(`${failedCount} QA tests failed.`);
  } else {
    // All QA tests passed
  }
}

runClinicalQATests();
