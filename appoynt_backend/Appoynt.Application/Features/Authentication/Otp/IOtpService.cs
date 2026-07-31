/**
 * File Name      : IOtpService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 25/07/2026
 * Version        : v1.0.0
 * Dependencies   : ApplicationUser, OtpPurpose, OtpResult, VerifyOtpRequest
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 25/07/2026
 * Description    : Defines the application contract for mobile OTP issuance
 *                  and verification.
 */

using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.Authentication.Otp;

/// <summary>Defines the application contract for mobile OTP operations.</summary>
public interface IOtpService
{
    /// <summary>Issues a new OTP challenge for the specified user and purpose.</summary>
    Task<OtpResult> IssueAsync(
        ApplicationUser user,
        OtpPurpose purpose,
        CancellationToken cancellationToken = default);

    /// <summary>Verifies a previously issued OTP challenge.</summary>
    Task<OtpResult> VerifyAsync(
        VerifyOtpRequest request,
        CancellationToken cancellationToken = default);

    /// <summary>Replaces an expired OTP challenge with a new OTP.</summary>
    Task<OtpResult> ResendAsync(
        ResendOtpRequest request,
        CancellationToken cancellationToken = default);
}
