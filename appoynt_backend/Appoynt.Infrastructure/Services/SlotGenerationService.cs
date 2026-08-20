/**
 * File Name      : SlotGenerationService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : ISlotGenerationService, ApplicationDbContext, IDateTimeProvider, ILogger
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Implements slot generation and extension logic for clinics.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace Appoynt.Infrastructure.Services;

/// <summary>
/// Service responsible for generating and managing appointment slots for clinics.
/// </summary>
public class SlotGenerationService : ISlotGenerationService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly IDateTimeProvider _dateTimeProvider;
    private readonly ILogger<SlotGenerationService> _logger;

    /// <summary>
    /// Initializes a new instance of the <see cref="SlotGenerationService"/> class.
    /// </summary>
    /// <param name="dbContext">The application database context.</param>
    /// <param name="dateTimeProvider">The date time provider.</param>
    /// <param name="logger">The logger instance.</param>
    public SlotGenerationService(
        ApplicationDbContext dbContext,
        IDateTimeProvider dateTimeProvider,
        ILogger<SlotGenerationService> logger)
    {
        _dbContext = dbContext;
        _dateTimeProvider = dateTimeProvider;
        _logger = logger;
    }

    /// <summary>
    /// Generates appointment slots for a specific clinic.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="cancellationToken">Cancellation token.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public async Task GenerateSlotsForClinicAsync(Guid clinicId, CancellationToken cancellationToken = default)
    {
        // Load the clinic from the database, including its working periods and breaks.
        var clinic = await _dbContext.Clinics
            .Include(c => c.WorkingPeriods)
            .ThenInclude(wp => wp.Breaks)
            .FirstOrDefaultAsync(c => c.Id == clinicId, cancellationToken);

        // Check if the clinic exists, is active, and is not logically deleted.
        if (clinic == null || clinic.Status == ClinicStatus.Inactive || clinic.DeletedAt != null)
        {
            // Exit early since slots cannot be generated for an invalid clinic.
            return;
        }
        else
        {
            // Proceed with slot generation.
        }

        // Get the current date in UTC to use as the starting point.
        var today = DateOnly.FromDateTime(_dateTimeProvider.UtcNow);

        // Query existing future slots that are either Available or Unavailable.
        var existingSlotsToRemove = await _dbContext.AppointmentSlots
            .Where(s => s.ClinicId == clinicId && s.Date >= today && (s.Status == SlotStatus.Available || s.Status == SlotStatus.Unavailable))
            .ToListAsync(cancellationToken);

        // Remove the existing available/unavailable future slots to prepare for regeneration.
        if (existingSlotsToRemove.Any())
        {
            _dbContext.AppointmentSlots.RemoveRange(existingSlotsToRemove);
        }
        else
        {
            // No slots to remove.
        }

        // Calculate the maximum date for advance booking.
        var targetEndDate = today.AddDays(clinic.MaxAdvanceBookingDays);

        // Prepare a list to hold the newly generated slots.
        var newSlots = new List<AppointmentSlot>();

        // Query existing slots that are Booked or Pending to avoid generating duplicates.
        var existingReservedSlots = await _dbContext.AppointmentSlots
            .AsNoTracking()
            .Where(s => s.ClinicId == clinicId && s.Date >= today && (s.Status == SlotStatus.Booked || s.Status == SlotStatus.Pending))
            .ToListAsync(cancellationToken);

        // Loop through each date from today to the target end date.
        for (var date = today; date <= targetEndDate; date = date.AddDays(1))
        {
            // Filter the working periods that apply to the current day of the week and are active.
            var activePeriods = clinic.WorkingPeriods
                .Where(wp => wp.IsActive && wp.DayOfWeek == (DayOfWeek)date.DayOfWeek)
                .ToList();

            // Iterate over each active working period for the current day.
            foreach (var wp in activePeriods)
            {
                // Initialize the start time for the first slot in the period.
                var slotStart = wp.StartTime;

                // Loop to create slots until the next slot would exceed the period's end time.
                while (slotStart.AddMinutes(clinic.AppointmentDurationMinutes) <= wp.EndTime)
                {
                    // Calculate the end time of the current slot.
                    var slotEnd = slotStart.AddMinutes(clinic.AppointmentDurationMinutes);

                    // Check if the current slot overlaps with any break in the working period.
                    bool hasBreak = wp.Breaks.Any(b => b.StartTime < slotEnd && slotStart < b.EndTime);

                    // Check if there is an existing Booked or Pending slot that overlaps with the current slot.
                    bool isReserved = existingReservedSlots.Any(s => s.Date == date && s.StartTime < slotEnd && slotStart < s.EndTime);

                    // If the slot is already reserved, skip generating it.
                    if (isReserved)
                    {
                        // Advance to the next slot time.
                        slotStart = slotEnd;
                        continue;
                    }
                    else
                    {
                        // Proceed to create a new slot.
                    }

                    // Create the new appointment slot.
                    var newSlot = new AppointmentSlot
                    {
                        Id = Guid.NewGuid(),
                        ClinicId = clinic.Id,
                        Clinic = clinic,
                        Date = date,
                        StartTime = slotStart,
                        EndTime = slotEnd,
                        Status = hasBreak ? SlotStatus.Unavailable : SlotStatus.Available
                    };

                    // Add the new slot to the batch list.
                    newSlots.Add(newSlot);

                    // Advance to the next slot time.
                    slotStart = slotEnd;
                }
            }
        }

        // Add all newly generated slots to the database context in a single operation.
        if (newSlots.Any())
        {
            await _dbContext.AppointmentSlots.AddRangeAsync(newSlots, cancellationToken);
        }
        else
        {
            // No new slots generated.
        }

        // Save all changes to the database.
        await _dbContext.SaveChangesAsync(cancellationToken);
    }

    /// <summary>
    /// Extends slots for all active clinics up to their maximum advance booking days.
    /// </summary>
    /// <param name="cancellationToken">Cancellation token.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public async Task ExtendSlotsForAllClinicsAsync(CancellationToken cancellationToken = default)
    {
        // Load all active clinics from the database, including their working periods and breaks.
        var clinics = await _dbContext.Clinics
            .Where(c => c.Status == ClinicStatus.Active && c.DeletedAt == null)
            .Include(c => c.WorkingPeriods)
            .ThenInclude(wp => wp.Breaks)
            .ToListAsync(cancellationToken);

        // Get the current date in UTC to use as the starting point.
        var today = DateOnly.FromDateTime(_dateTimeProvider.UtcNow);

        // Iterate over each active clinic to extend its slots.
        foreach (var clinic in clinics)
        {
            // Find the maximum date of existing slots for this clinic.
            var maxDate = await _dbContext.AppointmentSlots
                .Where(s => s.ClinicId == clinic.Id)
                .MaxAsync(s => (DateOnly?)s.Date, cancellationToken);

            // Calculate the target end date based on the clinic's max advance booking days setting.
            var targetEndDate = today.AddDays(clinic.MaxAdvanceBookingDays);

            // Determine the start date for generating new slots.
            DateOnly startDate;
            if (maxDate == null || maxDate < today)
            {
                // Start from today if there are no future slots.
                startDate = today;
            }
            else
            {
                // Start from the day after the last generated slot.
                startDate = maxDate.Value.AddDays(1);
            }

            // Generate slots only if the start date is within the target end date.
            if (startDate <= targetEndDate)
            {
                // Prepare a list to hold the newly generated slots for this clinic.
                var clinicSlots = new List<AppointmentSlot>();

                // Loop through each date from the start date to the target end date.
                for (var date = startDate; date <= targetEndDate; date = date.AddDays(1))
                {
                    // Filter the working periods that apply to the current day of the week and are active.
                    var activePeriods = clinic.WorkingPeriods
                        .Where(wp => wp.IsActive && wp.DayOfWeek == (DayOfWeek)date.DayOfWeek)
                        .ToList();

                    // Iterate over each active working period for the current day.
                    foreach (var wp in activePeriods)
                    {
                        // Initialize the start time for the first slot in the period.
                        var slotStart = wp.StartTime;

                        // Loop to create slots until the next slot would exceed the period's end time.
                        while (slotStart.AddMinutes(clinic.AppointmentDurationMinutes) <= wp.EndTime)
                        {
                            // Calculate the end time of the current slot.
                            var slotEnd = slotStart.AddMinutes(clinic.AppointmentDurationMinutes);

                            // Check if the current slot overlaps with any break in the working period.
                            bool hasBreak = wp.Breaks.Any(b => b.StartTime < slotEnd && slotStart < b.EndTime);

                            // Create the new appointment slot.
                            var newSlot = new AppointmentSlot
                            {
                                Id = Guid.NewGuid(),
                                ClinicId = clinic.Id,
                                Clinic = clinic,
                                Date = date,
                                StartTime = slotStart,
                                EndTime = slotEnd,
                                Status = hasBreak ? SlotStatus.Unavailable : SlotStatus.Available
                            };

                            // Add the new slot to the batch list.
                            clinicSlots.Add(newSlot);

                            // Advance to the next slot time.
                            slotStart = slotEnd;
                        }
                    }
                }

                // Add all newly generated slots for this clinic to the database context.
                if (clinicSlots.Any())
                {
                    await _dbContext.AppointmentSlots.AddRangeAsync(clinicSlots, cancellationToken);
                }
                else
                {
                    // No new slots generated.
                }
            }
            else
            {
                // No need to extend slots for this clinic.
            }
        }

        // Save all changes to the database.
        await _dbContext.SaveChangesAsync(cancellationToken);
    }

    /// <summary>
    /// Resets pending slots that have expired back to available status.
    /// </summary>
    /// <param name="cancellationToken">Cancellation token.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public async Task ResetExpiredPendingSlotsAsync(CancellationToken cancellationToken = default)
    {
        // Calculate the cutoff time for pending slots.
        var cutoff = _dateTimeProvider.UtcNow.AddMinutes(-ClinicConstants.PendingTimeoutMinutes);

        // Query pending slots that have expired.
        var expiredSlots = await _dbContext.AppointmentSlots
            .Where(s => s.Status == SlotStatus.Pending && s.UpdatedAt < cutoff)
            .ToListAsync(cancellationToken);

        // Reset the status of each expired slot to Available.
        if (expiredSlots.Any())
        {
            foreach (var slot in expiredSlots)
            {
                // Update the slot status to Available.
                slot.Status = SlotStatus.Available;
            }

            // Save all changes to the database.
            await _dbContext.SaveChangesAsync(cancellationToken);
        }
        else
        {
            // No expired pending slots found.
        }
    }
}
