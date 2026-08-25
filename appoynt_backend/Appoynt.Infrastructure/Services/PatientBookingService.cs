/**
 * File Name      : PatientBookingService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : IPatientBookingService, ApplicationDbContext, ICurrentUserService,
 *                  IDateTimeProvider, ICacheService
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-25
 * Description    : Implements the patient booking screen queries and the atomic
 *                  appointment-slot locking workflow with idempotent re-locks,
 *                  automatic old-lock switching, and calendar cache maintenance.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Application.Features.Booking;
using Appoynt.Application.Features.Booking.Contracts;
using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace Appoynt.Infrastructure.Services;

/// <summary>
/// Implements booking-screen reads and the atomic slot locking workflow.
/// </summary>
public sealed class PatientBookingService : IPatientBookingService
{
    // Lifetime of the cached per-clinic available-dates window, in minutes.
    private const int AvailableDatesCacheMinutes = 5;

    // Lifetime of the cached per-doctor booking summary, in minutes.
    private const int DoctorBookingSummaryCacheMinutes = 60;

    private readonly ApplicationDbContext _dbContext;
    private readonly ICurrentUserService _currentUserService;
    private readonly IDateTimeProvider _dateTimeProvider;
    private readonly ICacheService _cacheService;

    /// <summary>
    /// Initializes a new instance of the <see cref="PatientBookingService"/> class.
    /// </summary>
    /// <param name="dbContext">The application database context.</param>
    /// <param name="currentUserService">The authenticated user accessor.</param>
    /// <param name="dateTimeProvider">The deterministic UTC clock.</param>
    /// <param name="cacheService">The application cache abstraction.</param>
    public PatientBookingService(
        ApplicationDbContext dbContext,
        ICurrentUserService currentUserService,
        IDateTimeProvider dateTimeProvider,
        ICacheService cacheService)
    {
        _dbContext = dbContext;
        _currentUserService = currentUserService;
        _dateTimeProvider = dateTimeProvider;
        _cacheService = cacheService;
    }

    #region Read Paths

    /// <inheritdoc />
    public async Task<DoctorBookingSummaryDto?> GetDoctorBookingSummaryAsync(Guid doctorId, CancellationToken cancellationToken = default)
    {
        // Serve hot traffic from the summary cache when present.
        string cacheKey = CacheKeys.DoctorBookingSummary(doctorId);
        var cached = _cacheService.Get<DoctorBookingSummaryDto>(cacheKey);
        if (cached != null)
        {
            return cached;
        }
        else
        {
            // Cache miss: build the payload from the database below.
        }

        // Locate the doctor together with identity fields and bookable clinics.
        var doctor = await _dbContext.Doctors
            .AsNoTracking()
            .Include(d => d.User)
            .Include(d => d.Clinics
                .Where(c => c.Status == ClinicStatus.Active && c.DeletedAt == null))
                .ThenInclude(c => c.WorkingPeriods
                    .Where(wp => wp.IsActive))
            .FirstOrDefaultAsync(d => d.Id == doctorId && d.DeletedAt == null, cancellationToken);

        // A missing or soft-deleted doctor yields no summary at all.
        if (doctor == null)
        {
            return null;
        }
        else
        {
            // Doctor resolved; continue mapping.
        }

        // Prefer curated display names, falling back to the account name.
        string nameAr = doctor.NameAr ?? $"{doctor.User.FirstName} {doctor.User.LastName}".Trim();
        string nameEn = doctor.NameEn ?? $"{doctor.User.FirstName} {doctor.User.LastName}".Trim();

        // Order clinics so the default appears first, then stable creation order.
        var summary = new DoctorBookingSummaryDto
        {
            DoctorId = doctor.Id,
            NameAr = nameAr,
            NameEn = nameEn,
            PhotoUrl = doctor.User.ProfilePicturePath,
            Clinics = doctor.Clinics
                .OrderByDescending(c => c.IsDefault)
                .ThenBy(c => c.CreatedAt)
                .Select(MapClinicSummary)
                .ToList()
        };

        // Cache the immutable payload for the configured lifetime.
        _cacheService.Set(cacheKey, summary, TimeSpan.FromMinutes(DoctorBookingSummaryCacheMinutes));
        return summary;
    }

    /// <inheritdoc />
    public async Task<AvailableDatesResponseDto?> GetAvailableDatesAsync(Guid clinicId, CancellationToken cancellationToken = default)
    {
        // Serve the calendar window from cache when present.
        string cacheKey = CacheKeys.AvailableDates(clinicId);
        var cached = _cacheService.Get<AvailableDatesResponseDto>(cacheKey);
        if (cached != null)
        {
            return cached;
        }
        else
        {
            // Cache miss: query the database below.
        }

        // Validate that the clinic exists and has not been soft-deleted.
        var clinicExists = await _dbContext.Clinics
            .AsNoTracking()
            .AnyAsync(c => c.Id == clinicId && c.DeletedAt == null, cancellationToken);

        if (!clinicExists)
        {
            return null;
        }
        else
        {
            // Clinic resolved; compute the lit-up window below.
        }

        // Bound the window by the clinic's own advance booking setting.
        var today = DateOnly.FromDateTime(_dateTimeProvider.UtcNow);
        var windowEnd = today.AddDays(await _dbContext.Clinics
            .AsNoTracking()
            .Where(c => c.Id == clinicId)
            .Select(c => c.MaxAdvanceBookingDays)
            .FirstAsync(cancellationToken));

        // Select only the distinct dates that still hold available capacity.
        var dates = await _dbContext.AppointmentSlots
            .AsNoTracking()
            .Where(s => s.ClinicId == clinicId
                     && s.Status == SlotStatus.Available
                     && s.Date >= today
                     && s.Date <= windowEnd)
            .Select(s => s.Date)
            .Distinct()
            .OrderBy(date => date)
            .ToListAsync(cancellationToken);

        var response = new AvailableDatesResponseDto { AvailableDates = dates };

        // Cache the window briefly so bursts of calendar views stay cheap.
        _cacheService.Set(cacheKey, response, TimeSpan.FromMinutes(AvailableDatesCacheMinutes));
        return response;
    }

    /// <inheritdoc />
    public async Task<IReadOnlyList<ClinicSlotDto>?> GetClinicSlotsAsync(Guid clinicId, DateOnly date, CancellationToken cancellationToken = default)
    {
        // Validate that the clinic exists and has not been soft-deleted.
        var clinicExists = await _dbContext.Clinics
            .AsNoTracking()
            .AnyAsync(c => c.Id == clinicId && c.DeletedAt == null, cancellationToken);

        if (!clinicExists)
        {
            return null;
        }
        else
        {
            // Clinic resolved; stream the day's slots below.
        }

        // Capture caller identity once so own-lock flags stay consistent.
        Guid? currentPatientId = _currentUserService.UserId;
        var utcNow = _dateTimeProvider.UtcNow;

        // Load the full day's slots without tracking; this endpoint is real-time.
        var slots = await _dbContext.AppointmentSlots
            .AsNoTracking()
            .Where(s => s.ClinicId == clinicId && s.Date == date)
            .OrderBy(s => s.StartTime)
            .ToListAsync(cancellationToken);

        // Map each slot through the public status projection for anonymous callers.
        var dtos = slots.Select(slot =>
        {
            // An expired pending lock is presented as free immediately.
            bool isEffectivelyLocked = slot.Status == SlotStatus.Pending
                && slot.ExpiresAtUtc.HasValue
                && slot.ExpiresAtUtc.Value > utcNow;

            // Own-lock applies only to the caller's live locks.
            bool isLockedByMe = currentPatientId != null
                && isEffectivelyLocked
                && slot.HeldByUserId == currentPatientId.Value;

            // Build the anonymous-facing slot payload.
            return new ClinicSlotDto
            {
                SlotId = slot.Id,
                StartTime = slot.StartTime.ToString("HH:mm"),
                EndTime = slot.EndTime.ToString("HH:mm"),
                Status = ToPublicStatus(slot.Status, slot.ExpiresAtUtc, utcNow),
                IsMorning = slot.StartTime < ClinicConstants.MorningCutoff,
                IsLockedByMe = isLockedByMe,
                ExpiresAt = isLockedByMe ? slot.ExpiresAtUtc : null
            };
        }).ToList();

        return dtos;
    }

    #endregion

    #region Mutations

    /// <inheritdoc />
    public async Task<BookingOperationResult> LockSlotAsync(Guid slotId, CancellationToken cancellationToken = default)
    {
        // Resolve the locking patient strictly from the authentication context.
        Guid? patientId = _currentUserService.UserId;
        if (patientId == null)
        {
            return BookingOperationResult.Failure(AuthenticationErrorCodes.Forbidden);
        }
        else
        {
            // Caller authenticated; proceed with the atomic workflow.
        }

        var utcNow = _dateTimeProvider.UtcNow;
        var today = DateOnly.FromDateTime(utcNow);
        var nowTime = TimeOnly.FromDateTime(utcNow);

        // Step 0a: Reclaim an EXPIRED lock already held on this exact slot.
        // The lock stays pending-owned but receives a fresh countdown window.
        // NOTE: This operation intentionally bypasses the audit pipeline because
        // it runs through set-based updates; high-frequency temporary slot locks
        // are excluded from AuditLog by decision (same precedent as OtpChallenge).
        int reclaimedRows = await _dbContext.AppointmentSlots
            .Where(s => s.Id == slotId
                     && s.Status == SlotStatus.Pending
                     && s.HeldByUserId == patientId.Value
                     && s.ExpiresAtUtc <= utcNow)
            .ExecuteUpdateAsync(update => update
                .SetProperty(s => s.ExpiresAtUtc, utcNow.AddMinutes(ClinicConstants.PendingTimeoutMinutes)),
                cancellationToken);

        if (reclaimedRows > 0)
        {
            // The reclaimed lock is returned with its brand-new countdown.
            return await BuildLockSuccessAsync(slotId, cancellationToken);
        }
        else
        {
            // No expired self-lock existed; evaluate the live-lock paths below.
        }

        // Step 0b: Idempotency - returning the patient's own LIVE lock unchanged
        // keeps the original countdown instead of resetting it on every reopen.
        var existingLiveLock = await _dbContext.AppointmentSlots
            .AsNoTracking()
            .Where(s => s.Id == slotId
                     && s.Status == SlotStatus.Pending
                     && s.HeldByUserId == patientId.Value
                     && s.ExpiresAtUtc > utcNow)
            .OrderBy(s => s.Id)
            .Select(s => new { s.Id, s.ExpiresAtUtc })
            .FirstOrDefaultAsync(cancellationToken);

        if (existingLiveLock != null)
        {
            // Countdown continues from the original acquisition moment.
            return BookingOperationResult.Success(BuildLockResponse(existingLiveLock.Id, existingLiveLock.ExpiresAtUtc!.Value, utcNow));
        }
        else
        {
            // No live self-lock; attempt a fresh acquisition below.
        }

        // Step 1: Try to acquire the TARGET slot first. The single conditional
        // statement is the concurrency gate: simultaneous patients race here and
        // exactly one write can match. Guards include future time and an active,
        // non-deleted clinic (this context has no global query filters).
        int acquiredRows = await _dbContext.AppointmentSlots
            .Where(s => s.Id == slotId
                     && s.Status == SlotStatus.Available
                     && s.Clinic.Status == ClinicStatus.Active
                     && s.Clinic.DeletedAt == null
                     && (s.Date > today || (s.Date == today && s.StartTime > nowTime)))
            .ExecuteUpdateAsync(update => update
                .SetProperty(s => s.Status, SlotStatus.Pending)
                .SetProperty(s => s.HeldByUserId, patientId.Value)
                .SetProperty(s => s.ExpiresAtUtc, utcNow.AddMinutes(ClinicConstants.PendingTimeoutMinutes)),
                cancellationToken);

        // Zero rows means taken, pending elsewhere, past, or inactive clinic.
        if (acquiredRows == 0)
        {
            // IMPORTANT: the previous lock (if any) remains untouched because we
            // never released anything before winning the new acquisition.
            return BookingOperationResult.Failure(ClinicErrorCodes.SlotNotAvailable);
        }
        else
        {
            // Acquisition succeeded; swap out any older lock below.
        }

        // Step 2: Success - release every OTHER pending lock this patient holds,
        // never touching the slot just acquired.
        await _dbContext.AppointmentSlots
            .Where(s => s.HeldByUserId == patientId.Value
                     && s.Status == SlotStatus.Pending
                     && s.Id != slotId)
            .ExecuteUpdateAsync(update => update
                .SetProperty(s => s.Status, SlotStatus.Available)
                .SetProperty(s => s.HeldByUserId, (Guid?)null)
                .SetProperty(s => s.ExpiresAtUtc, (DateTime?)null),
                cancellationToken);

        return await BuildLockSuccessAsync(slotId, cancellationToken);
    }

    /// <inheritdoc />
    public async Task ReleaseSlotAsync(Guid slotId, CancellationToken cancellationToken = default)
    {
        // Identify the slot's clinic before clearing so the right calendar cache
        // entry can be invalidated after a successful release.
        Guid? clinicId = await _dbContext.AppointmentSlots
            .Where(s => s.Id == slotId)
            .Select(s => (Guid?)s.ClinicId)
            .FirstOrDefaultAsync(cancellationToken);

        // Clear the caller's pending lock; matching nothing is a safe no-op.
        // See LockSlotAsync for the documented audit-pipeline exclusion.
        int releasedRows = await _dbContext.AppointmentSlots
            .Where(s => s.Id == slotId
                     && s.HeldByUserId == _currentUserService.UserId
                     && s.Status == SlotStatus.Pending)
            .ExecuteUpdateAsync(update => update
                .SetProperty(s => s.Status, SlotStatus.Available)
                .SetProperty(s => s.HeldByUserId, (Guid?)null)
                .SetProperty(s => s.ExpiresAtUtc, (DateTime?)null),
                cancellationToken);

        // Only invalidate the calendar cache when something actually changed.
        if (releasedRows > 0 && clinicId.HasValue)
        {
            await _cacheService.RemoveAsync(CacheKeys.AvailableDates(clinicId.Value), cancellationToken);
        }
        else
        {
            // Nothing released; no cache maintenance required.
        }
    }

    #endregion

    #region Private Helpers

    /// <summary>
    /// Loads a freshly written lock and produces the success result including
    /// calendar-cache invalidation for the owning clinic.
    /// </summary>
    /// <param name="slotId">The locked slot identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The successful lock operation result.</returns>
    private async Task<BookingOperationResult> BuildLockSuccessAsync(Guid slotId, CancellationToken cancellationToken)
    {
        // Capture the current instant once for the countdown computation.
        var utcNow = _dateTimeProvider.UtcNow;

        // Re-read the locked row to capture its clinic reference and expiry.
        var locked = await _dbContext.AppointmentSlots
            .AsNoTracking()
            .Where(s => s.Id == slotId)
            .Select(s => new { s.Id, s.ClinicId, s.ExpiresAtUtc })
            .FirstAsync(cancellationToken);

        // The calendar window may have lost its last open slot; refresh it.
        await _cacheService.RemoveAsync(CacheKeys.AvailableDates(locked.ClinicId), cancellationToken);

        // Compose the response from the persisted values.
        return BookingOperationResult.Success(BuildLockResponse(locked.Id, locked.ExpiresAtUtc!.Value, utcNow));
    }

    /// <summary>
    /// Builds the public lock payload with a pre-computed remaining countdown.
    /// </summary>
    /// <param name="slotId">The locked slot identifier.</param>
    /// <param name="expiresAtUtc">The absolute UTC lock expiry.</param>
    /// <param name="utcNow">The current UTC instant.</param>
    /// <returns>The populated lock response.</returns>
    private static SlotLockResponseDto BuildLockResponse(Guid slotId, DateTime expiresAtUtc, DateTime utcNow)
    {
        // Compute the countdown from the real expiry, never a fixed duration.
        int remainingSeconds = (int)Math.Max(0, (expiresAtUtc - utcNow).TotalSeconds);

        // Assemble the public payload.
        return new SlotLockResponseDto
        {
            SlotId = slotId,
            ExpiresAt = expiresAtUtc,
            RemainingSeconds = remainingSeconds
        };
    }

    /// <summary>
    /// Maps a stored slot to the simplified public status shown to guests.
    /// The internal SlotStatus column and all internal queries keep the full enum.
    /// </summary>
    /// <param name="status">The stored status.</param>
    /// <param name="expiresAtUtc">The pending-lock expiry, when present.</param>
    /// <param name="utcNow">The current UTC instant used for effective-status evaluation.</param>
    /// <returns>The simplified public status string.</returns>
    private static string ToPublicStatus(SlotStatus status, DateTime? expiresAtUtc, DateTime utcNow)
    {
        // An expired pending lock is surfaced as free without waiting for the job.
        if (status == SlotStatus.Pending && (!expiresAtUtc.HasValue || expiresAtUtc.Value <= utcNow))
        {
            return "Available";
        }
        else
        {
            // Fall through to the standard mapping below.
        }

        // Collapse internal states onto the guest-facing vocabulary.
        return status switch
        {
            SlotStatus.Available => "Available",
            SlotStatus.Pending => "Pending",
            SlotStatus.Booked => "Booked",

            // Cancelled/Completed/NoShow/Unavailable are all closed to guests.
            _ => "Unavailable"
        };
    }

    /// <summary>
    /// Maps a clinic entity to its booking summary contract.
    /// </summary>
    /// <param name="clinic">The clinic entity.</param>
    /// <returns>The mapped <see cref="ClinicSummaryDto"/>.</returns>
    private static ClinicSummaryDto MapClinicSummary(Clinic clinic)
    {
        // Project the schedule into string form matching existing responses.
        return new ClinicSummaryDto
        {
            ClinicId = clinic.Id,
            Name = clinic.Name,
            DetailedAddress = clinic.DetailedAddress,
            Latitude = clinic.Latitude,
            Longitude = clinic.Longitude,
            ConsultationFee = clinic.ConsultationFee,
            IsDefault = clinic.IsDefault,
            WorkingDays = clinic.WorkingPeriods
                .OrderBy(wp => wp.DayOfWeek)
                .ThenBy(wp => wp.StartTime)
                .Select(wp => new WorkingPeriodDto
                {
                    Day = wp.DayOfWeek.ToString(),
                    StartTime = wp.StartTime.ToString("HH:mm"),
                    EndTime = wp.EndTime.ToString("HH:mm")
                })
                .ToList()
        };
    }

    #endregion
}





