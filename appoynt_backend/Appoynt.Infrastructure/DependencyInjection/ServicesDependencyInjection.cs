/**
 * File Name      : ServicesDependencyInjection.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 22/07/2026
 * Version        : v1.0.0
 * Dependencies   : CurrentUserService, DateTimeProvider
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 22/07/2026
 * Description    : Registers infrastructure services used throughout
 *                  the application.
 */

using Appoynt.Application.Common.Interfaces;
using Appoynt.Infrastructure.Services;
using Microsoft.Extensions.DependencyInjection;

namespace Appoynt.Infrastructure.DependencyInjection;

/// <summary>
/// Provides extension methods for registering infrastructure services.
/// </summary>
internal static class ServicesDependencyInjection
{
    /// <summary>
    /// Registers infrastructure services.
    /// </summary>
    /// <param name="services">
    /// The application service collection.
    /// </param>
    /// <returns>
    /// The updated <see cref="IServiceCollection"/>.
    /// </returns>
    internal static IServiceCollection AddInfrastructureServices(
        this IServiceCollection services)
    {
        // Register access to the current HTTP context.
        services.AddHttpContextAccessor();

        // Register the current authenticated user service.
        services.AddScoped<ICurrentUserService, CurrentUserService>();

        // Register the system date and time provider.
        services.AddSingleton<IDateTimeProvider, DateTimeProvider>();

        return services;
    }
}