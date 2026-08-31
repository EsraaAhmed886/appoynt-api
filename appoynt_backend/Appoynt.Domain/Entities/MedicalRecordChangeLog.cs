/**
 * File Name      : MedicalRecordChangeLog.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, MedicalRecord, ApplicationUser
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Represents an immutable audit change log entry tracking post-finalization edits to a medical record.
 */

using System;
using Appoynt.Domain.Common;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents an immutable historical audit record of modifications made to a finalized medical record.
/// </summary>
public class MedicalRecordChangeLog : BaseEntity
{
    #region Business Properties

    /// <summary>
    /// Gets or sets the name of the clinical field or section that was modified.
    /// </summary>
    public string Field { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the previous state or serialized value prior to the edit.
    /// </summary>
    public string? OldValue { get; set; }

    /// <summary>
    /// Gets or sets the newly updated state or serialized value after the edit.
    /// </summary>
    public string? NewValue { get; set; }

    /// <summary>
    /// Gets or sets the doctor's clinical justification or mandatory reason for the modification.
    /// </summary>
    public string Reason { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the UTC timestamp when the amendment was submitted.
    /// </summary>
    public DateTime ChangedAtUtc { get; set; }

    #endregion

    #region Relationship Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the modified medical record.
    /// </summary>
    public Guid MedicalRecordId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the modified medical record.
    /// </summary>
    public required MedicalRecord MedicalRecord { get; set; }

    /// <summary>
    /// Gets or sets the foreign key referencing the user/doctor who submitted the amendment.
    /// </summary>
    public Guid ChangedById { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the amending user.
    /// </summary>
    public required ApplicationUser ChangedBy { get; set; }

    #endregion
}
