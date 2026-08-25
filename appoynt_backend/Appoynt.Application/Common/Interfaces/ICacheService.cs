/**
 * File Name      : ICacheService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-25
 * Description    : Abstraction over application caching so consumers remain
 *                  decoupled from the concrete provider (memory today,
 *                  distributed cache tomorrow) and can be swapped via DI only.
 */

using System;
using System.Threading;
using System.Threading.Tasks;

namespace Appoynt.Application.Common.Interfaces;

/// <summary>
/// Provides a provider-agnostic caching contract for hot read paths.
/// </summary>
public interface ICacheService
{
    /// <summary>
    /// Gets the cached item stored under the specified key.
    /// </summary>
    /// <typeparam name="TItem">The cached item type.</typeparam>
    /// <param name="key">The cache key.</param>
    /// <returns>The cached item, or default when absent or expired.</returns>
    TItem? Get<TItem>(string key);

    /// <summary>
    /// Stores an item under the specified key for the supplied duration.
    /// </summary>
    /// <typeparam name="TItem">The cached item type.</typeparam>
    /// <param name="key">The cache key.</param>
    /// <param name="item">The item to cache.</param>
    /// <param name="duration">The sliding-free absolute lifetime of the entry.</param>
    void Set<TItem>(string key, TItem item, TimeSpan duration);

    /// <summary>
    /// Removes the entry stored under the specified key.
    /// </summary>
    /// <param name="key">The cache key.</param>
    void Remove(string key);

    /// <summary>
    /// Asynchronously removes the entry stored under the specified key.
    /// Present so distributed-cache implementations can honor cancellation.
    /// </summary>
    /// <param name="key">The cache key.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A task representing the removal operation.</returns>
    Task RemoveAsync(string key, CancellationToken cancellationToken = default);
}
