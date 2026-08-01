/**
 * File Name      : UsersController.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 28/07/2026
 * Version        : v1.0.0
 * Dependencies   : ASP.NET Core MVC, IUserManagementService
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 31/07/2026
 * Description    : Exposes endpoints for managing internal staff users.
 */

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
        var result = await _userManagementService.CreateAdminAsync(request, cancellationToken);

        if (!result.Succeeded)
        {
            return BadRequest(result);
        }
        else
        {
        }

        return StatusCode(StatusCodes.Status201Created, result);
    }

    /// <summary>
    /// Creates a new doctor account.
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
        [FromBody] CreateStaffRequest request,
        CancellationToken cancellationToken)
    {
        var result = await _userManagementService.CreateDoctorAsync(request, cancellationToken);

        if (!result.Succeeded)
        {
            return BadRequest(result);
        }
        else
        {
        }

        return StatusCode(StatusCodes.Status201Created, result);
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
        var result = await _userManagementService.CreateReceptionistAsync(request, cancellationToken);

        if (!result.Succeeded)
        {
            return BadRequest(result);
        }
        else
        {
        }

        return StatusCode(StatusCodes.Status201Created, result);
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
        // Delegate to the service layer for paginated, filtered user retrieval.
        var result = await _userManagementService.GetUsersAsync(queryParams, cancellationToken);

        // Return the paginated response.
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
        // Delegate to the service layer for authorized user retrieval.
        var result = await _userManagementService.GetUserByIdAsync(id, cancellationToken);
        
        // Return 404 when the user is not found or not accessible.
        if (result == null)
        {
            return NotFound();
        }
        else
        {
        }

        // Return the user details.
        return Ok(result);
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
        // Delegate to the service layer for authorized profile update.
        var result = await _userManagementService.UpdateUserAsync(id, request, cancellationToken);

        // Handle service-level failures.
        if (!result.Succeeded)
        {
            // Return 403 Forbidden when the caller lacks authorization.
            if (result.Errors.Any(e => e.Code == AuthenticationErrorCodes.Forbidden))
            {
                return Forbid();
            }
            else
            {
            }

            // Return 400 Bad Request for validation or business-rule failures.
            return BadRequest(result);
        }
        else
        {
        }

        // Return the successful update result.
        return Ok(result);
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
        // Delegate to the service layer for authorized soft-delete.
        var result = await _userManagementService.DeleteUserAsync(id, cancellationToken);

        // Handle service-level failures.
        if (!result.Succeeded)
        {
            // Return 403 Forbidden when the caller lacks authorization.
            if (result.Errors.Any(e => e.Code == AuthenticationErrorCodes.Forbidden))
            {
                return Forbid();
            }
            else
            {
            }

            // Return 400 Bad Request for validation or business-rule failures.
            return BadRequest(result);
        }
        else
        {
        }

        // Return 204 No Content on successful soft-delete.
        return NoContent();
    }
}
