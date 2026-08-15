/**
 * File Name      : PagedResponse.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 28/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-07-31
 * Description    : Wrapper for paginated API responses.
 */

namespace Appoynt.Application.Common.Models;

/// <summary>
/// A generic wrapper for paginated API responses.
/// </summary>
/// <typeparam name="T">The type of the items being paginated.</typeparam>
public sealed class PagedResponse<T>
{
    /// <summary>
    /// Gets the collection of items for the current page.
    /// </summary>
    public IEnumerable<T> Items { get; init; } = Enumerable.Empty<T>();

    /// <summary>
    /// Gets the total number of items matching the query.
    /// </summary>
    public int TotalCount { get; init; }

    /// <summary>
    /// Gets the current page number.
    /// </summary>
    public int PageNumber { get; init; }

    /// <summary>
    /// Gets the number of items per page.
    /// </summary>
    public int PageSize { get; init; }

    /// <summary>
    /// Gets the calculated total number of pages.
    /// </summary>
    public int TotalPages => (int)Math.Ceiling(TotalCount / (double)PageSize);
}
