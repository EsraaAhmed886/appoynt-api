/**
 * File Name      : SeedOptions.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 22/07/2026
 * Version        : v1.0.0
 * Dependencies   : AdminOptions
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 22/07/2026
 * Description    : Represents the application seed configuration
 *                  loaded from the "Seed" section in appsettings.json.
 */

namespace Appoynt.Infrastructure.Options;

/// <summary>
/// Represents application seed configuration.
/// </summary>
public sealed class SeedOptions
{
    /// <summary>
    /// Indicates whether database seeding should run at startup.
    /// </summary>
    public bool Enabled { get; init; } = true;

    /// <summary>
    /// Default administrator configuration.
    /// </summary>
    public AdminOptions Admin { get; init; } = new();

    /// <summary>
    /// Default doctor configuration.
    /// </summary>
    public DoctorOptions Doctor { get; init; } = new();
}