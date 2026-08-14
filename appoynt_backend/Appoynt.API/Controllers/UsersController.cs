/**
 * File Name      : UsersController.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-07-28
 * Version        : v1.0.0
 * Dependencies   : ASP.NET Core MVC, IUserManagementService, CreateDoctorRequest, CreateStaffRequest, UpdateUserRequest
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Exposes REST API endpoints for managing internal staff users (Admins, Doctors, Receptionists).
 */

using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Features.UserManagement;
using Appoynt.Application.Features.UserManagement.Contracts;
using Appoynt.Domain.Common.Constants;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Appoynt.API.Controllers;

/// <summary>
/// Handles user and staff management operations.
/// </summary>
[ApiController]
[Route("api/users")]
public sealed class UsersController : ControllerBase
{
    private readonly IUserManagementService _userManagementService;

    /// <summary>
    /// Initializes a new instance of the <see cref="UsersController"/> class.
    /// </summary>
    /// <param name="userManagementService">The user management service.</param>
    public UsersController(IUserManagementService userManagementService)
    {
        // Store user management service dependency
        _userManagementService = userManagementService;
    }

    /// <summary>
    /// Creates a new system administrator account.
    /// </summary>
    /// <param name="request">The creation request data.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 201 Created response if successful.</returns>
    [HttpPost("admins")]
    [Authorize(Roles = RoleConstants.Admin)]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> CreateAdmin(
        [FromBody] CreateStaffRequest request,
        CancellationToken cancellationToken)
    {
        // Delegate administrator creation to user management service
        var result = await _userManagementService.CreateAdminAsync(request, cancellationToken);

        // Check if creation operation succeeded
        if (!result.Succeeded)
        {
            // Return 400 Bad Request with creation error details
            return BadRequest(result);
        }
        else
        {
            // Return 201 Created with the new administrator details
            return StatusCode(StatusCodes.Status201Created, result);
        }
    }

    /// <summary>
    /// Creates a new doctor account with profile, specializations, and phone numbers.
    /// </summary>
    /// <param name="request">The creation request data.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 201 Created response if successful.</returns>
    [HttpPost("doctors")]
    [Authorize(Roles = RoleConstants.Admin)]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> CreateDoctor(
        [FromBody] CreateDoctorRequest request,
        CancellationToken cancellationToken)
    {
        // Delegate doctor creation with profile attributes to service
        var result = await _userManagementService.CreateDoctorAsync(request, cancellationToken);

        // Check if creation operation succeeded
        if (!result.Succeeded)
        {
            // Return 400 Bad Request with validation and business rule errors
            return BadRequest(result);
        }
        else
        {
            // Return 201 Created with the new doctor details
            return StatusCode(StatusCodes.Status201Created, result);
        }
    }

    /// <summary>
    /// Creates a new receptionist account linked to the authenticated doctor.
    /// </summary>
    /// <param name="request">The creation request data.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 201 Created response if successful.</returns>
    [HttpPost("receptionists")]
    [Authorize(Roles = RoleConstants.Doctor)]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> CreateReceptionist(
        [FromBody] CreateStaffRequest request,
        CancellationToken cancellationToken)
    {
        // Delegate receptionist creation to user management service
        var result = await _userManagementService.CreateReceptionistAsync(request, cancellationToken);

        // Check if creation operation succeeded
        if (!result.Succeeded)
        {
            // Return 400 Bad Request with error details
            return BadRequest(result);
        }
        else
        {
            // Return 201 Created with the new receptionist details
            return StatusCode(StatusCodes.Status201Created, result);
        }
    }

    /// <summary>
    /// Retrieves a paginated list of users.
    /// </summary>
    /// <param name="queryParams">The query parameters for pagination and filtering.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A paginated list of users.</returns>
    [HttpGet]
    [Authorize]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> GetUsers(
        [FromQuery] UserQueryParameters queryParams,
        CancellationToken cancellationToken)
    {
        // Retrieve paginated users list from service
        var result = await _userManagementService.GetUsersAsync(queryParams, cancellationToken);

        // Return 200 OK with paginated user data
        return Ok(result);
    }

    /// <summary>
    /// Retrieves a user by their unique identifier.
    /// </summary>
    /// <param name="id">The user identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The user details if found.</returns>
    [HttpGet("{id}")]
    [Authorize]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetUserById(
        [FromRoute] Guid id,
        CancellationToken cancellationToken)
    {
        // Retrieve user information by identifier
        var result = await _userManagementService.GetUserByIdAsync(id, cancellationToken);

        // Evaluate whether user was found
        if (result == null)
        {
            // Return 404 Not Found if user does not exist or caller is unauthorized
            return NotFound();
        }
        else
        {
            // Return 200 OK with retrieved user details
            return Ok(result);
        }
    }

    /// <summary>
    /// Updates a user's basic profile information.
    /// </summary>
    /// <param name="id">The user identifier.</param>
    /// <param name="request">The update request data.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if successful.</returns>
    [HttpPut("{id}")]
    [Authorize]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> UpdateUser(
        [FromRoute] Guid id,
        [FromBody] UpdateUserRequest request,
        CancellationToken cancellationToken)
    {
        // Execute user profile update via service
        var result = await _userManagementService.UpdateUserAsync(id, request, cancellationToken);

        // Evaluate whether the update succeeded
        if (!result.Succeeded)
        {
            // Check for forbidden access error
            if (result.Errors.Any(e => e.Code == AuthenticationErrorCodes.Forbidden))
            {
                // Return 403 Forbidden when caller lacks permissions
                return Forbid();
            }
            else
            {
                // Return 400 Bad Request for validation or business rule failures
                return BadRequest(result);
            }
        }
        else
        {
            // Return 200 OK with updated result
            return Ok(result);
        }
    }

    /// <summary>
    /// Soft deletes a user.
    /// </summary>
    /// <param name="id">The user identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 204 No Content response if successful.</returns>
    [HttpDelete("{id}")]
    [Authorize]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> DeleteUser(
        [FromRoute] Guid id,
        CancellationToken cancellationToken)
    {
        // Execute soft delete for target user
        var result = await _userManagementService.DeleteUserAsync(id, cancellationToken);

        // Evaluate whether deletion succeeded
        if (!result.Succeeded)
        {
            // Check for forbidden access error
            if (result.Errors.Any(e => e.Code == AuthenticationErrorCodes.Forbidden))
            {
                // Return 403 Forbidden when caller cannot delete target user
                return Forbid();
            }
            else
            {
                // Return 400 Bad Request for deletion failure
                return BadRequest(result);
            }
        }
        else
        {
            // Return 204 No Content on successful deletion
            return NoContent();
        }
    }

    /// <summary>
    /// Soft deletes all users except the currently authenticated administrator.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 204 No Content response if successful.</returns>
    [HttpDelete]
    [Authorize(Roles = RoleConstants.Admin)]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> DeleteAllUsers(CancellationToken cancellationToken)
    {
        // Execute batch deletion of non-admin users
        var result = await _userManagementService.DeleteAllUsersAsync(cancellationToken);

        // Evaluate whether deletion succeeded
        if (!result.Succeeded)
        {
            // Check for forbidden access error
            if (result.Errors.Any(e => e.Code == AuthenticationErrorCodes.Forbidden))
            {
                // Return 403 Forbidden when caller lacks permissions
                return Forbid();
            }
            else
            {
                // Return 400 Bad Request for deletion errors
                return BadRequest(result);
            }
        }
        else
        {
            // Return 204 No Content on successful deletion
            return NoContent();
        }
    }
}
