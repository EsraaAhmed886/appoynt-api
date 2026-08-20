/**
 * File Name      : Receptionist.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, ApplicationUser, Doctor
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Represents a receptionist within the application.
 */

using Appoynt.Domain.Common;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a receptionist in the system.
/// </summary>
public class Receptionist : BaseEntity
{
    #region Properties

    // Foreign key referencing the associated application user.
    public Guid UserId { get; set; }

    // Foreign key referencing the assigned doctor.
    public Guid DoctorId { get; set; }

    // Navigation property to the associated application user.
    public required ApplicationUser User { get; set; }

    // Navigation property to the assigned doctor.
    public required Doctor Doctor { get; set; }

    #endregion
}