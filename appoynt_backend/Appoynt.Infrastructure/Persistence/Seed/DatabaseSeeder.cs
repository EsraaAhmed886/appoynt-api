/**
 * File Name      : DatabaseSeeder.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 22/07/2026
 * Version        : v1.0.0
 * Dependencies   : IRoleSeeder, IAdminSeeder
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
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
    private readonly ISpecializationSeeder _specializationSeeder;
    private readonly IDoctorSeeder _doctorSeeder;
    private readonly IMedicalCatalogSeeder _medicalCatalogSeeder;
    private readonly ILogger<DatabaseSeeder> _logger;

    #endregion

    #region Constructors

    /// <summary>
    /// Initializes a new instance of the <see cref="DatabaseSeeder"/> class.
    /// </summary>
    /// <param name="roleSeeder">The role seeder.</param>
    /// <param name="adminSeeder">The administrator seeder.</param>
    /// <param name="specializationSeeder">The specialization seeder.</param>
    /// <param name="doctorSeeder">The doctor seeder.</param>
    /// <param name="medicalCatalogSeeder">The clinical reference catalog seeder.</param>
    /// <param name="logger">The logger instance.</param>
    public DatabaseSeeder(
        IRoleSeeder roleSeeder,
        IAdminSeeder adminSeeder,
        ISpecializationSeeder specializationSeeder,
        IDoctorSeeder doctorSeeder,
        IMedicalCatalogSeeder medicalCatalogSeeder,
        ILogger<DatabaseSeeder> logger)
    {
        _roleSeeder = roleSeeder;
        _adminSeeder = adminSeeder;
        _specializationSeeder = specializationSeeder;
        _doctorSeeder = doctorSeeder;
        _medicalCatalogSeeder = medicalCatalogSeeder;
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

        _logger.LogInformation("Seeding medical specializations.");
        await _specializationSeeder.SeedAsync(cancellationToken);

        _logger.LogInformation("Seeding sample doctors and clinics.");
        await _doctorSeeder.SeedAsync(cancellationToken);

        _logger.LogInformation("Seeding clinical reference catalogs (ICD-10, Medications, Diagnostic Tests).");
        await _medicalCatalogSeeder.SeedAsync(cancellationToken);
    }

    #endregion
}