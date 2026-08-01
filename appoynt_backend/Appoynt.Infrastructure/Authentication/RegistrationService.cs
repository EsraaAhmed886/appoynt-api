/**
 * File Name      : RegistrationService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : IRegistrationService, IOtpService, UserManager, RoleManager,
 *                  ApplicationDbContext, RegistrationInputNormalizer,
 *                  RegistrationValidator
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Implements patient account registration using ASP.NET Core
 *                  Identity and the existing application persistence model.
 */

using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Authentication.Registration;
using Appoynt.Application.Features.Authentication.Registration.Contracts;
using Appoynt.Application.Features.Authentication.Registration.Validation;
using Appoynt.Application.Features.Authentication.Otp;
using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Persistence;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace Appoynt.Infrastructure.Authentication;

/// <summary>
/// Implements patient account registration using ASP.NET Core Identity.
/// </summary>
public sealed class RegistrationService : IRegistrationService
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly RoleManager<IdentityRole<Guid>> _roleManager;
    private readonly ApplicationDbContext _dbContext;
    private readonly IOtpService _otpService;

    /// <summary>
    /// Initializes a new instance of the <see cref="RegistrationService"/> class.
    /// </summary>
    /// <param name="userManager">The ASP.NET Core Identity user manager.</param>
    /// <param name="roleManager">The ASP.NET Core Identity role manager.</param>
    /// <param name="dbContext">The application database context.</param>
    /// <param name="otpService">The mobile OTP service.</param>
    public RegistrationService(
        UserManager<ApplicationUser> userManager,
        RoleManager<IdentityRole<Guid>> roleManager,
        ApplicationDbContext dbContext,
        IOtpService otpService)
    {
        _userManager = userManager;
        _roleManager = roleManager;
        _dbContext = dbContext;
        _otpService = otpService;
    }

    /// <inheritdoc />
    public async Task<RegistrationResult> RegisterAsync(
        RegisterRequest request,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(request);

        NormalizedRegisterRequest normalizedRequest =
            RegistrationInputNormalizer.Normalize(request);

        IReadOnlyList<AuthenticationError> validationErrors =
            RegistrationValidator.Validate(normalizedRequest);

        if (validationErrors.Count > 0)
        {
            return Failure(validationErrors);
        }
        else
        {
        }

        string normalizedEmail = _userManager.NormalizeEmail(normalizedRequest.Email);

        if (await _userManager.Users.AnyAsync(
                user => user.NormalizedEmail == normalizedEmail,
                cancellationToken))
        {
            return Failure(AuthenticationErrorCodes.EmailAlreadyRegistered, "Email");
        }
        else
        {
        }

        if (await _userManager.Users.AnyAsync(
                user => user.PhoneNumber == normalizedRequest.PhoneNumber,
                cancellationToken))
        {
            return Failure(
                AuthenticationErrorCodes.PhoneAlreadyRegistered,
                "PhoneNumber");
        }
        else
        {
        }

        if (!await _roleManager.RoleExistsAsync(RoleConstants.Patient))
        {
            return Failure(AuthenticationErrorCodes.RegistrationFailed);
        }
        else
        {
        }

        await using var transaction = await _dbContext.Database
            .BeginTransactionAsync(cancellationToken);

        try
        {
            var user = new ApplicationUser
            {
                FirstName = normalizedRequest.FirstName,
                LastName = normalizedRequest.LastName,
                UserName = normalizedRequest.Email,
                Email = normalizedRequest.Email,
                PhoneNumber = normalizedRequest.PhoneNumber,
                EmailConfirmed = false,
                PhoneNumberConfirmed = false,
                LockoutEnabled = true,
                IsActive = true
            };

            IdentityResult createUserResult = await _userManager.CreateAsync(
                user,
                normalizedRequest.Password);

            if (!createUserResult.Succeeded)
            {
                await transaction.RollbackAsync(cancellationToken);
                return Failure(AuthenticationErrorCodes.RegistrationFailed);
            }
            else
            {
            }

            IdentityResult addRoleResult = await _userManager.AddToRoleAsync(
                user,
                RoleConstants.Patient);

            if (!addRoleResult.Succeeded)
            {
                await transaction.RollbackAsync(cancellationToken);
                return Failure(AuthenticationErrorCodes.RegistrationFailed);
            }
            else
            {
            }

            _dbContext.Patients.Add(new Patient
            {
                Id = Guid.NewGuid(),
                UserId = user.Id,
                User = user
            });

            await _dbContext.SaveChangesAsync(cancellationToken);

            OtpResult otpResult = await _otpService.IssueAsync(
                user,
                OtpPurpose.PhoneConfirmation,
                cancellationToken);

            if (!otpResult.Succeeded)
            {
                await transaction.RollbackAsync(cancellationToken);
                return Failure(otpResult.Errors);
            }
            else
            {
            }

            await transaction.CommitAsync(cancellationToken);

            return new RegistrationResult
            {
                Succeeded = true,
                Response = new RegisterResponse
                {
                    UserId = user.Id,
                    ChallengeId = otpResult.Challenge!.ChallengeId
                }
            };
        }
        catch (DbUpdateException)
        {
            await transaction.RollbackAsync(cancellationToken);
            return Failure(AuthenticationErrorCodes.RegistrationFailed);
        }
    }

    /// <summary>
    /// Creates a failed registration result from the supplied errors.
    /// </summary>
    private static RegistrationResult Failure(
        IReadOnlyList<AuthenticationError> errors)
    {
        return new RegistrationResult { Errors = errors };
    }

    /// <summary>
    /// Creates a failed registration result for one error code.
    /// </summary>
    private static RegistrationResult Failure(string code, string? field = null)
    {
        return Failure([new AuthenticationError(code, field)]);
    }
}
