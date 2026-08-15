/**
 * File Name      : DoctorPhoneNumberDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Data transfer object representing a doctor's additional contact phone number.
 */

namespace Appoynt.Application.Features.UserManagement.Contracts;

/// <summary>
/// Represents an additional contact phone number for a doctor.
/// </summary>
public sealed class DoctorPhoneNumberDto
{
    /// <summary>
    /// Gets or initializes the phone number string.
    /// </summary>
    public string? PhoneNumber { get; init; }

    /// <summary>
    /// Gets or initializes the descriptive label (e.g., 'Clinic', 'Emergency', 'Secretary').
    /// </summary>
    public string? Label { get; init; }
}
