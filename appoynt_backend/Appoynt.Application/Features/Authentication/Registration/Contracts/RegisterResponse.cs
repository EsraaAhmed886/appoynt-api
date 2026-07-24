/**
 * File Name      : RegisterResponse.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Defines the successful patient-registration response.
 */

namespace Appoynt.Application.Features.Authentication.Registration.Contracts;

/// <summary>
/// Represents the result of a successful patient registration.
/// </summary>
/// <remarks>
/// This response intentionally does not contain an access token, verification
/// result, or sensitive account information. Mobile-phone verification belongs
/// to the future SMS OTP milestone.
/// </remarks>
public sealed class RegisterResponse
{
    /// <summary>
    /// Gets or initializes the identifier of the newly created user account.
    /// </summary>
    public Guid UserId { get; init; }
}
