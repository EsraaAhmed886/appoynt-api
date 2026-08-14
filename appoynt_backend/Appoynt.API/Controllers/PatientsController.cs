/**
 * File Name      : PatientsController.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : ASP.NET Core MVC, IPatientService, RoleConstants, ProfileImageErrorCodes, PatientResult
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Exposes REST API endpoints for patient profile management,
 *                  profile photo upload/retrieval/deletion, and family member CRUD operations.
 */

using System;
using System.Collections.Generic;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Patient;
using Appoynt.Application.Features.Patient.Contracts;
using Appoynt.Domain.Common.Constants;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Appoynt.API.Controllers;

/// <summary>
/// Handles patient profile and family member management operations.
/// </summary>
[ApiController]
[Route("api/patients")]
[Authorize(Roles = RoleConstants.Patient)]
public sealed class PatientsController : ControllerBase
{
    private readonly IPatientService _patientService;

    /// <summary>
    /// Initializes a new instance of the <see cref="PatientsController"/> class.
    /// </summary>
    /// <param name="patientService">The patient application service.</param>
    public PatientsController(IPatientService patientService)
    {
        // Store patient service dependency
        _patientService = patientService;
    }

    #region Profile Management

    /// <summary>
    /// Retrieves the profile details of the currently authenticated patient.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The patient profile details if found.</returns>
    [HttpGet("profile")]
    [ProducesResponseType(typeof(PatientProfileResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetProfile(CancellationToken cancellationToken)
    {
        // Retrieve patient profile via application service
        var profile = await _patientService.GetProfileAsync(cancellationToken);

        // Check if profile exists for the current user
        if (profile == null)
        {
            // Return 404 Not Found if profile does not exist
            return NotFound();
        }
        else
        {
            // Return 200 OK with patient profile data
            return Ok(profile);
        }
    }

    /// <summary>
    /// Updates the profile information of the currently authenticated patient.
    /// </summary>
    /// <param name="request">The update payload.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if successful, or validation errors.</returns>
    [HttpPut("profile")]
    [ProducesResponseType(typeof(PatientResult), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> UpdateProfile(
        [FromBody] UpdatePatientProfileRequest request,
        CancellationToken cancellationToken)
    {
        // Execute profile update operation via application service
        var result = await _patientService.UpdateProfileAsync(request, cancellationToken);

        // Evaluate whether the update operation succeeded
        if (!result.Succeeded)
        {
            // Return 400 Bad Request with validation and business rule errors
            return BadRequest(result.Errors);
        }
        else
        {
            // Return 200 OK on successful profile update
            return Ok(result);
        }
    }

    #endregion

    #region Profile Photo

    /// <summary>
    /// Uploads or replaces the profile photo for the currently authenticated patient.
    /// </summary>
    /// <param name="file">The uploaded image file (JPEG, PNG, or WebP up to 10 MB).</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if successful.</returns>
    [HttpPost("profile-photo")]
    [Consumes("multipart/form-data")]
    [ProducesResponseType(typeof(PatientResult), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> UploadProfilePhoto(
        IFormFile file,
        CancellationToken cancellationToken)
    {
        // Validate that an image file was supplied and is non-empty
        if (file == null || file.Length == 0)
        {
            // Return 400 Bad Request if file payload is empty
            var emptyFileErrors = new[] { new AuthenticationError(ProfileImageErrorCodes.Empty, "file") };
            return BadRequest(emptyFileErrors);
        }
        else
        {
            // Open read stream for incoming file data
            await using var stream = file.OpenReadStream();

            // Delegate photo processing, compression, and persistence to service
            var result = await _patientService.UploadProfilePhotoAsync(
                stream,
                file.FileName,
                file.Length,
                cancellationToken);

            // Check if photo upload succeeded
            if (!result.Succeeded)
            {
                // Return 400 Bad Request with processing errors
                return BadRequest(result.Errors);
            }
            else
            {
                // Return 200 OK upon successful photo upload and compression
                return Ok(result);
            }
        }
    }

    /// <summary>
    /// Retrieves the profile photo image for a specified patient.
    /// </summary>
    /// <param name="patientId">The unique identifier of the patient.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The image stream with appropriate MIME content type.</returns>
    [HttpGet("{patientId:guid}/profile-photo")]
    [Authorize] // Allow Patients or Admins based on service authorization logic
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetProfilePhoto(
        Guid patientId,
        CancellationToken cancellationToken)
    {
        // Retrieve photo stream and content type from service
        var photo = await _patientService.GetProfilePhotoAsync(patientId, cancellationToken);

        // Verify if photo was located and stream is accessible
        if (photo == null || photo.Value.Stream == null)
        {
            // Return 404 Not Found when photo does not exist
            return NotFound();
        }
        else
        {
            // Return image file stream with appropriate content type
            return File(photo.Value.Stream, photo.Value.ContentType);
        }
    }

    /// <summary>
    /// Deletes the profile photo of the currently authenticated patient.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if deleted.</returns>
    [HttpDelete("profile-photo")]
    [ProducesResponseType(typeof(PatientResult), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> DeleteProfilePhoto(CancellationToken cancellationToken)
    {
        // Execute profile photo deletion via application service
        var result = await _patientService.DeleteProfilePhotoAsync(cancellationToken);

        // Check if deletion operation succeeded
        if (!result.Succeeded)
        {
            // Return 400 Bad Request with deletion error details
            return BadRequest(result.Errors);
        }
        else
        {
            // Return 200 OK on successful photo removal
            return Ok(result);
        }
    }

    #endregion

    #region Family Members

    /// <summary>
    /// Retrieves all family members linked to the currently authenticated patient.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A list of family member records.</returns>
    [HttpGet("family-members")]
    [ProducesResponseType(typeof(IReadOnlyList<FamilyMemberResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> GetFamilyMembers(CancellationToken cancellationToken)
    {
        // Retrieve family members linked to the patient
        var members = await _patientService.GetFamilyMembersAsync(cancellationToken);

        // Return 200 OK with family member collection
        return Ok(members);
    }

    /// <summary>
    /// Retrieves a specific family member by unique identifier.
    /// </summary>
    /// <param name="id">The unique identifier of the family member.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The family member details if found.</returns>
    [HttpGet("family-members/{id:guid}")]
    [ProducesResponseType(typeof(FamilyMemberResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetFamilyMemberById(
        Guid id,
        CancellationToken cancellationToken)
    {
        // Retrieve family member details by identifier
        var member = await _patientService.GetFamilyMemberByIdAsync(id, cancellationToken);

        // Verify if family member was found
        if (member == null)
        {
            // Return 404 Not Found if member does not exist or belong to caller
            return NotFound();
        }
        else
        {
            // Return 200 OK with family member details
            return Ok(member);
        }
    }

    /// <summary>
    /// Adds a new family member under the currently authenticated patient's account.
    /// </summary>
    /// <param name="request">The family member details.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if added successfully.</returns>
    [HttpPost("family-members")]
    [ProducesResponseType(typeof(PatientResult), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> AddFamilyMember(
        [FromBody] AddFamilyMemberRequest request,
        CancellationToken cancellationToken)
    {
        // Execute family member addition via application service
        var result = await _patientService.AddFamilyMemberAsync(request, cancellationToken);

        // Evaluate whether the addition succeeded
        if (!result.Succeeded)
        {
            // Return 400 Bad Request with validation errors
            return BadRequest(result.Errors);
        }
        else
        {
            // Return 200 OK on successful addition
            return Ok(result);
        }
    }

    /// <summary>
    /// Updates an existing family member's information.
    /// </summary>
    /// <param name="id">The unique identifier of the family member.</param>
    /// <param name="request">The update payload.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if updated successfully.</returns>
    [HttpPut("family-members/{id:guid}")]
    [ProducesResponseType(typeof(PatientResult), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> UpdateFamilyMember(
        Guid id,
        [FromBody] UpdateFamilyMemberRequest request,
        CancellationToken cancellationToken)
    {
        // Execute family member update operation
        var result = await _patientService.UpdateFamilyMemberAsync(id, request, cancellationToken);

        // Check if update operation succeeded
        if (!result.Succeeded)
        {
            // Return 400 Bad Request with validation errors
            return BadRequest(result.Errors);
        }
        else
        {
            // Return 200 OK on successful update
            return Ok(result);
        }
    }

    /// <summary>
    /// Deletes a family member from the patient's account.
    /// </summary>
    /// <param name="id">The unique identifier of the family member to remove.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if deleted successfully.</returns>
    [HttpDelete("family-members/{id:guid}")]
    [ProducesResponseType(typeof(PatientResult), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> DeleteFamilyMember(
        Guid id,
        CancellationToken cancellationToken)
    {
        // Execute family member soft deletion
        var result = await _patientService.DeleteFamilyMemberAsync(id, cancellationToken);

        // Check if deletion operation succeeded
        if (!result.Succeeded)
        {
            // Return 400 Bad Request with deletion errors
            return BadRequest(result.Errors);
        }
        else
        {
            // Return 200 OK on successful deletion
            return Ok(result);
        }
    }

    #endregion
}
