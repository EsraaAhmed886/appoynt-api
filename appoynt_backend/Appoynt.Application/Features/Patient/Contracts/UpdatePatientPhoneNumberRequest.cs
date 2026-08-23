/**
 * File Name      : UpdatePatientPhoneNumberRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-23
 * Description    : Data transfer object for replacing the patient's primary phone number.
 */

namespace Appoynt.Application.Features.Patient.Contracts;

/// <summary>
/// Represents a request to replace the patient's primary phone number.
/// </summary>
public record UpdatePatientPhoneNumberRequest
{
    /// <summary>
    /// Gets the new phone number.
    /// </summary>
    public string PhoneNumber { get; init; } = string.Empty;
}
