/**
 * File Name      : DoctorProfileService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : ApplicationDbContext, ICurrentUserService, IDoctorProfileService
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-23
 * Description    : Implementation of IDoctorProfileService for Doctor profile operations.
 */

using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Application.Features.Doctor;
using Appoynt.Application.Features.Doctor.Contracts;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence;
using FluentValidation;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Appoynt.Application.Common.Models;

namespace Appoynt.Infrastructure.Authentication.Doctor;

/// <summary>
/// Service for managing doctor profiles.
/// </summary>
public class DoctorProfileService : IDoctorProfileService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly ICurrentUserService _currentUserService;
    private readonly IValidator<UpdateDoctorProfileRequest> _updateValidator;
    private readonly IValidator<AddDoctorPhoneNumberRequest> _addPhoneValidator;
    private readonly ILogger<DoctorProfileService> _logger;

    /// <summary>
    /// Initializes a new instance of DoctorProfileService.
    /// </summary>
    public DoctorProfileService(
        ApplicationDbContext dbContext,
        ICurrentUserService currentUserService,
        IValidator<UpdateDoctorProfileRequest> updateValidator,
        IValidator<AddDoctorPhoneNumberRequest> addPhoneValidator,
        ILogger<DoctorProfileService> logger)
    {
        _dbContext = dbContext;
        _currentUserService = currentUserService;
        _updateValidator = updateValidator;
        _addPhoneValidator = addPhoneValidator;
        _logger = logger;
    }

    /// <inheritdoc />
    public async Task<DoctorProfileResponse?> GetProfileAsync(CancellationToken ct)
    {
        Guid? userId = _currentUserService.UserId;
        if (userId == null)
        {
            return null;
        }
        else
        {
            // Authenticated user ID is available.
        }

        var doctor = await _dbContext.Doctors
            .AsNoTracking()
            .Include(d => d.User)
            .Include(d => d.DoctorSpecializations)
                .ThenInclude(ds => ds.Specialization)
            .Include(d => d.PhoneNumbers)
            .FirstOrDefaultAsync(d => d.UserId == userId.Value, ct);

        if (doctor == null)
        {
            return null;
        }
        else
        {
            // Doctor entity found.
        }

        return new DoctorProfileResponse
        {
            Id = doctor.Id,
            UserId = doctor.UserId,
            FirstName = doctor.User.FirstName,
            LastName = doctor.User.LastName,
            NameAr = doctor.NameAr,
            NameEn = doctor.NameEn,
            Bio = doctor.Bio,
            Education = doctor.Education,
            Gender = doctor.User.Gender,
            DateOfBirth = doctor.User.DateOfBirth,
            Address = doctor.User.Address,
            HasProfilePhoto = !string.IsNullOrEmpty(doctor.User.ProfilePicturePath),
            PhoneNumbers = doctor.PhoneNumbers.Select(p => new DoctorPhoneNumberDto
            {
                Id = p.Id,
                PhoneNumber = p.PhoneNumber,
                Label = p.Label,
                IsVerified = p.IsVerified
            }).ToList(),
            Specializations = doctor.DoctorSpecializations.Select(ds => new SpecializationDto
            {
                Id = ds.SpecializationId,
                NameAr = ds.Specialization.NameAr,
                NameEn = ds.Specialization.NameEn
            }).ToList()
        };
    }

    /// <inheritdoc />
    public async Task<DoctorResult> UpdateProfileAsync(UpdateDoctorProfileRequest request, CancellationToken ct)
    {
        var validationResult = await _updateValidator.ValidateAsync(request, ct);
        if (!validationResult.IsValid)
        {
            return DoctorResult.Failure(validationResult.Errors.Select(e => new AuthenticationError(e.ErrorCode, e.PropertyName)).ToList());
        }
        else
        {
            // Request payload is valid.
        }

        Guid? userId = _currentUserService.UserId;
        if (userId == null)
        {
            return DoctorResult.Failure(AuthenticationErrorCodes.Forbidden, "User not authenticated.");
        }
        else
        {
            // Authenticated user ID is available.
        }

        var doctor = await _dbContext.Doctors
            .Include(d => d.User)
            .Include(d => d.DoctorSpecializations)
            .FirstOrDefaultAsync(d => d.UserId == userId.Value, ct);

        if (doctor == null)
        {
            return DoctorResult.Failure(AuthenticationErrorCodes.UserNotFound, "Doctor not found.");
        }
        else
        {
            // Doctor found.
        }

        // Validate Specializations exist
        if (request.SpecializationIds != null && request.SpecializationIds.Any())
        {
            var existingSpecs = await _dbContext.Specializations
                .Where(s => request.SpecializationIds.Contains(s.Id))
                .Select(s => s.Id)
                .ToListAsync(ct);
            
            if (existingSpecs.Count != request.SpecializationIds.Count)
            {
                return DoctorResult.Failure("doctor.specialization.not_found", "One or more specializations do not exist.");
            }
            else
            {
                // All specializations exist in database.
            }
        }
        else
        {
            // No specialization IDs to validate.
        }

        await using var transaction = await _dbContext.Database.BeginTransactionAsync(ct);

        try
        {
            // Update Base ApplicationUser fields
            if (!string.IsNullOrWhiteSpace(request.FirstName))
            {
                doctor.User.FirstName = request.FirstName;
            }
            else
            {
                // No action needed.
            }

            if (!string.IsNullOrWhiteSpace(request.LastName))
            {
                doctor.User.LastName = request.LastName;
            }
            else
            {
                // No action needed.
            }

            if (request.Gender.HasValue)
            {
                doctor.User.Gender = request.Gender.Value;
            }
            else
            {
                // No action needed.
            }

            if (request.BirthDate.HasValue)
            {
                doctor.User.DateOfBirth = request.BirthDate.Value;
            }
            else
            {
                // No action needed.
            }

            if (request.Address != null)
            {
                doctor.User.Address = request.Address;
            }
            else
            {
                // No action needed.
            }

            // Update Doctor fields
            if (!string.IsNullOrWhiteSpace(request.NameAr))
            {
                doctor.NameAr = request.NameAr;
            }
            else
            {
                // No action needed.
            }

            if (!string.IsNullOrWhiteSpace(request.NameEn))
            {
                doctor.NameEn = request.NameEn;
            }
            else
            {
                // No action needed.
            }

            if (request.Bio != null)
            {
                doctor.Bio = request.Bio;
            }
            else
            {
                // No action needed.
            }

            if (request.Education != null)
            {
                doctor.Education = request.Education;
            }
            else
            {
                // No action needed.
            }

            // Update Specializations (Full Replace)
            if (request.SpecializationIds != null)
            {
                _dbContext.Set<DoctorSpecialization>().RemoveRange(doctor.DoctorSpecializations);
                
                foreach (var specId in request.SpecializationIds)
                {
                    doctor.DoctorSpecializations.Add(new DoctorSpecialization
                    {
                        DoctorId = doctor.Id,
                        SpecializationId = specId,
                        Doctor = null!,
                        Specialization = null!
                    });
                }
            }
            else
            {
                // No specializations update requested.
            }

            await _dbContext.SaveChangesAsync(ct);
            await transaction.CommitAsync(ct);

            return DoctorResult.Success();
        }
        catch (Exception ex)
        {
            await transaction.RollbackAsync(ct);
            _logger.LogError(ex, "Failed to update doctor profile.");
            return DoctorResult.Failure("server.error", "Failed to update profile.");
        }
    }

    /// <inheritdoc />
    public async Task<DoctorResult> AddPhoneNumberAsync(AddDoctorPhoneNumberRequest request, CancellationToken ct)
    {
        var validationResult = await _addPhoneValidator.ValidateAsync(request, ct);
        if (!validationResult.IsValid)
        {
            return DoctorResult.Failure(validationResult.Errors.Select(e => new AuthenticationError(e.ErrorCode, e.PropertyName)).ToList());
        }
        else
        {
            // Validation passed.
        }

        Guid? userId = _currentUserService.UserId;
        if (userId == null)
        {
            return DoctorResult.Failure(AuthenticationErrorCodes.Forbidden, "User not authenticated.");
        }
        else
        {
            // User authenticated.
        }

        var doctor = await _dbContext.Doctors
            .FirstOrDefaultAsync(d => d.UserId == userId.Value, ct);

        if (doctor == null)
        {
            return DoctorResult.Failure(AuthenticationErrorCodes.UserNotFound, "Doctor not found.");
        }
        else
        {
            // Doctor found.
        }

        // Check globally across Users and DoctorPhoneNumbers
        bool existsInUsers = await _dbContext.Users.AnyAsync(u => u.PhoneNumber == request.PhoneNumber, ct);
        bool existsInDoctors = await _dbContext.Set<DoctorPhoneNumber>().AnyAsync(p => p.PhoneNumber == request.PhoneNumber, ct);

        if (existsInUsers || existsInDoctors)
        {
            return DoctorResult.Failure(AuthenticationErrorCodes.PhoneAlreadyRegistered, "Phone number is already registered.");
        }
        else
        {
            // Phone number is unique.
        }

        var newPhone = new DoctorPhoneNumber
        {
            DoctorId = doctor.Id,
            PhoneNumber = request.PhoneNumber,
            Label = request.Label ?? string.Empty,
            IsVerified = false,
            Doctor = null!
        };

        _dbContext.Set<DoctorPhoneNumber>().Add(newPhone);
        await _dbContext.SaveChangesAsync(ct);

        return DoctorResult.Success();
    }

    /// <inheritdoc />
    public async Task<DoctorResult> RemovePhoneNumberAsync(Guid phoneNumberId, CancellationToken ct)
    {
        Guid? userId = _currentUserService.UserId;
        if (userId == null)
        {
            return DoctorResult.Failure(AuthenticationErrorCodes.Forbidden, "User not authenticated.");
        }
        else
        {
            // User authenticated.
        }

        var doctor = await _dbContext.Doctors
            .Include(d => d.PhoneNumbers)
            .FirstOrDefaultAsync(d => d.UserId == userId.Value, ct);

        if (doctor == null)
        {
            return DoctorResult.Failure(AuthenticationErrorCodes.UserNotFound, "Doctor not found.");
        }
        else
        {
            // Doctor found.
        }

        var phoneToRemove = doctor.PhoneNumbers.FirstOrDefault(p => p.Id == phoneNumberId);
        if (phoneToRemove == null)
        {
            return DoctorResult.Failure("doctor.phone.not_found", "Phone number not found.");
        }
        else
        {
            // Phone number found.
        }

        // Check if it's the last phone number
        if (doctor.PhoneNumbers.Count <= 1)
        {
            return DoctorResult.Failure("doctor.phone.last_number", "Cannot delete the last phone number.");
        }
        else
        {
            // Doctor has more than one phone number.
        }

        _dbContext.Set<DoctorPhoneNumber>().Remove(phoneToRemove);
        await _dbContext.SaveChangesAsync(ct);

        return DoctorResult.Success();
    }
}
