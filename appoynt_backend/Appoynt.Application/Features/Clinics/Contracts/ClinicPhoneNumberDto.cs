/**
 * File Name      : ClinicPhoneNumberDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Data transfer object representing a clinic contact phone number and its label.
 */

namespace Appoynt.Application.Features.Clinics.Contracts;

/// <summary>
/// Represents a clinic's contact phone number data transfer object.
/// </summary>
public sealed class ClinicPhoneNumberDto
{
    /// <summary>
    /// Gets or sets the phone number.
    /// </summary>
    public string? PhoneNumber { get; set; }

    /// <summary>
    /// Gets or sets the descriptive label for the phone number (e.g., 'Main', 'Emergency', 'Reception').
    /// </summary>
    public string? Label { get; set; }
}

