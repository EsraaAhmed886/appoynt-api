/**
 * File Name      : IGovernorateSeeder.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Defines the contract for seeding governorate and city lookup data.
 */

namespace Appoynt.Application.Common.Interfaces.Seeding;

using System.Threading;
using System.Threading.Tasks;

/// <summary>
/// Defines a contract for a governorate seeder.
/// </summary>
public interface IGovernorateSeeder
{
    /// <summary>
    /// Seeds governorate and city data asynchronously.
    /// </summary>
    /// <param name="ct">A token to cancel the asynchronous operation.</param>
    /// <returns>A task representing the asynchronous seeding operation.</returns>
    Task SeedAsync(CancellationToken ct = default);
}
