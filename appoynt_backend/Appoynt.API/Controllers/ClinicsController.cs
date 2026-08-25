/**
 * File Name      : ClinicsController.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : IClinicService, CreateClinicRequest, UpdateClinicRequest, WorkingPeriodRequest, BreakRequest, ClinicPhoneNumberDto, RoleConstants
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Exposes REST API endpoints for clinic lifecycle management, working hours scheduling, breaks, contact numbers, receptionist assignment, and slot discovery.
 */

using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Application.Features.Clinics.Contracts;
using Appoynt.Domain.Common.Constants;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Appoynt.API.Controllers;

/// <summary>
/// Handles clinic management, weekly working schedules, breaks, phone numbers, and available slot discovery.
/// </summary>
[ApiController]
[Route("api/clinics")]
[Authorize]
public sealed class ClinicsController : ControllerBase
{
    #region Dependencies

    private readonly IClinicService _clinicService;

    #endregion

    #region Constructor

    /// <summary>
    /// Initializes a new instance of the <see cref="ClinicsController"/> class.
    /// </summary>
    /// <param name="clinicService">The clinic service.</param>
    public ClinicsController(IClinicService clinicService)
    {
        // Store the clinic service dependency.
        _clinicService = clinicService;
    }

    #endregion

    #region Clinic CRUD

    /// <summary>
    /// Creates a new clinic with optional phone numbers and working schedule for the authenticated doctor.
    /// </summary>
    /// <param name="request">The clinic creation request data.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 201 Created response if successful, or 400 Bad Request on failure.</returns>
    [HttpPost]
    [Authorize(Roles = RoleConstants.Doctor)]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> CreateClinic(
        [FromBody] CreateClinicRequest request,
        CancellationToken cancellationToken)
    {
        // Execute clinic creation via service.
        var result = await _clinicService.CreateClinicAsync(request, cancellationToken);

        // Check if operation succeeded.
        if (result.Succeeded)
        {
            // Return HTTP 201 Created with the created clinic ID payload.
            return StatusCode(StatusCodes.Status201Created, new { clinicId = result.ClinicId });
        }
        else
        {
            // Return HTTP 400 Bad Request with the list of error messages.
            return BadRequest(new { errors = result.Errors });
        }
    }

