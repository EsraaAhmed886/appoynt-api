/**
 * File Name      : PatientService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.1.0
 * Dependencies   : ApplicationDbContext, ICurrentUserService, IFileStorageService, IValidator, Appoynt.Application.Common.Models
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-23
 * Description    : Full implementation of IPatientService including profile, family members, and favorites management.
 */

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Patient;
using Appoynt.Application.Features.Patient.Contracts;
using Appoynt.Application.Features.Patient.Validation;
using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Appoynt.Domain.Common.Constants;
using Appoynt.Infrastructure.Persistence;
using FluentValidation;
using FluentValidation.Results;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace Appoynt.Infrastructure.Authentication.Patient;

/// <summary>
/// Service for managing patient profiles and family members.
/// </summary>
public class PatientService : IPatientService
{
    // Holds database context
    private readonly ApplicationDbContext _dbContext;
    // Holds current user service
    private readonly ICurrentUserService _currentUserService;
    // Holds file storage service
    private readonly IFileStorageService _fileStorageService;
    // Holds centralized profile image service
    private readonly IProfileImageService _profileImageService;
    // Validator for profile update
    private readonly IValidator<UpdatePatientProfileRequest> _updateProfileValidator;
    // Validator for adding family member
    private readonly IValidator<AddFamilyMemberRequest> _addFamilyMemberValidator;
    // Validator for updating family member
    private readonly IValidator<UpdateFamilyMemberRequest> _updateFamilyMemberValidator;
    // Holds logger
    private readonly ILogger<PatientService> _logger;

    /// <summary>
    /// Initializes a new instance of PatientService.
    /// </summary>
    public PatientService(
        ApplicationDbContext dbContext,
        ICurrentUserService currentUserService,
        IFileStorageService fileStorageService,
        IProfileImageService profileImageService,
        IValidator<UpdatePatientProfileRequest> updateProfileValidator,
        IValidator<AddFamilyMemberRequest> addFamilyMemberValidator,
        IValidator<UpdateFamilyMemberRequest> updateFamilyMemberValidator,
        ILogger<PatientService> logger)
    {
        // Set dependencies
        _dbContext = dbContext;
        _currentUserService = currentUserService;
        _fileStorageService = fileStorageService;
        _profileImageService = profileImageService;
        _updateProfileValidator = updateProfileValidator;
        _addFamilyMemberValidator = addFamilyMemberValidator;
        _updateFamilyMemberValidator = updateFamilyMemberValidator;
        _logger = logger;
    }

    /// <summary>
    /// Gets the current user's profile asynchronously.
    /// </summary>
    public async Task<PatientProfileResponse?> GetProfileAsync(CancellationToken cancellationToken)
    {
        // Get user ID
        Guid? userId = _currentUserService.UserId;
        
        // Check if user is logged in
        if (userId == null)
        {
            // Return null if no user
            return null;
        }
        else
        {
            // No action required.
        }

        // Fetch the patient from DB
        Appoynt.Domain.Entities.Patient? patient = await _dbContext.Set<Appoynt.Domain.Entities.Patient>()
            .AsNoTracking()
            .Include(p => p.User)
            .FirstOrDefaultAsync(p => p.UserId == userId.Value, cancellationToken);

        // Check if patient exists
        if (patient == null)
        {
            // Return null if not found
            return null;
        }
        else
        {
            // No action required.
        }

        // Map and return
        return new PatientProfileResponse
        {
            Id = patient.Id,
            PID = patient.PID,
            FamilyNumber = patient.FamilyNumber,
            NationalId = patient.NationalId,
            BirthDate = patient.BirthDate,
            WeightKg = patient.WeightKg,
            HeightCm = patient.HeightCm,
            BloodGroup = patient.BloodGroup,
            SmokingStatus = patient.SmokingStatus,
            HasProfilePhoto = !string.IsNullOrEmpty(patient.User.ProfilePicturePath),
            FirstName = patient.User.FirstName,
            LastName = patient.User.LastName,
            Email = patient.User.Email ?? string.Empty,
            PhoneNumber = patient.User.PhoneNumber ?? string.Empty,
            Gender = patient.User.Gender
        };
    }

