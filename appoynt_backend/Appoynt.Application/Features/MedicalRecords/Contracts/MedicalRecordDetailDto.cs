/**
 * File Name      : MedicalRecordDetailDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : MedicalRecordDiagnosisDto, MedicalRecordMedicationDto,
 *                  MedicalRecordTestRequestDto, MedicalRecordAttachmentDto, MedicalRecordChangeLogDto,
 *                  MedicalRecordStatus, ClinicalOutcome
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Data transfer object representing the complete detail payload of a medical record.
 */

using System;
using System.Collections.Generic;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.MedicalRecords.Contracts;

/// <summary>
/// Full detail payload of a medical record for editing a draft or viewing a finalized record.
/// </summary>
public sealed class MedicalRecordDetailDto
{
    #region Metadata

    /// <summary>
    /// Gets or sets the medical record identifier.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the associated appointment identifier.
    /// </summary>
    public Guid AppointmentId { get; set; }

    /// <summary>
    /// Gets or sets the patient identifier.
    /// </summary>
    public Guid PatientId { get; set; }

    /// <summary>
    /// Gets or sets the patient's full name.
    /// </summary>
    public string PatientName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the patient identifier (PID).
    /// </summary>
    public string PID { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the authoring doctor identifier.
    /// </summary>
    public Guid DoctorId { get; set; }

    /// <summary>
    /// Gets or sets the authoring doctor's display name.
    /// </summary>
    public string DoctorName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the clinic identifier.
    /// </summary>
    public Guid ClinicId { get; set; }

    /// <summary>
    /// Gets or sets the clinic name.
    /// </summary>
    public string ClinicName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the lifecycle status of the record.
    /// </summary>
    public MedicalRecordStatus Status { get; set; }

    /// <summary>
    /// Gets or sets the human-readable display status (e.g., "Draft", "Finalized", "Finalized with Amendments").
    /// </summary>
    public string DisplayStatus { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the clinical visit date.
    /// </summary>
    public DateOnly VisitDate { get; set; }

    /// <summary>
    /// Gets or sets the UTC creation timestamp.
    /// </summary>
    public DateTime CreatedAtUtc { get; set; }

    /// <summary>
    /// Gets or sets the UTC last updated timestamp.
    /// </summary>
    public DateTime UpdatedAtUtc { get; set; }

    /// <summary>
    /// Gets or sets the UTC finalization timestamp if finalized.
    /// </summary>
    public DateTime? FinalizedAtUtc { get; set; }

    /// <summary>
    /// Gets or sets the name of the user who signed the finalized record.
    /// </summary>
    public string? SignedByName { get; set; }

    /// <summary>
    /// Gets or sets the optimistic concurrency token (base64 formatted).
    /// </summary>
    public string Version { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets a value indicating whether the current caller can edit or amend this record.
    /// </summary>
    public bool IsEditableByCaller { get; set; }

    #endregion

    #region Clinical Details

    /// <summary>
    /// Gets or sets the clinical outcome classification.
    /// </summary>
    public ClinicalOutcome? ClinicalOutcome { get; set; }

    /// <summary>
    /// Gets or sets clinical notes, observations, and recommendations.
    /// </summary>
    public string? ClinicalNotes { get; set; }

    /// <summary>
    /// Gets or sets the diagnoses recorded for this consultation.
    /// </summary>
    public IReadOnlyList<MedicalRecordDiagnosisDto> Diagnoses { get; set; } = [];

    /// <summary>
    /// Gets or sets the medications prescribed during this consultation.
    /// </summary>
    public IReadOnlyList<MedicalRecordMedicationDto> Medications { get; set; } = [];

    /// <summary>
    /// Gets or sets the diagnostic tests ordered during this consultation.
    /// </summary>
    public IReadOnlyList<MedicalRecordTestRequestDto> TestRequests { get; set; } = [];

    /// <summary>
    /// Gets or sets the attachments linked to this consultation.
    /// </summary>
    public IReadOnlyList<MedicalRecordAttachmentDto> Attachments { get; set; } = [];

    /// <summary>
    /// Gets or sets the historical change logs of post-finalization edits.
    /// </summary>
    public IReadOnlyList<MedicalRecordChangeLogDto> ChangeLogs { get; set; } = [];

    #endregion
}
