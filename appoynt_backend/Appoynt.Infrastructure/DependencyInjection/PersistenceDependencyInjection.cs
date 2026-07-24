/**
 * File Name      : PersistenceDependencyInjection.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 22/07/2026
 * Version        : v1.0.0
 * Dependencies   : ApplicationDbContext
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 22/07/2026
 * Description    : Registers the application's persistence layer,
 *                  including Entity Framework Core and the database context.
 */

using Appoynt.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Appoynt.Infrastructure.DependencyInjection;

/// <summary>
/// Provides extension methods for registering persistence services.
/// </summary>
internal static class PersistenceDependencyInjection
{
    /// <summary>
    /// Registers the application's persistence layer.
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
    internal static IServiceCollection AddInfrastructurePersistence(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        // Register the Entity Framework Core database context.
        services.AddDbContext<ApplicationDbContext>(options =>
        {
            options.UseSqlServer(
                configuration.GetConnectionString("DefaultConnection"));
        });

        return services;
    }
}