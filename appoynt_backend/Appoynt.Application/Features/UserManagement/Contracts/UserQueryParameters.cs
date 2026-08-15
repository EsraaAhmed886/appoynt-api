/**
 * File Name      : UserQueryParameters.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 28/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-07-31
 * Description    : Parameters for querying users with pagination, search, and filtering.
 */

using System.ComponentModel.DataAnnotations;

namespace Appoynt.Application.Features.UserManagement.Contracts;

/// <summary>
/// Represents query parameters for retrieving a paginated list of users.
/// </summary>
public sealed class UserQueryParameters
{
    /// <summary>
    /// Gets the page number for pagination. Defaults to 1.
    /// </summary>
    [Range(1, int.MaxValue, ErrorMessage = "PageNumber must be greater than or equal to 1.")]
    public int PageNumber { get; init; } = 1;

    /// <summary>
    /// Gets the number of items per page. Defaults to 10.
    /// </summary>
    [Range(1, 100, ErrorMessage = "PageSize must be between 1 and 100.")]
    public int PageSize { get; init; } = 10;
    
    /// <summary>
    /// Gets the optional role filter.
    /// </summary>
    public string? Role { get; init; }

    /// <summary>
    /// Gets the optional name search filter.
    /// </summary>
    public string? Name { get; init; }
}
