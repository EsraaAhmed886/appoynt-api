/**
 * File Name      : OtpChallengeResponse.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 25/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 25/07/2026
 * Description    : Defines the response returned after an OTP challenge is
 *                  successfully issued.
 */

namespace Appoynt.Application.Features.Authentication.Otp.Contracts;

/// <summary>
/// Represents an issued mobile OTP challenge.
/// </summary>
public sealed class OtpChallengeResponse
{
    /// <summary>
    /// Gets or initializes the identifier required to verify or resend the
    /// challenge.
    /// </summary>
    public Guid ChallengeId { get; init; }
}
