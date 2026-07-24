/**
 * File Name      : Admin.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, ApplicationUser
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Represents an administrator within the application.
 */

using Appoynt.Domain.Common;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents an administrator in the system.
/// </summary>
public class Admin : BaseEntity
{
    // Foreign key referencing the associated application user.
    public Guid UserId { get; set; }

    // Navigation property to the associated application user.
    public required ApplicationUser User { get; set; }
}