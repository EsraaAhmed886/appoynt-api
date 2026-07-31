/**
 * File Name      : PasswordRecoveryService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 27/07/2026
 * Version        : v1.0.0
 * Dependencies   : IPasswordRecoveryService, UserManager, IOtpService
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 27/07/2026
 * Description    : Implements password recovery operations, including OTP issuance
 *                  and password resetting.
 */

using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Authentication.Otp;
using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Application.Features.Authentication.PasswordRecovery;
using Appoynt.Application.Features.Authentication.PasswordRecovery.Contracts;
using Appoynt.Application.Features.Authentication.PasswordRecovery.Validation;
using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace Appoynt.Infrastructure.Authentication;

/// <summary>
/// Implements password recovery functionality.
/// </summary>
public sealed class PasswordRecoveryService : IPasswordRecoveryService
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly IOtpService _otpService;

    /// <summary>
    /// Initializes a new instance of the <see cref="PasswordRecoveryService"/> class.
    /// </summary>
    public PasswordRecoveryService(
        UserManager<ApplicationUser> userManager,
        IOtpService otpService)
    {
        _userManager = userManager;
        _otpService = otpService;
    }

    /// <inheritdoc />
    public async Task<OtpResult> ForgotPasswordAsync(
        ForgotPasswordRequest request,
        CancellationToken cancellationToken = default)
    {
        IReadOnlyList<AuthenticationError> validationErrors = ForgotPasswordRequestValidator.Validate(request);
        if (validationErrors.Count > 0)
        {
            return new OtpResult { Errors = validationErrors };
        }

        string identifier = request.Identifier.Trim();

        ApplicationUser? user;
        if (identifier.Contains('@', StringComparison.Ordinal))
        {
            user = await _userManager.FindByEmailAsync(identifier);
        }
        else
        {
            // Phone number
            user = await _userManager.Users.SingleOrDefaultAsync(u => u.PhoneNumber == identifier, cancellationToken);
        }

        if (user is null || !user.IsActive)
        {
            // Return generic error to prevent user enumeration
            return new OtpResult
            {
                Errors = [new AuthenticationError(AuthenticationErrorCodes.PasswordRecoveryRequestInvalid)]
            };
        }

        return await _otpService.IssueAsync(user, OtpPurpose.PasswordReset, cancellationToken);
    }

    /// <inheritdoc />
    public async Task<(bool Succeeded, IReadOnlyList<AuthenticationError> Errors)> ResetPasswordAsync(
        ResetPasswordRequest request,
        CancellationToken cancellationToken = default)
    {
        string identifier = request.Identifier.Trim();

        ApplicationUser? user;
        if (identifier.Contains('@', StringComparison.Ordinal))
        {
            user = await _userManager.FindByEmailAsync(identifier);
        }
        else
        {
            user = await _userManager.Users.SingleOrDefaultAsync(u => u.PhoneNumber == identifier, cancellationToken);
        }

        if (user is null || !user.IsActive)
        {
            // Fail fast, generic error
            return (false, [new AuthenticationError(AuthenticationErrorCodes.PasswordRecoveryRequestInvalid)]);
        }

        IReadOnlyList<AuthenticationError> validationErrors = ResetPasswordRequestValidator.Validate(request, user);
        if (validationErrors.Count > 0)
        {
            return (false, validationErrors);
        }

        IdentityResult result = await _userManager.ResetPasswordAsync(user, request.ResetToken, request.NewPassword);

        if (result.Succeeded)
        {
            return (true, []);
        }

        var errors = result.Errors
            .Select(e => new AuthenticationError(e.Code))
            .ToList();

        return (false, errors);
    }
}
