/**
 * File Name      : DatabaseSeeder.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 22/07/2026
 * Version        : v1.0.0
 * Dependencies   : IRoleSeeder, IAdminSeeder
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 22/07/2026
 * Description    : Coordinates the execution of all database seeders
 *                  required by the application.
 */

using Appoynt.Application.Common.Interfaces.Seeding;
using Appoynt.Infrastructure.Persistence.Seed.Base;
using Microsoft.Extensions.Logging;

namespace Appoynt.Infrastructure.Persistence.Seed;

/// <summary>
/// Coordinates the execution of all database seeders.
/// </summary>
public sealed class DatabaseSeeder
    : SeederBase, IDatabaseSeeder
{
    #region Fields

    private readonly IRoleSeeder _roleSeeder;
    private readonly IAdminSeeder _adminSeeder;
    private readonly ILogger<DatabaseSeeder> _logger;

    #endregion

    #region Constructors

    /// <summary>
    /// Initializes a new instance of the <see cref="DatabaseSeeder"/> class.
    /// </summary>
    /// <param name="roleSeeder">
    /// The role seeder.
    /// </param>
    /// <param name="adminSeeder">
    /// The administrator seeder.
    /// </param>
    /// <param name="logger">
    /// The logger instance.
    /// </param>
    public DatabaseSeeder(
        IRoleSeeder roleSeeder,
        IAdminSeeder adminSeeder,
        ILogger<DatabaseSeeder> logger)
    {
        _roleSeeder = roleSeeder;
        _adminSeeder = adminSeeder;
        _logger = logger;
    }

    #endregion

    #region Public Methods

    /// <inheritdoc />
    public async Task SeedAsync(
        CancellationToken cancellationToken = default)
    {
        cancellationToken.ThrowIfCancellationRequested();

        _logger.LogInformation("Seeding application roles.");

        await _roleSeeder.SeedAsync(cancellationToken);

        _logger.LogInformation("Seeding default administrator account.");

        await _adminSeeder.SeedAsync(cancellationToken);
    }

    #endregion
}