    /// <summary>
    /// Updates the current user's profile asynchronously.
    /// </summary>
    public async Task<PatientResult> UpdateProfileAsync(UpdatePatientProfileRequest request, CancellationToken cancellationToken)
    {
        // Validate request
        ValidationResult validationResult = await _updateProfileValidator.ValidateAsync(request, cancellationToken);
        
        // Check validation
        if (!validationResult.IsValid)
        {
            // Return failure
            return PatientResult.Failure(validationResult.Errors.Select(e => new Appoynt.Application.Common.Models.AuthenticationError(e.ErrorCode, e.PropertyName)).ToList());
        }
        else
        {
            // No action required.
        }

        // Get user ID
        Guid? userId = _currentUserService.UserId;
        
        // Check if user ID is null
        if (userId == null)
        {
            // Return forbidden
            return PatientResult.Failure(PatientErrorCodes.Forbidden, "User not authenticated.");
        }
        else
        {
            // No action required.
        }

        // Fetch patient
        Appoynt.Domain.Entities.Patient? patient = await _dbContext.Set<Appoynt.Domain.Entities.Patient>()
            .Include(p => p.User)
            .FirstOrDefaultAsync(p => p.UserId == userId.Value, cancellationToken);

        // Check if patient exists
        if (patient == null)
        {
            // Return not found
            return PatientResult.Failure(PatientErrorCodes.NotFound, "Patient not found.");
        }
        else
        {
            // No action required.
        }

        // Begin transaction
        await using var transaction = await _dbContext.Database.BeginTransactionAsync(cancellationToken);

        try
        {
            // Update Base ApplicationUser fields
            if (!string.IsNullOrWhiteSpace(request.FirstName))
            {
                patient.User.FirstName = request.FirstName;
            }
            else
            {
                // No update needed.
            }

            if (!string.IsNullOrWhiteSpace(request.LastName))
            {
                patient.User.LastName = request.LastName;
            }
            else
            {
                // No update needed.
            }

            if (request.Gender.HasValue)
            {
                patient.User.Gender = request.Gender.Value;
            }
            else
            {
                // No update needed.
            }

            if (request.BirthDate.HasValue)
            {
                patient.User.DateOfBirth = request.BirthDate.Value;
            }
            else
            {
                // No update needed.
            }

            if (request.Address != null)
            {
                patient.User.Address = request.Address;
            }
            else
            {
                // No update needed.
            }

            // If National ID is provided
            if (!string.IsNullOrEmpty(request.NationalId))
            {
                // Validate National ID
                var natIdResult = EgyptianNationalIdValidator.Validate(request.NationalId);
                
                // Check result
                if (!natIdResult.IsValid)
                {
                    // Return failure
                    return PatientResult.Failure(PatientErrorCodes.NationalIdInvalidFormat, "Invalid National ID.");
                }
                else
                {
                    // No action required.
                }

                // Check for uniqueness
                bool exists = await _dbContext.Set<Appoynt.Domain.Entities.Patient>()
                    .AnyAsync(p => p.NationalId == request.NationalId && p.Id != patient.Id, cancellationToken);
                    
                // If exists, fail
                if (exists)
                {
                    // Return failure
                    return PatientResult.Failure(PatientErrorCodes.NationalIdDuplicate, "National ID already in use.");
                }
                else
                {
                    // No action required.
                }

                // Set National ID
                patient.NationalId = request.NationalId;
                // Set birth date extracted
                patient.BirthDate = natIdResult.BirthDate;
            }
            else
            {
                // No action required.
            }

            // Update Patient fields
            if (request.WeightKg.HasValue)
            {
                patient.WeightKg = request.WeightKg.Value;
            }
            else
            {
                // No update needed.
            }

            if (request.HeightCm.HasValue)
            {
                patient.HeightCm = request.HeightCm.Value;
            }
            else
            {
                // No update needed.
            }

            if (request.BloodGroup.HasValue)
            {
                patient.BloodGroup = request.BloodGroup.Value;
            }
            else
            {
                // No update needed.
            }

            if (request.SmokingStatus.HasValue)
            {
                patient.SmokingStatus = request.SmokingStatus.Value;
            }
            else
            {
                // No update needed.
            }

            // Save changes
            await _dbContext.SaveChangesAsync(cancellationToken);
            
            // Commit transaction
            await transaction.CommitAsync(cancellationToken);

            // Return success
            return PatientResult.Success(patient.Id);
        }
        catch (Exception ex)
        {
            // Rollback on error
            await transaction.RollbackAsync(cancellationToken);
            _logger.LogError(ex, "Failed to update patient profile.");
            return PatientResult.Failure("server.error", "Failed to update profile.");
        }
    }

    /// <summary>
    /// Replaces the primary phone number of the current patient.
    /// </summary>
    public async Task<PatientResult> UpdatePhoneNumberAsync(UpdatePatientPhoneNumberRequest request, CancellationToken cancellationToken)
    {
        Guid? userId = _currentUserService.UserId;
        if (userId == null)
        {
            return PatientResult.Failure(PatientErrorCodes.Forbidden, "User not authenticated.");
        }
        else
        {
            // User authenticated.
        }

        var patient = await _dbContext.Set<Appoynt.Domain.Entities.Patient>()
            .Include(p => p.User)
            .FirstOrDefaultAsync(p => p.UserId == userId.Value, cancellationToken);

        if (patient == null)
        {
            return PatientResult.Failure(PatientErrorCodes.NotFound, "Patient not found.");
        }
        else
        {
            // Patient found.
        }

        bool isPhoneTaken = await _dbContext.Users
            .AnyAsync(u => u.PhoneNumber == request.PhoneNumber && u.Id != userId.Value, cancellationToken);

        if (isPhoneTaken)
        {
            return PatientResult.Failure(AuthenticationErrorCodes.PhoneAlreadyRegistered, "Phone number is already in use.");
        }
        else
        {
            // Phone number is available.
        }

        patient.User.PhoneNumber = request.PhoneNumber;
        patient.User.PhoneNumberConfirmed = false;

        await _dbContext.SaveChangesAsync(cancellationToken);

        return PatientResult.Success(patient.Id);
    }

    /// <summary>
    /// Uploads a profile photo asynchronously.
    /// </summary>
    public async Task<PatientResult> UploadProfilePhotoAsync(Stream fileStream, string fileName, long fileSize, CancellationToken cancellationToken)
    {
        // Get user ID
        Guid? userId = _currentUserService.UserId;
        
        // Check user
        if (userId == null)
        {
            // Return forbidden
            return PatientResult.Failure(PatientErrorCodes.Forbidden, "User not authenticated.");
        }
        else
        {
            // No action required.
        }

        // Fetch patient
        Appoynt.Domain.Entities.Patient? patient = await _dbContext.Set<Appoynt.Domain.Entities.Patient>()
            .FirstOrDefaultAsync(p => p.UserId == userId.Value, cancellationToken);
            
        // Check patient
        if (patient == null)
        {
            // Return not found
            return PatientResult.Failure(PatientErrorCodes.NotFound, "Patient not found.");
        }
        else
        {
            // No action required.
        }

        // Delegate upload and compression to centralized profile image service
        var uploadResult = await _profileImageService.UploadProfileImageAsync(
            userId.Value,
            fileStream,
            fileName,
            fileSize,
            cancellationToken);

        if (!uploadResult.Succeeded)
        {
            var errors = uploadResult.Errors
                .Select(e => new Appoynt.Application.Common.Models.AuthenticationError(e.Code, e.Field))
                .ToList();
            return PatientResult.Failure(errors);
        }
        else
        {
            // Upload succeeded.
        }

        // Return success with patient ID
        return PatientResult.Success(patient.Id);
    }

