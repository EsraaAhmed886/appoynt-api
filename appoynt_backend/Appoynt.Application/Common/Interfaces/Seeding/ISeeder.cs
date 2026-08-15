/**
 * File Name      : ISeeder.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 22/07/2026
 * Version        : v1.0.0
 * Description    : Defines the contract for all database seeders.
 */

namespace Appoynt.Application.Common.Interfaces.Seeding;

/// <summary>
/// Represents a database seeder.
/// </summary>
public interface ISeeder
{
    /// <summary>
    /// Seeds application data.
    /// </summary>
    Task SeedAsync(
        CancellationToken cancellationToken = default);
}