/**
 * File Name      : IPasswordRecoveryService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 27/07/2026
 * Version        : v1.0.0
 * Dependencies   : ForgotPasswordRequest, ResetPasswordRequest, OtpResult
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 27/07/2026
 * Description    : Defines the contract for password recovery operations.
 */

using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Application.Features.Authentication.PasswordRecovery.Contracts;

namespace Appoynt.Application.Features.Authentication.PasswordRecovery;

/// <summary>
/// Defines the application contract for password recovery operations.
/// </summary>
public interface IPasswordRecoveryService
{
    /// <summary>
    /// Initiates a password recovery request by issuing an OTP challenge.
    /// </summary>
    /// <param name="request">The forgot password request containing the user's identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An <see cref="OtpResult"/> indicating the outcome.</returns>
    Task<OtpResult> ForgotPasswordAsync(
        ForgotPasswordRequest request,
        CancellationToken cancellationToken = default);

    /// <summary>
    /// Resets the user's password using a valid reset token.
    /// </summary>
    /// <param name="request">The reset password request containing the token and new password.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A tuple indicating success and an optional list of errors.</returns>
    Task<(bool Succeeded, IReadOnlyList<AuthenticationError> Errors)> ResetPasswordAsync(
        ResetPasswordRequest request,
        CancellationToken cancellationToken = default);
}
