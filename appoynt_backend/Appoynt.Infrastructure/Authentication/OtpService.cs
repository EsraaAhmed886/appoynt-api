/**
 * File Name      : OtpService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 25/07/2026
 * Version        : v1.0.0
 * Dependencies   : IOtpService, ISmsSender, ApplicationDbContext,
 *                  UserManager, PasswordHasher
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 25/07/2026
 * Description    : Implements mobile OTP issuance and verification for phone
 *                  confirmation and Login verification.
 */

using System.Security.Cryptography;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Application.Common.Models;
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
/// Implements mobile OTP issuance and verification.
/// </summary>
public sealed class OtpService : IOtpService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly ISmsSender _smsSender;
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly PasswordHasher<OtpChallenge> _passwordHasher = new();

    /// <summary>Initializes a new instance of the <see cref="OtpService"/> class.</summary>
    public OtpService(
        ApplicationDbContext dbContext,
        ISmsSender smsSender,
        UserManager<ApplicationUser> userManager)
    {
        _dbContext = dbContext;
        _smsSender = smsSender;
        _userManager = userManager;
    }

    /// <inheritdoc />
    public async Task<OtpResult> IssueAsync(
        ApplicationUser user,
        OtpPurpose purpose,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(user);

        string phoneNumber = user.PhoneNumber
            ?? throw new InvalidOperationException("OTP requires a phone number.");

        string code = RandomNumberGenerator.GetInt32(0, 1_000_000).ToString("D6");

        if (!await _smsSender.SendOtpAsync(phoneNumber, code, cancellationToken))
        {
            return Failure(AuthenticationErrorCodes.OtpDeliveryUnavailable);
        }
        else
        {
        }

        DateTime utcNow = DateTime.UtcNow;
        List<OtpChallenge> activeChallenges = await _dbContext.OtpChallenges
            .Where(challenge => challenge.UserId == user.Id &&
                                challenge.Purpose == purpose &&
                                challenge.ConsumedAt == null &&
                                challenge.InvalidatedAt == null)
            .ToListAsync(cancellationToken);

        foreach (OtpChallenge activeChallenge in activeChallenges)
        {
            activeChallenge.InvalidatedAt = utcNow;
        }

        var challenge = new OtpChallenge
        {
            Id = Guid.NewGuid(),
            UserId = user.Id,
            User = user,
            Purpose = purpose,
            CodeHash = string.Empty,
            ExpiresAt = utcNow.AddSeconds(UserConstants.OtpExpirySeconds),
            SentAt = utcNow
        };

        challenge.CodeHash = _passwordHasher.HashPassword(challenge, code);
        _dbContext.OtpChallenges.Add(challenge);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return new OtpResult
        {
            Succeeded = true,
            Challenge = new OtpChallengeResponse { ChallengeId = challenge.Id }
        };
    }

    /// <inheritdoc />
    public async Task<OtpResult> VerifyAsync(
        VerifyOtpRequest request,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(request);

        if (request.ChallengeId == Guid.Empty ||
            string.IsNullOrWhiteSpace(request.Code) ||
            request.Code.Length != UserConstants.OtpLength ||
            request.Code.Any(character => character is < '0' or > '9'))
        {
            return Failure(AuthenticationErrorCodes.OtpInvalid);
        }
        else
        {
        }

        OtpChallenge? challenge = await _dbContext.OtpChallenges
            .Include(item => item.User)
            .SingleOrDefaultAsync(item => item.Id == request.ChallengeId, cancellationToken);

        if (challenge is null || challenge.ConsumedAt is not null ||
            challenge.InvalidatedAt is not null)
        {
            return Failure(AuthenticationErrorCodes.OtpInvalid);
        }
        else
        {
        }

        DateTime utcNow = DateTime.UtcNow;

        if (challenge.ExpiresAt <= utcNow)
        {
            return Failure(AuthenticationErrorCodes.OtpExpired);
        }
        else
        {
        }

        if (challenge.VerificationAttempts >= UserConstants.MaxOtpAttempts)
        {
            return Failure(AuthenticationErrorCodes.OtpAttemptsExceeded);
        }
        else
        {
        }

        PasswordVerificationResult verificationResult =
            _passwordHasher.VerifyHashedPassword(challenge, challenge.CodeHash, request.Code);

        if (verificationResult == PasswordVerificationResult.Failed)
        {
            challenge.VerificationAttempts++;
            await _dbContext.SaveChangesAsync(cancellationToken);

            return Failure(challenge.VerificationAttempts >= UserConstants.MaxOtpAttempts
                ? AuthenticationErrorCodes.OtpAttemptsExceeded
                : AuthenticationErrorCodes.OtpInvalid);
        }
        else
        {
        }

        challenge.ConsumedAt = utcNow;
        
        string? passwordResetToken = null;
        bool? phoneNumberConfirmed = null;

        if (challenge.Purpose == OtpPurpose.PhoneConfirmation)
        {
            challenge.User.PhoneNumberConfirmed = true;
            phoneNumberConfirmed = true;
        }
        else if (challenge.Purpose == OtpPurpose.PasswordReset)
        {
            passwordResetToken = await _userManager.GeneratePasswordResetTokenAsync(challenge.User);
        }
        else
        {
        }

        await _dbContext.SaveChangesAsync(cancellationToken);

        return new OtpResult
        {
            Succeeded = true,
            Verification = new OtpVerificationResponse
            {
                PhoneNumberConfirmed = phoneNumberConfirmed,
                PasswordResetToken = passwordResetToken
            }
        };
    }

    /// <inheritdoc />
    public async Task<OtpResult> ResendAsync(
        ResendOtpRequest request,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(request);

        OtpChallenge? previousChallenge = await _dbContext.OtpChallenges
            .Include(challenge => challenge.User)
            .SingleOrDefaultAsync(
                challenge => challenge.Id == request.ChallengeId,
                cancellationToken);

        if (previousChallenge is null || previousChallenge.ConsumedAt is not null ||
            previousChallenge.InvalidatedAt is not null)
        {
            return Failure(AuthenticationErrorCodes.OtpInvalid);
        }
        else
        {
        }

        DateTime utcNow = DateTime.UtcNow;

        if (previousChallenge.ExpiresAt > utcNow)
        {
            return Failure(AuthenticationErrorCodes.OtpResendNotAvailable);
        }
        else
        {
        }

        if (previousChallenge.ResendCount >= UserConstants.MaxOtpResends)
        {
            return Failure(AuthenticationErrorCodes.OtpResendLimitReached);
        }
        else
        {
        }

        string phoneNumber = previousChallenge.User.PhoneNumber
            ?? throw new InvalidOperationException("OTP requires a phone number.");
        string code = RandomNumberGenerator.GetInt32(0, 1_000_000).ToString("D6");

        if (!await _smsSender.SendOtpAsync(phoneNumber, code, cancellationToken))
        {
            return Failure(AuthenticationErrorCodes.OtpDeliveryUnavailable);
        }
        else
        {
        }

        previousChallenge.InvalidatedAt = utcNow;

        var challenge = new OtpChallenge
        {
            Id = Guid.NewGuid(),
            UserId = previousChallenge.UserId,
            User = previousChallenge.User,
            Purpose = previousChallenge.Purpose,
            CodeHash = string.Empty,
            ExpiresAt = utcNow.AddSeconds(UserConstants.OtpExpirySeconds),
            SentAt = utcNow,
            ResendCount = previousChallenge.ResendCount + 1
        };

        challenge.CodeHash = _passwordHasher.HashPassword(challenge, code);
        _dbContext.OtpChallenges.Add(challenge);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return new OtpResult
        {
            Succeeded = true,
            Challenge = new OtpChallengeResponse { ChallengeId = challenge.Id }
        };
    }

    private static OtpResult Failure(string code)
    {
        return new OtpResult
        {
            Errors = [new AuthenticationError(code)]
        };
    }
}
