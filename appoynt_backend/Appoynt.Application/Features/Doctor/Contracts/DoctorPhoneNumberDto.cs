/**
 * File Name      : DoctorPhoneNumberDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : System
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-23
 * Description    : Data transfer object for phone numbers in doctor profile.
 */

using System;

namespace Appoynt.Application.Features.Doctor.Contracts;

/// <summary>
/// Represents a doctor's phone number in the profile response.
/// </summary>
public class DoctorPhoneNumberDto
{
    /// <summary>
    /// Gets or sets the phone number identifier.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the phone number string.
    /// </summary>
    public string PhoneNumber { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the label for the phone number (e.g., Clinic, Personal).
    /// </summary>
    public string? Label { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether the phone number is verified.
    /// </summary>
    public bool IsVerified { get; set; }
}
