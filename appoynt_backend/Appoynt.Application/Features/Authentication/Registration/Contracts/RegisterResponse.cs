/**
 * File Name      : RegisterResponse.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Defines the successful response contract for patient
 *                  registration and its phone-confirmation challenge.
 */

namespace Appoynt.Application.Features.Authentication.Registration.Contracts;

/// <summary>
/// Represents the result of successfully creating a patient account.
/// </summary>
public sealed class RegisterResponse
{
    /// <summary>
    /// Gets or initializes the identifier of the newly created user account.
    /// </summary>
    public Guid UserId { get; init; }

    /// <summary>
    /// Gets or initializes the phone-confirmation OTP challenge identifier.
    /// </summary>
    public Guid ChallengeId { get; init; }
}
