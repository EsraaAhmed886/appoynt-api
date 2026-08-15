/**
 * File Name      : DependencyInjection.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-07-21
 * Version        : v1.0.0
 * Dependencies   : IServiceCollection, Microsoft.Extensions.DependencyInjection
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Registers application-layer dependencies and services into the DI container.
 */

using Microsoft.Extensions.DependencyInjection;

namespace Appoynt.Application;

/// <summary>
/// Provides extension methods for registering Application layer services into the dependency injection container.
/// </summary>
public static class DependencyInjection
{
    /// <summary>
    /// Registers all core Application layer services, validators, and behaviors.
    /// </summary>
    /// <param name="services">The service collection to add registrations to.</param>
    /// <returns>The modified service collection for method chaining.</returns>
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        // Return the service collection for fluent chaining
        return services;
    }
}
