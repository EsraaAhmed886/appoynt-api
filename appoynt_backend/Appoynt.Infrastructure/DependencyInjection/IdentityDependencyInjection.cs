/**
 * File Name      : IdentityDependencyInjection.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 22/07/2026
 * Version        : v1.0.0
 * Dependencies   : ApplicationUser, ApplicationDbContext, ASP.NET Identity
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 22/07/2026
 * Description    : Registers ASP.NET Core Identity services required by
 *                  the application.
 */

using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.DependencyInjection;

namespace Appoynt.Infrastructure.DependencyInjection;

/// <summary>
/// Provides extension methods for registering ASP.NET Core Identity.
/// </summary>
internal static class IdentityDependencyInjection
{
    /// <summary>
    /// Registers ASP.NET Core Identity services.
    /// </summary>
    /// <param name="services">
    /// The service collection.
    /// </param>
    /// <returns>
    /// The updated <see cref="IServiceCollection"/>.
    /// </returns>
    internal static IServiceCollection AddInfrastructureIdentity(
        this IServiceCollection services)
    {
        services
            .AddIdentity<ApplicationUser, IdentityRole<Guid>>(options =>
            {
                options.Password.RequiredLength = UserConstants.PasswordMinLength;
                options.Password.RequireDigit = true;
                options.Password.RequireLowercase = true;
                options.Password.RequireUppercase = true;
                options.Password.RequireNonAlphanumeric = true;

                options.Lockout.AllowedForNewUsers = true;
                options.Lockout.MaxFailedAccessAttempts = UserConstants.MaxFailedAccessAttempts;
                options.Lockout.DefaultLockoutTimeSpan = TimeSpan.FromMinutes(UserConstants.DefaultLockoutTimeSpanMinutes);
            })
            .AddEntityFrameworkStores<ApplicationDbContext>()
            .AddDefaultTokenProviders();

        return services;
    }
}