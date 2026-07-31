/**
 * File Name      : PagedResponse.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 28/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 28/07/2026
 * Description    : Wrapper for paginated API responses.
 */

namespace Appoynt.Application.Common.Models;

/// <summary>
/// A generic wrapper for paginated API responses.
/// </summary>
/// <typeparam name="T">The type of the items being paginated.</typeparam>
public sealed class PagedResponse<T>
{
    public IEnumerable<T> Items { get; init; } = Enumerable.Empty<T>();
    public int TotalCount { get; init; }
    public int PageNumber { get; init; }
    public int PageSize { get; init; }
    public int TotalPages => (int)Math.Ceiling(TotalCount / (double)PageSize);
}
