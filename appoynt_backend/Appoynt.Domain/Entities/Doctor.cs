/**
 * File Name      : Doctor.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, ApplicationUser, Receptionist
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Represents a doctor within the application.
 */

using Appoynt.Domain.Common;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a doctor in the system.
/// </summary>
public class Doctor : BaseEntity
{
    #region Properties

    // Foreign key referencing the associated application user.
    public Guid UserId { get; set; }

    // Navigation property to the associated application user.
    public required ApplicationUser User { get; set; }

    // Collection of receptionists assigned to this doctor.
    public ICollection<Receptionist> Receptionists { get; set; } = [];

    #endregion
}