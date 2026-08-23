/**
 * File Name      : AddDoctorPhoneNumberRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : System
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-23
 * Description    : Request model for adding a doctor phone number.
 */

using System;

namespace Appoynt.Application.Features.Doctor.Contracts;

/// <summary>
/// Represents the request to add a phone number to a doctor's profile.
/// </summary>
public class AddDoctorPhoneNumberRequest
{
    /// <summary>
    /// Gets or sets the phone number.
    /// </summary>
    public string PhoneNumber { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the label for the phone number (e.g., Clinic, Personal).
    /// </summary>
    public string? Label { get; set; }
}
