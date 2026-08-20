/**
 * File Name      : Doctor.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v2.0.0
 * Dependencies   : BaseEntity, ApplicationUser, Receptionist,
 *                  DoctorPhoneNumber, DoctorSpecialization
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Represents a doctor within the application, including
 *                  profile display names, biography, education, contact
 *                  phone numbers, and medical specializations.
 */

using System.Collections.Generic;
using Appoynt.Domain.Common;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a doctor in the system.
/// </summary>
public class Doctor : BaseEntity
{
    #region Business Properties

    /// <summary>
    /// Gets or sets the doctor's display name in Arabic.
    /// </summary>
    public string? NameAr { get; set; }

    /// <summary>
    /// Gets or sets the doctor's display name in English.
    /// </summary>
    public string? NameEn { get; set; }

    /// <summary>
    /// Gets or sets the doctor's professional biography.
    /// </summary>
    public string? Bio { get; set; }

    /// <summary>
    /// Gets or sets the doctor's education and qualifications summary.
    /// </summary>
    public string? Education { get; set; }

    #endregion

    #region Relationship Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the associated application user.
    /// </summary>
    public Guid UserId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the associated application user.
    /// </summary>
    public required ApplicationUser User { get; set; }

    /// <summary>
    /// Gets or sets the collection of receptionists assigned to this doctor.
    /// </summary>
    public ICollection<Receptionist> Receptionists { get; set; } = [];

    /// <summary>
    /// Gets or sets the collection of additional phone numbers for this doctor.
    /// </summary>
    public ICollection<DoctorPhoneNumber> PhoneNumbers { get; set; } = [];

    /// <summary>
    /// Gets or sets the collection of specializations linked to this doctor.
    /// </summary>
    public ICollection<DoctorSpecialization> DoctorSpecializations { get; set; } = [];

    #endregion
}