    /// <summary>
    /// Gets the profile photo asynchronously.
    /// </summary>
    public async Task<(Stream? Stream, string ContentType)?> GetProfilePhotoAsync(Guid patientId, CancellationToken cancellationToken)
    {
        // Fetch patient
        Appoynt.Domain.Entities.Patient? patient = await _dbContext.Set<Appoynt.Domain.Entities.Patient>()
            .AsNoTracking()
            .FirstOrDefaultAsync(p => p.Id == patientId, cancellationToken);
            
        // Check if patient exists
        if (patient == null)
        {
            // Return null
            return null;
        }
        else
        {
            // No action required.
        }

        // Check if user owns patient or is admin
        bool isOwner = patient.UserId == _currentUserService.UserId;
        bool isAdmin = _currentUserService.Role == "Admin";
        
        // Authorize
        if (!isOwner && !isAdmin)
        {
            // Return null for unauthorized
            return null;
        }
        else
        {
            // No action required.
        }

        // Delegate image retrieval to centralized profile image service
        return await _profileImageService.GetProfileImageAsync(patient.UserId, cancellationToken);
    }

    /// <summary>
    /// Deletes the profile photo asynchronously.
    /// </summary>
    public async Task<PatientResult> DeleteProfilePhotoAsync(CancellationToken cancellationToken)
    {
        // Get user ID
        Guid? userId = _currentUserService.UserId;
        
        // Check user
        if (userId == null)
        {
            // Return forbidden
            return PatientResult.Failure(PatientErrorCodes.Forbidden, "User not authenticated.");
        }
        else
        {
            // No action required.
        }

        // Fetch patient
        Appoynt.Domain.Entities.Patient? patient = await _dbContext.Set<Appoynt.Domain.Entities.Patient>()
            .FirstOrDefaultAsync(p => p.UserId == userId.Value, cancellationToken);
            
        // Check patient
        if (patient == null)
        {
            // Return not found
            return PatientResult.Failure(PatientErrorCodes.NotFound, "Patient not found.");
        }
        else
        {
            // No action required.
        }

        // Delegate photo deletion to centralized profile image service
        var deleteResult = await _profileImageService.DeleteProfileImageAsync(userId.Value, cancellationToken);

        if (!deleteResult.Succeeded)
        {
            var errors = deleteResult.Errors
                .Select(e => new Appoynt.Application.Common.Models.AuthenticationError(e.Code, e.Field))
                .ToList();
            return PatientResult.Failure(errors);
        }
        else
        {
            // Deletion succeeded.
        }

        // Return success
        return PatientResult.Success(patient.Id);
    }

    /// <summary>
    /// Adds a family member asynchronously.
    /// </summary>
    public async Task<PatientResult> AddFamilyMemberAsync(AddFamilyMemberRequest request, CancellationToken cancellationToken)
    {
        // Validate request
        ValidationResult validationResult = await _addFamilyMemberValidator.ValidateAsync(request, cancellationToken);
        
        // Check validation
        if (!validationResult.IsValid)
        {
            // Return failure
            return PatientResult.Failure(validationResult.Errors.Select(e => new Appoynt.Application.Common.Models.AuthenticationError(e.ErrorCode, e.PropertyName)).ToList());
        }
        else
        {
            // No action required.
        }

        // Check relationship consistency
        if (!PidGenerator.ValidateGenderRelationshipConsistency(request.Gender!.Value, request.Relationship!.Value))
        {
            // Return failure
            return PatientResult.Failure(PatientErrorCodes.FamilyMemberRelationshipGenderMismatch, "Gender and relationship mismatch.");
        }
        else
        {
            // No action required.
        }

        // Get user ID
        Guid? userId = _currentUserService.UserId;
        
        // Check user
        if (userId == null)
        {
            // Return forbidden
            return PatientResult.Failure(PatientErrorCodes.Forbidden, "User not authenticated.");
        }
        else
        {
            // No action required.
        }

        // Fetch patient and family members
        Appoynt.Domain.Entities.Patient? patient = await _dbContext.Set<Appoynt.Domain.Entities.Patient>()
            .Include(p => p.FamilyMembers)
            .FirstOrDefaultAsync(p => p.UserId == userId.Value, cancellationToken);
            
        // Check patient
        if (patient == null)
        {
            // Return not found
            return PatientResult.Failure(PatientErrorCodes.NotFound, "Patient not found.");
        }
        else
        {
            // No action required.
        }

        // Collect used sequence numbers
        List<int> usedSequences = new List<int> { 0 }; // 0 is reserved for patient
        
        // Add existing family member sequences
        foreach (var fm in patient.FamilyMembers)
        {
            // Get last character
            char lastChar = fm.PID[^1];
            
            // Parse to int
            if (int.TryParse(lastChar.ToString(), out int seq))
            {
                // Add to list
                usedSequences.Add(seq);
            }
            else
            {
                // No action required.
            }
        }
        
        // Find available sequence
        int sequence;
        try
        {
            // Attempt to find sequence
            sequence = PidGenerator.FindLowestAvailableSequence(usedSequences);
        }
        catch (InvalidOperationException)
        {
            // Return failure if maxed out
            return PatientResult.Failure(PatientErrorCodes.FamilyMemberSequenceLimitReached, "Maximum family members reached.");
        }

        // Generate PID
        string pid = PidGenerator.GeneratePid(patient.FamilyNumber, request.Relationship.Value, sequence);
        
        // Verify PID uniqueness
        bool pidExistsInPatients = await _dbContext.Set<Appoynt.Domain.Entities.Patient>()
            .AnyAsync(p => p.PID == pid, cancellationToken);
            
        // Verify PID in FamilyMembers
        bool pidExistsInFamily = await _dbContext.Set<FamilyMember>()
            .AnyAsync(f => f.PID == pid, cancellationToken);
            
        // Check existence
        if (pidExistsInPatients || pidExistsInFamily)
        {
            // Return failure
            return PatientResult.Failure(PatientErrorCodes.PidDuplicate, "Generated PID already exists.");
        }
        else
        {
            // No action required.
        }

        // Create new family member
        FamilyMember member = new FamilyMember
        {
            Id = Guid.NewGuid(),
            PID = pid,
            FullName = request.FullName!,
            Gender = request.Gender.Value,
            Relationship = request.Relationship.Value,
            BirthDate = request.BirthDate!.Value,
            PatientId = patient.Id,
            Patient = patient
        };
        
        // Add to DbContext
        _dbContext.Set<FamilyMember>().Add(member);
        
        // Save changes
        await _dbContext.SaveChangesAsync(cancellationToken);
        
        // Return success
        return PatientResult.Success(member.Id);
    }

