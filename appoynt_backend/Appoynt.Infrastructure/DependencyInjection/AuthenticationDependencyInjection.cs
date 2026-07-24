/**
 * File Name      : AuthenticationDependencyInjection.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 22/07/2026
 * Version        : v1.0.0
 * Dependencies   : JwtOptions, JwtTokenService, JWT Bearer Authentication
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 22/07/2026
 * Description    : Registers authentication services used by the
 *                  application.
 */

using System.Text;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Infrastructure.Authentication;
using Appoynt.Infrastructure.Options;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace Appoynt.Infrastructure.DependencyInjection;

/// <summary>
/// Provides extension methods for registering authentication services.
/// </summary>
internal static class AuthenticationDependencyInjection
{
    /// <summary>
    /// Registers authentication services.
    /// </summary>
    /// <param name="services">
    /// The application service collection.
    /// </param>
    /// <param name="configuration">
    /// The application configuration.
    /// </param>
    /// <returns>
    /// The updated <see cref="IServiceCollection"/>.
    /// </returns>
    internal static IServiceCollection AddInfrastructureAuthentication(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        ArgumentNullException.ThrowIfNull(configuration);

        services
            .AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme =
                    JwtBearerDefaults.AuthenticationScheme;

                options.DefaultChallengeScheme =
                    JwtBearerDefaults.AuthenticationScheme;
            })
            .AddJwtBearer();

        services
            .AddOptions<JwtBearerOptions>(
                JwtBearerDefaults.AuthenticationScheme)
            .Configure<IOptions<JwtOptions>>(
                (options, jwtOptions) =>
            {
                options.MapInboundClaims = false;

                SymmetricSecurityKey signingKey = new(
                    Encoding.UTF8.GetBytes(jwtOptions.Value.SecretKey));

                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = signingKey,
                    ValidateIssuer = true,
                    ValidIssuer = jwtOptions.Value.Issuer,
                    ValidateAudience = true,
                    ValidAudience = jwtOptions.Value.Audience,
                    ValidateLifetime = true,
                    RequireExpirationTime = true,
                    RequireSignedTokens = true,
                    ValidAlgorithms = [SecurityAlgorithms.HmacSha256],
                    ClockSkew = TimeSpan.Zero
                };
            });

        services.AddScoped<ITokenService, JwtTokenService>();

        return services;
    }
}
