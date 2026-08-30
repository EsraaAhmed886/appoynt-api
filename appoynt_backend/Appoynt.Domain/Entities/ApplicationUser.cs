/**
 * File Name      : ApplicationUser.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.1.0
 * Dependencies   : IdentityUser<Guid>, Gender, Governorate, City, Doctor, Patient,
 *                  Admin, Receptionist, RefreshToken
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-30
 * Description    : Represents an application user with business information,
 *                  location associations, profile picture path, audit information,
 *                  and navigation properties.
 */

using Appoynt.Domain.Enums;
using Microsoft.AspNetCore.Identity;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents an authenticated application user.
/// </summary>
public class ApplicationUser : IdentityUser<Guid>
{
    #region Business Properties

    // User's first name.
    public required string FirstName { get; set; }

    // User's last name.
    public required string LastName { get; set; }

    // User's gender.
    public Gender? Gender { get; set; }

    // User's date of birth.
    public DateOnly? DateOfBirth { get; set; }

    /// <summary>
    /// Gets or sets the foreign key referencing the associated governorate.
    /// </summary>
    public Guid? GovernorateId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the associated governorate.
    /// </summary>
    public Governorate? Governorate { get; set; }

    /// <summary>
    /// Gets or sets the foreign key referencing the associated city.
    /// </summary>
    public Guid? CityId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the associated city.
    /// </summary>
    public City? City { get; set; }

    // Indicates whether the user account is active.
    public bool IsActive { get; set; } = true;

    /// <summary>
    /// Gets or sets the relative storage path for the user's profile picture.
    /// Example: profiles/{guid}/profile.jpg.
    /// </summary>
    public string? ProfilePicturePath { get; set; }

    #endregion

    #region Audit Properties

    // Date and time when the user was created.
    public DateTime CreatedAt { get; set; }

    // Identifier of the user who created this record.
    public Guid? CreatedById { get; set; }

    // Navigation property to the creator.
    public ApplicationUser? CreatedBy { get; set; }

    // Date and time of the last update.
    public DateTime UpdatedAt { get; set; }

    // Identifier of the user who last updated this record.
    public Guid? UpdatedById { get; set; }

    // Navigation property to the last updater.
    public ApplicationUser? UpdatedBy { get; set; }

    // Date and time when the record was soft deleted.
    public DateTime? DeletedAt { get; set; }

    // Identifier of the user who performed the soft delete.
    public Guid? DeletedById { get; set; }

    // Navigation property to the user who performed the soft delete.
    public ApplicationUser? DeletedBy { get; set; }

    #endregion

    #region Navigation Properties

    // Navigation property to the associated doctor profile.
    public Doctor? Doctor { get; set; }

    // Navigation property to the associated patient profile.
    public Patient? Patient { get; set; }

    // Navigation property to the associated administrator profile.
    public Admin? Admin { get; set; }

    // Navigation property to the associated receptionist profile.
    public Receptionist? Receptionist { get; set; }

    // Collection of refresh tokens issued for this user.
    public ICollection<RefreshToken> RefreshTokens { get; set; } = [];

    #endregion
}