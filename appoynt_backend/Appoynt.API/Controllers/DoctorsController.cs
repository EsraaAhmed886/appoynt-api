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
using System.Collections.Generic;
using Appoynt.Application.Features.Clinics.Contracts;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Appoynt.API.Controllers;

/// <summary>
/// Handles doctor operations including profile picture upload, public retrieval, deletion, and clinic listing.
/// </summary>
[ApiController]
[Route("api/doctors")]
public sealed class DoctorsController : ControllerBase
{
    private readonly IProfileImageService _profileImageService;
    private readonly IClinicService _clinicService;
    private readonly ICurrentUserService _currentUserService;
    private readonly ApplicationDbContext _dbContext;

    /// <summary>
    /// Initializes a new instance of the <see cref="DoctorsController"/> class.
    /// </summary>
    /// <param name="profileImageService">The centralized profile image service.</param>
    /// <param name="clinicService">The clinic service.</param>
    /// <param name="currentUserService">The current authenticated user accessor.</param>
    /// <param name="dbContext">The application database context.</param>
    public DoctorsController(
        IProfileImageService profileImageService,
        IClinicService clinicService,
        ICurrentUserService currentUserService,
        ApplicationDbContext dbContext)
    {
        // Store profile image service dependency
        _profileImageService = profileImageService;

        // Store clinic service dependency
        _clinicService = clinicService;

        // Store current user service dependency
        _currentUserService = currentUserService;

        // Store database context dependency
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
        // Validate that an image file was supplied and is non-empty
        if (file == null || file.Length == 0)
        {
            // Return 400 Bad Request when file is missing or empty
            return BadRequest(new[] { new AuthenticationError(ProfileImageErrorCodes.Empty, "file") });
        }
        else
        {
            // Retrieve authenticated doctor user identifier
            Guid? userId = _currentUserService.UserId;

            // Verify user identifier from authentication context
            if (userId == null)
            {
                // Return 401 Unauthorized if user is not authenticated
                return Unauthorized();
            }
            else
            {
                // Open read stream for incoming file data
                await using var stream = file.OpenReadStream();

                // Delegate photo processing, compression, and persistence to service
                var result = await _profileImageService.UploadProfileImageAsync(
                    userId.Value,
                    stream,
                    file.FileName,
                    file.Length,
                    cancellationToken);

                // Check if photo upload and compression succeeded
                if (!result.Succeeded)
                {
                    // Return 400 Bad Request with processing error details
                    return BadRequest(result.Errors);
                }
                else
                {
                    // Return 200 OK upon successful photo upload and compression
                    return Ok(result);
                }
            }
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
        // Look up the doctor entity to resolve associated ApplicationUser identifier
        Doctor? doctor = await _dbContext.Doctors
            .AsNoTracking()
            .FirstOrDefaultAsync(d => d.Id == doctorId, cancellationToken);

        // Verify if doctor entity was located
        if (doctor == null)
        {
            // Return 404 Not Found when doctor does not exist
            return NotFound();
        }
        else
        {
            // Retrieve profile photo stream for doctor's user account
            var photo = await _profileImageService.GetProfileImageAsync(doctor.UserId, cancellationToken);

            // Verify if photo was located and stream is accessible
            if (photo == null || photo.Value.Stream == null)
            {
                // Return 404 Not Found if photo is not set or missing
                return NotFound();
            }
            else
            {
                // Return JPEG image file stream with appropriate content type
                return File(photo.Value.Stream, photo.Value.ContentType);
            }
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
        // Retrieve authenticated doctor user identifier
        Guid? userId = _currentUserService.UserId;

        // Verify user identifier from authentication context
        if (userId == null)
        {
            // Return 401 Unauthorized if user is not authenticated
            return Unauthorized();
        }
        else
        {
            // Delegate photo deletion to centralized profile image service
            var result = await _profileImageService.DeleteProfileImageAsync(userId.Value, cancellationToken);

            // Check if deletion operation succeeded
            if (!result.Succeeded)
            {
                // Return 400 Bad Request with deletion error details
                return BadRequest(result.Errors);
            }
            else
            {
                // Return 200 OK upon successful photo deletion
                return Ok(result);
            }
        }
    }

    #endregion

    #region Clinic Operations

    /// <summary>
    /// Retrieves all active clinics for a specific doctor. Open to all authenticated users.
    /// </summary>
    /// <param name="doctorId">The unique identifier of the doctor.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response with the list of active clinics.</returns>
    [HttpGet("{doctorId:guid}/clinics")]
    [Authorize]
    [ProducesResponseType(typeof(List<ClinicResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> GetDoctorClinics(
        [FromRoute] Guid doctorId,
        CancellationToken cancellationToken)
    {
        // Retrieve active clinics for the requested doctor.
        var clinics = await _clinicService.GetDoctorClinicsAsync(doctorId, cancellationToken);

        // Return HTTP 200 OK with the retrieved clinics list.
        return Ok(clinics);
    }

    #endregion
}