    /// <summary>
    /// Gets family members asynchronously.
    /// </summary>
    public async Task<IEnumerable<FamilyMemberResponse>> GetFamilyMembersAsync(CancellationToken cancellationToken)
    {
        // Get user ID
        Guid? userId = _currentUserService.UserId;
        
        // Check user
        if (userId == null)
        {
            // Return empty list
            return Array.Empty<FamilyMemberResponse>();
        }
        else
        {
            // No action required.
        }

        // Fetch family members
        List<FamilyMember> members = await _dbContext.Set<FamilyMember>()
            .AsNoTracking()
            .Where(f => f.Patient.UserId == userId.Value)
            .ToListAsync(cancellationToken);
            
        // Return mapped list
        return members.Select(f => new FamilyMemberResponse
        {
            Id = f.Id,
            PID = f.PID,
            FullName = f.FullName,
            Gender = f.Gender,
            Relationship = f.Relationship,
            BirthDate = f.BirthDate
        }).ToList();
    }

    /// <summary>
    /// Gets a family member by ID asynchronously.
    /// </summary>
    public async Task<FamilyMemberResponse?> GetFamilyMemberByIdAsync(Guid id, CancellationToken cancellationToken)
    {
        // Get user ID
        Guid? userId = _currentUserService.UserId;
        
        // Check user
        if (userId == null)
        {
            // Return null
            return null;
        }
        else
        {
            // No action required.
        }

        // Fetch family member
        FamilyMember? member = await _dbContext.Set<FamilyMember>()
            .AsNoTracking()
            .FirstOrDefaultAsync(f => f.Id == id && f.Patient.UserId == userId.Value, cancellationToken);
            
        // Check member
        if (member == null)
        {
            // Return null
            return null;
        }
        else
        {
            // No action required.
        }

        // Return mapped object
        return new FamilyMemberResponse
        {
            Id = member.Id,
            PID = member.PID,
            FullName = member.FullName,
            Gender = member.Gender,
            Relationship = member.Relationship,
            BirthDate = member.BirthDate
        };
    }

    /// <summary>
    /// Updates a family member asynchronously.
    /// </summary>
    public async Task<PatientResult> UpdateFamilyMemberAsync(Guid id, UpdateFamilyMemberRequest request, CancellationToken cancellationToken)
    {
        // Validate request
        ValidationResult validationResult = await _updateFamilyMemberValidator.ValidateAsync(request, cancellationToken);
        
        // Check validation
        if (!validationResult.IsValid)
        {
            // Return failure
            return PatientResult.Failure(validationResult.Errors.Select(e => new Appoynt.Application.Common.Models.AuthenticationError(e.ErrorCode, e.PropertyName)).ToList());
        }
        else
        {
            // No action required.
        }

        // Get user ID
        Guid? userId = _currentUserService.UserId;
        
        // Check user
        if (userId == null)
        {
            // Return forbidden
            return PatientResult.Failure(PatientErrorCodes.Forbidden, "User not authenticated.");
        }
        else
        {
            // No action required.
        }

        // Fetch member
        FamilyMember? member = await _dbContext.Set<FamilyMember>()
            .Include(f => f.Patient)
            .FirstOrDefaultAsync(f => f.Id == id && f.Patient.UserId == userId.Value, cancellationToken);
            
        // Check member
        if (member == null)
        {
            // Return not found
            return PatientResult.Failure(PatientErrorCodes.FamilyMemberNotFound, "Family member not found.");
        }
        else
        {
            // No action required.
        }

        // Get effective gender and relationship
        Gender effectiveGender = request.Gender ?? member.Gender;
        FamilyRelationship effectiveRelationship = request.Relationship ?? member.Relationship;
        
        // Validate consistency if changing
        if (request.Gender.HasValue || request.Relationship.HasValue)
        {
            // Check consistency
            if (!PidGenerator.ValidateGenderRelationshipConsistency(effectiveGender, effectiveRelationship))
            {
                // Return failure
                return PatientResult.Failure(PatientErrorCodes.FamilyMemberRelationshipGenderMismatch, "Gender and relationship mismatch.");
            }
            else
            {
                // No action required.
            }
        }
        else
        {
            // No action required.
        }

        // Check if relationship changed
        if (request.Relationship.HasValue && request.Relationship.Value != member.Relationship)
        {
            // Need to regenerate PID
            char lastChar = member.PID[^1];
            
            // Extract sequence
            if (int.TryParse(lastChar.ToString(), out int seq))
            {
                // Generate new PID
                string newPid = PidGenerator.GeneratePid(member.Patient.FamilyNumber, request.Relationship.Value, seq);
                
                // Update PID
                member.PID = newPid;
            }
            else
            {
                // No action required.
            }
        }
        else
        {
            // No action required.
        }

        // Update other fields
        if (!string.IsNullOrEmpty(request.FullName))
        {
            member.FullName = request.FullName;
        }
        else
        {
            // No update needed.
        }

        if (request.Gender.HasValue)
        {
            member.Gender = request.Gender.Value;
        }
        else
        {
            // No update needed.
        }

        if (request.Relationship.HasValue)
        {
            member.Relationship = request.Relationship.Value;
        }
        else
        {
            // No update needed.
        }

        if (request.BirthDate.HasValue)
        {
            member.BirthDate = request.BirthDate.Value;
        }
        else
        {
            // No update needed.
        }

        // Save changes
        await _dbContext.SaveChangesAsync(cancellationToken);
        
        // Return success
        return PatientResult.Success(member.Id);
    }

