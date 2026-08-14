/**
 * File Name      : IUserManagementService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 28/07/2026
 * Version        : v1.1.0
 * Dependencies   : CreateDoctorRequest, CreateStaffRequest, Result, UpdateUserRequest, UserQueryParameters, UserResponse, PagedResponse
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Defines the contract for user management operations including staff and doctor creation.
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
    /// Creates a new doctor account with profile, specializations, and phone numbers.
    /// </summary>
    /// <param name="request">The creation request data.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A result containing the user ID if successful, or validation errors.</returns>
    Task<UserManagementResult> CreateDoctorAsync(
        CreateDoctorRequest request,
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

    /// <summary>
    /// Retrieves a paginated list of users based on query parameters.
    /// </summary>
    /// <param name="queryParams">The pagination and filtering parameters.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A paginated response containing user details.</returns>
    Task<PagedResponse<UserResponse>> GetUsersAsync(
        UserQueryParameters queryParams,
        CancellationToken cancellationToken = default);

    /// <summary>
    /// Retrieves a user by their unique identifier.
    /// </summary>
    /// <param name="id">The unique identifier of the user.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The user details if found; otherwise, null.</returns>
    Task<UserResponse?> GetUserByIdAsync(
        Guid id,
        CancellationToken cancellationToken = default);

    /// <summary>
    /// Updates an existing user's information.
    /// </summary>
    /// <param name="id">The unique identifier of the user to update.</param>
    /// <param name="request">The update request data.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A result indicating success or containing validation errors.</returns>
    Task<UserManagementResult> UpdateUserAsync(
        Guid id,
        UpdateUserRequest request,
        CancellationToken cancellationToken = default);

    /// <summary>
    /// Deletes a user by their unique identifier.
    /// </summary>
    /// <param name="id">The unique identifier of the user to delete.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A result indicating success or containing validation errors.</returns>
    Task<UserManagementResult> DeleteUserAsync(
        Guid id,
        CancellationToken cancellationToken = default);

    /// <summary>
    /// Soft deletes all users in the system except the currently authenticated administrator.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A result indicating success or containing validation errors.</returns>
    Task<UserManagementResult> DeleteAllUsersAsync(
        CancellationToken cancellationToken = default);
}
