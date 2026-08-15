/**
 * File Name      : ResendOtpRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 27/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 27/07/2026
 * Description    : Defines the request contract for replacing an expired OTP
 *                  challenge with a new OTP.
 */

namespace Appoynt.Application.Features.Authentication.Otp.Contracts;

/// <summary>
/// Represents a request to resend an expired mobile OTP challenge.
/// </summary>
public sealed class ResendOtpRequest
{
    /// <summary>
    /// Gets or initializes the expired challenge identifier to replace.
    /// </summary>
    public Guid ChallengeId { get; init; }
}
