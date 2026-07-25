/**
 * File Name      : OtpVerificationResponse.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 25/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 25/07/2026
 * Description    : Defines the successful result of verifying an OTP challenge.
 */

namespace Appoynt.Application.Features.Authentication.Otp.Contracts;

/// <summary>
/// Represents the successful result of verifying a mobile OTP challenge.
/// </summary>
public sealed class OtpVerificationResponse
{
    /// <summary>
    /// Gets or initializes the JWT access token issued after Login OTP
    /// verification. It is null for phone-confirmation challenges.
    /// </summary>
    public string? AccessToken { get; init; }
}
