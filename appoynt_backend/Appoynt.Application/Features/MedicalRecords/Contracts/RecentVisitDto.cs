/**
 * File Name      : RecentVisitDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Data transfer object representing a recent patient visit snapshot.
 */

using System;

namespace Appoynt.Application.Features.MedicalRecords.Contracts;

/// <summary>
/// Represents a concise summary of a prior patient consultation visit.
/// </summary>
public sealed class RecentVisitDto
{
    /// <summary>
    /// Gets or sets the medical record identifier (null if no finalized record exists).
    /// </summary>
    public Guid? MedicalRecordId { get; set; }

    /// <summary>
    /// Gets or sets the appointment identifier.
    /// </summary>
    public Guid AppointmentId { get; set; }

    /// <summary>
    /// Gets or sets the clinical visit date.
    /// </summary>
    public DateOnly VisitDate { get; set; }

    /// <summary>
    /// Gets or sets the doctor display name.
    /// </summary>
    public string DoctorName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the clinic name.
    /// </summary>
    public string ClinicName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the primary diagnosis name if established.
    /// </summary>
    public string? PrimaryDiagnosis { get; set; }

    /// <summary>
    /// Gets or sets the medical record status string (e.g., Finalized, Draft).
    /// </summary>
    public string Status { get; set; } = string.Empty;
}
