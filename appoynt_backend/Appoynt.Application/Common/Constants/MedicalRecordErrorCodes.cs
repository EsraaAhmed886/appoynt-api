/**
 * File Name      : MedicalRecordErrorCodes.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Defines stable machine-readable error codes for medical record operations,
 *                  access control, validations, and lifecycle transitions.
 */

namespace Appoynt.Application.Common.Constants;

/// <summary>
/// Provides error codes returned by medical record application operations.
/// </summary>
public static class MedicalRecordErrorCodes
{
    /// <summary>
    /// Indicates the requested medical record was not found or is invisible to the caller.
    /// </summary>
    public const string NotFound = "medical_record.not_found";

    /// <summary>
    /// Indicates the appointment is missing or not assigned to the doctor.
    /// </summary>
    public const string AppointmentNotFound = "medical_record.appointment_not_found";

    /// <summary>
    /// Indicates the appointment status does not permit starting consultation or creating a record.
    /// </summary>
    public const string AppointmentNotEligible = "medical_record.appointment_not_eligible";

    /// <summary>
    /// Indicates the authenticated doctor is not authorized to perform the requested operation.
    /// </summary>
    public const string UnauthorizedDoctor = "medical_record.unauthorized_doctor";

    /// <summary>
    /// Indicates the patient has disabled full medical history sharing with other physicians.
    /// </summary>
    public const string PatientSharingDisabled = "medical_record.patient_sharing_disabled";

    /// <summary>
    /// Indicates a medical record or draft already exists for the selected appointment.
    /// </summary>
    public const string RecordAlreadyExists = "medical_record.already_exists";

    /// <summary>
    /// Indicates an attempt to directly modify a finalized record without an amendment/change log.
    /// </summary>
    public const string CannotModifyFinalized = "medical_record.cannot_modify_finalized";

    /// <summary>
    /// Indicates an optimistic concurrency conflict (the record was updated elsewhere).
    /// </summary>
    public const string VersionConflict = "medical_record.version_conflict";

    /// <summary>
    /// Indicates finalization was blocked because incomplete draft items remain.
    /// </summary>
    public const string IncompleteItemsExist = "medical_record.incomplete_items_exist";

    /// <summary>
    /// Indicates a confirmed diagnosis outcome requires a primary diagnosis.
    /// </summary>
    public const string PrimaryDiagnosisRequired = "medical_record.primary_diagnosis_required";

    /// <summary>
    /// Indicates the same diagnosis was selected multiple times or as both primary and secondary.
    /// </summary>
    public const string DuplicateDiagnosis = "medical_record.duplicate_diagnosis";

    /// <summary>
    /// Indicates the maximum limit of 10 secondary diagnoses has been exceeded.
    /// </summary>
    public const string MaxSecondaryDiagnosesExceeded = "medical_record.max_secondary_diagnoses_exceeded";

    /// <summary>
    /// Indicates clinical notes are mandatory for this outcome and were missing.
    /// </summary>
    public const string ClinicalNotesRequired = "medical_record.clinical_notes_required";

    /// <summary>
    /// Indicates clinical notes contain fewer than 10 non-whitespace characters.
    /// </summary>
    public const string ClinicalNotesTooShort = "medical_record.clinical_notes_too_short";

    /// <summary>
    /// Indicates clinical notes exceed the maximum character limit (5,000 chars).
    /// </summary>
    public const string ClinicalNotesTooLong = "medical_record.clinical_notes_too_long";

    /// <summary>
    /// Indicates prescribing an unlisted custom medication requires doctor risk acknowledgment.
    /// </summary>
    public const string MedicationRiskUnacknowledged = "medical_record.medication_risk_unacknowledged";

    /// <summary>
    /// Indicates instructions are mandatory when a medication frequency is As Needed (PRN).
    /// </summary>
    public const string AsNeededInstructionsRequired = "medical_record.as_needed_instructions_required";

    /// <summary>
    /// Indicates neither MedicationCatalogId nor CustomMedicationId was provided.
    /// </summary>
    public const string InvalidMedicationSource = "medical_record.invalid_medication_source";

    /// <summary>
    /// Indicates a mandatory reason was missing when submitting a post-finalization edit.
    /// </summary>
    public const string AmendmentReasonRequired = "medical_record.amendment_reason_required";

    /// <summary>
    /// Indicates the amendment reason is shorter than 10 non-whitespace characters.
    /// </summary>
    public const string AmendmentReasonTooShort = "medical_record.amendment_reason_too_short";

    /// <summary>
    /// Indicates the amendment reason exceeds the maximum limit (1,000 chars).
    /// </summary>
    public const string AmendmentReasonTooLong = "medical_record.amendment_reason_too_long";

    /// <summary>
    /// Indicates no effective changes were detected when attempting to amend a finalized record.
    /// </summary>
    public const string NoEffectiveChanges = "medical_record.no_effective_changes";

    /// <summary>
    /// Indicates an active allergy conflict was detected for a prescribed medication.
    /// </summary>
    public const string AllergyConflictDetected = "medical_record.allergy_conflict_detected";
}