    /// <summary>
    /// Deletes a family member asynchronously.
    /// </summary>
    public async Task<PatientResult> DeleteFamilyMemberAsync(Guid id, CancellationToken cancellationToken)
    {
        // Get user ID
        Guid? userId = _currentUserService.UserId;
        
        // Check user
        if (userId == null)
        {
            // Return forbidden
            return PatientResult.Failure(PatientErrorCodes.Forbidden, "User not authenticated.");
        }
        else
        {
            // No action required.
        }

        // Fetch member
        FamilyMember? member = await _dbContext.Set<FamilyMember>()
            .FirstOrDefaultAsync(f => f.Id == id && f.Patient.UserId == userId.Value, cancellationToken);
            
        // Check member
        if (member == null)
        {
            // Return not found
            return PatientResult.Failure(PatientErrorCodes.FamilyMemberNotFound, "Family member not found.");
        }
        else
        {
            // No action required.
        }

        // Remove member (soft delete via interceptor)
        _dbContext.Set<FamilyMember>().Remove(member);
        
        // Save changes
        await _dbContext.SaveChangesAsync(cancellationToken);
        
        // Return success
        return PatientResult.Success(member.Id);
    }

    #region Doctor Favorites

    /// <inheritdoc />
    public async Task<PatientResult> AddDoctorToFavoritesAsync(Guid doctorId, CancellationToken cancellationToken = default)
    {
        // Retrieve the current authenticated user's ID
        Guid? userId = _currentUserService.UserId;

        // Verify that the user is authenticated
        if (userId == null)
        {
            // Return 403 Forbidden failure when user is unauthenticated
            return PatientResult.Failure(PatientErrorCodes.Forbidden, "User is not authenticated.");
        }
        else
        {
            // No action required.
        }

        // Retrieve the patient profile associated with the authenticated user
        var patient = await _dbContext.Patients
            .FirstOrDefaultAsync(p => p.UserId == userId.Value, cancellationToken);

        // Verify that the patient profile exists
        if (patient == null)
        {
            // Return not found failure when patient profile does not exist
            return PatientResult.Failure(PatientErrorCodes.NotFound, "Patient profile not found.");
        }
        else
        {
            // No action required.
        }

        // Verify that the target doctor exists and is active
        var doctorExists = await _dbContext.Doctors
            .AnyAsync(d => d.Id == doctorId, cancellationToken);

        // Check if the doctor exists in the database
        if (!doctorExists)
        {
            // Return doctor not found error
            return PatientResult.Failure(PatientErrorCodes.FavoriteDoctorNotFound, "Doctor not found.");
        }
        else
        {
            // No action required.
        }

        // Perform initial check to prevent duplicate favorites
        var alreadyFavorited = await _dbContext.PatientFavoriteDoctors
            .AnyAsync(pfd => pfd.PatientId == patient.Id && pfd.DoctorId == doctorId, cancellationToken);

        // Check if the doctor is already favorited by this patient
        if (alreadyFavorited)
        {
            // Return already added error code
            return PatientResult.Failure(PatientErrorCodes.FavoriteAlreadyAdded, "Doctor is already in favorites.");
        }
        else
        {
            // No action required.
        }

        // Create new patient favorite doctor join entity
        var favorite = new PatientFavoriteDoctor
        {
            PatientId = patient.Id,
            Patient = patient,
            DoctorId = doctorId,
            Doctor = null!,
            AddedAt = DateTime.UtcNow
        };

        // Add the favorite record to the database context
        _dbContext.PatientFavoriteDoctors.Add(favorite);

        // Wrap save changes in try-catch to safely handle race conditions and concurrency collisions
        try
        {
            // Persist the new favorite record to the database
            await _dbContext.SaveChangesAsync(cancellationToken);
        }
        catch (DbUpdateException)
        {
            // Return already added error when unique composite key constraint is violated
            return PatientResult.Failure(PatientErrorCodes.FavoriteAlreadyAdded, "Doctor is already in favorites.");
        }

        // Log successful addition of favorite doctor
        _logger.LogInformation("Patient {PatientId} added doctor {DoctorId} to favorites.", patient.Id, doctorId);

        // Return successful patient result
        return PatientResult.Success(patient.Id);
    }

    /// <inheritdoc />
    public async Task<PatientResult> RemoveDoctorFromFavoritesAsync(Guid doctorId, CancellationToken cancellationToken = default)
    {
        // Retrieve the current authenticated user's ID
        Guid? userId = _currentUserService.UserId;

        // Verify that the user is authenticated
        if (userId == null)
        {
            // Return forbidden failure when unauthenticated
            return PatientResult.Failure(PatientErrorCodes.Forbidden, "User is not authenticated.");
        }
        else
        {
            // No action required.
        }

        // Retrieve the patient profile for the current user
        var patient = await _dbContext.Patients
            .FirstOrDefaultAsync(p => p.UserId == userId.Value, cancellationToken);

        // Verify that the patient profile exists
        if (patient == null)
        {
            // Return patient not found error
            return PatientResult.Failure(PatientErrorCodes.NotFound, "Patient profile not found.");
        }
        else
        {
            // No action required.
        }

        // Query the favorite entry to be removed
        var favorite = await _dbContext.PatientFavoriteDoctors
            .FirstOrDefaultAsync(pfd => pfd.PatientId == patient.Id && pfd.DoctorId == doctorId, cancellationToken);

        // Verify that the favorite entry exists
        if (favorite == null)
        {
            // Return error indicating doctor is not in patient's favorites
            return PatientResult.Failure(PatientErrorCodes.FavoriteNotInFavorites, "Doctor is not in favorites.");
        }
        else
        {
            // No action required.
        }

        // Remove the favorite entry from the context
        _dbContext.PatientFavoriteDoctors.Remove(favorite);

        // Persist the removal to the database
        await _dbContext.SaveChangesAsync(cancellationToken);

        // Log removal of favorite doctor
        _logger.LogInformation("Patient {PatientId} removed doctor {DoctorId} from favorites.", patient.Id, doctorId);

        // Return success result
        return PatientResult.Success(patient.Id);
    }

