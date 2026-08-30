/**
 * File Name      : UpdateDoctorProfileRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : System
 *                  System.Collections.Generic
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-30
 * Description    : Request model for updating a doctor's profile.
 */

using System;
using System.Collections.Generic;
using Appoynt.Application.Common.Models;

namespace Appoynt.Application.Features.Doctor.Contracts;

/// <summary>
/// Represents the request to update a doctor's profile.
/// </summary>
public class UpdateDoctorProfileRequest
{
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
    /// Gets or sets the doctor's birth date.
    /// </summary>
    public DateOnly? BirthDate { get; set; }

    /// <summary>
    /// Gets or sets the user's location address details.
    /// </summary>
    public UpdateAddressDto? Address { get; set; }

    /// <summary>
    /// Gets or sets the list of specialization identifiers.
    /// </summary>
    public List<Guid> SpecializationIds { get; set; } = new();
}
