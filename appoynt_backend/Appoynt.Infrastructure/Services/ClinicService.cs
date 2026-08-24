/**
 * File Name      : ClinicService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : IClinicService, ApplicationDbContext, ICurrentUserService, ISlotGenerationService, IValidator, ILogger
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Implements clinic management operations including CRUD, scheduling, breaks, phone numbers, receptionist assignment, and slot generation.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Application.Common.Validation;
using Appoynt.Application.Features.Clinics.Contracts;
using Appoynt.Application.Features.Clinics.Validation;
using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Persistence;
using FluentValidation;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace Appoynt.Infrastructure.Services;

/// <summary>
/// Service responsible for managing clinics, their schedules, phone numbers, and slot generation.
/// </summary>
public sealed class ClinicService : IClinicService
{
    #region Dependencies

    private readonly ApplicationDbContext _dbContext;
    private readonly ICurrentUserService _currentUserService;
    private readonly ISlotGenerationService _slotGenerationService;
    private readonly IValidator<CreateClinicRequest> _createValidator;
    private readonly IValidator<UpdateClinicRequest> _updateValidator;
    private readonly IValidator<WorkingPeriodRequest> _periodValidator;
    private readonly IValidator<BreakRequest> _breakValidator;
    private readonly ILogger<ClinicService> _logger;
    private readonly IDateTimeProvider _dateTimeProvider;

    #endregion

    #region Constructor

    /// <summary>
    /// Initializes a new instance of the <see cref="ClinicService"/> class.
    /// </summary>
    /// <param name="dbContext">The application database context.</param>
    /// <param name="currentUserService">The current authenticated user service.</param>
    /// <param name="slotGenerationService">The slot generation service.</param>
    /// <param name="createValidator">The create clinic request validator.</param>
    /// <param name="updateValidator">The update clinic request validator.</param>
    /// <param name="periodValidator">The working period request validator.</param>
    /// <param name="breakValidator">The break request validator.</param>
    /// <param name="logger">The logger instance.</param>
    /// <param name="dateTimeProvider">The abstraction for deterministic UTC timestamps.</param>
    public ClinicService(
        ApplicationDbContext dbContext,
        ICurrentUserService currentUserService,
        ISlotGenerationService slotGenerationService,
        IValidator<CreateClinicRequest> createValidator,
        IValidator<UpdateClinicRequest> updateValidator,
        IValidator<WorkingPeriodRequest> periodValidator,
        IValidator<BreakRequest> breakValidator,
        ILogger<ClinicService> logger,
        IDateTimeProvider dateTimeProvider)
    {
        _dbContext = dbContext;
        _currentUserService = currentUserService;
        _slotGenerationService = slotGenerationService;
        _createValidator = createValidator;
        _updateValidator = updateValidator;
        _periodValidator = periodValidator;
        _breakValidator = breakValidator;
        _logger = logger;
        _dateTimeProvider = dateTimeProvider;
    }

    #endregion

    #region Private Helpers

    /// <summary>
    /// Resolves the doctor profile associated with the currently authenticated user.
    /// When <see cref="Failure"/> is non-null the <c>Doctor</c> element must not be used.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The resolved doctor on success, or a failure result describing why resolution failed.</returns>
    private async Task<(Doctor Doctor, ClinicResult? Failure)> ResolveCurrentDoctorAsync(CancellationToken cancellationToken)
    {
        // Reject anonymous callers up front.
        Guid? userId = _currentUserService.UserId;
        if (userId == null)
        {
            // The doctor element is undefined on the failure path.
            return (null!, ClinicResult.Failure(AuthenticationErrorCodes.Forbidden, "UserId"));
        }
        else
        {
            // User ID present.
        }

        // Locate the doctor record linked to the authenticated user.
        Doctor? doctor = await _dbContext.Doctors.FirstOrDefaultAsync(d => d.UserId == userId.Value, cancellationToken);
        if (doctor == null)
        {
            // The doctor element is undefined on the failure path.
            return (null!, ClinicResult.Failure(AuthenticationErrorCodes.Forbidden, "Doctor"));
        }
        else
        {
            // Doctor found.
        }

        return (doctor, null);
    }

    /// <summary>
    /// Loads an active clinic by identifier and verifies the supplied doctor owns it.
    /// When <see cref="Failure"/> is non-null the <c>Clinic</c> element must not be used.
    /// </summary>
    /// <param name="clinicId">The clinic identifier.</param>
    /// <param name="doctor">The authenticated doctor used for the ownership check.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <param name="shape">Optional query shaping delegate for eager loading related collections.</param>
    /// <returns>The owned clinic on success, or a failure result when missing or foreign-owned.</returns>
    private async Task<(Clinic Clinic, ClinicResult? Failure)> GetOwnedClinicAsync(
        Guid clinicId,
        Doctor doctor,
        CancellationToken cancellationToken,
        Func<IQueryable<Clinic>, IQueryable<Clinic>>? shape = null)
    {
        // Apply optional eager loading while keeping the shared filter logic.
        IQueryable<Clinic> query = shape != null ? shape(_dbContext.Clinics) : _dbContext.Clinics;

        // Load the active clinic from database.
        Clinic? clinic = await query.FirstOrDefaultAsync(c => c.Id == clinicId && c.DeletedAt == null, cancellationToken);
        if (clinic == null)
        {
            // The clinic element is undefined on the failure path.
            return (null!, ClinicResult.Failure(ClinicErrorCodes.ClinicNotFound, nameof(clinicId)));
        }
        else
        {
            // Clinic found.
        }

        // Verify the requesting doctor owns this clinic.
        if (clinic.DoctorId != doctor.Id)
        {
            // The clinic element is undefined on the failure path.
            return (null!, ClinicResult.Failure(ClinicErrorCodes.NotOwner, "DoctorId"));
        }
        else
        {
            // Ownership verified.
        }

        return (clinic, null);
    }

    /// <summary>
    /// Persists pending clinic or schedule changes together with appointment slot
    /// regeneration as one atomic unit. If slot generation fails, both writes are rolled back.
    /// </summary>
    /// <param name="clinicId">The clinic whose slots may need regeneration.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <param name="regenerateSlots">When true, slots are regenerated after saving.</param>
    private async Task SaveAndRegenerateSlotsAsync(
        Guid clinicId,
        CancellationToken cancellationToken,
        bool regenerateSlots = true)
    {
        // Group the schedule persistence and slot regeneration into a single transaction.
        await using var transaction = await _dbContext.Database.BeginTransactionAsync(cancellationToken);

        // Persist the pending clinic or schedule mutations first.
        await _dbContext.SaveChangesAsync(cancellationToken);

        // Regenerate appointment slots from the updated schedule when requested.
        if (regenerateSlots)
        {
            await _slotGenerationService.GenerateSlotsForClinicAsync(clinicId, cancellationToken);
        }
        else
        {
            // No slot regeneration requested.
        }

        // Commit only after every write in the unit has succeeded.
        await transaction.CommitAsync(cancellationToken);
    }

    #endregion

    #region Clinic CRUD

    /// <inheritdoc />
    public async Task<ClinicResult> CreateClinicAsync(CreateClinicRequest request, CancellationToken cancellationToken = default)
    {
        // Validate incoming request.
        var validationResult = await _createValidator.ValidateAsync(request, cancellationToken);
        if (!validationResult.IsValid)
        {
            return ClinicResult.Failure(validationResult.ToAuthenticationErrors().Select(error => new ClinicError(error.Code, error.Field)));
        }
        else
        {
            // Validation passed.
        }

        // Resolve the authenticated doctor or capture a failure result.
        var (doctor, doctorResolutionFailure) = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctorResolutionFailure != null)
        {
            return doctorResolutionFailure;
        }
        else
        {
            // Doctor resolved.
        }

        // Check active clinics count limit for this doctor.
        int currentClinicsCount = await _dbContext.Clinics
            .CountAsync(c => c.DoctorId == doctor.Id && c.DeletedAt == null, cancellationToken);

        if (currentClinicsCount >= ClinicConstants.MaxClinicsPerDoctor)
        {
            return ClinicResult.Failure(ClinicErrorCodes.MaxClinicsExceeded, "ClinicLimit");
        }
        else
        {
            // Under limit.
        }

        // Verify city and governorate existence and consistency.
        var city = await _dbContext.Cities
            .AsNoTracking()
            .FirstOrDefaultAsync(c => c.Id == request.CityId!.Value && c.DeletedAt == null, cancellationToken);

        if (city == null)
        {
            return ClinicResult.Failure(ClinicErrorCodes.CityNotFound, nameof(request.CityId));
        }
        else
        {
            // City exists.
        }

        if (city.GovernorateId != request.GovernorateId!.Value)
        {
            return ClinicResult.Failure(ClinicErrorCodes.CityGovernorateMismatch, nameof(request.CityId));
        }
        else
        {
            // City belongs to governorate.
        }

        // Check for cross-clinic schedule conflicts if working periods provided.
        if (request.WorkingPeriods != null && request.WorkingPeriods.Count > 0)
        {
            // Check cross-clinic conflicts for each requested working period.
            foreach (var wpReq in request.WorkingPeriods)
            {
                var dayOfWeek = (DayOfWeek)wpReq.DayOfWeek!.Value;
                var wpStartTime = TimeOnly.Parse(wpReq.StartTime!);
                var wpEndTime = TimeOnly.Parse(wpReq.EndTime!);

                // Load existing periods for this doctor on the same day.
                var existingPeriods = await _dbContext.ClinicWorkingPeriods
                    .Where(wp => wp.Clinic.DoctorId == doctor.Id && wp.DayOfWeek == dayOfWeek && wp.IsActive && wp.DeletedAt == null)
                    .Select(wp => new { wp.StartTime, wp.EndTime })
                    .ToListAsync(cancellationToken);

                // Detect overlaps.
                bool hasConflict = existingPeriods.Any(ep => ep.StartTime < wpEndTime && wpStartTime < ep.EndTime);
                if (hasConflict)
                {
                    return ClinicResult.Failure(ClinicErrorCodes.CrossClinicConflict, nameof(request.WorkingPeriods));
                }
                else
                {
                    // No conflict on this period.
                }
            }
        }
        else
        {
            // No initial working periods requested.
        }

        // Create Clinic entity.
        var clinic = new Clinic
        {
            Id = Guid.NewGuid(),
            DoctorId = doctor.Id,
            Doctor = doctor,
            Name = request.Name!,
            GovernorateId = request.GovernorateId!.Value,
            Governorate = null!,
            CityId = request.CityId!.Value,
            City = null!,
            DetailedAddress = request.DetailedAddress,
            ConsultationFee = request.ConsultationFee!.Value,
            Status = ClinicStatus.Active,
            AppointmentDurationMinutes = request.AppointmentDurationMinutes!.Value,
            MaxAdvanceBookingDays = request.MaxAdvanceBookingDays!.Value
        };

        // Attach phone numbers if provided.
        if (request.PhoneNumbers != null && request.PhoneNumbers.Count > 0)
        {
            foreach (var phoneDto in request.PhoneNumbers)
            {
                clinic.PhoneNumbers.Add(new ClinicPhoneNumber
                {
                    Id = Guid.NewGuid(),
                    ClinicId = clinic.Id,
                    Clinic = clinic,
                    PhoneNumber = phoneDto.PhoneNumber!,
                    Label = phoneDto.Label!
                });
            }
        }
        else
        {
            // No phone numbers.
        }

        // Attach working periods and breaks if provided.
        if (request.WorkingPeriods != null && request.WorkingPeriods.Count > 0)
        {
            foreach (var wpReq in request.WorkingPeriods)
            {
                var wp = new ClinicWorkingPeriod
                {
                    Id = Guid.NewGuid(),
                    ClinicId = clinic.Id,
                    Clinic = clinic,
                    DayOfWeek = (DayOfWeek)wpReq.DayOfWeek!.Value,
                    StartTime = TimeOnly.Parse(wpReq.StartTime!),
                    EndTime = TimeOnly.Parse(wpReq.EndTime!),
                    IsActive = true
                };

                if (wpReq.Breaks != null && wpReq.Breaks.Count > 0)
                {
                    foreach (var brReq in wpReq.Breaks)
                    {
                        wp.Breaks.Add(new ClinicBreak
                        {
                            Id = Guid.NewGuid(),
                            WorkingPeriodId = wp.Id,
                            WorkingPeriod = wp,
                            StartTime = TimeOnly.Parse(brReq.StartTime!),
                            EndTime = TimeOnly.Parse(brReq.EndTime!)
                        });
                    }
                }
                else
                {
                    // No breaks.
                }

                clinic.WorkingPeriods.Add(wp);
            }
        }
        else
        {
            // No working periods.
        }

        // Add clinic to DbContext.
        _dbContext.Clinics.Add(clinic);

        // Persist the new clinic and generate its initial slots atomically.
        await SaveAndRegenerateSlotsAsync(clinic.Id, cancellationToken);

        _logger.LogInformation("Clinic '{ClinicName}' ({ClinicId}) created successfully for doctor {DoctorId}.", clinic.Name, clinic.Id, doctor.Id);

        return ClinicResult.Success(clinic.Id);
    }

    /// <inheritdoc />
    public async Task<ClinicResult> UpdateClinicAsync(Guid clinicId, UpdateClinicRequest request, CancellationToken cancellationToken = default)
    {
        // Validate request.
        var validationResult = await _updateValidator.ValidateAsync(request, cancellationToken);
        if (!validationResult.IsValid)
        {
            return ClinicResult.Failure(validationResult.ToAuthenticationErrors().Select(error => new ClinicError(error.Code, error.Field)));
        }
        else
        {
            // Validation passed.
        }

        // Resolve the authenticated doctor or capture a failure result.
        var (doctor, doctorResolutionFailure) = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctorResolutionFailure != null)
        {
            return doctorResolutionFailure;
        }
        else
        {
            // Doctor resolved.
        }

// Load and verify ownership of the target clinic.
        var (clinic, ownedClinicFailure) = await GetOwnedClinicAsync(clinicId, doctor, cancellationToken);
        if (ownedClinicFailure != null)
        {
            return ownedClinicFailure;
        }
        else
        {
            // Clinic resolved.
        }

        // Verify city/governorate if provided.
        if (request.CityId.HasValue && request.GovernorateId.HasValue)
        {
            var city = await _dbContext.Cities.AsNoTracking().FirstOrDefaultAsync(c => c.Id == request.CityId.Value && c.DeletedAt == null, cancellationToken);
            if (city == null)
            {
                return ClinicResult.Failure(ClinicErrorCodes.CityNotFound, nameof(request.CityId));
            }
            else
            {
                // City exists.
            }

            if (city.GovernorateId != request.GovernorateId.Value)
            {
                return ClinicResult.Failure(ClinicErrorCodes.CityGovernorateMismatch, nameof(request.CityId));
            }
            else
            {
                // Matches.
            }

            clinic.CityId = request.CityId.Value;
            clinic.GovernorateId = request.GovernorateId.Value;
        }
        else
        {
            // No location change.
        }

        // Update properties if provided.
        if (!string.IsNullOrWhiteSpace(request.Name))
        {
            clinic.Name = request.Name;
        }
        else
        {
            // Keep existing name.
        }

        if (request.DetailedAddress != null)
        {
            clinic.DetailedAddress = request.DetailedAddress;
        }
        else
        {
            // Keep existing detailed address.
        }

        if (request.ConsultationFee.HasValue)
        {
            clinic.ConsultationFee = request.ConsultationFee.Value;
        }
        else
        {
            // Keep existing fee.
        }

        bool durationChanged = false;
        if (request.AppointmentDurationMinutes.HasValue && clinic.AppointmentDurationMinutes != request.AppointmentDurationMinutes.Value)
        {
            clinic.AppointmentDurationMinutes = request.AppointmentDurationMinutes.Value;
            durationChanged = true;
        }
        else
        {
            // Duration unchanged.
        }

        if (request.MaxAdvanceBookingDays.HasValue)
        {
            clinic.MaxAdvanceBookingDays = request.MaxAdvanceBookingDays.Value;
        }
        else
        {
            // Advance booking window unchanged.
        }

        bool statusChangedToInactive = false;
        if (request.Status.HasValue)
        {
            var newStatus = (ClinicStatus)request.Status.Value;
            if (clinic.Status != newStatus && newStatus == ClinicStatus.Inactive)
            {
                statusChangedToInactive = true;
            }
            else
            {
                // Status not transitioning to inactive.
            }

            clinic.Status = newStatus;
        }
        else
        {
            // Status unchanged.
        }

        // If clinic is marked Inactive, turn future Available slots into Unavailable.
        if (statusChangedToInactive)
        {
            var today = DateOnly.FromDateTime(_dateTimeProvider.UtcNow);
            var futureSlots = await _dbContext.AppointmentSlots
                .Where(s => s.ClinicId == clinic.Id && s.Date >= today && s.Status == SlotStatus.Available)
                .ToListAsync(cancellationToken);

            foreach (var slot in futureSlots)
            {
                slot.Status = SlotStatus.Unavailable;
            }
        }
        else
        {
            // Active status retained.
        }

        // Persist changes and regenerate slots atomically when the duration changed.
        await SaveAndRegenerateSlotsAsync(
            clinic.Id,
            cancellationToken,
            regenerateSlots: durationChanged && clinic.Status == ClinicStatus.Active);

        return ClinicResult.Success(clinic.Id);
    }

    /// <inheritdoc />
    public async Task<ClinicResult> DeleteClinicAsync(Guid clinicId, CancellationToken cancellationToken = default)
    {
        // Resolve the authenticated doctor or capture a failure result.
        var (doctor, doctorResolutionFailure) = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctorResolutionFailure != null)
        {
            return doctorResolutionFailure;
        }
        else
        {
            // Doctor resolved.
        }

// Load and verify ownership of the target clinic.
        var (clinic, ownedClinicFailure) = await GetOwnedClinicAsync(clinicId, doctor, cancellationToken);
        if (ownedClinicFailure != null)
        {
            return ownedClinicFailure;
        }
        else
        {
            // Clinic resolved.
        }

        // Soft delete the clinic.
        _dbContext.Clinics.Remove(clinic);

        // Mark future Available slots as Unavailable.
        var today = DateOnly.FromDateTime(_dateTimeProvider.UtcNow);
        var futureSlots = await _dbContext.AppointmentSlots
            .Where(s => s.ClinicId == clinicId && s.Date >= today && s.Status == SlotStatus.Available)
            .ToListAsync(cancellationToken);

        foreach (var slot in futureSlots)
        {
            slot.Status = SlotStatus.Unavailable;
        }

        // Save changes.
        await _dbContext.SaveChangesAsync(cancellationToken);

        _logger.LogInformation("Clinic '{ClinicName}' ({ClinicId}) soft-deleted successfully.", clinic.Name, clinicId);

        return ClinicResult.Success(clinicId);
    }

    /// <inheritdoc />
    public async Task<ClinicResponse?> GetClinicByIdAsync(Guid clinicId, CancellationToken cancellationToken = default)
    {
        // Query clinic with full relationships using AsNoTracking.
        var clinic = await _dbContext.Clinics
            .AsNoTracking()
            .Include(c => c.Governorate)
            .Include(c => c.City)
            .Include(c => c.PhoneNumbers)
            .Include(c => c.WorkingPeriods)
            .ThenInclude(wp => wp.Breaks)
            .FirstOrDefaultAsync(c => c.Id == clinicId && c.DeletedAt == null, cancellationToken);

        if (clinic == null)
        {
            return null;
        }
        else
        {
            return MapToClinicResponse(clinic);
        }
    }

    /// <inheritdoc />
    public async Task<List<ClinicResponse>> GetMyClinicsAsync(CancellationToken cancellationToken = default)
    {
        var userId = _currentUserService.UserId;
        if (userId == null)
        {
            return [];
        }
        else
        {
            // User ID present.
        }

        var doctor = await _dbContext.Doctors.AsNoTracking().FirstOrDefaultAsync(d => d.UserId == userId.Value, cancellationToken);
        if (doctor == null)
        {
            return [];
        }
        else
        {
            // Doctor found.
        }

        var clinics = await _dbContext.Clinics
            .AsNoTracking()
            .Include(c => c.Governorate)
            .Include(c => c.City)
            .Include(c => c.PhoneNumbers)
            .Include(c => c.WorkingPeriods)
            .ThenInclude(wp => wp.Breaks)
            .Where(c => c.DoctorId == doctor.Id && c.DeletedAt == null)
            .ToListAsync(cancellationToken);

        return clinics.Select(MapToClinicResponse).ToList();
    }

    /// <inheritdoc />
    public async Task<List<ClinicResponse>> GetDoctorClinicsAsync(Guid doctorId, CancellationToken cancellationToken = default)
    {
        var clinics = await _dbContext.Clinics
            .AsNoTracking()
            .Include(c => c.Governorate)
            .Include(c => c.City)
            .Include(c => c.PhoneNumbers)
            .Include(c => c.WorkingPeriods)
            .ThenInclude(wp => wp.Breaks)
            .Where(c => c.DoctorId == doctorId && c.Status == ClinicStatus.Active && c.DeletedAt == null)
            .ToListAsync(cancellationToken);

        return clinics.Select(MapToClinicResponse).ToList();
    }

    #endregion

    #region Phone Numbers

    /// <inheritdoc />
    public async Task<ClinicResult> AddPhoneNumberAsync(Guid clinicId, ClinicPhoneNumberDto dto, CancellationToken cancellationToken = default)
    {
        // Resolve the authenticated doctor or capture a failure result.
        var (doctor, doctorResolutionFailure) = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctorResolutionFailure != null)
        {
            return doctorResolutionFailure;
        }
        else
        {
            // Doctor resolved.
        }

        // Load and verify ownership of the target clinic including its phone numbers.
        var (clinic, ownedClinicFailure) = await GetOwnedClinicAsync(
            clinicId, doctor, cancellationToken, query => query.Include(c => c.PhoneNumbers));
        if (ownedClinicFailure != null)
        {
            return ownedClinicFailure;
        }
        else
        {
            // Clinic resolved.
        }

        // Validate max phone numbers count.
        if (clinic.PhoneNumbers.Count >= ClinicConstants.MaxPhoneNumbersPerClinic)
        {
            return ClinicResult.Failure(ClinicErrorCodes.PhoneMaxExceeded, "PhoneNumbers");
        }
        else
        {
            // Under limit.
        }

        // Validate duplicate phone number.
        bool isDuplicate = clinic.PhoneNumbers.Any(p => p.PhoneNumber.Equals(dto.PhoneNumber, StringComparison.OrdinalIgnoreCase));
        if (isDuplicate)
        {
            return ClinicResult.Failure(ClinicErrorCodes.PhoneDuplicate, nameof(dto.PhoneNumber));
        }
        else
        {
            // Not duplicate.
        }

        // Add phone number entity.
        var phone = new ClinicPhoneNumber
        {
            Id = Guid.NewGuid(),
            ClinicId = clinic.Id,
            Clinic = clinic,
            PhoneNumber = dto.PhoneNumber!,
            Label = dto.Label!
        };

        _dbContext.ClinicPhoneNumbers.Add(phone);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return ClinicResult.Success(clinicId);
    }

    /// <inheritdoc />
    public async Task<ClinicResult> RemovePhoneNumberAsync(Guid clinicId, Guid phoneNumberId, CancellationToken cancellationToken = default)
    {
        // Resolve the authenticated doctor or capture a failure result.
        var (doctor, doctorResolutionFailure) = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctorResolutionFailure != null)
        {
            return doctorResolutionFailure;
        }
        else
        {
            // Doctor resolved.
        }

        // Load phone number entity.
        var phone = await _dbContext.ClinicPhoneNumbers
            .Include(p => p.Clinic)
            .FirstOrDefaultAsync(p => p.Id == phoneNumberId && p.ClinicId == clinicId && p.DeletedAt == null, cancellationToken);

        if (phone == null)
        {
            return ClinicResult.Failure(ClinicErrorCodes.PhoneNotFound, nameof(phoneNumberId));
        }
        else
        {
            // Phone found.
        }

        // Verify ownership.
        if (phone.Clinic.DoctorId != doctor.Id)
        {
            return ClinicResult.Failure(ClinicErrorCodes.NotOwner, "DoctorId");
        }
        else
        {
            // Ownership verified.
        }

        // Remove phone number entity.
        _dbContext.ClinicPhoneNumbers.Remove(phone);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return ClinicResult.Success(clinicId);
    }

    #endregion

    #region Working Periods

    /// <inheritdoc />
    public async Task<ClinicResult> AddWorkingPeriodAsync(Guid clinicId, WorkingPeriodRequest request, CancellationToken cancellationToken = default)
    {
        // Validate request.
        var validationResult = await _periodValidator.ValidateAsync(request, cancellationToken);
        if (!validationResult.IsValid)
        {
            return ClinicResult.Failure(validationResult.ToAuthenticationErrors().Select(error => new ClinicError(error.Code, error.Field)));
        }
        else
        {
            // Validation passed.
        }

        // Resolve the authenticated doctor or capture a failure result.
        var (doctor, doctorResolutionFailure) = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctorResolutionFailure != null)
        {
            return doctorResolutionFailure;
        }
        else
        {
            // Doctor resolved.
        }

// Load and verify ownership of the target clinic.
        var (clinic, ownedClinicFailure) = await GetOwnedClinicAsync(clinicId, doctor, cancellationToken);
        if (ownedClinicFailure != null)
        {
            return ownedClinicFailure;
        }
        else
        {
            // Clinic resolved.
        }

        var dayOfWeek = (DayOfWeek)request.DayOfWeek!.Value;
        var wpStartTime = TimeOnly.Parse(request.StartTime!);
        var wpEndTime = TimeOnly.Parse(request.EndTime!);

        // Check cross-clinic conflicts for this doctor across all clinics for this day.
        var existingPeriods = await _dbContext.ClinicWorkingPeriods
            .Where(wp => wp.Clinic.DoctorId == doctor.Id && wp.DayOfWeek == dayOfWeek && wp.IsActive && wp.DeletedAt == null)
            .Select(wp => new { wp.StartTime, wp.EndTime })
            .ToListAsync(cancellationToken);

        bool hasConflict = existingPeriods.Any(ep => ep.StartTime < wpEndTime && wpStartTime < ep.EndTime);
        if (hasConflict)
        {
            return ClinicResult.Failure(ClinicErrorCodes.CrossClinicConflict, nameof(request.StartTime));
        }
        else
        {
            // No conflict.
        }

        // Create working period.
        var period = new ClinicWorkingPeriod
        {
            Id = Guid.NewGuid(),
            ClinicId = clinic.Id,
            Clinic = clinic,
            DayOfWeek = dayOfWeek,
            StartTime = wpStartTime,
            EndTime = wpEndTime,
            IsActive = true
        };

        // Attach breaks if provided.
        if (request.Breaks != null && request.Breaks.Count > 0)
        {
            foreach (var brReq in request.Breaks)
            {
                var brStartTime = TimeOnly.Parse(brReq.StartTime!);
                var brEndTime = TimeOnly.Parse(brReq.EndTime!);

                if (brStartTime < wpStartTime || brEndTime > wpEndTime)
                {
                    return ClinicResult.Failure(ClinicErrorCodes.BreakOutsidePeriod, nameof(request.Breaks));
                }
                else
                {
                    // Within range.
                }

                period.Breaks.Add(new ClinicBreak
                {
                    Id = Guid.NewGuid(),
                    WorkingPeriodId = period.Id,
                    WorkingPeriod = period,
                    StartTime = brStartTime,
                    EndTime = brEndTime
                });
            }
        }
        else
        {
            // No breaks.
        }

        await SaveAndRegenerateSlotsAsync(clinicId, cancellationToken);

        return ClinicResult.Success(clinicId);
    }

    /// <inheritdoc />
    public async Task<ClinicResult> UpdateWorkingPeriodAsync(Guid clinicId, Guid periodId, WorkingPeriodRequest request, CancellationToken cancellationToken = default)
    {
        // Validate request.
        var validationResult = await _periodValidator.ValidateAsync(request, cancellationToken);
        if (!validationResult.IsValid)
        {
            return ClinicResult.Failure(validationResult.ToAuthenticationErrors().Select(error => new ClinicError(error.Code, error.Field)));
        }
        else
        {
            // Validation passed.
        }

        // Resolve the authenticated doctor or capture a failure result.
        var (doctor, doctorResolutionFailure) = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctorResolutionFailure != null)
        {
            return doctorResolutionFailure;
        }
        else
        {
            // Doctor resolved.
        }

        // Load working period.
        var period = await _dbContext.ClinicWorkingPeriods
            .Include(wp => wp.Clinic)
            .Include(wp => wp.Breaks)
            .FirstOrDefaultAsync(wp => wp.Id == periodId && wp.ClinicId == clinicId && wp.DeletedAt == null, cancellationToken);

        if (period == null)
        {
            return ClinicResult.Failure(ClinicErrorCodes.WorkingPeriodNotFound, nameof(periodId));
        }
        else
        {
            // Period found.
        }

        // Verify ownership.
        if (period.Clinic.DoctorId != doctor.Id)
        {
            return ClinicResult.Failure(ClinicErrorCodes.NotOwner, "DoctorId");
        }
        else
        {
            // Ownership verified.
        }

        var dayOfWeek = (DayOfWeek)request.DayOfWeek!.Value;
        var wpStartTime = TimeOnly.Parse(request.StartTime!);
        var wpEndTime = TimeOnly.Parse(request.EndTime!);

        // Check cross-clinic conflicts for this doctor (excluding self).
        var existingPeriods = await _dbContext.ClinicWorkingPeriods
            .Where(wp => wp.Clinic.DoctorId == doctor.Id && wp.DayOfWeek == dayOfWeek && wp.IsActive && wp.Id != periodId && wp.DeletedAt == null)
            .Select(wp => new { wp.StartTime, wp.EndTime })
            .ToListAsync(cancellationToken);

        bool hasConflict = existingPeriods.Any(ep => ep.StartTime < wpEndTime && wpStartTime < ep.EndTime);
        if (hasConflict)
        {
            return ClinicResult.Failure(ClinicErrorCodes.CrossClinicConflict, nameof(request.StartTime));
        }
        else
        {
            // No conflict.
        }

        period.DayOfWeek = dayOfWeek;
        period.StartTime = wpStartTime;
        period.EndTime = wpEndTime;

        // Persist the mutation and regenerate slots atomically.
        await SaveAndRegenerateSlotsAsync(clinicId, cancellationToken);

        return ClinicResult.Success(clinicId);
    }

    /// <inheritdoc />
    public async Task<ClinicResult> DeleteWorkingPeriodAsync(Guid clinicId, Guid periodId, CancellationToken cancellationToken = default)
    {
        // Resolve the authenticated doctor or capture a failure result.
        var (doctor, doctorResolutionFailure) = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctorResolutionFailure != null)
        {
            return doctorResolutionFailure;
        }
        else
        {
            // Doctor resolved.
        }

        // Load period.
        var period = await _dbContext.ClinicWorkingPeriods
            .Include(wp => wp.Clinic)
            .FirstOrDefaultAsync(wp => wp.Id == periodId && wp.ClinicId == clinicId && wp.DeletedAt == null, cancellationToken);

        if (period == null)
        {
            return ClinicResult.Failure(ClinicErrorCodes.WorkingPeriodNotFound, nameof(periodId));
        }
        else
        {
            // Period found.
        }

        // Verify ownership.
        if (period.Clinic.DoctorId != doctor.Id)
        {
            return ClinicResult.Failure(ClinicErrorCodes.NotOwner, "DoctorId");
        }
        else
        {
            // Ownership verified.
        }

        _dbContext.ClinicWorkingPeriods.Remove(period);

        // Persist the mutation and regenerate slots atomically.
        await SaveAndRegenerateSlotsAsync(clinicId, cancellationToken);

        return ClinicResult.Success(clinicId);
    }

    #endregion

    #region Breaks

    /// <inheritdoc />
    public async Task<ClinicResult> AddBreakAsync(Guid clinicId, Guid periodId, BreakRequest request, CancellationToken cancellationToken = default)
    {
        // Validate request.
        var validationResult = await _breakValidator.ValidateAsync(request, cancellationToken);
        if (!validationResult.IsValid)
        {
            return ClinicResult.Failure(validationResult.ToAuthenticationErrors().Select(error => new ClinicError(error.Code, error.Field)));
        }
        else
        {
            // Validation passed.
        }

        // Resolve the authenticated doctor or capture a failure result.
        var (doctor, doctorResolutionFailure) = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctorResolutionFailure != null)
        {
            return doctorResolutionFailure;
        }
        else
        {
            // Doctor resolved.
        }

        // Load working period with breaks.
        var period = await _dbContext.ClinicWorkingPeriods
            .Include(wp => wp.Clinic)
            .Include(wp => wp.Breaks)
            .FirstOrDefaultAsync(wp => wp.Id == periodId && wp.ClinicId == clinicId && wp.DeletedAt == null, cancellationToken);

        if (period == null)
        {
            return ClinicResult.Failure(ClinicErrorCodes.WorkingPeriodNotFound, nameof(periodId));
        }
        else
        {
            // Period found.
        }

        // Verify ownership.
        if (period.Clinic.DoctorId != doctor.Id)
        {
            return ClinicResult.Failure(ClinicErrorCodes.NotOwner, "DoctorId");
        }
        else
        {
            // Ownership verified.
        }

        var brStartTime = TimeOnly.Parse(request.StartTime!);
        var brEndTime = TimeOnly.Parse(request.EndTime!);

        // Ensure break is inside working period range.
        if (brStartTime < period.StartTime || brEndTime > period.EndTime)
        {
            return ClinicResult.Failure(ClinicErrorCodes.BreakOutsidePeriod, nameof(request.StartTime));
        }
        else
        {
            // Inside range.
        }

        // Check max breaks count.
        if (period.Breaks.Count >= ClinicConstants.MaxBreaksPerWorkingPeriod)
        {
            return ClinicResult.Failure(ClinicErrorCodes.BreakMaxExceeded, "Breaks");
        }
        else
        {
            // Under limit.
        }

        // Check overlap with existing breaks.
        bool hasOverlap = period.Breaks.Any(b => b.StartTime < brEndTime && brStartTime < b.EndTime);
        if (hasOverlap)
        {
            return ClinicResult.Failure(ClinicErrorCodes.BreakOverlapDetected, nameof(request.StartTime));
        }
        else
        {
            // No overlap.
        }

        var clinicBreak = new ClinicBreak
        {
            Id = Guid.NewGuid(),
            WorkingPeriodId = period.Id,
            WorkingPeriod = period,
            StartTime = brStartTime,
            EndTime = brEndTime
        };

        _dbContext.ClinicBreaks.Add(clinicBreak);

        // Persist the mutation and regenerate slots atomically.
        await SaveAndRegenerateSlotsAsync(clinicId, cancellationToken);

        return ClinicResult.Success(clinicId);
    }

    /// <inheritdoc />
    public async Task<ClinicResult> RemoveBreakAsync(Guid clinicId, Guid breakId, CancellationToken cancellationToken = default)
    {
        // Resolve the authenticated doctor or capture a failure result.
        var (doctor, doctorResolutionFailure) = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctorResolutionFailure != null)
        {
            return doctorResolutionFailure;
        }
        else
        {
            // Doctor resolved.
        }

        // Load break.
        var clinicBreak = await _dbContext.ClinicBreaks
            .Include(b => b.WorkingPeriod)
            .ThenInclude(wp => wp.Clinic)
            .FirstOrDefaultAsync(b => b.Id == breakId && b.WorkingPeriod.ClinicId == clinicId && b.DeletedAt == null, cancellationToken);

        if (clinicBreak == null)
        {
            return ClinicResult.Failure(ClinicErrorCodes.BreakNotFound, nameof(breakId));
        }
        else
        {
            // Break found.
        }

        // Verify ownership.
        if (clinicBreak.WorkingPeriod.Clinic.DoctorId != doctor.Id)
        {
            return ClinicResult.Failure(ClinicErrorCodes.NotOwner, "DoctorId");
        }
        else
        {
            // Ownership verified.
        }

        _dbContext.ClinicBreaks.Remove(clinicBreak);

        // Persist the mutation and regenerate slots atomically.
        await SaveAndRegenerateSlotsAsync(clinicId, cancellationToken);

        return ClinicResult.Success(clinicId);
    }

    #endregion

    #region Receptionist Assignment

    /// <inheritdoc />
    public async Task<ClinicResult> AssignReceptionistAsync(Guid clinicId, Guid receptionistId, CancellationToken cancellationToken = default)
    {
        // Resolve the authenticated doctor or capture a failure result.
        var (doctor, doctorResolutionFailure) = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctorResolutionFailure != null)
        {
            return doctorResolutionFailure;
        }
        else
        {
            // Doctor resolved.
        }

// Load and verify ownership of the target clinic.
        var (clinic, ownedClinicFailure) = await GetOwnedClinicAsync(clinicId, doctor, cancellationToken);
        if (ownedClinicFailure != null)
        {
            return ownedClinicFailure;
        }
        else
        {
            // Clinic resolved.
        }

        // Load receptionist.
        var receptionist = await _dbContext.Receptionists.FirstOrDefaultAsync(r => r.Id == receptionistId && r.DeletedAt == null, cancellationToken);
        if (receptionist == null)
        {
            return ClinicResult.Failure(ClinicErrorCodes.ReceptionistNotFound, nameof(receptionistId));
        }
        else
        {
            // Receptionist found.
        }

        // Ensure receptionist belongs to the same doctor.
        if (receptionist.DoctorId != doctor.Id)
        {
            return ClinicResult.Failure(ClinicErrorCodes.ReceptionistNotSameDoctor, nameof(receptionistId));
        }
        else
        {
            // Same doctor verified.
        }

        // Check if already assigned.
        bool alreadyAssigned = await _dbContext.ClinicReceptionists
            .AnyAsync(cr => cr.ClinicId == clinicId && cr.ReceptionistId == receptionistId, cancellationToken);

        if (alreadyAssigned)
        {
            return ClinicResult.Failure(ClinicErrorCodes.ReceptionistAlreadyAssigned, nameof(receptionistId));
        }
        else
        {
            // Not assigned yet.
        }

        var clinicReceptionist = new ClinicReceptionist
        {
            ClinicId = clinic.Id,
            Clinic = clinic,
            ReceptionistId = receptionist.Id,
            Receptionist = receptionist
        };

        _dbContext.ClinicReceptionists.Add(clinicReceptionist);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return ClinicResult.Success(clinicId);
    }

    /// <inheritdoc />
    public async Task<ClinicResult> RemoveReceptionistAsync(Guid clinicId, Guid receptionistId, CancellationToken cancellationToken = default)
    {
        // Resolve the authenticated doctor or capture a failure result.
        var (doctor, doctorResolutionFailure) = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctorResolutionFailure != null)
        {
            return doctorResolutionFailure;
        }
        else
        {
            // Doctor resolved.
        }

// Load and verify ownership of the target clinic.
        var (clinic, ownedClinicFailure) = await GetOwnedClinicAsync(clinicId, doctor, cancellationToken);
        if (ownedClinicFailure != null)
        {
            return ownedClinicFailure;
        }
        else
        {
            // Clinic resolved.
        }

        // Find assignment entry.
        var clinicReceptionist = await _dbContext.ClinicReceptionists
            .FirstOrDefaultAsync(cr => cr.ClinicId == clinicId && cr.ReceptionistId == receptionistId, cancellationToken);

        if (clinicReceptionist == null)
        {
            return ClinicResult.Failure(ClinicErrorCodes.ReceptionistNotFound, nameof(receptionistId));
        }
        else
        {
            // Found.
        }

        _dbContext.ClinicReceptionists.Remove(clinicReceptionist);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return ClinicResult.Success(clinicId);
    }

    #endregion

    #region Slots

    /// <inheritdoc />
    public async Task<List<SlotResponse>> GetAvailableSlotsAsync(Guid clinicId, DateOnly date, CancellationToken cancellationToken = default)
    {
        // Query available slots using AsNoTracking for read performance.
        var slots = await _dbContext.AppointmentSlots
            .AsNoTracking()
            .Where(s => s.ClinicId == clinicId && s.Date == date && s.Status == SlotStatus.Available && s.DeletedAt == null)
            .OrderBy(s => s.StartTime)
            .ToListAsync(cancellationToken);

        // Map and return the list of slot responses.
        return slots.Select(s => new SlotResponse
        {
            Id = s.Id,
            Date = s.Date.ToString("yyyy-MM-dd"),
            StartTime = s.StartTime.ToString("HH:mm"),
            EndTime = s.EndTime.ToString("HH:mm"),
            Status = s.Status.ToString()
        }).ToList();
    }

    #endregion

    #region Helper Methods

    /// <summary>
    /// Maps a Clinic entity to a ClinicResponse DTO.
    /// </summary>
    /// <param name="clinic">The clinic entity to map.</param>
    /// <returns>The mapped ClinicResponse DTO.</returns>
    private static ClinicResponse MapToClinicResponse(Clinic clinic)
    {
        return new ClinicResponse
        {
            Id = clinic.Id,
            DoctorId = clinic.DoctorId,
            Name = clinic.Name,
            GovernorateName = clinic.Governorate?.NameEn ?? string.Empty,
            CityName = clinic.City?.NameEn ?? string.Empty,
            DetailedAddress = clinic.DetailedAddress,
            ConsultationFee = clinic.ConsultationFee,
            Status = clinic.Status.ToString(),
            AppointmentDurationMinutes = clinic.AppointmentDurationMinutes,
            MaxAdvanceBookingDays = clinic.MaxAdvanceBookingDays,
            PhoneNumbers = clinic.PhoneNumbers.Select(p => new ClinicPhoneNumberDto
            {
                PhoneNumber = p.PhoneNumber,
                Label = p.Label
            }).ToList(),
            WorkingPeriods = clinic.WorkingPeriods.Select(wp => new ClinicResponse.WorkingPeriodResponse
            {
                Id = wp.Id,
                DayOfWeek = (int)wp.DayOfWeek,
                DayName = wp.DayOfWeek.ToString(),
                StartTime = wp.StartTime.ToString("HH:mm"),
                EndTime = wp.EndTime.ToString("HH:mm"),
                IsActive = wp.IsActive,
                Breaks = wp.Breaks.Select(b => new ClinicResponse.BreakResponse
                {
                    Id = b.Id,
                    StartTime = b.StartTime.ToString("HH:mm"),
                    EndTime = b.EndTime.ToString("HH:mm")
                }).ToList()
            }).ToList()
        };
    }

    #endregion
}