    /// <inheritdoc />
    public async Task<PatientResult> RemoveAllFavoriteDoctorsAsync(CancellationToken cancellationToken = default)
    {
        // Retrieve current authenticated user ID
        Guid? userId = _currentUserService.UserId;

        // Verify user authentication
        if (userId == null)
        {
            // Return forbidden failure
            return PatientResult.Failure(PatientErrorCodes.Forbidden, "User is not authenticated.");
        }
        else
        {
            // No action required.
        }

        // Retrieve the patient profile
        var patient = await _dbContext.Patients
            .FirstOrDefaultAsync(p => p.UserId == userId.Value, cancellationToken);

        // Verify patient profile existence
        if (patient == null)
        {
            // Return not found failure
            return PatientResult.Failure(PatientErrorCodes.NotFound, "Patient profile not found.");
        }
        else
        {
            // No action required.
        }

        // Query all favorite doctor records for this patient
        var favorites = await _dbContext.PatientFavoriteDoctors
            .Where(pfd => pfd.PatientId == patient.Id)
            .ToListAsync(cancellationToken);

        // Check if there are any favorites to remove
        if (favorites.Count > 0)
        {
            // Remove the range of favorite records
            _dbContext.PatientFavoriteDoctors.RemoveRange(favorites);

            // Persist the deletions to the database
            await _dbContext.SaveChangesAsync(cancellationToken);

            // Log bulk removal
            _logger.LogInformation("Patient {PatientId} cleared all favorite doctors ({Count} items).", patient.Id, favorites.Count);
        }
        else
        {
            // No action required when list is already empty.
        }

        // Return success result
        return PatientResult.Success(patient.Id);
    }

    /// <inheritdoc />
    public async Task<PagedResponse<FavoriteDoctorResponse>> GetFavoriteDoctorsAsync(
        int pageNumber,
        int pageSize,
        string? search = null,
        CancellationToken cancellationToken = default)
    {
        // Retrieve the current user identifier
        Guid? userId = _currentUserService.UserId;

        // Check if the user is unauthenticated
        if (userId == null)
        {
            // Return empty paged response for unauthenticated caller
            return new PagedResponse<FavoriteDoctorResponse>
            {
                Items = [],
                TotalCount = 0,
                PageNumber = pageNumber,
                PageSize = pageSize
            };
        }
        else
        {
            // No action required.
        }

        // Retrieve the patient record for the current user
        var patient = await _dbContext.Patients
            .AsNoTracking()
            .FirstOrDefaultAsync(p => p.UserId == userId.Value, cancellationToken);

        // Check if the patient profile exists
        if (patient == null)
        {
            // Return empty paged response if patient does not exist
            return new PagedResponse<FavoriteDoctorResponse>
            {
                Items = [],
                TotalCount = 0,
                PageNumber = pageNumber,
                PageSize = pageSize
            };
        }
        else
        {
            // No action required.
        }

        // Enforce safe page boundary defaults (clamp page size between 1 and 50)
        int validPageNumber = pageNumber < 1 ? 1 : pageNumber;
        int validPageSize = Math.Clamp(pageSize, 1, 50);

        // Build the base query for the patient's favorite doctors
        var query = _dbContext.PatientFavoriteDoctors
            .AsNoTracking()
            .Where(pfd => pfd.PatientId == patient.Id);

        // Apply optional search filter across doctor names if specified
        if (!string.IsNullOrWhiteSpace(search))
        {
            // Trim search term for accurate matching
            string trimmedSearch = search.Trim();

            // Filter by English or Arabic display names or User first/last names
            query = query.Where(pfd =>
                (pfd.Doctor.NameEn != null && pfd.Doctor.NameEn.Contains(trimmedSearch)) ||
                (pfd.Doctor.NameAr != null && pfd.Doctor.NameAr.Contains(trimmedSearch)) ||
                pfd.Doctor.User.FirstName.Contains(trimmedSearch) ||
                pfd.Doctor.User.LastName.Contains(trimmedSearch));
        }
        else
        {
            // No search filtering applied.
        }

        // Calculate total count of matching favorite items
        int totalCount = await query.CountAsync(cancellationToken);

        // Retrieve the paginated slice with eager loading
        var pagedEntries = await query
            .OrderByDescending(pfd => pfd.AddedAt)
            .Skip((validPageNumber - 1) * validPageSize)
            .Take(validPageSize)
            .Include(pfd => pfd.Doctor)
                .ThenInclude(d => d.User)
            .Include(pfd => pfd.Doctor)
                .ThenInclude(d => d.DoctorSpecializations)
                    .ThenInclude(ds => ds.Specialization)
            .Include(pfd => pfd.Doctor)
                .ThenInclude(d => d.Clinics)
                    .ThenInclude(c => c.Governorate)
            .ToListAsync(cancellationToken);

        // Map retrieved database entities to response DTOs
        var items = pagedEntries.Select(pfd =>
        {
            var doctor = pfd.Doctor;
            var user = doctor.User;
            var spec = doctor.DoctorSpecializations.FirstOrDefault()?.Specialization?.NameEn;
            var primaryClinic = doctor.Clinics
                .Where(c => c.Status == ClinicStatus.Active && c.DeletedAt == null)
                .OrderBy(c => c.CreatedAt)
                .FirstOrDefault();

            string? location = primaryClinic?.DetailedAddress ?? primaryClinic?.Governorate?.NameEn;
            decimal price = primaryClinic?.ConsultationFee ?? 0m;
            bool isActive = (user?.IsActive ?? true) && doctor.DeletedAt == null;

            return new FavoriteDoctorResponse
            {
                Id = pfd.DoctorId,
                NameAr = doctor.NameAr ?? $"{user?.FirstName} {user?.LastName}".Trim(),
                NameEn = doctor.NameEn ?? $"{user?.FirstName} {user?.LastName}".Trim(),
                PhotoUrl = user?.ProfilePicturePath,
                Specialty = spec,
                Location = location,
                Rating = 0m,
                Price = price,
                IsAvailableToday = isActive,
                IsActive = isActive,
                AddedAt = pfd.AddedAt
            };
        }).ToList();

        // Return wrapped paginated response
        return new PagedResponse<FavoriteDoctorResponse>
        {
            Items = items,
            TotalCount = totalCount,
            PageNumber = validPageNumber,
            PageSize = validPageSize
        };
    }

