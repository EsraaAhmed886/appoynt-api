/**
 * File Name      : VerifyOtpRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 25/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 25/07/2026
 * Description    : Defines the raw input contract for verifying a mobile OTP
 *                  challenge.
 */

namespace Appoynt.Application.Features.Authentication.Otp.Contracts;

/// <summary>
/// Represents the raw input submitted to verify a mobile OTP challenge.
/// </summary>
public sealed class VerifyOtpRequest
{
    /// <summary>
    /// Gets or initializes the challenge identifier returned when the OTP was
    /// issued.
    /// </summary>
    public Guid ChallengeId { get; init; }

    /// <summary>
    /// Gets or initializes the submitted six-digit OTP code.
    /// </summary>
    public string? Code { get; init; }
}
