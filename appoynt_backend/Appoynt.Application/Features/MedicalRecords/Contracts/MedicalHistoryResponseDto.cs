/**
 * File Name      : MedicalHistoryResponseDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : MedicalHistoryItemDto, PatientAllergyDto
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Data transfer object for the full Medical History tab view with header metadata and filters.
 */

using System;
using System.Collections.Generic;

namespace Appoynt.Application.Features.MedicalRecords.Contracts;

/// <summary>
/// Response payload for the patient's medical history tab.
/// </summary>
public sealed class MedicalHistoryResponseDto
{
    /// <summary>
    /// Gets or sets the patient identifier.
    /// </summary>
    public Guid PatientId { get; set; }

    /// <summary>
    /// Gets or sets the full patient display name.
    /// </summary>
    public string PatientName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the Patient Identifier (PID).
    /// </summary>
    public string PID { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the total count of finalized records the doctor is authorized to view.
    /// </summary>
    public int TotalAuthorizedRecordsCount { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether the patient's full medical history sharing is enabled.
    /// </summary>
    public bool IsSharingEnabled { get; set; }

    /// <summary>
    /// Gets or sets the identifier of the latest authorized medical record for quick viewing.
    /// </summary>
    public Guid? LatestMedicalRecordId { get; set; }

    /// <summary>
    /// Gets or sets the persistent allergy alerts for the header.
    /// </summary>
    public IReadOnlyList<PatientAllergyDto> Allergies { get; set; } = [];

    /// <summary>
    /// Gets or sets the authorized finalized medical history items.
    /// </summary>
    public IReadOnlyList<MedicalHistoryItemDto> Records { get; set; } = [];
}
