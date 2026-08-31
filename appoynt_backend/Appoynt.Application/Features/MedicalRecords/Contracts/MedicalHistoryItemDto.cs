/**
 * File Name      : MedicalHistoryItemDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Data transfer object representing a single historical medical record in the patient's timeline.
 */

using System;

namespace Appoynt.Application.Features.MedicalRecords.Contracts;

/// <summary>
/// Represents a finalized medical record card in the patient medical history tab.
/// </summary>
public sealed class MedicalHistoryItemDto
{
    /// <summary>
    /// Gets or sets the medical record unique identifier.
    /// </summary>
    public Guid MedicalRecordId { get; set; }

    /// <summary>
    /// Gets or sets the associated appointment identifier.
    /// </summary>
    public Guid AppointmentId { get; set; }

    /// <summary>
    /// Gets or sets the clinical visit date.
    /// </summary>
    public DateOnly VisitDate { get; set; }

    /// <summary>
    /// Gets or sets the name of the clinic where the visit occurred.
    /// </summary>
    public string ClinicName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the name of the consulting doctor who created the record.
    /// </summary>
    public string DoctorName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the primary diagnosis name if established.
    /// </summary>
    public string? PrimaryDiagnosis { get; set; }

    /// <summary>
    /// Gets or sets the primary diagnosis ICD-10 code.
    /// </summary>
    public string? PrimaryDiagnosisCode { get; set; }

    /// <summary>
    /// Gets or sets the clinical outcome (ConfirmedDiagnosis, NoIllnessDetected, DiagnosisPending).
    /// </summary>
    public string ClinicalOutcome { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the display state of the record ("Finalized", "Finalized with Amendments").
    /// </summary>
    public string DisplayStatus { get; set; } = "Finalized";

    /// <summary>
    /// Gets or sets a value indicating whether post-finalization amendments exist for this record.
    /// </summary>
    public bool HasAmendments { get; set; }

    /// <summary>
    /// Gets or sets the number of prescribed medications.
    /// </summary>
    public int MedicationsCount { get; set; }

    /// <summary>
    /// Gets or sets the number of ordered tests.
    /// </summary>
    public int TestsCount { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether the caller is the original authoring doctor.
    /// </summary>
    public bool IsCreatedByCaller { get; set; }
}
