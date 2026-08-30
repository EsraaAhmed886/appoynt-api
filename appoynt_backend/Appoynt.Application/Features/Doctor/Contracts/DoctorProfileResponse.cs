/**
 * File Name      : DoctorProfileResponse.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : System
 *                  System.Collections.Generic
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-30
 * Description    : Response model for doctor profile data.
 */

using System;
using System.Collections.Generic;
using Appoynt.Application.Common.Models;

namespace Appoynt.Application.Features.Doctor.Contracts;

/// <summary>
/// Represents the doctor profile response.
/// </summary>
public class DoctorProfileResponse
{
    /// <summary>
    /// Gets or sets the doctor identifier.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the associated user identifier.
    /// </summary>
    public Guid UserId { get; set; }

    /// <summary>
    /// Gets or sets the doctor's first name.
    /// </summary>
    public string FirstName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the doctor's last name.
    /// </summary>
    public string LastName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the doctor's name in Arabic.
    /// </summary>
    public string? NameAr { get; set; }

    /// <summary>
    /// Gets or sets the doctor's name in English.
    /// </summary>
    public string? NameEn { get; set; }

    /// <summary>
    /// Gets or sets the doctor's biography.
    /// </summary>
    public string? Bio { get; set; }

    /// <summary>
    /// Gets or sets the doctor's education.
    /// </summary>
    public string? Education { get; set; }

    /// <summary>
    /// Gets or sets the doctor's gender.
    /// </summary>
    public Appoynt.Domain.Enums.Gender? Gender { get; set; }

    /// <summary>
    /// Gets or sets the doctor's date of birth.
    /// </summary>
    public DateOnly? DateOfBirth { get; set; }

    /// <summary>
    /// Gets or sets the user's location address details.
    /// </summary>
    public AddressDto? Address { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether the doctor has a profile photo.
    /// </summary>
    public bool HasProfilePhoto { get; set; }

    /// <summary>
    /// Gets or sets the URL of the doctor's profile photo.
    /// </summary>
    public string? ProfilePhotoUrl { get; set; }

    /// <summary>
    /// Gets or sets the list of specializations.
    /// </summary>
    public List<SpecializationDto> Specializations { get; set; } = new();

    /// <summary>
    /// Gets or sets the list of phone numbers.
    /// </summary>
    public List<DoctorPhoneNumberDto> PhoneNumbers { get; set; } = new();
}
