/*
 * File Name: medical_record_validator.ts
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - zod
 *   - @/types/medical_record
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Zod schema validators enforcing clinical consultation business constraints across Step 1 ICD-10 diagnostics, Step 2 prescriptions, Step 3 test orders, and final clinical locking.
 */

import { z } from "zod";

export const DiagnosisItemSchema = z.object({
  code: z
    .string()
    .min(1, { message: "ICD-10 code is required" })
    .regex(/^[A-TV-Z][0-9][0-9A-TV-Z](\.[0-9A-TV-Z]{1,4})?$/i, {
      message: "Invalid ICD-10 format (e.g. I10, E11.9, J06.9)",
    }),
  name: z.string().min(2, { message: "Diagnosis name must have at least 2 characters" }),
  category: z.string().optional(),
  description: z.string().optional(),
  isPrimary: z.boolean().optional(),
});

export const MedicationItemSchema = z.object({
  id: z.string().min(1, { message: "Medication ID is required" }),
  medicationName: z
    .string()
    .min(2, { message: "Medication name must have at least 2 characters" }),
  dosageAmount: z
    .number()
    .positive({ message: "Dosage amount must be a positive number" }),
  dosageUnit: z.enum(
    ["mg", "mL", "tablet", "capsule", "drops", "puff", "patch", "IU"],
    { message: "Invalid dosage unit" }
  ),
  frequency: z.enum(
    [
      "Once daily",
      "Twice daily",
      "Three times daily",
      "Four times daily",
      "Every 8 hours",
      "Every 12 hours",
      "With meals",
      "Before bed",
      "As Needed",
    ],
    { message: "Invalid frequency selection" }
  ),
  isOngoing: z.boolean(),
  durationValue: z.number().int().positive().optional(),
  durationUnit: z.enum(["Days", "Weeks", "Months", "Years"]).optional(),
  route: z.enum(
    [
      "Oral",
      "Topical",
      "Inhalation",
      "Intravenous",
      "Intramuscular",
      "Subcutaneous",
      "Ophthalmic",
      "Otic",
    ],
    { message: "Invalid route of administration" }
  ),
  instructions: z.string().max(1000).optional(),
  isIncomplete: z.boolean().optional(),
  allergyConflict: z
    .object({
      allergen: z.string(),
      severity: z.string(),
    })
    .optional(),
});

export const TestOrderItemSchema = z.object({
  id: z.string().min(1, { message: "Test order ID is required" }),
  testCatalogId: z.string().optional(),
  testName: z.string().min(2, { message: "Test name must have at least 2 characters" }),
  type: z.string().min(1, { message: "Test category is required" }),
  priority: z.enum(["Routine", "Urgent", "STAT"], { message: "Invalid priority" }),
  status: z.enum(["Ordered", "Sample Collected", "Completed", "Cancelled"]),
  orderedOn: z.string(),
  clinicalNotes: z.string().max(1000).optional(),
});

export const AttachmentItemSchema = z.object({
  id: z.string().min(1, { message: "Attachment ID is required" }),
  fileName: z.string().min(1, { message: "File name is required" }),
  fileSize: z.number().positive(),
  fileType: z.string(),
  uploadedAt: z.string(),
  fileUrl: z.string(),
});

export const Step1DiagnosisSchema = z
  .object({
    clinicalOutcome: z.enum(
      ["CONFIRMED_DIAGNOSIS", "NO_ILLNESS_DETECTED", "DIAGNOSIS_PENDING"],
      { message: "Please designate a clinical outcome" }
    ),
    primaryDiagnosis: DiagnosisItemSchema.nullable(),
    secondaryDiagnoses: z
      .array(DiagnosisItemSchema)
      .max(10, { message: "Maximum 10 secondary diagnoses allowed" }),
    clinicalNotes: z
      .string()
      .trim()
      .min(10, {
        message: "Clinical notes must contain at least 10 non-whitespace characters",
      })
      .max(5000, { message: "Clinical notes cannot exceed 5000 characters" }),
  })
  .refine(
    (data) => {
      if ("CONFIRMED_DIAGNOSIS" === data.clinicalOutcome) {
        return Boolean(data.primaryDiagnosis && data.primaryDiagnosis.code);
      }
      return true;
    },
    {
      message: "Primary diagnosis is required when Clinical Outcome is 'Confirmed Diagnosis'",
      path: ["primaryDiagnosis"],
    }
  );

export const FinalizeMedicalRecordSchema = z
  .object({
    clinicalOutcome: z.enum(
      ["CONFIRMED_DIAGNOSIS", "NO_ILLNESS_DETECTED", "DIAGNOSIS_PENDING"]
    ),
    primaryDiagnosis: DiagnosisItemSchema.nullable(),
    secondaryDiagnoses: z.array(DiagnosisItemSchema).max(10),
    clinicalNotes: z.string().trim().min(10).max(5000),
    medications: z.array(MedicationItemSchema),
    testsOrdered: z.array(TestOrderItemSchema),
    attachments: z.array(AttachmentItemSchema),
  })
  .refine(
    (data) => {
      if ("CONFIRMED_DIAGNOSIS" === data.clinicalOutcome) {
        return Boolean(data.primaryDiagnosis);
      }
      return true;
    },
    {
      message: "Cannot finalize without a primary diagnosis for Confirmed Diagnosis outcome",
      path: ["primaryDiagnosis"],
    }
  );
