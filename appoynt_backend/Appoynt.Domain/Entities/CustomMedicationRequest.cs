/**
 * File Name      : CustomMedicationRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, Doctor, Medication, CustomMedicationStatus
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Represents a custom medication submitted by a doctor for private immediate prescribing
 *                  and passive administrative catalog approval.
 */

using System;
using Appoynt.Domain.Common;
using Appoynt.Domain.Enums;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a custom unlisted medication requested by a physician.
/// </summary>
public class CustomMedicationRequest : BaseEntity
{
    #region Business Properties

    /// <summary>
    /// Gets or sets the custom medication name entered by the prescribing doctor.
    /// </summary>
    public string Name { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the current administrative review status.
    /// </summary>
    public CustomMedicationStatus Status { get; set; } = CustomMedicationStatus.PendingAdminApproval;

    /// <summary>
    /// Gets or sets optional administrative notes or rejection reason if the request was declined.
    /// </summary>
    public string? AdminNotes { get; set; }

    /// <summary>
    /// Gets or sets optional notes entered by the requesting doctor regarding dosage or active ingredients.
    /// </summary>
    public string? DoctorNotes { get; set; }

    #endregion

    #region Relationship Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the doctor who created and requested this custom medication.
    /// </summary>
    public Guid DoctorId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the requesting doctor.
    /// </summary>
    public required Doctor Doctor { get; set; }

    /// <summary>
    /// Gets or sets the foreign key referencing the merged global Medication catalog entry once approved.
    /// </summary>
    public Guid? LinkedMedicationCatalogId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the linked global Medication catalog entry.
    /// </summary>
    public Medication? LinkedMedicationCatalog { get; set; }

    #endregion
}
