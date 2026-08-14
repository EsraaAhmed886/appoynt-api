/**
 * File Name      : DoctorsController.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : ASP.NET Core MVC, IProfileImageService, ICurrentUserService, ApplicationDbContext, RoleConstants, ProfileImageErrorCodes
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Exposes REST API endpoints for doctor profile photo upload, retrieval, and deletion operations.
 */

using System;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Application.Common.Models;
using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Appoynt.API.Controllers;

/// <summary>
/// Handles doctor operations including profile picture upload, public retrieval, and deletion.
/// </summary>
[ApiController]
[Route("api/doctors")]
public sealed class DoctorsController : ControllerBase
{
    private readonly IProfileImageService _profileImageService;
    private readonly ICurrentUserService _currentUserService;
    private readonly ApplicationDbContext _dbContext;

    /// <summary>
    /// Initializes a new instance of the <see cref="DoctorsController"/> class.
    /// </summary>
    /// <param name="profileImageService">The centralized profile image service.</param>
    /// <param name="currentUserService">The current authenticated user accessor.</param>
    /// <param name="dbContext">The application database context.</param>
    public DoctorsController(
        IProfileImageService profileImageService,
        ICurrentUserService currentUserService,
        ApplicationDbContext dbContext)
    {
        _profileImageService = profileImageService;
        _currentUserService = currentUserService;
        _dbContext = dbContext;
    }

    #region Profile Photo Operations

    /// <summary>
    /// Uploads or replaces the profile picture for the currently authenticated doctor.
    /// </summary>
    /// <param name="file">The uploaded image file (JPEG, PNG, or WebP up to 10 MB).</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if successful, or validation errors.</returns>
    [HttpPost("profile-photo")]
    [Authorize(Roles = RoleConstants.Doctor)]
    [Consumes("multipart/form-data")]
    [ProducesResponseType(typeof(ProfileImageResult), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> UploadProfilePhoto(
        IFormFile file,
        CancellationToken cancellationToken)
    {
        // Validate that a non-empty file was provided.
        if (file == null || file.Length == 0)
        {
            return BadRequest(new[] { new AuthenticationError(ProfileImageErrorCodes.Empty, "file") });
        }
        else
        {
            // Proceed with upload.
        }

        // Retrieve current authenticated doctor's user ID.
        Guid? userId = _currentUserService.UserId;
        if (userId == null)
        {
            return Unauthorized();
        }
        else
        {
            // User ID verified.
        }

        // Open read stream for the uploaded file.
        await using var stream = file.OpenReadStream();

        // Delegate upload and image processing to the centralized profile image service.
        var result = await _profileImageService.UploadProfileImageAsync(
            userId.Value,
            stream,
            file.FileName,
            file.Length,
            cancellationToken);

        if (!result.Succeeded)
        {
            return BadRequest(result.Errors);
        }
        else
        {
            return Ok(result);
        }
    }

    /// <summary>
    /// Retrieves the profile picture for the specified doctor. Open to all authenticated users.
    /// </summary>
    /// <param name="doctorId">The unique identifier of the doctor.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The JPEG image stream if found.</returns>
    [HttpGet("{doctorId:guid}/profile-photo")]
    [Authorize]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetProfilePhoto(
        Guid doctorId,
        CancellationToken cancellationToken)
    {
        // Look up the doctor entity to resolve their associated ApplicationUser ID.
        Doctor? doctor = await _dbContext.Doctors
            .AsNoTracking()
            .FirstOrDefaultAsync(d => d.Id == doctorId, cancellationToken);

        if (doctor == null)
        {
            return NotFound();
        }
        else
        {
            // Doctor found.
        }

        // Retrieve the profile image stream for the doctor's user account.
        var photo = await _profileImageService.GetProfileImageAsync(doctor.UserId, cancellationToken);

        if (photo == null || photo.Value.Stream == null)
        {
            return NotFound();
        }
        else
        {
            return File(photo.Value.Stream, photo.Value.ContentType);
        }
    }

    /// <summary>
    /// Deletes the profile picture of the currently authenticated doctor.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if deleted successfully.</returns>
    [HttpDelete("profile-photo")]
    [Authorize(Roles = RoleConstants.Doctor)]
    [ProducesResponseType(typeof(ProfileImageResult), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> DeleteProfilePhoto(CancellationToken cancellationToken)
    {
        // Retrieve current authenticated doctor's user ID.
        Guid? userId = _currentUserService.UserId;
        if (userId == null)
        {
            return Unauthorized();
        }
        else
        {
            // User ID verified.
        }

        // Delegate deletion to the centralized profile image service.
        var result = await _profileImageService.DeleteProfileImageAsync(userId.Value, cancellationToken);

        if (!result.Succeeded)
        {
            return BadRequest(result.Errors);
        }
        else
        {
            return Ok(result);
        }
    }

    #endregion
}
