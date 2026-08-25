/**
 * File Name      : PatientBookingController.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : ASP.NET Core MVC, IPatientBookingService
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-25
 * Description    : Exposes the patient booking screen endpoints: available dates,
 *                  day slot views for anonymous browsing, and authenticated
 *                  atomic slot lock/release mutations.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Features.Booking;
using Appoynt.Application.Features.Booking.Contracts;
using Appoynt.Domain.Common.Constants;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace Appoynt.API.Controllers;

/// <summary>
/// Handles the patient appointment booking workflow.
/// </summary>
[ApiController]
[Route("api/booking")]
public sealed class PatientBookingController : ControllerBase
{
    private readonly IPatientBookingService _bookingService;

    /// <summary>
    /// Initializes a new instance of the <see cref="PatientBookingController"/> class.
    /// </summary>
    /// <param name="bookingService">The booking application service.</param>
    public PatientBookingController(IPatientBookingService bookingService)
    {
        _bookingService = bookingService;
    }

    /// <summary>
    /// Gets the distinct dates holding at least one available slot inside the
    /// clinic's advance booking window.
    /// </summary>
    /// <param name="clinicId">The clinic identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The lit-up calendar dates, or 404 when the clinic does not exist.</returns>
    [HttpGet("clinics/{clinicId:guid}/available-dates")]
    [AllowAnonymous]
    [ProducesResponseType(typeof(AvailableDatesResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetAvailableDates(Guid clinicId, CancellationToken cancellationToken)
    {
        // Delegate to the cached read path.
        var response = await _bookingService.GetAvailableDatesAsync(clinicId, cancellationToken);

        // Unknown or deleted clinics yield a not-found response.
        if (response == null)
        {
            return NotFound();
        }
        else
        {
            return Ok(response);
        }
    }

    /// <summary>
    /// Gets every slot of a clinic for one date with guest-facing statuses.
    /// A missing or malformed date is rejected automatically by model binding.
    /// </summary>
    /// <param name="clinicId">The clinic identifier.</param>
    /// <param name="date">The requested date (yyyy-MM-dd).</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The day's slots, or 404 when the clinic does not exist.</returns>
    [HttpGet("clinics/{clinicId:guid}/slots")]
    [AllowAnonymous]
    [ProducesResponseType(typeof(IReadOnlyList<ClinicSlotDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetClinicSlots(Guid clinicId, [FromQuery] DateOnly date, CancellationToken cancellationToken)
    {
        // Delegate to the real-time read path.
        var slots = await _bookingService.GetClinicSlotsAsync(clinicId, date, cancellationToken);

        // Unknown or deleted clinics yield a not-found response.
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
    /// Atomically locks an available slot for the authenticated patient.
    /// Re-locking the same slot preserves its original countdown; acquiring a
    /// different slot releases the caller's previous lock only after success.
    /// </summary>
    /// <param name="slotId">The slot to lock.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The acquired or existing lock with countdown details.</returns>
    [HttpPost("slots/{slotId:guid}/lock")]
    [Authorize(Roles = RoleConstants.Patient)]
    [EnableRateLimiting("Booking")]
    [ProducesResponseType(typeof(SlotLockResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> LockSlot(Guid slotId, CancellationToken cancellationToken)
    {
        // Execute the atomic lock workflow; identity comes from token claims only.
        var result = await _bookingService.LockSlotAsync(slotId, cancellationToken);

        // Surface authentication failures as forbidden before lock semantics.
        if (!result.Succeeded && result.Errors.Any(error => error.Code == AuthenticationErrorCodes.Forbidden))
        {
            return Forbid();
        }
        else
        {
            // Not an authorization problem; evaluate the lock outcome below.
        }

        // Any other failure means the slot cannot currently be locked.
        if (!result.Succeeded)
        {
            return Conflict(new { errors = result.Errors });
        }
        else
        {
            return Ok(result.Lock);
        }
    }

    /// <summary>
    /// Releases the authenticated patient's pending lock on a slot.
    /// The operation is idempotent and always completes with 204 No Content.
    /// </summary>
    /// <param name="slotId">The slot to release.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>An empty 204 response regardless of prior lock state.</returns>
    [HttpPost("slots/{slotId:guid}/release")]
    [Authorize(Roles = RoleConstants.Patient)]
    [EnableRateLimiting("Booking")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> ReleaseSlot(Guid slotId, CancellationToken cancellationToken)
    {
        // Release is a safe no-op when nothing matches; still return success.
        await _bookingService.ReleaseSlotAsync(slotId, cancellationToken);
        return NoContent();
    }
}

