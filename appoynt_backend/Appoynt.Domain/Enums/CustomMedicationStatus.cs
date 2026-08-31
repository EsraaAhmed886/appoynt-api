/**
 * File Name      : CustomMedicationStatus.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Defines the review and approval status for doctor-submitted custom medications.
 */

namespace Appoynt.Domain.Enums;

/// <summary>
/// Represents the approval status of a custom medication submitted by a doctor.
/// </summary>
public enum CustomMedicationStatus
{
    /// <summary>
    /// The medication is pending administrative review and catalog linkage.
    /// The requesting doctor can use it immediately without being blocked.
    /// </summary>
    PendingAdminApproval = 1,

    /// <summary>
    /// The medication has been reviewed, approved, and merged into the global medication catalog.
    /// </summary>
    Approved = 2,

    /// <summary>
    /// The custom medication was reviewed and rejected by the administrator.
    /// </summary>
    Rejected = 3
}