    #endregion

    #region Clinic Favorites

    /// <inheritdoc />
    public async Task<PatientResult> AddClinicToFavoritesAsync(Guid clinicId, CancellationToken cancellationToken = default)
    {
        // Retrieve the current authenticated user ID
        Guid? userId = _currentUserService.UserId;

        // Verify that the user is authenticated
        if (userId == null)
        {
            // Return forbidden failure when unauthenticated
            return PatientResult.Failure(PatientErrorCodes.Forbidden, "User is not authenticated.");
        }
        else
        {
            // No action required.
        }

        // Retrieve the patient profile
        var patient = await _dbContext.Patients
            .FirstOrDefaultAsync(p => p.UserId == userId.Value, cancellationToken);

        // Verify that the patient profile exists
        if (patient == null)
        {
            // Return not found failure when patient profile does not exist
            return PatientResult.Failure(PatientErrorCodes.NotFound, "Patient profile not found.");
        }
        else
        {
            // No action required.
        }

        // Verify that the target clinic exists and is active
        var clinicExists = await _dbContext.Clinics
            .AnyAsync(c => c.Id == clinicId, cancellationToken);

        // Check if the clinic exists
        if (!clinicExists)
        {
            // Return clinic not found error
            return PatientResult.Failure(PatientErrorCodes.FavoriteClinicNotFound, "Clinic not found.");
        }
        else
        {
            // No action required.
        }

        // Perform initial check to prevent duplicate favorites
        var alreadyFavorited = await _dbContext.PatientFavoriteClinics
            .AnyAsync(pfc => pfc.PatientId == patient.Id && pfc.ClinicId == clinicId, cancellationToken);

        // Check if the clinic is already favorited
        if (alreadyFavorited)
        {
            // Return already added error code
            return PatientResult.Failure(PatientErrorCodes.FavoriteAlreadyAdded, "Clinic is already in favorites.");
        }
        else
        {
            // No action required.
        }

        // Create new patient favorite clinic join entity
        var favorite = new PatientFavoriteClinic
        {
            PatientId = patient.Id,
            Patient = patient,
            ClinicId = clinicId,
            Clinic = null!,
            AddedAt = DateTime.UtcNow
        };

        // Add the favorite record to the context
        _dbContext.PatientFavoriteClinics.Add(favorite);

        // Wrap save changes in try-catch to safely handle race conditions and concurrency collisions
        try
        {
            // Persist the new favorite record to the database
            await _dbContext.SaveChangesAsync(cancellationToken);
        }
        catch (DbUpdateException)
        {
            // Return already added error when unique composite key constraint is violated
            return PatientResult.Failure(PatientErrorCodes.FavoriteAlreadyAdded, "Clinic is already in favorites.");
        }

        // Log successful addition of favorite clinic
        _logger.LogInformation("Patient {PatientId} added clinic {ClinicId} to favorites.", patient.Id, clinicId);

        // Return successful patient result
        return PatientResult.Success(patient.Id);
    }

    /// <inheritdoc />
    public async Task<PatientResult> RemoveClinicFromFavoritesAsync(Guid clinicId, CancellationToken cancellationToken = default)
    {
        // Retrieve current authenticated user ID
        Guid? userId = _currentUserService.UserId;

        // Verify user authentication
        if (userId == null)
        {
            // Return forbidden failure when unauthenticated
            return PatientResult.Failure(PatientErrorCodes.Forbidden, "User is not authenticated.");
        }
        else
        {
            // No action required.
        }

        // Retrieve patient profile
        var patient = await _dbContext.Patients
            .FirstOrDefaultAsync(p => p.UserId == userId.Value, cancellationToken);

        // Verify patient profile existence
        if (patient == null)
        {
            // Return patient not found error
            return PatientResult.Failure(PatientErrorCodes.NotFound, "Patient profile not found.");
        }
        else
        {
            // No action required.
        }

        // Query the favorite entry to be removed
        var favorite = await _dbContext.PatientFavoriteClinics
            .FirstOrDefaultAsync(pfc => pfc.PatientId == patient.Id && pfc.ClinicId == clinicId, cancellationToken);

        // Verify that the favorite entry exists
        if (favorite == null)
        {
            // Return error indicating clinic is not in favorites
            return PatientResult.Failure(PatientErrorCodes.FavoriteNotInFavorites, "Clinic is not in favorites.");
        }
        else
        {
            // No action required.
        }

        // Remove the favorite entry from the context
        _dbContext.PatientFavoriteClinics.Remove(favorite);

        // Persist the removal to the database
        await _dbContext.SaveChangesAsync(cancellationToken);

        // Log removal of favorite clinic
        _logger.LogInformation("Patient {PatientId} removed clinic {ClinicId} from favorites.", patient.Id, clinicId);

        // Return success result
        return PatientResult.Success(patient.Id);
    }

