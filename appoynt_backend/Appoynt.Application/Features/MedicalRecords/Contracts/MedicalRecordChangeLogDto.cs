/**
 * File Name      : MedicalRecordChangeLogDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Data transfer object representing an audit change log entry for post-finalization edits.
 */

using System;

namespace Appoynt.Application.Features.MedicalRecords.Contracts;

/// <summary>
/// Represents an immutable audit change entry of an edit made after finalization.
/// </summary>
public sealed class MedicalRecordChangeLogDto
{
    /// <summary>
    /// Gets or sets the change log identifier.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the modified field or section name.
    /// </summary>
    public string Field { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the previous serialized value prior to the edit.
    /// </summary>
    public string? OldValue { get; set; }

    /// <summary>
    /// Gets or sets the new serialized value after the edit.
    /// </summary>
    public string? NewValue { get; set; }

    /// <summary>
    /// Gets or sets the doctor's clinical justification or mandatory reason.
    /// </summary>
    public string Reason { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the name of the doctor who made the amendment.
    /// </summary>
    public string ChangedByName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the UTC timestamp of the amendment.
    /// </summary>
    public DateTime ChangedAtUtc { get; set; }
}
