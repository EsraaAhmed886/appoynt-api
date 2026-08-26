/**
 * File Name      : IDoctorAppointmentsService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : DoctorAppointments Contracts, Booking Contracts
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-26
 * Description    : Defines the read and lifecycle operations powering the
 *                  doctor's appointments screen (current patient, queue,
 *                  day slots panel, and start/end consultation actions).
 */

using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Features.Booking.Contracts;
using Appoynt.Application.Features.DoctorAppointments.Contracts;

namespace Appoynt.Application.Features.DoctorAppointments;

/// <summary>
/// Provides the doctor appointments screen queries and consultation transitions.
/// </summary>
public interface IDoctorAppointmentsService
{
    /// <summary>
    /// Gets today's current in-consultation patient plus the paginated upcoming
    /// queue for one clinic owned by the calling doctor.
    /// </summary>
    /// <param name="clinicId">The clinic identifier to scope the view.</param>
    /// <param name="take">Requested queue page size; clamped to configured bounds.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The screen payload, or null when the clinic does not exist or is not owned by the caller.</returns>
    Task<CurrentAppointmentsDto?> GetCurrentAsync(Guid clinicId, int take, CancellationToken cancellationToken = default);

    /// <summary>
    /// Gets every slot of an owned clinic for one date with computed display statuses.
    /// </summary>
    /// <param name="clinicId">The clinic identifier to scope the panel.</param>
    /// <param name="date">The requested date.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The mapped slots, or null when the clinic does not exist or is not owned by the caller.</returns>
    Task<IReadOnlyList<DoctorDashboardSlotDto>?> GetSlotsAsync(Guid clinicId, DateOnly date, CancellationToken cancellationToken = default);

    /// <summary>
    /// Gets the calendar picker dates for an owned clinic: working days inside
    /// the clinic's own advance booking horizon.
    /// </summary>
    /// <param name="clinicId">The clinic identifier to scope the calendar.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The available dates, or null when the clinic does not exist or is not owned by the caller.</returns>
    Task<AvailableDatesResponseDto?> GetAvailableDatesAsync(Guid clinicId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Starts the consultation of an Upcoming appointment owned by the calling
    /// doctor. Rejected when another appointment of the same doctor (any clinic,
    /// same day) is already InConsultation, or when the transition is invalid.
    /// </summary>
    /// <param name="appointmentId">The appointment to start.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The updated state, or a failure describing why the action was rejected.</returns>
    Task<AppointmentOperationResult> StartConsultationAsync(Guid appointmentId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Ends the InConsultation appointment owned by the calling doctor, marking
    /// it Completed with the actual end timestamp.
    /// </summary>
    /// <param name="appointmentId">The appointment to end.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The updated state, or a failure describing why the action was rejected.</returns>
    Task<AppointmentOperationResult> EndConsultationAsync(Guid appointmentId, CancellationToken cancellationToken = default);
}