    /// <summary>
    /// Retrieves all clinics owned by the currently authenticated doctor.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response with the list of clinics.</returns>
    [HttpGet("my")]
    [Authorize(Roles = RoleConstants.Doctor)]
    [ProducesResponseType(typeof(List<ClinicResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> GetMyClinics(CancellationToken cancellationToken)
    {
        // Retrieve the authenticated doctor's clinics.
        var clinics = await _clinicService.GetMyClinicsAsync(cancellationToken);

        // Return HTTP 200 OK with the clinics list.
        return Ok(clinics);
    }

    /// <summary>
    /// Retrieves details of a specific clinic by its unique identifier.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if found, or 404 Not Found.</returns>
    [HttpGet("{clinicId:guid}")]
    [ProducesResponseType(typeof(ClinicResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetClinicById(
        [FromRoute] Guid clinicId,
        CancellationToken cancellationToken)
    {
        // Fetch the clinic details via service.
        var clinic = await _clinicService.GetClinicByIdAsync(clinicId, cancellationToken);

        // Verify if clinic exists.
        if (clinic == null)
        {
            // Return HTTP 404 Not Found if clinic does not exist.
            return NotFound();
        }
        else
        {
            // Return HTTP 200 OK with the clinic data.
            return Ok(clinic);
        }
    }

    /// <summary>
    /// Updates general information and booking settings for an owned clinic.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="request">The clinic update request data.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if successful, or 400 Bad Request.</returns>
    [HttpPut("{clinicId:guid}")]
    [Authorize(Roles = RoleConstants.Doctor)]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> UpdateClinic(
        [FromRoute] Guid clinicId,
        [FromBody] UpdateClinicRequest request,
        CancellationToken cancellationToken)
    {
        // Execute clinic update via service.
        var result = await _clinicService.UpdateClinicAsync(clinicId, request, cancellationToken);

        // Check if operation succeeded.
        if (result.Succeeded)
        {
            // Return HTTP 200 OK with success confirmation.
            return Ok(new { clinicId });
        }
        else
        {
            // Return HTTP 400 Bad Request with the list of error messages.
            return BadRequest(new { errors = result.Errors });
        }
    }

    /// <summary>
    /// Soft deletes a clinic owned by the authenticated doctor.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if successful, or 400 Bad Request.</returns>
    [HttpDelete("{clinicId:guid}")]
    [Authorize(Roles = RoleConstants.Doctor)]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> DeleteClinic(
        [FromRoute] Guid clinicId,
        CancellationToken cancellationToken)
    {
        // Execute clinic deletion via service.
        var result = await _clinicService.DeleteClinicAsync(clinicId, cancellationToken);

        // Check if operation succeeded.
        if (result.Succeeded)
        {
            // Return HTTP 200 OK with confirmation.
            return Ok(new { clinicId });
        }
        else
        {
            // Return HTTP 400 Bad Request with error list.
            return BadRequest(new { errors = result.Errors });
        }
    }

    #endregion

    #region Phone Numbers

    /// <summary>
    /// Adds an additional contact phone number to the specified clinic.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="dto">The phone number data.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if successful, or 400 Bad Request.</returns>
    [HttpPost("{clinicId:guid}/phone-numbers")]
    [Authorize(Roles = RoleConstants.Doctor)]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> AddPhoneNumber(
        [FromRoute] Guid clinicId,
        [FromBody] ClinicPhoneNumberDto dto,
        CancellationToken cancellationToken)
    {
        // Execute phone number addition via service.
        var result = await _clinicService.AddPhoneNumberAsync(clinicId, dto, cancellationToken);

        // Check if operation succeeded.
        if (result.Succeeded)
        {
            // Return HTTP 200 OK.
            return Ok(new { clinicId });
        }
        else
        {
            // Return HTTP 400 Bad Request with error list.
            return BadRequest(new { errors = result.Errors });
        }
    }

    /// <summary>
    /// Removes a contact phone number from the specified clinic.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="phoneNumberId">The unique identifier of the phone number entity.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if successful, or 400 Bad Request.</returns>
    [HttpDelete("{clinicId:guid}/phone-numbers/{phoneNumberId:guid}")]
    [Authorize(Roles = RoleConstants.Doctor)]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> RemovePhoneNumber(
        [FromRoute] Guid clinicId,
        [FromRoute] Guid phoneNumberId,
        CancellationToken cancellationToken)
    {
        // Execute phone number removal via service.
        var result = await _clinicService.RemovePhoneNumberAsync(clinicId, phoneNumberId, cancellationToken);

        // Check if operation succeeded.
        if (result.Succeeded)
        {
            // Return HTTP 200 OK.
            return Ok(new { clinicId, phoneNumberId });
        }
        else
        {
            // Return HTTP 400 Bad Request with error list.
            return BadRequest(new { errors = result.Errors });
        }
    }

    #endregion

    #region Working Periods

    /// <summary>
    /// Adds a weekly working period to the specified clinic schedule.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="request">The working period details.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if successful, or 400 Bad Request.</returns>
    [HttpPost("{clinicId:guid}/working-periods")]
    [Authorize(Roles = RoleConstants.Doctor)]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> AddWorkingPeriod(
        [FromRoute] Guid clinicId,
        [FromBody] WorkingPeriodRequest request,
        CancellationToken cancellationToken)
    {
        // Execute working period addition via service.
        var result = await _clinicService.AddWorkingPeriodAsync(clinicId, request, cancellationToken);

        // Check if operation succeeded.
        if (result.Succeeded)
        {
            // Return HTTP 200 OK.
            return Ok(new { clinicId });
        }
        else
        {
            // Return HTTP 400 Bad Request with error list.
            return BadRequest(new { errors = result.Errors });
        }
    }

    /// <summary>
    /// Updates an existing working period in the specified clinic schedule.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="periodId">The unique identifier of the working period.</param>
    /// <param name="request">The updated working period details.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if successful, or 400 Bad Request.</returns>
    [HttpPut("{clinicId:guid}/working-periods/{periodId:guid}")]
    [Authorize(Roles = RoleConstants.Doctor)]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> UpdateWorkingPeriod(
        [FromRoute] Guid clinicId,
        [FromRoute] Guid periodId,
        [FromBody] WorkingPeriodRequest request,
        CancellationToken cancellationToken)
    {
        // Execute working period update via service.
        var result = await _clinicService.UpdateWorkingPeriodAsync(clinicId, periodId, request, cancellationToken);

        // Check if operation succeeded.
        if (result.Succeeded)
        {
            // Return HTTP 200 OK.
            return Ok(new { clinicId, periodId });
        }
        else
        {
            // Return HTTP 400 Bad Request with error list.
            return BadRequest(new { errors = result.Errors });
        }
    }

    /// <summary>
    /// Deletes a working period from the specified clinic schedule.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="periodId">The unique identifier of the working period.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if successful, or 400 Bad Request.</returns>
    [HttpDelete("{clinicId:guid}/working-periods/{periodId:guid}")]
    [Authorize(Roles = RoleConstants.Doctor)]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> DeleteWorkingPeriod(
        [FromRoute] Guid clinicId,
        [FromRoute] Guid periodId,
        CancellationToken cancellationToken)
    {
        // Execute working period deletion via service.
        var result = await _clinicService.DeleteWorkingPeriodAsync(clinicId, periodId, cancellationToken);

        // Check if operation succeeded.
        if (result.Succeeded)
        {
            // Return HTTP 200 OK.
            return Ok(new { clinicId, periodId });
        }
        else
        {
            // Return HTTP 400 Bad Request with error list.
            return BadRequest(new { errors = result.Errors });
        }
    }

    #endregion

    #region Breaks

    /// <summary>
    /// Adds a break to an existing working period.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="periodId">The unique identifier of the working period.</param>
    /// <param name="request">The break details.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if successful, or 400 Bad Request.</returns>
    [HttpPost("{clinicId:guid}/working-periods/{periodId:guid}/breaks")]
    [Authorize(Roles = RoleConstants.Doctor)]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> AddBreak(
        [FromRoute] Guid clinicId,
        [FromRoute] Guid periodId,
        [FromBody] BreakRequest request,
        CancellationToken cancellationToken)
    {
        // Execute break addition via service.
        var result = await _clinicService.AddBreakAsync(clinicId, periodId, request, cancellationToken);

        // Check if operation succeeded.
        if (result.Succeeded)
        {
            // Return HTTP 200 OK.
            return Ok(new { clinicId, periodId });
        }
        else
        {
            // Return HTTP 400 Bad Request with error list.
            return BadRequest(new { errors = result.Errors });
        }
    }

    /// <summary>
    /// Removes a break from a clinic working period.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="breakId">The unique identifier of the break.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if successful, or 400 Bad Request.</returns>
    [HttpDelete("{clinicId:guid}/breaks/{breakId:guid}")]
    [Authorize(Roles = RoleConstants.Doctor)]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> RemoveBreak(
        [FromRoute] Guid clinicId,
        [FromRoute] Guid breakId,
        CancellationToken cancellationToken)
    {
        // Execute break removal via service.
        var result = await _clinicService.RemoveBreakAsync(clinicId, breakId, cancellationToken);

        // Check if operation succeeded.
        if (result.Succeeded)
        {
            // Return HTTP 200 OK.
            return Ok(new { clinicId, breakId });
        }
        else
        {
            // Return HTTP 400 Bad Request with error list.
            return BadRequest(new { errors = result.Errors });
        }
    }

    #endregion

    #region Receptionist Assignment

    /// <summary>
    /// Assigns a receptionist to the specified clinic. The receptionist must belong to the same doctor.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="receptionistId">The unique identifier of the receptionist.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if successful, or 400 Bad Request.</returns>
    [HttpPost("{clinicId:guid}/receptionists/{receptionistId:guid}")]
    [Authorize(Roles = RoleConstants.Doctor)]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> AssignReceptionist(
        [FromRoute] Guid clinicId,
        [FromRoute] Guid receptionistId,
        CancellationToken cancellationToken)
    {
        // Execute receptionist assignment via service.
        var result = await _clinicService.AssignReceptionistAsync(clinicId, receptionistId, cancellationToken);

        // Check if operation succeeded.
        if (result.Succeeded)
        {
            // Return HTTP 200 OK.
            return Ok(new { clinicId, receptionistId });
        }
        else
        {
            // Return HTTP 400 Bad Request with error list.
            return BadRequest(new { errors = result.Errors });
        }
    }

    /// <summary>
    /// Removes a receptionist assignment from the specified clinic.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="receptionistId">The unique identifier of the receptionist.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response if successful, or 400 Bad Request.</returns>
    [HttpDelete("{clinicId:guid}/receptionists/{receptionistId:guid}")]
    [Authorize(Roles = RoleConstants.Doctor)]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> RemoveReceptionist(
        [FromRoute] Guid clinicId,
        [FromRoute] Guid receptionistId,
        CancellationToken cancellationToken)
    {
        // Execute receptionist removal via service.
        var result = await _clinicService.RemoveReceptionistAsync(clinicId, receptionistId, cancellationToken);

        // Check if operation succeeded.
        if (result.Succeeded)
        {
            // Return HTTP 200 OK.
            return Ok(new { clinicId, receptionistId });
        }
        else
        {
            // Return HTTP 400 Bad Request with error list.
            return BadRequest(new { errors = result.Errors });
        }
    }

    #endregion

    #region Slots Discovery

    /// <summary>
    /// Retrieves available appointment slots for a clinic on a specific date.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="date">The target date (yyyy-MM-dd).</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An HTTP 200 OK response with the list of available slots.</returns>
    [HttpGet("{clinicId:guid}/slots")]
    [ProducesResponseType(typeof(List<SlotResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> GetAvailableSlots(
        [FromRoute] Guid clinicId,
        [FromQuery] DateOnly date,
        CancellationToken cancellationToken)
    {
        // Retrieve available slots for the clinic on the requested date.
        var slots = await _clinicService.GetAvailableSlotsAsync(clinicId, date, cancellationToken);

        // Return HTTP 200 OK with the retrieved slots list.
        return Ok(slots);
    }

    #endregion
}
