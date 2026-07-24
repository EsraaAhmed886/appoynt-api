/**
 * File Name      : SeedingDependencyInjection.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 22/07/2026
 * Version        : v1.0.0
 * Dependencies   : RoleSeeder, AdminSeeder, DatabaseSeeder
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 22/07/2026
 * Description    : Registers all database seeders used by the application.
 */

using Appoynt.Application.Common.Interfaces.Seeding;
using Appoynt.Infrastructure.Persistence.Seed;
using Microsoft.Extensions.DependencyInjection;

namespace Appoynt.Infrastructure.DependencyInjection;

/// <summary>
/// Provides extension methods for registering database seeders.
/// </summary>
internal static class SeedingDependencyInjection
{
    /// <summary>
    /// Registers all database seeders.
    /// </summary>
    /// <param name="services">
    /// The application service collection.
    /// </param>
    /// <returns>
    /// The updated <see cref="IServiceCollection"/>.
    /// </returns>
    internal static IServiceCollection AddInfrastructureSeeding(
        this IServiceCollection services)
    {
        services.AddScoped<IRoleSeeder, RoleSeeder>();

        services.AddScoped<IAdminSeeder, AdminSeeder>();

        services.AddScoped<IDatabaseSeeder, DatabaseSeeder>();

        return services;
    }
}