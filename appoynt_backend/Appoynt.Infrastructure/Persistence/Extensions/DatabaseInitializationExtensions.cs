/**
 * File Name      : DatabaseInitializationExtensions.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : ApplicationDbContext, IDatabaseSeeder, SeedOptions
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Provides startup helpers for applying database migrations
 *                  and running seed operations.
 */

using Appoynt.Application.Common.Interfaces.Seeding;
using Appoynt.Infrastructure.Options;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace Appoynt.Infrastructure.Persistence.Extensions;

/// <summary>
/// Provides extension methods for initializing the application database.
/// </summary>
public static class DatabaseInitializationExtensions
{
    /// <summary>
    /// Applies pending migrations and runs database seeders when enabled.
    /// </summary>
    /// <param name="host">
    /// The application host.
    /// </param>
    /// <param name="cancellationToken">
    /// The cancellation token.
    /// </param>
    /// <returns>
    /// A task representing the asynchronous initialization operation.
    /// </returns>
    public static async Task InitializeDatabaseAsync(
        this IHost host,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(host);

        using IServiceScope scope = host.Services.CreateScope();

        IServiceProvider services = scope.ServiceProvider;

        ILoggerFactory loggerFactory =
            services.GetRequiredService<ILoggerFactory>();

        ILogger logger =
            loggerFactory.CreateLogger("DatabaseInitialization");

        IHostEnvironment environment =
            services.GetRequiredService<IHostEnvironment>();

        ApplicationDbContext dbContext =
            services.GetRequiredService<ApplicationDbContext>();

        SeedOptions seedOptions =
            services.GetRequiredService<IOptions<SeedOptions>>().Value;

        logger.LogInformation(
            "Starting database initialization for environment '{EnvironmentName}'.",
            environment.EnvironmentName);

        try
        {
            logger.LogInformation("Applying pending database migrations.");

            await dbContext.Database
                .MigrateAsync(cancellationToken)
                .ConfigureAwait(false);

            logger.LogInformation("Database migrations applied successfully.");

            if (!seedOptions.Enabled)
            {
                logger.LogInformation(
                    "Database seeding is disabled via configuration.");

                return;
            }

            logger.LogInformation("Starting database seeding.");

            IDatabaseSeeder databaseSeeder =
                services.GetRequiredService<IDatabaseSeeder>();

            await databaseSeeder
                .SeedAsync(cancellationToken)
                .ConfigureAwait(false);

            logger.LogInformation("Database seeding completed successfully.");
        }
        catch (Exception exception)
        {
            logger.LogError(
                exception,
                "Database initialization failed for environment '{EnvironmentName}'.",
                environment.EnvironmentName);

            throw;
        }
    }
}
