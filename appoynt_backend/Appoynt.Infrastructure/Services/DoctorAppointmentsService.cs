/**
 * File Name      : DoctorAppointmentsService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : IDoctorAppointmentsService, ApplicationDbContext, ICurrentUserService,
 *                  IDateTimeProvider
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-26
 * Description    : Implements the doctor appointments screen reads (current
 *                  patient, paginated queue, day slot panel with computed
 *                  display statuses) and the start/end consultation lifecycle
 *                  with a per-doctor single-in-consultation guard.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Application.Features.Booking.Contracts;
using Appoynt.Application.Features.DoctorAppointments;
using Appoynt.Application.Features.DoctorAppointments.Contracts;
using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace Appoynt.Infrastructure.Services;

/// <summary>
/// Implements the doctor appointments screen operations.
/// </summary>
public sealed class DoctorAppointmentsService : IDoctorAppointmentsService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly ICurrentUserService _currentUserService;
    private readonly IDateTimeProvider _dateTimeProvider;

    /// <summary>
    /// Initializes a new instance of the <see cref="DoctorAppointmentsService"/> class.
    /// </summary>
    /// <param name="dbContext">The application database context.</param>
    /// <param name="currentUserService">The authenticated user accessor.</param>
    /// <param name="dateTimeProvider">The deterministic UTC clock.</param>
    public DoctorAppointmentsService(
        ApplicationDbContext dbContext,
        ICurrentUserService currentUserService,
        IDateTimeProvider dateTimeProvider)
    {
        _dbContext = dbContext;
        _currentUserService = currentUserService;
        _dateTimeProvider = dateTimeProvider;
    }

    #region Read Paths

    /// <inheritdoc />
    public async Task<CurrentAppointmentsDto?> GetCurrentAsync(Guid clinicId, int take, CancellationToken cancellationToken = default)
    {
        // Every read is scoped to a clinic the calling doctor actually owns.
        Doctor? doctor = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctor == null || !await IsOwnedClinicAsync(doctor.Id, clinicId, cancellationToken))
        {
            return null;
        }
        else
        {
            // Clinic ownership verified; load today's board below.
        }

        // Clamp the requested page size into configured bounds.
        int pageSize = Math.Clamp(take, 1, DoctorAppointmentConstants.MaxQueuePageSize);
        var today = DateOnly.FromDateTime(_dateTimeProvider.UtcNow);

        // Load today's appointments for this clinic with identity and slot times.
        var todaysAppointments = await _dbContext.Appointments
            .AsNoTracking()
            .Include(a => a.Patient)
                .ThenInclude(p => p.User)
            .Include(a => a.AppointmentSlot)
            .Where(a => a.ClinicId == clinicId && a.Date == today)
            .ToListAsync(cancellationToken);

        // At most one in-consultation row can exist thanks to the start guard.
        Appointment? currentAppointment = todaysAppointments
            .Where(a => a.Status == AppointmentStatus.InConsultation)
            .OrderBy(a => a.ActualStartTimeUtc)
            .FirstOrDefault();

        // Queue counts come from the full upcoming set before paging.
        List<Appointment> upcomingAll = todaysAppointments
            .Where(a => a.Status == AppointmentStatus.Upcoming)
            .OrderBy(a => a.AppointmentSlot.StartTime)
            .ThenBy(a => a.Id)
            .ToList();

        // Project the current patient card when present.
        var dto = new CurrentAppointmentsDto
        {
            CurrentPatient = currentAppointment == null ? null : MapCurrentPatient(currentAppointment),
            QueueTotalCount = upcomingAll.Count,
            QueueHasMore = upcomingAll.Count > pageSize,
            Queue = upcomingAll
                .Take(pageSize)
                .Select(MapQueuePatient)
                .ToList()
        };

        return dto;
    }

    /// <inheritdoc />
    public async Task<IReadOnlyList<DoctorDashboardSlotDto>?> GetSlotsAsync(Guid clinicId, DateOnly date, CancellationToken cancellationToken = default)
    {
        // Scope the panel to clinics owned by the caller.
        Doctor? doctor = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctor == null || !await IsOwnedClinicAsync(doctor.Id, clinicId, cancellationToken))
        {
            return null;
        }
        else
        {
            // Clinic ownership verified; stream the day's slots below.
        }

        // Capture now once so effective-status evaluation stays consistent.
        var utcNow = _dateTimeProvider.UtcNow;

        // Load the full day's slots including any bound appointment for status join.
        List<AppointmentSlot> slots = await _dbContext.AppointmentSlots
            .AsNoTracking()
            .Include(slot => slot.Appointment)
            .Where(slot => slot.ClinicId == clinicId && slot.Date == date)
            .OrderBy(slot => slot.StartTime)
            .ToListAsync(cancellationToken);

        // Project each slot through the computed display-status mapping.
        var dtos = slots.Select(slot => new DoctorDashboardSlotDto
        {
            SlotId = slot.Id,
            StartTime = slot.StartTime.ToString("HH:mm"),
            EndTime = slot.EndTime.ToString("HH:mm"),
            DisplayStatus = ToDisplayStatus(slot, utcNow)
        }).ToList();

        return dtos;
    }

    /// <inheritdoc />
    public async Task<AvailableDatesResponseDto?> GetAvailableDatesAsync(Guid clinicId, CancellationToken cancellationToken = default)
    {
        // Scope the calendar to clinics owned by the caller.
        Doctor? doctor = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctor == null)
        {
            return null;
        }
        else
        {
            // Doctor resolved; verify clinic ownership below.
        }

        // Ownership check returns the clinic too so its horizon setting is reused.
        Clinic? clinic = await _dbContext.Clinics
            .AsNoTracking()
            .FirstOrDefaultAsync(c => c.Id == clinicId && c.DeletedAt == null, cancellationToken);

        if (clinic == null || clinic.DoctorId != doctor.Id)
        {
            return null;
        }
        else
        {
            // Owned clinic resolved; compute the working-day window below.
        }

        // Window mirrors the patient booking horizon using the clinic's own limit.
        var today = DateOnly.FromDateTime(_dateTimeProvider.UtcNow);
        var windowEnd = today.AddDays(clinic.MaxAdvanceBookingDays);

        // Working weekdays come from active recurring periods only.
        HashSet<DayOfWeek> workingDays = await _dbContext.ClinicWorkingPeriods
            .AsNoTracking()
            .Where(wp => wp.ClinicId == clinicId && wp.IsActive)
            .Select(wp => wp.DayOfWeek)
            .ToHashSetAsync(cancellationToken);

        // Walk the window collecting dates whose weekday is a working day.
        var dates = new List<DateOnly>();
        for (var date = today; date <= windowEnd; date = date.AddDays(1))
        {
            if (workingDays.Contains(date.DayOfWeek))
            {
                dates.Add(date);
            }
            else
            {
                // Non-working day; skip from the picker.
            }
        }

        return new AvailableDatesResponseDto { AvailableDates = dates };
    }

    #endregion

    #region Lifecycle Mutations

    /// <inheritdoc />
    public async Task<AppointmentOperationResult> StartConsultationAsync(Guid appointmentId, CancellationToken cancellationToken = default)
    {
        // Resolve the acting doctor; anonymous callers are rejected upstream by auth.
        Doctor? doctor = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctor == null)
        {
            return AppointmentOperationResult.Failure(AuthenticationErrorCodes.Forbidden);
        }
        else
        {
            // Doctor resolved; load the target appointment below.
        }

        // Load tracked so the mutation flows through the audited SaveChanges path.
        Appointment? appointment = await _dbContext.Appointments
            .Include(a => a.Clinic)
            .FirstOrDefaultAsync(a => a.Id == appointmentId, cancellationToken);

        // Hide foreign-owned or missing appointments behind one not-found code.
        if (appointment == null || appointment.Clinic.DoctorId != doctor.Id || appointment.Clinic.DeletedAt != null)
        {
            return AppointmentOperationResult.Failure(AppointmentErrorCodes.NotFound);
        }
        else
        {
            // Ownership verified; evaluate transition guards below.
        }

        var utcNow = _dateTimeProvider.UtcNow;
        var today = DateOnly.FromDateTime(utcNow);

        // Per-doctor single-consultation guard across ALL owned clinics, scoped to
        // today so an accidentally abandoned past consultation cannot deadlock the queue.
        bool anotherInConsultation = await _dbContext.Appointments
            .AnyAsync(a => a.Id != appointmentId
                        && a.Status == AppointmentStatus.InConsultation
                        && a.Date == today
                        && a.Clinic!.DoctorId == doctor.Id,
                cancellationToken);

        if (anotherInConsultation)
        {
            return AppointmentOperationResult.Failure(AppointmentErrorCodes.AlreadyInConsultation);
        }
        else
        {
            // No competing consultation; validate this appointment's own state below.
        }

        // State machine: only Upcoming may transition into InConsultation.
        if (appointment.Status == AppointmentStatus.InConsultation)
        {
            return AppointmentOperationResult.Failure(AppointmentErrorCodes.InvalidTransition);
        }
        else if (appointment.Status != AppointmentStatus.Upcoming)
        {
            return AppointmentOperationResult.Failure(AppointmentErrorCodes.InvalidTransition);
        }
        else
        {
            // Valid transition; apply below.
        }

        // Apply the transition through the audited persistence pipeline.
        appointment.Status = AppointmentStatus.InConsultation;
        appointment.ActualStartTimeUtc = utcNow;
        await _dbContext.SaveChangesAsync(cancellationToken);

        return AppointmentOperationResult.Success(MapState(appointment));
    }

    /// <inheritdoc />
    public async Task<AppointmentOperationResult> EndConsultationAsync(Guid appointmentId, CancellationToken cancellationToken = default)
    {
        // Resolve the acting doctor first.
        Doctor? doctor = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctor == null)
        {
            return AppointmentOperationResult.Failure(AuthenticationErrorCodes.Forbidden);
        }
        else
        {
            // Doctor resolved; load the target appointment below.
        }

        // Load tracked for the audited update path.
        Appointment? appointment = await _dbContext.Appointments
            .Include(a => a.Clinic)
            .FirstOrDefaultAsync(a => a.Id == appointmentId, cancellationToken);

        // Hide foreign-owned or missing appointments behind one not-found code.
        if (appointment == null || appointment.Clinic.DoctorId != doctor.Id || appointment.Clinic.DeletedAt != null)
        {
            return AppointmentOperationResult.Failure(AppointmentErrorCodes.NotFound);
        }
        else
        {
            // Ownership verified; validate the ending transition below.
        }

        // State machine: only an InConsultation appointment may be ended.
        if (appointment.Status != AppointmentStatus.InConsultation)
        {
            return AppointmentOperationResult.Failure(AppointmentErrorCodes.InvalidTransition);
        }
        else
        {
            // Valid transition; apply below.
        }

        // Stamp completion through the audited persistence pipeline.
        appointment.Status = AppointmentStatus.Completed;
        appointment.ActualEndTimeUtc = _dateTimeProvider.UtcNow;
        await _dbContext.SaveChangesAsync(cancellationToken);

        return AppointmentOperationResult.Success(MapState(appointment));
    }

    #endregion

    #region Private Helpers

    /// <summary>
    /// Resolves the doctor profile associated with the authenticated user.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The doctor profile, or null when unauthenticated or not a doctor.</returns>
    private async Task<Doctor?> ResolveCurrentDoctorAsync(CancellationToken cancellationToken)
    {
        // Reject anonymous callers up front.
        Guid? userId = _currentUserService.UserId;
        if (userId == null)
        {
            return null;
        }
        else
        {
            // User authenticated; locate the doctor profile below.
        }

        // Locate the doctor record linked to the authenticated user.
        return await _dbContext.Doctors
            .AsNoTracking()
            .FirstOrDefaultAsync(d => d.UserId == userId.Value, cancellationToken);
    }

    /// <summary>
    /// Checks that a clinic exists, is not soft-deleted, and belongs to the doctor.
    /// </summary>
    /// <param name="doctorId">The owning doctor identifier.</param>
    /// <param name="clinicId">The clinic to verify.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>True when the clinic is an owned active clinic.</returns>
    private async Task<bool> IsOwnedClinicAsync(Guid doctorId, Guid clinicId, CancellationToken cancellationToken)
    {
        // Single existence query covers missing, deleted, and foreign cases.
        return await _dbContext.Clinics
            .AsNoTracking()
            .AnyAsync(c => c.Id == clinicId && c.DoctorId == doctorId && c.DeletedAt == null, cancellationToken);
    }

    /// <summary>
    /// Maps an appointment to the current-patient card payload.
    /// </summary>
    /// <param name="appointment">The in-consultation appointment.</param>
    /// <returns>The populated <see cref="CurrentPatientDto"/>.</returns>
    private static CurrentPatientDto MapCurrentPatient(Appointment appointment)
    {
        // Compose the display name from the linked user account.
        string patientName = $"{appointment.Patient.User.FirstName} {appointment.Patient.User.LastName}".Trim();

        // Build the card with snapshot placeholders left for the Medical Record task.
        return new CurrentPatientDto
        {
            AppointmentId = appointment.Id,
            PatientName = patientName,
            PhoneNumber = appointment.Patient.User.PhoneNumber,
            BookingType = appointment.Type,
            ExpectedTime = appointment.AppointmentSlot.StartTime.ToString("HH:mm"),
            ActualStartTimeUtc = appointment.ActualStartTimeUtc
        };
    }

    /// <summary>
    /// Maps an appointment to a queue row payload.
    /// </summary>
    /// <param name="appointment">The upcoming appointment.</param>
    /// <returns>The populated <see cref="QueuePatientDto"/>.</returns>
    private static QueuePatientDto MapQueuePatient(Appointment appointment)
    {
        // Compose the display name from the linked user account.
        string patientName = $"{appointment.Patient.User.FirstName} {appointment.Patient.User.LastName}".Trim();

        // Build the minimal queue row.
        return new QueuePatientDto
        {
            AppointmentId = appointment.Id,
            PatientName = patientName,
            BookingType = appointment.Type,
            ExpectedTime = appointment.AppointmentSlot.StartTime.ToString("HH:mm")
        };
    }

    /// <summary>
    /// Maps an updated appointment to its post-action state payload.
    /// </summary>
    /// <param name="appointment">The mutated appointment.</param>
    /// <returns>The populated <see cref="AppointmentStateDto"/>.</returns>
    private static AppointmentStateDto MapState(Appointment appointment)
    {
        // Surface exactly what changed for client-side card refresh.
        return new AppointmentStateDto
        {
            AppointmentId = appointment.Id,
            Status = appointment.Status,
            ActualStartTimeUtc = appointment.ActualStartTimeUtc,
            ActualEndTimeUtc = appointment.ActualEndTimeUtc
        };
    }

    /// <summary>
    /// Computes the guest-safe display label for a slot by joining SlotStatus
    /// inventory state with the linked appointment's lifecycle state.
    /// Never persisted; recomputed on every panel read.
    /// </summary>
    /// <param name="slot">The slot being projected.</param>
    /// <param name="utcNow">The current UTC instant for lock-expiry evaluation.</param>
    /// <returns>The simplified display status string.</returns>
    private static string ToDisplayStatus(AppointmentSlot slot, DateTime utcNow)
    {
        // An expired pending lock no longer reserves anything for anyone.
        if (slot.Status == SlotStatus.Pending
            && (!slot.ExpiresAtUtc.HasValue || slot.ExpiresAtUtc.Value <= utcNow))
        {
            return "Available";
        }
        else
        {
            // Continue with the standard mapping below.
        }

        switch (slot.Status)
        {
            case SlotStatus.Available:
                // Free capacity ready for booking.
                return "Available";
            case SlotStatus.Pending:
                // A patient holds a live countdown lock; not yet confirmed.
                return "Pending";
            case SlotStatus.Unavailable:
                // Generation bakes break windows as Unavailable slots.
                return "Break";
            case SlotStatus.Booked:
                // Join the appointment lifecycle for the consultation view.
                Appointment? appointment = slot.Appointment;
                if (appointment != null && appointment.Status == AppointmentStatus.InConsultation)
                {
                    return "InConsultation";
                }
                else
                {
                    // Upcoming (and, until the cancel write path ships, terminal
                    // states too) surface as plain Booked per the documented rule.
                    return "Booked";
                }
            default:
                // Dormant statuses (Completed/Cancelled/NoShow) stay closed.
                return "Unavailable";
        }
    }

    #endregion
}
