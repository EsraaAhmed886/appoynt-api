/**
 * File Name      : LoginService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : ILoginService, IOtpService, UserManager,
 *                  LoginInputNormalizer, LoginValidator
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Implements account login using ASP.NET Core Identity and
 *                  the existing JWT token infrastructure.
 */

using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Authentication.Login;
using Appoynt.Application.Features.Authentication.Login.Contracts;
using Appoynt.Application.Features.Authentication.Login.Validation;
using Appoynt.Application.Features.Authentication.Otp;
using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace Appoynt.Infrastructure.Authentication;

/// <summary>
/// Implements account login using ASP.NET Core Identity.
/// </summary>
public sealed class LoginService : ILoginService
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly IOtpService _otpService;

    /// <summary>
    /// Initializes a new instance of the <see cref="LoginService"/> class.
    /// </summary>
    /// <param name="userManager">The ASP.NET Core Identity user manager.</param>
    /// <param name="otpService">The mobile OTP service.</param>
    public LoginService(
        UserManager<ApplicationUser> userManager,
        IOtpService otpService)
    {
        _userManager = userManager;
        _otpService = otpService;
    }

    /// <inheritdoc />
    public async Task<LoginResult> LoginAsync(
        LoginRequest request,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(request);

        NormalizedLoginRequest normalizedRequest =
            LoginInputNormalizer.Normalize(request);

        if (!LoginValidator.IsValid(normalizedRequest))
        {
            return Failure();
        }

        ApplicationUser? user = normalizedRequest.IsEmailIdentifier
            ? await FindByEmailAsync(normalizedRequest.Identifier, cancellationToken)
            : await _userManager.Users.SingleOrDefaultAsync(
                applicationUser =>
                    applicationUser.PhoneNumber == normalizedRequest.PhoneNumber,
                cancellationToken);

        if (user is null || !user.IsActive || !user.PhoneNumberConfirmed)
        {
            return Failure();
        }

        if (!await _userManager.CheckPasswordAsync(user, normalizedRequest.Password))
        {
            return Failure();
        }

        OtpResult otpResult = await _otpService.IssueAsync(
            user,
            OtpPurpose.Login,
            cancellationToken);

        if (!otpResult.Succeeded)
        {
            return new LoginResult { Errors = otpResult.Errors };
        }

        return new LoginResult
        {
            Succeeded = true,
            Response = new LoginResponse
            {
                ChallengeId = otpResult.Challenge!.ChallengeId
            }
        };
    }

    /// <summary>
    /// Finds an account by the Identity-normalized email address.
    /// </summary>
    private async Task<ApplicationUser?> FindByEmailAsync(
        string email,
        CancellationToken cancellationToken)
    {
        string? normalizedEmail = _userManager.NormalizeEmail(email);

        return await _userManager.Users.SingleOrDefaultAsync(
            user => user.NormalizedEmail == normalizedEmail,
            cancellationToken);
    }

    /// <summary>
    /// Creates the generic failure result required to prevent account
    /// enumeration.
    /// </summary>
    private static LoginResult Failure()
    {
        return new LoginResult
        {
            Errors = [new AuthenticationError(AuthenticationErrorCodes.InvalidCredentials)]
        };
    }
}
