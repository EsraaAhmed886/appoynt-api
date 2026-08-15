/**
 * File Name      : SmsSenders.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 25/07/2026
 * Version        : v1.0.0
 * Dependencies   : ISmsSender, ILogger
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 25/07/2026
 * Description    : Provides local-development and production-safe placeholder
 *                  implementations of the SMS delivery contract.
 */

using Appoynt.Application.Common.Interfaces;
using Microsoft.Extensions.Logging;

namespace Appoynt.Infrastructure.Authentication;

/// <summary>
/// Logs OTP delivery details for local Development testing only.
/// </summary>
public sealed class DevelopmentSmsSender(ILogger<DevelopmentSmsSender> logger)
    : ISmsSender
{
    /// <inheritdoc />
    public Task<bool> SendOtpAsync(
        string phoneNumber,
        string code,
        CancellationToken cancellationToken = default)
    {
        logger.LogWarning(
            "Development OTP for phone number {PhoneNumber}: {OtpCode}",
            phoneNumber,
            code);

        return Task.FromResult(true);
    }
}

/// <summary>
/// Safely declines OTP delivery when no production SMS provider is configured.
/// </summary>
public sealed class UnavailableSmsSender(ILogger<UnavailableSmsSender> logger)
    : ISmsSender
{
    /// <inheritdoc />
    public Task<bool> SendOtpAsync(
        string phoneNumber,
        string code,
        CancellationToken cancellationToken = default)
    {
        logger.LogError(
            "OTP delivery was requested but no SMS provider is configured.");

        return Task.FromResult(false);
    }
}
