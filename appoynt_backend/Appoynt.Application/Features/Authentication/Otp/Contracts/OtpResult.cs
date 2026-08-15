/**
 * File Name      : OtpResult.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 25/07/2026
 * Version        : v1.0.0
 * Dependencies   : AuthenticationError, OtpChallengeResponse,
 *                  OtpVerificationResponse
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 25/07/2026
 * Description    : Represents the outcome of an OTP issue or verification
 *                  operation.
 */

using Appoynt.Application.Common.Models;

namespace Appoynt.Application.Features.Authentication.Otp.Contracts;

/// <summary>
/// Represents either a successful OTP outcome or its stable error code.
/// </summary>
public sealed class OtpResult
{
    /// <summary>Gets a value indicating whether the operation succeeded.</summary>
    public bool Succeeded { get; init; }

    /// <summary>Gets the issued challenge when an OTP was sent.</summary>
    public OtpChallengeResponse? Challenge { get; init; }

    /// <summary>Gets the verification result when an OTP was verified.</summary>
    public OtpVerificationResponse? Verification { get; init; }

    /// <summary>Gets the operation errors when it failed.</summary>
    public IReadOnlyList<AuthenticationError> Errors { get; init; } = [];
}
