/**
 * File Name      : UserManagementService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 28/07/2026
 * Version        : v1.0.0
 * Dependencies   : IUserManagementService, UserManager, RoleManager,
 *                  ApplicationDbContext, ICurrentUserService
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 31/07/2026
 * Description    : Implements staff user management.
 */

using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.UserManagement;
using Appoynt.Application.Features.UserManagement.Contracts;
using Appoynt.Application.Features.UserManagement.Validation;
using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using FluentValidation;

namespace Appoynt.Infrastructure.Authentication.UserManagement;

/// <summary>
/// Implements staff account creation and management using ASP.NET Core Identity.
/// </summary>
public sealed class UserManagementService : IUserManagementService
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly RoleManager<IdentityRole<Guid>> _roleManager;
    private readonly ApplicationDbContext _dbContext;
    private readonly ICurrentUserService _currentUserService;
    private readonly IValidator<CreateStaffRequest> _validator;
    private readonly IValidator<CreateDoctorRequest> _doctorValidator;
    private readonly IValidator<UpdateUserRequest> _updateValidator;
    private readonly ILogger<UserManagementService> _logger;

    /// <summary>
    /// Initializes a new instance of the <see cref="UserManagementService"/> class.
    /// </summary>
    public UserManagementService(
        UserManager<ApplicationUser> userManager,
        RoleManager<IdentityRole<Guid>> roleManager,
        ApplicationDbContext dbContext,
        ICurrentUserService currentUserService,
        IValidator<CreateStaffRequest> validator,
        IValidator<CreateDoctorRequest> doctorValidator,
        IValidator<UpdateUserRequest> updateValidator,
        ILogger<UserManagementService> logger)
    {
        _userManager = userManager;
        _roleManager = roleManager;
        _dbContext = dbContext;
        _currentUserService = currentUserService;
        _validator = validator;
        _doctorValidator = doctorValidator;
        _updateValidator = updateValidator;
        _logger = logger;
    }

    /// <inheritdoc />
    public async Task<UserManagementResult> CreateAdminAsync(
        CreateStaffRequest request,
        CancellationToken cancellationToken = default)
    {
        return await CreateStaffUserAsync(request, RoleConstants.Admin, cancellationToken);
    }

    /// <inheritdoc />
    public async Task<UserManagementResult> CreateDoctorAsync(
        CreateDoctorRequest request,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(request);

        // Validate the doctor creation request payload.
        var validationResult = await _doctorValidator.ValidateAsync(request, cancellationToken);

        if (!validationResult.IsValid)
        {
            var errors = validationResult.Errors
                .Select(e => new AuthenticationError(e.ErrorCode, e.PropertyName))
                .ToList();
            return new UserManagementResult { Errors = errors };
        }
        else
        {
            // No action required.
        }

        // Normalize email and check for existing registration.
        string normalizedEmail = _userManager.NormalizeEmail(request.Email!);

        if (await _userManager.Users.AnyAsync(
                user => user.NormalizedEmail == normalizedEmail,
                cancellationToken))
        {
            return Failure(AuthenticationErrorCodes.EmailAlreadyRegistered, "Email");
        }
        else
        {
            // No action required.
        }

        // Check for duplicate phone number registration.
        if (await _userManager.Users.AnyAsync(
                user => user.PhoneNumber == request.PhoneNumber,
                cancellationToken))
        {
            return Failure(AuthenticationErrorCodes.PhoneAlreadyRegistered, "PhoneNumber");
        }
        else
        {
            // No action required.
        }

        // Verify that the Doctor system role exists.
        if (!await _roleManager.RoleExistsAsync(RoleConstants.Doctor))
        {
            return Failure(AuthenticationErrorCodes.RegistrationFailed);
        }
        else
        {
            // No action required.
        }

        // If specialization IDs were supplied, verify all exist in the database.
        List<Guid> distinctSpecializationIds = [];
        if (request.SpecializationIds != null && request.SpecializationIds.Count > 0)
        {
            distinctSpecializationIds = request.SpecializationIds.Distinct().ToList();

            var existingCount = await _dbContext.Specializations
                .CountAsync(s => distinctSpecializationIds.Contains(s.Id), cancellationToken);

            if (existingCount != distinctSpecializationIds.Count)
            {
                return Failure(DoctorErrorCodes.SpecializationNotFound, nameof(request.SpecializationIds));
            }
            else
            {
                // All specializations exist.
            }
        }
        else
        {
            // No specializations provided.
        }

        // Begin an atomic database transaction to prevent partial state creation.
        await using var transaction = await _dbContext.Database.BeginTransactionAsync(cancellationToken);

        try
        {
            // Instantiate the identity application user.
            var user = new ApplicationUser
            {
                FirstName = request.FirstName!,
                LastName = request.LastName!,
                UserName = request.Email,
                Email = request.Email,
                PhoneNumber = request.PhoneNumber,
                EmailConfirmed = true,
                PhoneNumberConfirmed = true,
                LockoutEnabled = true,
                IsActive = true
            };

            // Create the user in ASP.NET Core Identity.
            IdentityResult createUserResult = await _userManager.CreateAsync(user, request.Password!);

            if (!createUserResult.Succeeded)
            {
                await transaction.RollbackAsync(cancellationToken);
                var errors = createUserResult.Errors
                    .Select(e => new AuthenticationError(e.Code, e.Description))
                    .ToList();
                return new UserManagementResult { Errors = errors };
            }
            else
            {
                // User created successfully.
            }

            // Assign the Doctor role to the user.
            IdentityResult addRoleResult = await _userManager.AddToRoleAsync(user, RoleConstants.Doctor);

            if (!addRoleResult.Succeeded)
            {
                await transaction.RollbackAsync(cancellationToken);
                var errors = addRoleResult.Errors
                    .Select(e => new AuthenticationError(e.Code, e.Description))
                    .ToList();
                return new UserManagementResult { Errors = errors };
            }
            else
            {
                // Role assigned successfully.
            }

            // Instantiate and add the Doctor domain entity with profile properties.
            var doctor = new Doctor
            {
                Id = Guid.NewGuid(),
                UserId = user.Id,
                User = user,
                NameAr = request.NameAr,
                NameEn = request.NameEn,
                Bio = request.Bio,
                Education = request.Education
            };

            _dbContext.Doctors.Add(doctor);

            // Add specialization join rows if provided.
            if (distinctSpecializationIds.Count > 0)
            {
                foreach (var specId in distinctSpecializationIds)
                {
                    var specialization = await _dbContext.Specializations
                        .FirstAsync(s => s.Id == specId, cancellationToken);

                    _dbContext.DoctorSpecializations.Add(new DoctorSpecialization
                    {
                        DoctorId = doctor.Id,
                        Doctor = doctor,
                        SpecializationId = specId,
                        Specialization = specialization
                    });
                }
            }
            else
            {
                // No specializations to link.
            }

            // Add additional contact phone numbers if provided.
            if (request.PhoneNumbers != null && request.PhoneNumbers.Count > 0)
            {
                foreach (var phoneDto in request.PhoneNumbers)
                {
                    _dbContext.DoctorPhoneNumbers.Add(new DoctorPhoneNumber
                    {
                        Id = Guid.NewGuid(),
                        DoctorId = doctor.Id,
                        Doctor = doctor,
                        PhoneNumber = phoneDto.PhoneNumber!,
                        Label = phoneDto.Label!
                    });
                }
            }
            else
            {
                // No additional phone numbers to link.
            }

            // Save all related entities to the database.
            await _dbContext.SaveChangesAsync(cancellationToken);

            // Commit the transaction.
            await transaction.CommitAsync(cancellationToken);

            _logger.LogInformation("Doctor account {DoctorId} for user {UserId} created successfully", doctor.Id, user.Id);

            return UserManagementResult.Success(user.Id);
        }
        catch (DbUpdateException ex)
        {
            _logger.LogError(ex, "A database error occurred while creating a doctor account.");
            await transaction.RollbackAsync(cancellationToken);
            return Failure(AuthenticationErrorCodes.RegistrationFailed);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "An unexpected error occurred while creating a doctor account.");
            await transaction.RollbackAsync(cancellationToken);
            return Failure(AuthenticationErrorCodes.RegistrationFailed);
        }
    }

    /// <inheritdoc />
    public async Task<UserManagementResult> CreateReceptionistAsync(
        CreateStaffRequest request,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(request);

        // Fetch the authenticated doctor.
        var doctorUserId = _currentUserService.UserId;
        if (doctorUserId == null)
        {
            return Failure(AuthenticationErrorCodes.RegistrationFailed);
        }
        else
        {
            // Proceed with doctor lookup.
        }

        var doctor = await _dbContext.Doctors
            .FirstOrDefaultAsync(d => d.UserId == doctorUserId, cancellationToken);

        if (doctor == null)
        {
            return Failure(AuthenticationErrorCodes.CurrentDoctorNotFound, "DoctorId");
        }
        else
        {
            // Doctor found.
        }

        return await CreateStaffUserAsync(
            request, 
            RoleConstants.Receptionist, 
            cancellationToken, 
            doctor);
    }

    private async Task<UserManagementResult> CreateStaffUserAsync(
        CreateStaffRequest request,
        string role,
        CancellationToken cancellationToken,
        Doctor? assignedDoctor = null)
    {
        ArgumentNullException.ThrowIfNull(request);

        var validationResult = await _validator.ValidateAsync(request, cancellationToken);

        if (!validationResult.IsValid)
        {
            var errors = validationResult.Errors
                .Select(e => new AuthenticationError(e.ErrorCode, e.ErrorMessage))
                .ToList();
            return new UserManagementResult { Errors = errors };
        }
        else
        {
        }

        string normalizedEmail = _userManager.NormalizeEmail(request.Email!);

        if (await _userManager.Users.AnyAsync(
                user => user.NormalizedEmail == normalizedEmail,
                cancellationToken))
        {
            return Failure(AuthenticationErrorCodes.EmailAlreadyRegistered, "Email");
        }
        else
        {
        }

        if (await _userManager.Users.AnyAsync(
                user => user.PhoneNumber == request.PhoneNumber,
                cancellationToken))
        {
            return Failure(AuthenticationErrorCodes.PhoneAlreadyRegistered, "PhoneNumber");
        }
        else
        {
        }

        if (!await _roleManager.RoleExistsAsync(role))
        {
            return Failure(AuthenticationErrorCodes.RegistrationFailed);
        }
        else
        {
        }

        await using var transaction = await _dbContext.Database.BeginTransactionAsync(cancellationToken);

        try
        {
            var user = new ApplicationUser
            {
                FirstName = request.FirstName!,
                LastName = request.LastName!,
                UserName = request.Email,
                Email = request.Email,
                PhoneNumber = request.PhoneNumber,
                EmailConfirmed = true, // Staff accounts are usually pre-confirmed or confirmed via email flow.
                PhoneNumberConfirmed = true,
                LockoutEnabled = true,
                IsActive = true
            };

            IdentityResult createUserResult = await _userManager.CreateAsync(user, request.Password!);

            if (!createUserResult.Succeeded)
            {
                await transaction.RollbackAsync(cancellationToken);
                var errors = createUserResult.Errors
                    .Select(e => new AuthenticationError(e.Code, e.Description))
                    .ToList();
                return new UserManagementResult { Errors = errors };
            }
            else
            {
            }

            IdentityResult addRoleResult = await _userManager.AddToRoleAsync(user, role);

            if (!addRoleResult.Succeeded)
            {
                await transaction.RollbackAsync(cancellationToken);
                var errors = addRoleResult.Errors
                    .Select(e => new AuthenticationError(e.Code, e.Description))
                    .ToList();
                return new UserManagementResult { Errors = errors };
            }
            else
            {
            }

            // Create the corresponding domain entity.
            switch (role)
            {
                case RoleConstants.Admin:
                    _dbContext.Admins.Add(new Admin
                    {
                        Id = Guid.NewGuid(),
                        UserId = user.Id,
                        User = user
                    });
                    break;
                case RoleConstants.Doctor:
                    _dbContext.Doctors.Add(new Doctor
                    {
                        Id = Guid.NewGuid(),
                        UserId = user.Id,
                        User = user
                    });
                    break;
                case RoleConstants.Receptionist:
                    _dbContext.Receptionists.Add(new Receptionist
                    {
                        Id = Guid.NewGuid(),
                        UserId = user.Id,
                        DoctorId = assignedDoctor!.Id,
                        User = user,
                        Doctor = assignedDoctor
                    });
                    break;
                default:
                    break;
            }

            await _dbContext.SaveChangesAsync(cancellationToken);
            await transaction.CommitAsync(cancellationToken);

            return UserManagementResult.Success(user.Id);
    }
        catch (DbUpdateException ex)
        {
            _logger.LogError(ex, "A database error occurred while creating a {Role} user.", role);
            await transaction.RollbackAsync(cancellationToken);
            return Failure(AuthenticationErrorCodes.RegistrationFailed);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "An unexpected error occurred while creating a {Role} user.", role);
            await transaction.RollbackAsync(cancellationToken);
            return Failure(AuthenticationErrorCodes.RegistrationFailed);
        }
    }

    private static UserManagementResult Failure(string errorCode, string propertyName = "")
    {
        return UserManagementResult.Failure(errorCode, propertyName);
    }

    /// <inheritdoc />
    public async Task<PagedResponse<UserResponse>> GetUsersAsync(
        UserQueryParameters queryParams,
        CancellationToken cancellationToken = default)
    {
        // Build the base query with Receptionist navigation for authorization filtering.
        var query = _dbContext.Users
            .AsNoTracking()
            .Include(u => u.Receptionist)
            .AsQueryable();

        // Retrieve the current user's identity and role for authorization decisions.
        var currentUserId = _currentUserService.UserId;
        var currentRole = _currentUserService.Role;

        // Apply Global Filter (Only Active)
        if (currentRole != RoleConstants.Admin)
        {
            query = query.Where(u => u.IsActive);
        }
        else
        {
        }

        // Apply authorization filtering based on the caller's role.
        if (currentRole == RoleConstants.Doctor)
        {
            // Resolve the Doctor entity ID linked to the current user.
            var doctorId = await _dbContext.Doctors
                .Where(d => d.UserId == currentUserId)
                .Select(d => d.Id)
                .FirstOrDefaultAsync(cancellationToken);

            // Doctors can only see themselves and their own receptionists.
            query = query.Where(u => u.Id == currentUserId || (u.Receptionist != null && u.Receptionist.DoctorId == doctorId));
        }
        else if (currentRole == RoleConstants.Patient || currentRole == RoleConstants.Receptionist)
        {
            // Patients and Receptionists can only see their own profile.
            query = query.Where(u => u.Id == currentUserId);
        }
        else
        {
        }

        // Apply Search Filtering
        if (!string.IsNullOrWhiteSpace(queryParams.Name))
        {
            var name = queryParams.Name;
            query = query.Where(u => EF.Functions.Like(u.FirstName + " " + u.LastName, $"%{name}%"));
        }
        else
        {
        }

        // Apply role filtering by joining to IdentityUserRole via a subquery.
        if (!string.IsNullOrWhiteSpace(queryParams.Role))
        {
            var role = queryParams.Role;
            // Resolve the role identifier from the role name.
            var roleId = await _dbContext.Roles.Where(r => r.Name == role).Select(r => r.Id).FirstOrDefaultAsync(cancellationToken);
            if (roleId != Guid.Empty)
            {
                // Build a subquery of user IDs belonging to the requested role.
                var userIdsInRole = _dbContext.UserRoles.Where(ur => ur.RoleId == roleId).Select(ur => ur.UserId);
                // Filter the main query to only include users in the requested role.
                query = query.Where(u => userIdsInRole.Contains(u.Id));
            }
            else
            {
            }
        }
        else
        {
        }

        // Count total matching records before applying pagination.
        var totalCount = await query.CountAsync(cancellationToken);

        // Apply deterministic ordering and pagination.
        var users = await query
            .OrderByDescending(u => u.CreatedAt)
            .ThenBy(u => u.Id)
            .Skip((queryParams.PageNumber - 1) * queryParams.PageSize)
            .Take(queryParams.PageSize)
            .ToListAsync(cancellationToken);

        // Map each user entity to a response DTO, including their assigned roles.
        var responses = new List<UserResponse>();
        foreach (var user in users)
        {
            // Retrieve the user's assigned roles from Identity.
            var roles = await _userManager.GetRolesAsync(user);
            responses.Add(MapToResponse(user, roles.ToList()));
        }

        // Return the paginated response with metadata.
        return new PagedResponse<UserResponse>
        {
            Items = responses,
            TotalCount = totalCount,
            PageNumber = queryParams.PageNumber,
            PageSize = queryParams.PageSize
        };
    }

    /// <inheritdoc />
    public async Task<UserResponse?> GetUserByIdAsync(Guid id, CancellationToken cancellationToken = default)
    {
        // Build the base query with Receptionist navigation for authorization filtering.
        var query = _dbContext.Users
            .AsNoTracking()
            .Include(u => u.Receptionist)
            .AsQueryable();

        // Retrieve the current user's identity and role for authorization decisions.
        var currentUserId = _currentUserService.UserId;
        var currentRole = _currentUserService.Role;

        // Non-admin users can only see active users.
        if (currentRole != RoleConstants.Admin)
        {
            query = query.Where(u => u.IsActive);
        }
        else
        {
        }

        // Apply authorization filtering based on the caller's role.
        if (currentRole == RoleConstants.Doctor)
        {
            // Resolve the Doctor entity ID linked to the current user.
            var doctorId = await _dbContext.Doctors
                .Where(d => d.UserId == currentUserId)
                .Select(d => d.Id)
                .FirstOrDefaultAsync(cancellationToken);

            // Doctors can only see themselves and their own receptionists.
            query = query.Where(u => u.Id == currentUserId || (u.Receptionist != null && u.Receptionist.DoctorId == doctorId));
        }
        else if (currentRole == RoleConstants.Patient || currentRole == RoleConstants.Receptionist)
        {
            // Patients and Receptionists can only see their own profile.
            query = query.Where(u => u.Id == currentUserId);
        }
        else
        {
        }

        // Attempt to find the user matching the requested ID within the authorized scope.
        var user = await query.FirstOrDefaultAsync(u => u.Id == id, cancellationToken);

        // Return null when the user is not found or not accessible.
        if (user == null)
        {
            return null;
        }
        else
        {
        }

        // Retrieve the user's assigned roles from Identity.
        var roles = await _userManager.GetRolesAsync(user);

        // Map and return the user response DTO.
        return MapToResponse(user, roles.ToList());
    }

    /// <inheritdoc />
    public async Task<UserManagementResult> UpdateUserAsync(Guid id, UpdateUserRequest request, CancellationToken cancellationToken = default)
    {
        // Guard against null request.
        ArgumentNullException.ThrowIfNull(request);

        // Validate the update request using FluentValidation.
        var validationResult = await _updateValidator.ValidateAsync(request, cancellationToken);
        if (!validationResult.IsValid)
        {
            // Map validation failures to structured error responses.
            var errors = validationResult.Errors.Select(e => new AuthenticationError(e.ErrorCode, e.PropertyName)).ToList();
            return UserManagementResult.Failure(errors);
        }
        else
        {
        }

        // Load the target user with Receptionist navigation for authorization checks.
        var user = await _dbContext.Users
            .Include(u => u.Receptionist)
            .FirstOrDefaultAsync(u => u.Id == id, cancellationToken);

        // Return an error if the user does not exist or has been soft-deleted.
        if (user == null || !user.IsActive)
        {
            return UserManagementResult.Failure(AuthenticationErrorCodes.UserNotFound, nameof(id));
        }
        else
        {
        }

        // Retrieve the current user's identity and role for authorization decisions.
        var currentUserId = _currentUserService.UserId;
        var currentRole = _currentUserService.Role;

        // Apply authorization checks based on the caller's role.
        if (currentRole == RoleConstants.Doctor)
        {
            // Resolve the Doctor entity ID linked to the current user.
            var doctorId = await _dbContext.Doctors
                .Where(d => d.UserId == currentUserId)
                .Select(d => d.Id)
                .FirstOrDefaultAsync(cancellationToken);

            // Check if the doctor is updating their own profile or their receptionist's.
            bool isSelf = id == currentUserId;
            bool isOwnReceptionist = user.Receptionist != null && user.Receptionist.DoctorId == doctorId;

            // Deny access if the doctor is not updating themselves or their own receptionist.
            if (!isSelf && !isOwnReceptionist)
            {
                return UserManagementResult.Failure(AuthenticationErrorCodes.Forbidden, nameof(id));
            }
            else
            {
            }
        }
        else if (currentRole == RoleConstants.Patient || currentRole == RoleConstants.Receptionist)
        {
            // Patients and Receptionists can only update their own profile.
            if (id != currentUserId)
            {
                return UserManagementResult.Failure(AuthenticationErrorCodes.Forbidden, nameof(id));
            }
            else
            {
            }
        }
        else if (currentRole != RoleConstants.Admin)
        {
            // Deny access for any unrecognized role.
            return UserManagementResult.Failure(AuthenticationErrorCodes.Forbidden, nameof(id));
        }
        else
        {
        }

        // Apply only the fields that were explicitly provided in the request.
        if (request.FirstName != null)
        {
            user.FirstName = request.FirstName;
        }
        else
        {
        }

        if (request.LastName != null)
        {
            user.LastName = request.LastName;
        }
        else
        {
        }

        if (request.Gender != null)
        {
            user.Gender = request.Gender;
        }
        else
        {
        }

        if (request.DateOfBirth != null)
        {
            user.DateOfBirth = request.DateOfBirth;
        }
        else
        {
        }

        if (request.Address != null)
        {
            user.Address = request.Address;
        }
        else
        {
        }

        // Update audit trail fields.
        user.UpdatedAt = DateTime.UtcNow;
        user.UpdatedById = currentUserId;

        // Persist the updated user profile to the database.
        await _dbContext.SaveChangesAsync(cancellationToken);

        // Return the updated user's identifier.
        return UserManagementResult.Success(user.Id);
    }

    /// <inheritdoc />
    public async Task<UserManagementResult> DeleteUserAsync(Guid id, CancellationToken cancellationToken = default)
    {
        // Only administrators are allowed to delete users.
        var currentRole = _currentUserService.Role;
        if (currentRole != RoleConstants.Admin)
        {
            return UserManagementResult.Failure(AuthenticationErrorCodes.Forbidden, nameof(id));
        }
        else
        {
        }

        // Load the target user from the database.
        var user = await _dbContext.Users.FirstOrDefaultAsync(u => u.Id == id, cancellationToken);

        // Return an error if the user does not exist or has already been soft-deleted.
        if (user == null || !user.IsActive)
        {
            return UserManagementResult.Failure(AuthenticationErrorCodes.UserNotFound, nameof(id));
        }
        else
        {
        }

        // Mark the user as inactive (soft delete) and record the deletion audit trail.
        user.IsActive = false;
        user.DeletedAt = DateTime.UtcNow;
        user.DeletedById = _currentUserService.UserId;

        // Persist the soft-delete changes to the database.
        await _dbContext.SaveChangesAsync(cancellationToken);

        // Return the soft-deleted user's identifier.
        return UserManagementResult.Success(user.Id);
    }

    /// <inheritdoc />
    public async Task<UserManagementResult> DeleteAllUsersAsync(CancellationToken cancellationToken = default)
    {
        // Only administrators are allowed to perform bulk user deletion.
        var currentRole = _currentUserService.Role;
        if (currentRole != RoleConstants.Admin)
        {
            return UserManagementResult.Failure(AuthenticationErrorCodes.Forbidden);
        }
        else
        {
        }

        var currentUserId = _currentUserService.UserId;

        // Fetch all active users except the performing administrator to prevent self-lockout.
        var usersToDelete = await _dbContext.Users
            .Where(u => u.IsActive && u.Id != currentUserId)
            .ToListAsync(cancellationToken);

        var now = DateTime.UtcNow;

        foreach (var user in usersToDelete)
        {
            user.IsActive = false;
            user.DeletedAt = now;
            user.DeletedById = currentUserId;
        }

        await _dbContext.SaveChangesAsync(cancellationToken);

        return UserManagementResult.Success(currentUserId ?? Guid.Empty);
    }

    /// <summary>
    /// Maps an <see cref="ApplicationUser"/> entity to a <see cref="UserResponse"/> DTO.
    /// </summary>
    /// <param name="user">The application user entity.</param>
    /// <param name="roles">The list of role names assigned to the user.</param>
    /// <returns>A <see cref="UserResponse"/> representing the user's profile.</returns>
    private static UserResponse MapToResponse(ApplicationUser user, List<string> roles)
    {
        // Map entity properties to the response DTO.
        return new UserResponse
        {
            Id = user.Id,
            FirstName = user.FirstName,
            LastName = user.LastName,
            Email = user.Email!,
            PhoneNumber = user.PhoneNumber,
            Gender = user.Gender,
            DateOfBirth = user.DateOfBirth,
            Address = user.Address,
            IsActive = user.IsActive,
            CreatedAt = user.CreatedAt,
            Roles = roles
        };
    }
}
