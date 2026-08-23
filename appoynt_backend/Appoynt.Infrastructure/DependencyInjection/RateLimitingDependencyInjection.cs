/**
 * File Name      : RateLimitingDependencyInjection.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 27/07/2026
 * Version        : v1.0.0
 * Dependencies   : Microsoft.AspNetCore.RateLimiting, Microsoft.AspNetCore.Http
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 27/07/2026
 * Description    : Registers rate limiting services and configures policies.
 */

using System.Threading.RateLimiting;
using Appoynt.Infrastructure.Options;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Appoynt.Infrastructure.DependencyInjection;

/// <summary>
/// Provides extension methods for registering rate limiting services.
/// </summary>
internal static class RateLimitingDependencyInjection
{
    /// <summary>
    /// Registers rate limiting services.
    /// </summary>
    /// <param name="services">The application service collection.</param>
    /// <param name="configuration">The application configuration.</param>
    /// <returns>The updated <see cref="IServiceCollection"/>.</returns>
    internal static IServiceCollection AddInfrastructureRateLimiting(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        var rateLimitingOptions = configuration
            .GetSection(RateLimitingOptions.SectionName)
            .Get<RateLimitingOptions>();

        if (rateLimitingOptions == null)
        {
            throw new InvalidOperationException("RateLimiting configuration section is missing or invalid.");
        }
        else
        {
        }

        services.AddRateLimiter(options =>
        {
            // Global rejection status code
            options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;

            // Login Policy
            options.AddPolicy("Login", httpContext =>
            {
                var opt = httpContext.RequestServices
                    .GetRequiredService<Microsoft.Extensions.Options.IOptions<RateLimitingOptions>>().Value;

                if (!opt.Enabled)
                {
                    return RateLimitPartition.GetNoLimiter(GetClientIpAddress(httpContext));
                }
                else
                {
                    return RateLimitPartition.GetFixedWindowLimiter(
                        partitionKey: GetClientIpAddress(httpContext),
                        factory: _ => new FixedWindowRateLimiterOptions
                        {
                            PermitLimit = opt.Login.PermitLimit,
                            Window = TimeSpan.FromMinutes(opt.Login.WindowInMinutes),
                            QueueProcessingOrder = QueueProcessingOrder.OldestFirst,
                            QueueLimit = 0
                        });
                }
            });

            // Register Policy
            options.AddPolicy("Register", httpContext =>
            {
                var opt = httpContext.RequestServices
                    .GetRequiredService<Microsoft.Extensions.Options.IOptions<RateLimitingOptions>>().Value;

                if (!opt.Enabled)
                {
                    return RateLimitPartition.GetNoLimiter(GetClientIpAddress(httpContext));
                }
                else
                {
                    return RateLimitPartition.GetFixedWindowLimiter(
                        partitionKey: GetClientIpAddress(httpContext),
                        factory: _ => new FixedWindowRateLimiterOptions
                        {
                            PermitLimit = opt.Register.PermitLimit,
                            Window = TimeSpan.FromMinutes(opt.Register.WindowInMinutes),
                            QueueProcessingOrder = QueueProcessingOrder.OldestFirst,
                            QueueLimit = 0
                        });
                }
            });

            // OTP Verify Policy
            options.AddPolicy("OtpVerify", httpContext =>
            {
                var opt = httpContext.RequestServices
                    .GetRequiredService<Microsoft.Extensions.Options.IOptions<RateLimitingOptions>>().Value;

                if (!opt.Enabled)
                {
                    return RateLimitPartition.GetNoLimiter(GetClientIpAddress(httpContext));
                }
                else
                {
                    return RateLimitPartition.GetFixedWindowLimiter(
                        partitionKey: GetClientIpAddress(httpContext),
                        factory: _ => new FixedWindowRateLimiterOptions
                        {
                            PermitLimit = opt.OtpVerify.PermitLimit,
                            Window = TimeSpan.FromMinutes(opt.OtpVerify.WindowInMinutes),
                            QueueProcessingOrder = QueueProcessingOrder.OldestFirst,
                            QueueLimit = 0
                        });
                }
            });

            // OTP Resend Policy
            options.AddPolicy("OtpResend", httpContext =>
            {
                var opt = httpContext.RequestServices
                    .GetRequiredService<Microsoft.Extensions.Options.IOptions<RateLimitingOptions>>().Value;

                if (!opt.Enabled)
                {
                    return RateLimitPartition.GetNoLimiter(GetClientIpAddress(httpContext));
                }
                else
                {
                    return RateLimitPartition.GetFixedWindowLimiter(
                        partitionKey: GetClientIpAddress(httpContext),
                        factory: _ => new FixedWindowRateLimiterOptions
                        {
                            PermitLimit = opt.OtpResend.PermitLimit,
                            Window = TimeSpan.FromMinutes(opt.OtpResend.WindowInMinutes),
                            QueueProcessingOrder = QueueProcessingOrder.OldestFirst,
                            QueueLimit = 0
                        });
                }
            });

            // Forgot Password Policy
            options.AddPolicy("ForgotPassword", httpContext =>
            {
                var opt = httpContext.RequestServices
                    .GetRequiredService<Microsoft.Extensions.Options.IOptions<RateLimitingOptions>>().Value;

                if (!opt.Enabled)
                {
                    return RateLimitPartition.GetNoLimiter(GetClientIpAddress(httpContext));
                }
                else
                {
                    return RateLimitPartition.GetFixedWindowLimiter(
                        partitionKey: GetClientIpAddress(httpContext),
                        factory: _ => new FixedWindowRateLimiterOptions
                        {
                            PermitLimit = opt.ForgotPassword.PermitLimit,
                            Window = TimeSpan.FromMinutes(opt.ForgotPassword.WindowInMinutes),
                            QueueProcessingOrder = QueueProcessingOrder.OldestFirst,
                            QueueLimit = 0
                        });
                }
            });

            // Reset Password Policy
            options.AddPolicy("ResetPassword", httpContext =>
            {
                var opt = httpContext.RequestServices
                    .GetRequiredService<Microsoft.Extensions.Options.IOptions<RateLimitingOptions>>().Value;

                if (!opt.Enabled)
                {
                    return RateLimitPartition.GetNoLimiter(GetClientIpAddress(httpContext));
                }
                else
                {
                    return RateLimitPartition.GetFixedWindowLimiter(
                        partitionKey: GetClientIpAddress(httpContext),
                        factory: _ => new FixedWindowRateLimiterOptions
                        {
                            PermitLimit = opt.ResetPassword.PermitLimit,
                            Window = TimeSpan.FromMinutes(opt.ResetPassword.WindowInMinutes),
                            QueueProcessingOrder = QueueProcessingOrder.OldestFirst,
                            QueueLimit = 0
                        });
                }
            });
        });

        return services;
    }

    private static string GetClientIpAddress(HttpContext context)
    {
        return context.Connection.RemoteIpAddress?.ToString() ?? "unknown";
    }
}
