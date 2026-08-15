/**
 * File Name      : PatientService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : ApplicationDbContext, ICurrentUserService, IFileStorageService, IValidator
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Full implementation of IPatientService.
 */

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Interfaces;
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

        // Update other fields
        if (request.WeightKg.HasValue) patient.WeightKg = request.WeightKg.Value;
        if (request.HeightCm.HasValue) patient.HeightCm = request.HeightCm.Value;
        if (request.BloodGroup.HasValue) patient.BloodGroup = request.BloodGroup.Value;
        if (request.SmokingStatus.HasValue) patient.SmokingStatus = request.SmokingStatus.Value;

        // Save changes
        await _dbContext.SaveChangesAsync(cancellationToken);

        // Return success
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
        if (!string.IsNullOrEmpty(request.FullName)) member.FullName = request.FullName;
        if (request.Gender.HasValue) member.Gender = request.Gender.Value;
        if (request.Relationship.HasValue) member.Relationship = request.Relationship.Value;
        if (request.BirthDate.HasValue) member.BirthDate = request.BirthDate.Value;

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
}
