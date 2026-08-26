/**
 * File Name      : IPatientBookingService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : Booking Contracts
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-25
 * Description    : Defines the read and mutation operations powering the patient
 *                  appointment booking screen, including the atomic slot lock.
 */

using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Features.Booking.Contracts;

namespace Appoynt.Application.Features.Booking;

/// <summary>
/// Provides the booking-screen queries and slot locking operations.
/// </summary>
public interface IPatientBookingService
{
    /// <summary>
    /// Gets a doctor together with their active clinics for the booking screen,
    /// ordered so the default clinic appears first.
    /// </summary>
    /// <param name="doctorId">The doctor identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The booking summary, or null when the doctor does not exist.</returns>
    Task<DoctorBookingSummaryDto?> GetDoctorBookingSummaryAsync(Guid doctorId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Gets the distinct dates holding at least one available slot within the
    /// clinic's maximum advance booking window.
    /// </summary>
    /// <param name="clinicId">The clinic identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The available dates response, or null when the clinic does not exist.</returns>
    Task<AvailableDatesResponseDto?> GetAvailableDatesAsync(Guid clinicId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Gets every slot of a clinic for one specific date with public status mapping.
    /// </summary>
    /// <param name="clinicId">The clinic identifier.</param>
    /// <param name="date">The requested date.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The day's slots, or null when the clinic does not exist.</returns>
    Task<IReadOnlyList<ClinicSlotDto>?> GetClinicSlotsAsync(Guid clinicId, DateOnly date, CancellationToken cancellationToken = default);

    /// <summary>
    /// Atomically locks an available slot for the currently authenticated patient.
    /// Re-locking the same still-valid lock is idempotent and preserves its expiry;
    /// acquiring a new lock releases any other lock the patient holds only after
    /// the new acquisition succeeds.
    /// </summary>
    /// <param name="slotId">The slot to lock.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The acquired or existing lock, or a failure describing why the slot cannot be locked.</returns>
    Task<BookingOperationResult> LockSlotAsync(Guid slotId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Releases the caller's pending lock on a slot. The operation is idempotent:
    /// releasing a slot that is not locked by the caller succeeds as a no-op.
    /// </summary>
    /// <param name="slotId">The slot to release.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A task representing the asynchronous operation.</returns>
    Task ReleaseSlotAsync(Guid slotId, CancellationToken cancellationToken = default);
}
