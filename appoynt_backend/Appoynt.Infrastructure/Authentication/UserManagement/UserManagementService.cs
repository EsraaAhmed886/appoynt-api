/**
 * File Name      : UserManagementService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 28/07/2026
 * Version        : v1.0.0
 * Dependencies   : IUserManagementService, UserManager, RoleManager,
 *                  ApplicationDbContext, ICurrentUserService
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 28/07/2026
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
        IValidator<UpdateUserRequest> updateValidator,
        ILogger<UserManagementService> logger)
    {
        _userManager = userManager;
        _roleManager = roleManager;
        _dbContext = dbContext;
        _currentUserService = currentUserService;
        _validator = validator;
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
        CreateStaffRequest request,
        CancellationToken cancellationToken = default)
    {
        return await CreateStaffUserAsync(request, RoleConstants.Doctor, cancellationToken);
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

        var doctor = await _dbContext.Doctors
            .FirstOrDefaultAsync(d => d.UserId == doctorUserId, cancellationToken);

        if (doctor == null)
        {
            return Failure(AuthenticationErrorCodes.CurrentDoctorNotFound, "DoctorId");
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

        string normalizedEmail = _userManager.NormalizeEmail(request.Email!);

        if (await _userManager.Users.AnyAsync(
                user => user.NormalizedEmail == normalizedEmail,
                cancellationToken))
        {
            return Failure(AuthenticationErrorCodes.EmailAlreadyRegistered, "Email");
        }

        if (await _userManager.Users.AnyAsync(
                user => user.PhoneNumber == request.PhoneNumber,
                cancellationToken))
        {
            return Failure(AuthenticationErrorCodes.PhoneAlreadyRegistered, "PhoneNumber");
        }

        if (!await _roleManager.RoleExistsAsync(role))
        {
            return Failure(AuthenticationErrorCodes.RegistrationFailed);
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

            IdentityResult addRoleResult = await _userManager.AddToRoleAsync(user, role);

            if (!addRoleResult.Succeeded)
            {
                await transaction.RollbackAsync(cancellationToken);
                var errors = addRoleResult.Errors
                    .Select(e => new AuthenticationError(e.Code, e.Description))
                    .ToList();
                return new UserManagementResult { Errors = errors };
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

    public async Task<PagedResponse<UserResponse>> GetUsersAsync(
        UserQueryParameters queryParams,
        CancellationToken cancellationToken = default)
    {
        var query = _dbContext.Users
            .Include(u => u.Receptionist)
            .AsQueryable();

        var currentUserId = _currentUserService.UserId;
        var currentRole = _currentUserService.Role;

        // Apply Global Filter (Only Active)
        if (currentRole != RoleConstants.Admin)
        {
            query = query.Where(u => u.IsActive);
        }

        // Apply Authorization Filtering
        if (currentRole == RoleConstants.Doctor)
        {
            var doctorId = await _dbContext.Doctors
                .Where(d => d.UserId == currentUserId)
                .Select(d => d.Id)
                .FirstOrDefaultAsync(cancellationToken);

            query = query.Where(u => u.Id == currentUserId || (u.Receptionist != null && u.Receptionist.DoctorId == doctorId));
        }
        else if (currentRole == RoleConstants.Patient || currentRole == RoleConstants.Receptionist)
        {
            query = query.Where(u => u.Id == currentUserId);
        }

        // Apply Search Filtering
        if (!string.IsNullOrWhiteSpace(queryParams.Name))
        {
            var name = queryParams.Name;
            query = query.Where(u => EF.Functions.Like(u.FirstName + " " + u.LastName, $"%{name}%"));
        }

        // Note: Role filtering requires join to IdentityUserRole. Since we want to keep it simple, we fetch the roles later.
        // Or we can filter based on navigation properties since our application is strictly typed.
        if (!string.IsNullOrWhiteSpace(queryParams.Role))
        {
            var role = queryParams.Role;
            var roleId = await _dbContext.Roles.Where(r => r.Name == role).Select(r => r.Id).FirstOrDefaultAsync(cancellationToken);
            if (roleId != Guid.Empty)
            {
                var userIdsInRole = _dbContext.UserRoles.Where(ur => ur.RoleId == roleId).Select(ur => ur.UserId);
                query = query.Where(u => userIdsInRole.Contains(u.Id));
            }
        }

        var totalCount = await query.CountAsync(cancellationToken);

        var users = await query
            .OrderByDescending(u => u.CreatedAt)
            .ThenBy(u => u.Id)
            .Skip((queryParams.PageNumber - 1) * queryParams.PageSize)
            .Take(queryParams.PageSize)
            .ToListAsync(cancellationToken);

        var responses = new List<UserResponse>();
        foreach (var user in users)
        {
            var roles = await _userManager.GetRolesAsync(user);
            responses.Add(MapToResponse(user, roles.ToList()));
        }

        return new PagedResponse<UserResponse>
        {
            Items = responses,
            TotalCount = totalCount,
            PageNumber = queryParams.PageNumber,
            PageSize = queryParams.PageSize
        };
    }

    public async Task<UserResponse?> GetUserByIdAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var query = _dbContext.Users
            .Include(u => u.Receptionist)
            .AsQueryable();

        var currentUserId = _currentUserService.UserId;
        var currentRole = _currentUserService.Role;

        if (currentRole != RoleConstants.Admin)
        {
            query = query.Where(u => u.IsActive);
        }

        if (currentRole == RoleConstants.Doctor)
        {
            var doctorId = await _dbContext.Doctors
                .Where(d => d.UserId == currentUserId)
                .Select(d => d.Id)
                .FirstOrDefaultAsync(cancellationToken);

            query = query.Where(u => u.Id == currentUserId || (u.Receptionist != null && u.Receptionist.DoctorId == doctorId));
        }
        else if (currentRole == RoleConstants.Patient || currentRole == RoleConstants.Receptionist)
        {
            query = query.Where(u => u.Id == currentUserId);
        }

        var user = await query.FirstOrDefaultAsync(u => u.Id == id, cancellationToken);
        if (user == null) return null;

        var roles = await _userManager.GetRolesAsync(user);
        return MapToResponse(user, roles.ToList());
    }

    public async Task<UserManagementResult> UpdateUserAsync(Guid id, UpdateUserRequest request, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(request);

        var validationResult = await _updateValidator.ValidateAsync(request, cancellationToken);
        if (!validationResult.IsValid)
        {
            var errors = validationResult.Errors.Select(e => new AuthenticationError(e.ErrorCode, e.PropertyName)).ToList();
            return UserManagementResult.Failure(errors);
        }

        var user = await _dbContext.Users
            .Include(u => u.Receptionist)
            .FirstOrDefaultAsync(u => u.Id == id, cancellationToken);

        if (user == null || !user.IsActive)
        {
            return UserManagementResult.Failure(AuthenticationErrorCodes.RegistrationFailed, "User not found");
        }

        var currentUserId = _currentUserService.UserId;
        var currentRole = _currentUserService.Role;

        if (currentRole == RoleConstants.Doctor)
        {
            var doctorId = await _dbContext.Doctors
                .Where(d => d.UserId == currentUserId)
                .Select(d => d.Id)
                .FirstOrDefaultAsync(cancellationToken);

            bool isSelf = id == currentUserId;
            bool isOwnReceptionist = user.Receptionist != null && user.Receptionist.DoctorId == doctorId;

            if (!isSelf && !isOwnReceptionist)
            {
                return UserManagementResult.Failure(AuthenticationErrorCodes.Forbidden, "Unauthorized");
            }
        }
        else if (currentRole == RoleConstants.Patient || currentRole == RoleConstants.Receptionist)
        {
            if (id != currentUserId)
            {
                return UserManagementResult.Failure(AuthenticationErrorCodes.Forbidden, "Unauthorized");
            }
        }
        else if (currentRole != RoleConstants.Admin)
        {
            return UserManagementResult.Failure(AuthenticationErrorCodes.Forbidden, "Unauthorized");
        }

        if (request.FirstName != null) user.FirstName = request.FirstName;
        if (request.LastName != null) user.LastName = request.LastName;
        if (request.Gender != null) user.Gender = request.Gender;
        if (request.DateOfBirth != null) user.DateOfBirth = request.DateOfBirth;
        if (request.Address != null) user.Address = request.Address;

        user.UpdatedAt = DateTime.UtcNow;
        user.UpdatedById = currentUserId;

        await _dbContext.SaveChangesAsync(cancellationToken);

        return UserManagementResult.Success(user.Id);
    }

    public async Task<UserManagementResult> DeleteUserAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var currentRole = _currentUserService.Role;
        if (currentRole != RoleConstants.Admin)
        {
            return UserManagementResult.Failure(AuthenticationErrorCodes.Forbidden, "Unauthorized");
        }

        var user = await _dbContext.Users.FirstOrDefaultAsync(u => u.Id == id, cancellationToken);
        if (user == null || !user.IsActive)
        {
            return UserManagementResult.Failure(AuthenticationErrorCodes.RegistrationFailed, "User not found");
        }

        user.IsActive = false;
        user.DeletedAt = DateTime.UtcNow;
        user.DeletedById = _currentUserService.UserId;

        await _dbContext.SaveChangesAsync(cancellationToken);

        return UserManagementResult.Success(user.Id);
    }

    private static UserResponse MapToResponse(ApplicationUser user, List<string> roles)
    {
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
