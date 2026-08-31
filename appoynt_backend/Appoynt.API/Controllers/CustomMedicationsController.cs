/**
 * File Name      : CustomMedicationsController.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : ASP.NET Core MVC, ICustomMedicationService, MedicalRecords Contracts
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Exposes endpoints for doctor custom unlisted medication requests
 *                  and administrative catalog approval/merge workflows.
 */

using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Features.MedicalRecords;
using Appoynt.Application.Features.MedicalRecords.Contracts;
using Appoynt.Domain.Common.Constants;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Appoynt.API.Controllers;

/// <summary>
/// Handles custom medication requests and administrative approvals.
/// </summary>
[ApiController]
[Route("api/custom-medications")]
public sealed class CustomMedicationsController : ControllerBase
{
    private readonly ICustomMedicationService _customMedicationService;

    /// <summary>
    /// Initializes a new instance of the <see cref="CustomMedicationsController"/> class.
    /// </summary>
    /// <param name="customMedicationService">The custom medication application service.</param>
    public CustomMedicationsController(ICustomMedicationService customMedicationService)
    {
        _customMedicationService = customMedicationService;
    }

    /// <summary>
    /// Creates a custom unlisted medication for immediate prescribing by the calling doctor.
    /// </summary>
    /// <param name="request">The creation request payload.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The created custom medication details.</returns>
    [HttpPost]
    [Authorize(Roles = RoleConstants.Doctor)]
    [ProducesResponseType(typeof(CustomMedicationResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> CreateCustomMedication([FromBody] CreateCustomMedicationRequestDto request, CancellationToken cancellationToken)
    {
        var result = await _customMedicationService.CreateCustomMedicationAsync(request, cancellationToken);
        if (result == null)
        {
            return BadRequest();
        }
        else
        {
            return Ok(result);
        }
    }

    /// <summary>
    /// Gets all custom medications created by the calling doctor.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The collection of custom medications.</returns>
    [HttpGet("my")]
    [Authorize(Roles = RoleConstants.Doctor)]
    [ProducesResponseType(typeof(IReadOnlyList<CustomMedicationResponseDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetDoctorCustomMedications(CancellationToken cancellationToken)
    {
        var result = await _customMedicationService.GetDoctorCustomMedicationsAsync(cancellationToken);
        return Ok(result);
    }

    /// <summary>
    /// Gets all pending custom medication requests awaiting administrative review.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The list of pending requests.</returns>
    [HttpGet("pending")]
    [Authorize(Roles = RoleConstants.Admin)]
    [ProducesResponseType(typeof(IReadOnlyList<CustomMedicationResponseDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetPendingAdminRequests(CancellationToken cancellationToken)
    {
        var result = await _customMedicationService.GetPendingAdminRequestsAsync(cancellationToken);
        return Ok(result);
    }

    /// <summary>
    /// Approves a custom medication and merges it into the global medication catalog.
    /// </summary>
    /// <param name="id">The custom medication request identifier.</param>
    /// <param name="request">The approved catalog details.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>NoContent on success, or 400/404.</returns>
    [HttpPut("{id:guid}/approve")]
    [Authorize(Roles = RoleConstants.Admin)]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> ApproveCustomMedication(Guid id, [FromBody] ApproveCustomMedicationRequest request, CancellationToken cancellationToken)
    {
        bool success = await _customMedicationService.ApproveCustomMedicationAsync(id, request, cancellationToken);
        if (!success)
        {
            return NotFound();
        }
        else
        {
            return NoContent();
        }
    }

    /// <summary>
    /// Rejects a custom medication request.
    /// </summary>
    /// <param name="id">The custom medication request identifier.</param>
    /// <param name="reason">Optional administrative reason.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>NoContent on success, or 404.</returns>
    [HttpPut("{id:guid}/reject")]
    [Authorize(Roles = RoleConstants.Admin)]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> RejectCustomMedication(Guid id, [FromQuery] string? reason, CancellationToken cancellationToken)
    {
        bool success = await _customMedicationService.RejectCustomMedicationAsync(id, reason, cancellationToken);
        if (!success)
        {
            return NotFound();
        }
        else
        {
            return NoContent();
        }
    }
}
