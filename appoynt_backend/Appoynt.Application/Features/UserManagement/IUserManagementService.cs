/**
 * File Name      : IUserManagementService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 28/07/2026
 * Version        : v1.0.0
 * Dependencies   : CreateStaffRequest, Result
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 28/07/2026
 * Description    : Defines the contract for user management operations.
 */

using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.UserManagement.Contracts;

namespace Appoynt.Application.Features.UserManagement;

/// <summary>
/// Defines the contract for internal user management operations.
/// </summary>
public interface IUserManagementService
{
    /// <summary>
    /// Creates a new system administrator account.
    /// </summary>
    /// <param name="request">The creation request data.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A result containing the user ID if successful, or validation errors.</returns>
    Task<UserManagementResult> CreateAdminAsync(
        CreateStaffRequest request,
        CancellationToken cancellationToken = default);

    /// <summary>
    /// Creates a new doctor account.
    /// </summary>
    /// <param name="request">The creation request data.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A result containing the user ID if successful, or validation errors.</returns>
    Task<UserManagementResult> CreateDoctorAsync(
        CreateStaffRequest request,
        CancellationToken cancellationToken = default);

    /// <summary>
    /// Creates a new receptionist account linked to the authenticated doctor.
    /// </summary>
    /// <param name="request">The creation request data.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A result containing the user ID if successful, or validation errors.</returns>
    Task<UserManagementResult> CreateReceptionistAsync(
        CreateStaffRequest request,
        CancellationToken cancellationToken = default);

    Task<PagedResponse<UserResponse>> GetUsersAsync(
        UserQueryParameters queryParams,
        CancellationToken cancellationToken = default);

    Task<UserResponse?> GetUserByIdAsync(
        Guid id,
        CancellationToken cancellationToken = default);

    Task<UserManagementResult> UpdateUserAsync(
        Guid id,
        UpdateUserRequest request,
        CancellationToken cancellationToken = default);

    Task<UserManagementResult> DeleteUserAsync(
        Guid id,
        CancellationToken cancellationToken = default);
}