    /// <inheritdoc />
    public async Task<PatientResult> RemoveAllFavoriteClinicsAsync(CancellationToken cancellationToken = default)
    {
        // Retrieve current authenticated user ID
        Guid? userId = _currentUserService.UserId;

        // Verify user authentication
        if (userId == null)
        {
            // Return forbidden failure
            return PatientResult.Failure(PatientErrorCodes.Forbidden, "User is not authenticated.");
        }
        else
        {
            // No action required.
        }

        // Retrieve patient profile
        var patient = await _dbContext.Patients
            .FirstOrDefaultAsync(p => p.UserId == userId.Value, cancellationToken);

        // Verify patient profile existence
        if (patient == null)
        {
            // Return not found failure
            return PatientResult.Failure(PatientErrorCodes.NotFound, "Patient profile not found.");
        }
        else
        {
            // No action required.
        }

        // Query all favorite clinic records for this patient
        var favorites = await _dbContext.PatientFavoriteClinics
            .Where(pfc => pfc.PatientId == patient.Id)
            .ToListAsync(cancellationToken);

        // Check if there are any favorites to remove
        if (favorites.Count > 0)
        {
            // Remove the range of favorite records
            _dbContext.PatientFavoriteClinics.RemoveRange(favorites);

            // Persist the deletions to the database
            await _dbContext.SaveChangesAsync(cancellationToken);

            // Log bulk removal
            _logger.LogInformation("Patient {PatientId} cleared all favorite clinics ({Count} items).", patient.Id, favorites.Count);
        }
        else
        {
            // No action required when list is already empty.
        }

        // Return success result
        return PatientResult.Success(patient.Id);
    }

    /// <inheritdoc />
    public async Task<PagedResponse<FavoriteClinicResponse>> GetFavoriteClinicsAsync(
        int pageNumber,
        int pageSize,
        string? search = null,
        CancellationToken cancellationToken = default)
    {
        // Retrieve current user identifier
        Guid? userId = _currentUserService.UserId;

        // Check if user is unauthenticated
        if (userId == null)
        {
            // Return empty paged response for unauthenticated caller
            return new PagedResponse<FavoriteClinicResponse>
            {
                Items = [],
                TotalCount = 0,
                PageNumber = pageNumber,
                PageSize = pageSize
            };
        }
        else
        {
            // No action required.
        }

        // Retrieve the patient record
        var patient = await _dbContext.Patients
            .AsNoTracking()
            .FirstOrDefaultAsync(p => p.UserId == userId.Value, cancellationToken);

        // Check if patient profile exists
        if (patient == null)
        {
            // Return empty paged response if patient does not exist
            return new PagedResponse<FavoriteClinicResponse>
            {
                Items = [],
                TotalCount = 0,
                PageNumber = pageNumber,
                PageSize = pageSize
            };
        }
        else
        {
            // No action required.
        }

        // Enforce safe page boundary defaults (clamp page size between 1 and 50)
        int validPageNumber = pageNumber < 1 ? 1 : pageNumber;
        int validPageSize = Math.Clamp(pageSize, 1, 50);

        // Build the base query for the patient's favorite clinics
        var query = _dbContext.PatientFavoriteClinics
            .AsNoTracking()
            .Where(pfc => pfc.PatientId == patient.Id);

        // Apply optional search filter across clinic name or location if specified
        if (!string.IsNullOrWhiteSpace(search))
        {
            // Trim search term for accurate matching
            string trimmedSearch = search.Trim();

            // Filter by clinic name or detailed address
            query = query.Where(pfc =>
                pfc.Clinic.Name.Contains(trimmedSearch) ||
                (pfc.Clinic.DetailedAddress != null && pfc.Clinic.DetailedAddress.Contains(trimmedSearch)));
        }
        else
        {
            // No search filtering applied.
        }

        // Calculate total count of matching favorite items
        int totalCount = await query.CountAsync(cancellationToken);

        // Retrieve the paginated slice with eager loading
        var pagedEntries = await query
            .OrderByDescending(pfc => pfc.AddedAt)
            .Skip((validPageNumber - 1) * validPageSize)
            .Take(validPageSize)
            .Include(pfc => pfc.Clinic)
                .ThenInclude(c => c.City)
            .Include(pfc => pfc.Clinic)
                .ThenInclude(c => c.Governorate)
            .Include(pfc => pfc.Clinic)
                .ThenInclude(c => c.Doctor)
                    .ThenInclude(d => d.User)
            .ToListAsync(cancellationToken);

        // Map retrieved database entities to response DTOs
        var items = pagedEntries.Select(pfc =>
        {
            var clinic = pfc.Clinic;
            var doctor = clinic.Doctor;
            var docUser = doctor?.User;
            string? location = clinic.DetailedAddress ?? (clinic.City != null && clinic.Governorate != null ? $"{clinic.City.NameEn}, {clinic.Governorate.NameEn}" : clinic.Governorate?.NameEn);
            string? doctorName = doctor?.NameEn ?? (docUser != null ? $"{docUser.FirstName} {docUser.LastName}".Trim() : null);
            bool isActive = clinic.Status == ClinicStatus.Active && clinic.DeletedAt == null;

            return new FavoriteClinicResponse
            {
                Id = pfc.ClinicId,
                Name = clinic.Name,
                Location = location,
                ConsultationFee = clinic.ConsultationFee,
                Status = clinic.Status,
                IsActive = isActive,
                DoctorName = doctorName,
                AddedAt = pfc.AddedAt
            };
        }).ToList();

        // Return wrapped paginated response
        return new PagedResponse<FavoriteClinicResponse>
        {
            Items = items,
            TotalCount = totalCount,
            PageNumber = validPageNumber,
            PageSize = validPageSize
        };
    }

    #endregion
}
