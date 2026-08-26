/**
 * File Name      : DoctorAppointmentsController.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : ASP.NET Core MVC, IDoctorAppointmentsService
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-26
 * Description    : Exposes the doctor appointments screen endpoints: today's
 *                  current patient and queue, the day slot panel, calendar
 *                  dates, and the start/end consultation lifecycle actions.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Features.Booking.Contracts;
using Appoynt.Application.Features.DoctorAppointments;
using Appoynt.Application.Features.DoctorAppointments.Contracts;
using Appoynt.Domain.Common.Constants;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Appoynt.API.Controllers;

/// <summary>
/// Handles the doctor's appointments screen operations for the authenticated doctor.
/// </summary>
[ApiController]
[Route("api/doctor/appointments")]
[Authorize(Roles = RoleConstants.Doctor)]
public sealed class DoctorAppointmentsController : ControllerBase
{
    private readonly IDoctorAppointmentsService _appointmentsService;

    /// <summary>
    /// Initializes a new instance of the <see cref="DoctorAppointmentsController"/> class.
    /// </summary>
    /// <param name="appointmentsService">The doctor appointments application service.</param>
    public DoctorAppointmentsController(IDoctorAppointmentsService appointmentsService)
    {
        _appointmentsService = appointmentsService;
    }

    /// <summary>
    /// Gets today's current in-consultation patient plus the paginated upcoming queue.
    /// </summary>
    /// <param name="clinicId">The clinic to scope the board.</param>
    /// <param name="take">Queue page size; defaults to 5 and is clamped server-side.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The screen payload, or 404 when the clinic is unknown or foreign.</returns>
    [HttpGet("current")]
    [ProducesResponseType(typeof(CurrentAppointmentsDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetCurrent(
        [FromQuery] Guid clinicId,
        [FromQuery] int take = DoctorAppointmentConstants.DefaultQueuePageSize,
        CancellationToken cancellationToken = default)
    {
        // Delegate to the ownership-scoped read path.
        var result = await _appointmentsService.GetCurrentAsync(clinicId, take, cancellationToken);

        // Unknown or foreign clinics are indistinguishable by design.
        if (result == null)
        {
            return NotFound();
        }
        else
        {
            return Ok(result);
        }
    }

    /// <summary>
    /// Gets every slot of an owned clinic for one date with computed display statuses.
    /// </summary>
    /// <param name="clinicId">The clinic to scope the panel.</param>
    /// <param name="date">The requested date (yyyy-MM-dd).</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The mapped slots, or 404 when the clinic is unknown or foreign.</returns>
    [HttpGet("slots")]
    [ProducesResponseType(typeof(IReadOnlyList<DoctorDashboardSlotDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetSlots(
        [FromQuery] Guid clinicId,
        [FromQuery] DateOnly date,
        CancellationToken cancellationToken)
    {
        // Delegate to the ownership-scoped read path.
        var slots = await _appointmentsService.GetSlotsAsync(clinicId, date, cancellationToken);

        // Unknown or foreign clinics are indistinguishable by design.
        if (slots == null)
        {
            return NotFound();
        }
        else
        {
            return Ok(slots);
        }
    }

    /// <summary>
    /// Gets the calendar picker dates: working days inside the clinic's horizon.
    /// </summary>
    /// <param name="clinicId">The clinic to scope the calendar.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The available dates, or 404 when the clinic is unknown or foreign.</returns>
    [HttpGet("slots/available-dates")]
    [ProducesResponseType(typeof(AvailableDatesResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetAvailableDates(
        [FromQuery] Guid clinicId,
        CancellationToken cancellationToken)
    {
        // Delegate to the ownership-scoped read path.
        var dates = await _appointmentsService.GetAvailableDatesAsync(clinicId, cancellationToken);

        // Unknown or foreign clinics are indistinguishable by design.
        if (dates == null)
        {
            return NotFound();
        }
        else
        {
            return Ok(dates);
        }
    }

    /// <summary>
    /// Starts the consultation of an Upcoming appointment owned by the caller.
    /// </summary>
    /// <param name="id">The appointment identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The updated state, 409 on guard rejection, or 404 when invisible.</returns>
    [HttpPut("{id:guid}/start")]
    [ProducesResponseType(typeof(AppointmentStateDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> StartConsultation(Guid id, CancellationToken cancellationToken)
    {
        // Execute the guarded transition.
        var result = await _appointmentsService.StartConsultationAsync(id, cancellationToken);
        return MapLifecycleResult(result);
    }

    /// <summary>
    /// Ends the InConsultation appointment owned by the caller, marking it Completed.
    /// </summary>
    /// <param name="id">The appointment identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The updated state, 409 on guard rejection, or 404 when invisible.</returns>
    [HttpPut("{id:guid}/end")]
    [ProducesResponseType(typeof(AppointmentStateDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> EndConsultation(Guid id, CancellationToken cancellationToken)
    {
        // Execute the guarded transition.
        var result = await _appointmentsService.EndConsultationAsync(id, cancellationToken);
        return MapLifecycleResult(result);
    }

    /// <summary>
    /// Maps a lifecycle operation result onto the matching HTTP response.
    /// </summary>
    /// <param name="result">The service outcome.</param>
    /// <returns>The action result carrying state, conflict, or not-found semantics.</returns>
    private IActionResult MapLifecycleResult(AppointmentOperationResult result)
    {
        // Success returns the refreshed card so clients skip a refetch round-trip.
        if (result.Succeeded)
        {
            return Ok(result.Appointment);
        }
        else
        {
            // Foreign-owned or missing targets stay hidden behind not-found.
        }

        if (result.Errors.Any(error => error.Code == AppointmentErrorCodes.NotFound))
        {
            return NotFound();
        }
        else
        {
            // Guard rejections surface as conflicts with structured errors below.
        }

        return Conflict(new { errors = result.Errors });
    }
}
