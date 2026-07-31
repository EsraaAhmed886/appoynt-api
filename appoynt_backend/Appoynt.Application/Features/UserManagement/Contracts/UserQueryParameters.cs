/**
 * File Name      : UserQueryParameters.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 28/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 28/07/2026
 * Description    : Parameters for querying users with pagination, search, and filtering.
 */

using System.ComponentModel.DataAnnotations;

namespace Appoynt.Application.Features.UserManagement.Contracts;

public sealed class UserQueryParameters
{
    [Range(1, int.MaxValue, ErrorMessage = "PageNumber must be greater than or equal to 1.")]
    public int PageNumber { get; init; } = 1;

    [Range(1, 100, ErrorMessage = "PageSize must be between 1 and 100.")]
    public int PageSize { get; init; } = 10;
    
    public string? Role { get; init; }
    public string? Name { get; init; }
}
