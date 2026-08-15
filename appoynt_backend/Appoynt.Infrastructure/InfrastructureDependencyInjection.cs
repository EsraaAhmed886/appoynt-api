/**
 * File Name      : DependencyInjection.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v2.1.0
 * Dependencies   : Infrastructure Dependency Injection Extensions
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 22/07/2026
 * Description    : Serves as the infrastructure composition root by
 *                  orchestrating the registration of all infrastructure
 *                  dependencies.
 */

using Appoynt.Infrastructure.DependencyInjection;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Appoynt.Infrastructure;

/// <summary>
/// Provides extension methods for registering all infrastructure services.
/// </summary>
public static class InfrastructureDependencyInjection
{
    #region Public Methods

    /// <summary>
    /// Registers all infrastructure dependencies required by the application.
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
    public static IServiceCollection AddInfrastructure(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        // Register persistence layer.
        services.AddInfrastructurePersistence(configuration);

        // Register ASP.NET Core Identity.
        services.AddInfrastructureIdentity();

        // Register authentication.
        services.AddInfrastructureAuthentication(configuration);

        // Register authorization.
        services.AddInfrastructureAuthorization();

        // Register infrastructure configuration options.
        services.AddInfrastructureOptions(configuration);

        // Register rate limiting services.
        services.AddInfrastructureRateLimiting(configuration);

        // Register infrastructure services.
        services.AddInfrastructureServices();

        // Register database seeders.
        services.AddInfrastructureSeeding();

        return services;
    }

    #endregion
}