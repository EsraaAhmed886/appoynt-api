/*
 * File Name: medical_record_validator.ts
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.1.0
 * Dependencies:
 *   - zod
 *   - @/types/medical_record
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Pure clinical validator engine enforcing business constraints: Primary diagnosis presence, duplicate secondary diagnosis prevention, clinical notes boundary limits (10 to 5000 chars), and drug allergy contraindication intersection analysis.
 */

import { z } from "zod";
import {
  MedicalRecord,
  DiagnosisItem,
  MedicationItem,
  AllergyItem,
} from "@/types/medical_record";

export interface ValidationResult {
  isValid: boolean;
  errors: Record<string, string>;
}

export interface ContraindicationAlert {
  medicationName: string;
  allergen: string;
  severity: string;
}

export class ClinicalRecordValidator {
  /**
   * Validate Step 1: Diagnoses & Clinical Notes
   */
  static validateStep1(
    primaryDiagnosis?: DiagnosisItem | null,
    secondaryDiagnoses: DiagnosisItem[] = [],
    clinicalNotes: string = ""
  ): ValidationResult {
    const errors: Record<string, string> = {};

    // 1. Primary Diagnosis is mandatory
    if (!primaryDiagnosis || !primaryDiagnosis.code || !primaryDiagnosis.code.trim()) {
      errors.primaryDiagnosis = "Primary diagnosis is required";
    } else {
      // Primary diagnosis provided
    }

    // 2. Secondary Diagnoses must not duplicate Primary
    if (primaryDiagnosis && primaryDiagnosis.code) {
      const isDuplicate = secondaryDiagnoses.some(
        (sec) => sec.code.toLowerCase() === primaryDiagnosis.code.toLowerCase()
      );
      if (isDuplicate) {
        errors.secondaryDiagnosis = "Secondary diagnosis must be different from primary";
      } else {
        // No duplicate secondary diagnosis
      }
    } else {
      // No primary diagnosis to compare
    }

    // 3. Clinical notes must satisfy 10-character minimum (ignoring whitespace) and max 5000 chars
    const trimmedNotes = clinicalNotes.replace(/\s+/g, "");
    if (trimmedNotes.length < 10) {
      errors.clinicalNotes = "Please enter detailed notes (at least 10 characters)";
    } else if (clinicalNotes.length > 5000) {
      errors.clinicalNotes = "Clinical notes cannot exceed 5000 characters";
    } else {
      // Notes length is valid
    }

    return {
      isValid: Object.keys(errors).length === 0,
      errors,
    };
  }

  /**
   * Evaluate drug contraindications against patient allergies
   */
  static evaluateContraindications(
    medications: MedicationItem[] = [],
    allergies: AllergyItem[] = []
  ): ContraindicationAlert[] {
    const alerts: ContraindicationAlert[] = [];
    if (!allergies || allergies.length === 0 || !medications || medications.length === 0) {
      return alerts;
    } else {
      // Proceed with contraindication check
    }

    medications.forEach((med) => {
      const medName = med.medicationName.toLowerCase();
      allergies.forEach((alg) => {
        const algName = alg.name.toLowerCase();

        // Check direct string intersection or penicillin / sulfa class relations
        const isDirectMatch = medName.includes(algName);
        const isPenicillinConflict =
          algName.includes("penicillin") &&
          (medName.includes("amox") ||
            medName.includes("ampic") ||
            medName.includes("penic") ||
            medName.includes("augmentin"));
        const isSulfaConflict =
          algName.includes("sulfa") &&
          (medName.includes("bactrim") ||
            medName.includes("septra") ||
            medName.includes("sulfamethoxazole"));

        if (isDirectMatch || isPenicillinConflict || isSulfaConflict) {
          alerts.push({
            medicationName: med.medicationName,
            allergen: alg.name,
            severity: alg.severity,
          });
        } else {
          // No conflict for this allergen
        }
      });
    });

    return alerts;
  }

  /**
   * Validate entire medical record ready for finalization
   */
  static validateForFinalization(
    record: MedicalRecord,
    allergies: AllergyItem[] = [],
    contraindicationAcknowledged: boolean = false
  ): ValidationResult {
    const errors: Record<string, string> = {};

    const step1Result = this.validateStep1(
      record.primaryDiagnosis,
      record.secondaryDiagnoses,
      record.clinicalNotes
    );

    if (!step1Result.isValid) {
      Object.assign(errors, step1Result.errors);
    } else {
      // Step 1 valid
    }

    const contraindications = this.evaluateContraindications(
      record.medications || [],
      allergies
    );

    if (contraindications.length > 0 && !contraindicationAcknowledged) {
      errors.contraindications =
        "Active drug allergy contraindication must be clinically acknowledged before finalization.";
    } else {
      // No unacknowledged contraindications
    }

    return {
      isValid: Object.keys(errors).length === 0,
      errors,
    };
  }
}
