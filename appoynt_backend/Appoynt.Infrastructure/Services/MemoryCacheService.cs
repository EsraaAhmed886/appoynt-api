/**
 * File Name      : MemoryCacheService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : ICacheService, IMemoryCache
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-25
 * Description    : In-memory implementation of the application cache contract.
 *                  Swapping to a distributed provider later only requires a new
 *                  implementation of ICacheService registered in DI.
 */

using System;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Interfaces;
using Microsoft.Extensions.Caching.Memory;

namespace Appoynt.Infrastructure.Services;

/// <summary>
/// Implements the application cache contract over IMemoryCache.
/// </summary>
public sealed class MemoryCacheService : ICacheService
{
    // The underlying in-memory cache store.
    private readonly IMemoryCache _memoryCache;

    /// <summary>
    /// Initializes a new instance of the <see cref="MemoryCacheService"/> class.
    /// </summary>
    /// <param name="memoryCache">The framework memory cache.</param>
    public MemoryCacheService(IMemoryCache memoryCache)
    {
        _memoryCache = memoryCache;
    }

    /// <inheritdoc />
    public TItem? Get<TItem>(string key)
    {
        // Attempt to read the live entry for the supplied key.
        return _memoryCache.TryGetValue(key, out TItem? item) ? item : default;
    }

    /// <inheritdoc />
    public void Set<TItem>(string key, TItem item, TimeSpan duration)
    {
        // Store the entry with an absolute expiration relative to now.
        _memoryCache.Set(key, item, DateTimeOffset.UtcNow.Add(duration));
    }

    /// <inheritdoc />
    public void Remove(string key)
    {
        // Evict the entry if present; missing keys are a harmless no-op.
        _memoryCache.Remove(key);
    }

    /// <inheritdoc />
    public Task RemoveAsync(string key, CancellationToken cancellationToken = default)
    {
        // The memory provider is synchronous; complete immediately while keeping
        // the async signature so distributed implementations can slot in later.
        Remove(key);
        return Task.CompletedTask;
    }
}
