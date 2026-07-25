/**
 * File Name      : LoginResponse.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Defines the response returned after a Login OTP challenge
 *                  is successfully issued.
 */

namespace Appoynt.Application.Features.Authentication.Login.Contracts;

/// <summary>
/// Represents the result of successfully starting account authentication.
/// </summary>
public sealed class LoginResponse
{
    /// <summary>
    /// Gets or initializes the Login OTP challenge identifier.
    /// </summary>
    public Guid ChallengeId { get; init; }
}
