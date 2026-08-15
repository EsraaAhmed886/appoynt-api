/**
 * File Name      : AuthorizationDependencyInjection.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 22/07/2026
 * Version        : v1.0.0
 * Dependencies   : ASP.NET Core Authorization
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 22/07/2026
 * Description    : Registers authorization services and policies used
 *                  by the application.
 */

using Microsoft.Extensions.DependencyInjection;

namespace Appoynt.Infrastructure.DependencyInjection;

/// <summary>
/// Provides extension methods for registering authorization services.
/// </summary>
internal static class AuthorizationDependencyInjection
{
    /// <summary>
    /// Registers authorization services.
    /// </summary>
    /// <param name="services">
    /// The application service collection.
    /// </param>
    /// <returns>
    /// The updated <see cref="IServiceCollection"/>.
    /// </returns>
    internal static IServiceCollection AddInfrastructureAuthorization(
        this IServiceCollection services)
    {
        services.AddAuthorization();

        return services;
    }
}
