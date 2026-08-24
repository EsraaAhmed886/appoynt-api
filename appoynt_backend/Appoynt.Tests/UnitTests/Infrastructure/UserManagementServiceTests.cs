/**
 * File Name      : UserManagementServiceTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-24
 * Version        : v1.0.0
 * Dependencies   : UserManagementService, UserManager, RoleManager,
 *                  ApplicationDbContext, FluentValidation validators, Moq, FluentAssertions
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-24
 * Description    : Unit tests for UserManagementService covering staff account
 *                  creation guards (duplicate email/phone, missing roles, failed
 *                  identity operations), doctor profile persistence with
 *                  specializations, receptionist linkage, authorization-scoped
 *                  retrieval, soft deletion, and bulk deletion self-lockout prevention.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Application.Features.UserManagement.Contracts;
using Appoynt.Application.Features.UserManagement.Validation;
using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Authentication.UserManagement;
using Appoynt.Infrastructure.Persistence;
using FluentAssertions;
using FluentValidation;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Moq;
using Xunit;

namespace Appoynt.Tests.UnitTests.Infrastructure;

/// <summary>
/// Unit tests for the Identity-backed staff management service.
/// </summary>
public class UserManagementServiceTests
{
    // Mocked Identity user store backing the user manager.
    private readonly Mock<IUserStore<ApplicationUser>> _userStoreMock = new();

    // Mocked Identity role store backing the role manager.
    private readonly Mock<IRoleStore<IdentityRole<Guid>>> _roleStoreMock = new();

    // Mocked current-user accessor simulating authentication state per test.
    private readonly Mock<ICurrentUserService> _currentUserMock = new();

    // Mocked logger satisfying the service logging requirement.
    private readonly Mock<ILogger<UserManagementService>> _loggerMock = new();

    /// <summary>
    /// Builds a role manager mock whose role existence checks succeed by default.
    /// </summary>
    /// <returns>A configured <see cref="RoleManager{TRole}"/> mock.</returns>
    private static Mock<RoleManager<IdentityRole<Guid>>> CreateRoleManagerMock()
    {
        // Build the standard five-argument Identity role manager constructor mock.
        var roleManagerMock = new Mock<RoleManager<IdentityRole<Guid>>>(
            new Mock<IRoleStore<IdentityRole<Guid>>>().Object,
            null!, null!, null!, null!);

        // Default every seeded system role to exist; individual tests may override.
        roleManagerMock
            .Setup(manager => manager.RoleExistsAsync(It.IsAny<string>()))
            .ReturnsAsync(true);
        return roleManagerMock;
    }

    /// <summary>
    /// Builds the service under test wired with real validators and supplied managers.
    /// </summary>
    /// <param name="dbContext">The isolated in-memory database context.</param>
    /// <param name="userManager">The configured user manager instance.</param>
    /// <param name="roleManager">Optional configured role manager instance.</param>
    /// <param name="currentUser">Optional current-user accessor override.</param>
    /// <returns>A configured <see cref="UserManagementService"/>.</returns>
    private static UserManagementService CreateService(
        ApplicationDbContext dbContext,
        UserManager<ApplicationUser> userManager,
        RoleManager<IdentityRole<Guid>>? roleManager = null,
        ICurrentUserService? currentUser = null)
    {
        // Assemble the service with real FluentValidation validators.
        return new UserManagementService(
            userManager,
            roleManager ?? CreateRoleManagerMock().Object,
            dbContext,
            currentUser ?? new Mock<ICurrentUserService>().Object,
            new CreateStaffRequestValidator(),
            new CreateDoctorRequestValidator(),
            new UpdateUserRequestValidator(),
            new Mock<ILogger<UserManagementService>>().Object);
    }

    /// <summary>
    /// Creates a user manager mock whose Users property is backed by the given context.
    /// </summary>
    /// <param name="dbContext">The database context supplying the users queryable.</param>
    /// <returns>A configured <see cref="UserManager{TUser}"/> mock.</returns>
    private static Mock<UserManager<ApplicationUser>> CreateUserManagerMock(ApplicationDbContext dbContext)
    {
        // Build the standard nine-argument Identity constructor mock.
        var userManagerMock = new Mock<UserManager<ApplicationUser>>(
            new Mock<IUserStore<ApplicationUser>>().Object,
            null!, null!, null!, null!, null!, null!, null!, null!);

        // Route the Users queryable through the async-capable EF provider.
        userManagerMock.Setup(manager => manager.Users).Returns(dbContext.Users);

        // Provide deterministic uppercase normalization mirroring production behavior.
        userManagerMock
            .Setup(manager => manager.NormalizeEmail(It.IsAny<string>()))
            .Returns((string email) => email.ToUpperInvariant());

        // Default identity creation to success; individual tests may override.
        userManagerMock
            .Setup(manager => manager.CreateAsync(It.IsAny<ApplicationUser>(), It.IsAny<string>()))
            .ReturnsAsync(IdentityResult.Success);

        // Default role assignment to success; individual tests may override.
        userManagerMock
            .Setup(manager => manager.AddToRoleAsync(It.IsAny<ApplicationUser>(), It.IsAny<string>()))
            .ReturnsAsync(IdentityResult.Success);
        return userManagerMock;
    }

    /// <summary>
    /// Seeds an existing user row to trigger duplicate-detection paths.
    /// </summary>
    /// <param name="dbContext">The database context to seed.</param>
    /// <param name="email">The email address of the existing user.</param>
    /// <param name="phoneNumber">The phone number of the existing user.</param>
    /// <returns>The seeded user identifier.</returns>
    private static async Task<Guid> SeedExistingUserAsync(ApplicationDbContext dbContext, string email, string phoneNumber)
    {
        // Persist a fully populated existing user matching required column rules.
        var existing = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Existing",
            LastName = "User",
            Email = email,
            NormalizedEmail = email.ToUpperInvariant(),
            UserName = email,
            PhoneNumber = phoneNumber,
            IsActive = true
        };
        dbContext.Users.Add(existing);
        await dbContext.SaveChangesAsync();
        return existing.Id;
    }

    /// <summary>
    /// Builds a valid staff creation payload with optional overrides for reuse across scenarios.
    /// </summary>
    /// <param name="email">Optional email override.</param>
    /// <param name="phoneNumber">Optional phone override.</param>
    /// <param name="password">Optional password override.</param>
    /// <returns>A valid <see cref="CreateStaffRequest"/>.</returns>
    private static CreateStaffRequest BuildValidStaffRequest(
        string? email = null,
        string? phoneNumber = null,
        string? password = null)
    {
        // Return a baseline payload satisfying every validator rule with applied overrides.
        return new CreateStaffRequest
        {
            FirstName = "New",
            LastName = "Admin",
            Email = email ?? $"new.admin.{Guid.NewGuid():N}@appoynt.com",
            PhoneNumber = phoneNumber ?? "+2010" + Random.Shared.Next(10000000, 99999999).ToString(),
            Password = password ?? "ValidPass123!"
        };
    }

    #region CreateAdminAsync

    /// <summary>
    /// A valid admin creation must persist an active, confirmed, lockout-enabled user plus an Admin record.
    /// </summary>
    [Fact]
    public async Task CreateAdminAsync_ValidRequest_CreatesConfirmedActiveAdminRecord()
    {
        // Arrange an isolated context with a passing default role check and a valid request.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        var service = CreateService(dbContext, userManagerMock.Object);
        var request = BuildValidStaffRequest();

        // Act
        var result = await service.CreateAdminAsync(request, CancellationToken.None);

        // Assert both the outcome and the persisted state are correct.
        result.Succeeded.Should().BeTrue();
        result.UserId.Should().NotBeNull();

        var createdUser = await dbContext.Users.AsNoTracking().SingleAsync(user => user.Id == result.UserId);
        createdUser.EmailConfirmed.Should().BeTrue();
        createdUser.PhoneNumberConfirmed.Should().BeTrue();
        createdUser.LockoutEnabled.Should().BeTrue();
        createdUser.IsActive.Should().BeTrue();

        dbContext.Admins.AsNoTracking().Should().ContainSingle(admin => admin.UserId == result.UserId);
    }

    /// <summary>
    /// A duplicate email must be rejected before any identity creation occurs.
    /// </summary>
    [Fact]
    public async Task CreateAdminAsync_DuplicateEmail_ReturnsEmailAlreadyRegistered()
    {
        // Arrange an existing user occupying the target email address.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        var existingEmail = "taken@appoynt.com";
        await SeedExistingUserAsync(dbContext, existingEmail, "01011110001");
        var service = CreateService(dbContext, userManagerMock.Object);
        var request = BuildValidStaffRequest(email: existingEmail);

        // Act
        var result = await service.CreateAdminAsync(request, CancellationToken.None);

        // Assert rejection happened prior to contacting Identity.
        result.Succeeded.Should().BeFalse();
        result.Errors.Should().Contain(error => error.Code == AuthenticationErrorCodes.EmailAlreadyRegistered);
        userManagerMock.Verify(
            manager => manager.CreateAsync(It.IsAny<ApplicationUser>(), It.IsAny<string>()),
            Times.Never);
    }

    /// <summary>
    /// A duplicate phone number must be rejected before any identity creation occurs.
    /// </summary>
    [Fact]
    public async Task CreateAdminAsync_DuplicatePhone_ReturnsPhoneAlreadyRegistered()
    {
        // Arrange an existing user occupying the target phone number.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        const string takenPhone = "+201055556666";
        await SeedExistingUserAsync(dbContext, "owner@appoynt.com", takenPhone);
        var service = CreateService(dbContext, userManagerMock.Object);
        var request = BuildValidStaffRequest(phoneNumber: takenPhone);

        // Act
        var result = await service.CreateAdminAsync(request, CancellationToken.None);

        // Assert.
        result.Succeeded.Should().BeFalse();
        result.Errors.Should().Contain(error => error.Code == AuthenticationErrorCodes.PhoneAlreadyRegistered);
        userManagerMock.Verify(
            manager => manager.CreateAsync(It.IsAny<ApplicationUser>(), It.IsAny<string>()),
            Times.Never);
    }

    /// <summary>
    /// Creation must fail cleanly when the target system role has not been seeded.
    /// </summary>
    [Fact]
    public async Task CreateAdminAsync_RoleDoesNotExist_ReturnsRegistrationFailed()
    {
        // Arrange the role lookup to report a missing Admin role.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        var missingRoleManagerMock = CreateRoleManagerMock();
        missingRoleManagerMock
            .Setup(manager => manager.RoleExistsAsync(RoleConstants.Admin))
            .ReturnsAsync(false);
        var service = CreateService(dbContext, userManagerMock.Object, missingRoleManagerMock.Object);

        // Act
        var result = await service.CreateAdminAsync(BuildValidStaffRequest(), CancellationToken.None);

        // Assert.
        result.Succeeded.Should().BeFalse();
        result.Errors.Should().Contain(error => error.Code == AuthenticationErrorCodes.RegistrationFailed);
    }

    /// <summary>
    /// An invalid staff payload must surface validator errors without any identity interaction.
    /// </summary>
    [Fact]
    public async Task CreateAdminAsync_InvalidPayload_ReturnsValidationErrorsWithoutIdentityCalls()
    {
        // Arrange a payload missing its password complexity requirements.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        var service = CreateService(dbContext, userManagerMock.Object);
        var request = BuildValidStaffRequest(password: "weak");

        // Act
        var result = await service.CreateAdminAsync(request, CancellationToken.None);

        // Assert the validator failure targets the password rule without identity interaction.
        result.Succeeded.Should().BeFalse();
        result.Errors.Should().Contain(error =>
            error.Field == AuthenticationErrorCodes.PasswordComplexityInvalid);
        userManagerMock.Verify(
            manager => manager.CreateAsync(It.IsAny<ApplicationUser>(), It.IsAny<string>()),
            Times.Never);
    }

    /// <summary>
    /// When Identity rejects user creation its errors must be propagated verbatim.
    /// </summary>
    [Fact]
    public async Task CreateAdminAsync_IdentityCreateFails_PropagatesIdentityErrors()
    {
        // Arrange identity creation to fail with a duplicate-name descriptor.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        userManagerMock
            .Setup(manager => manager.CreateAsync(It.IsAny<ApplicationUser>(), It.IsAny<string>()))
            .ReturnsAsync(IdentityResult.Failed(new IdentityError { Code = "DuplicateUserName", Description = "Username already taken." }));
        var service = CreateService(dbContext, userManagerMock.Object);

        // Act
        var result = await service.CreateAdminAsync(BuildValidStaffRequest(), CancellationToken.None);

        // Assert the raw identity codes flow through untouched.
        result.Succeeded.Should().BeFalse();
        result.Errors.Should().Contain(error => error.Code == "DuplicateUserName");
    }

    /// <summary>
    /// A failed role assignment must abort creation and return the role errors.
    /// </summary>
    [Fact]
    public async Task CreateAdminAsync_AddToRoleFails_ReturnsErrorsAndSkipsPersistence()
    {
        // Arrange successful creation but failing role assignment.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        userManagerMock
            .Setup(manager => manager.AddToRoleAsync(It.IsAny<ApplicationUser>(), RoleConstants.Admin))
            .ReturnsAsync(IdentityResult.Failed(new IdentityError { Code = "RoleMissing", Description = "Role missing." }));
        var service = CreateService(dbContext, userManagerMock.Object);

        // Act
        var result = await service.CreateAdminAsync(BuildValidStaffRequest(), CancellationToken.None);

        // Assert no Admin record was committed despite user creation succeeding.
        result.Succeeded.Should().BeFalse();
        result.Errors.Should().Contain(error => error.Code == "RoleMissing");
        dbContext.Admins.AsNoTracking().Should().BeEmpty();
    }

    #endregion

    #region CreateDoctorAsync

    /// <summary>
    /// A valid doctor creation must persist the Doctor entity with an auto-composed English name.
    /// </summary>
    [Fact]
    public async Task CreateDoctorAsync_ValidRequestWithoutNameEn_ComposesNameFromFirstAndLast()
    {
        // Arrange a valid doctor payload relying on automatic name composition.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        var service = CreateService(dbContext, userManagerMock.Object);
        var request = new CreateDoctorRequest
        {
            FirstName = "Mona",
            LastName = "Adel",
            Email = $"dr.mona.{Guid.NewGuid():N}@appoynt.com",
            PhoneNumber = "+2010" + Random.Shared.Next(10000000, 99999999).ToString(),
            Password = "ValidPass123!",
            NameAr = "د. منى عادل",
            SpecializationIds = []
        };

        // Act
        var result = await service.CreateDoctorAsync(request, CancellationToken.None);

        // Assert the composed display name and domain entity linkage.
        result.Succeeded.Should().BeTrue();
        var doctor = await dbContext.Doctors.AsNoTracking().SingleAsync(d => d.UserId == result.UserId);
        doctor.NameEn.Should().Be("Mona Adel");
        doctor.NameAr.Should().Be("د. منى عادل");
    }

    /// <summary>
    /// Referencing unknown specializations must reject the whole creation.
    /// </summary>
    [Fact]
    public async Task CreateDoctorAsync_UnknownSpecialization_ReturnsSpecializationNotFound()
    {
        // Arrange a payload referencing a nonexistent specialization identifier.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        var service = CreateService(dbContext, userManagerMock.Object);
        var request = new CreateDoctorRequest
        {
            FirstName = "Mona",
            LastName = "Adel",
            Email = $"dr.spec.{Guid.NewGuid():N}@appoynt.com",
            PhoneNumber = "+2010" + Random.Shared.Next(10000000, 99999999).ToString(),
            Password = "ValidPass123!",
            NameAr = "د. منى عادل",
            SpecializationIds = [Guid.NewGuid()]
        };

        // Act
        var result = await service.CreateDoctorAsync(request, CancellationToken.None);

        // Assert.
        result.Succeeded.Should().BeFalse();
        result.Errors.Should().Contain(error => error.Code == DoctorErrorCodes.SpecializationNotFound);
        userManagerMock.Verify(
            manager => manager.CreateAsync(It.IsAny<ApplicationUser>(), It.IsAny<string>()),
            Times.Never);
    }

    /// <summary>
    /// A payload failing doctor validation must be rejected before any lookups occur.
    /// </summary>
    [Fact]
    public async Task CreateDoctorAsync_MissingArabicName_ReturnsValidationErrorImmediately()
    {
        // Arrange a payload omitting the mandatory Arabic display name.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        var service = CreateService(dbContext, userManagerMock.Object);
        var request = new CreateDoctorRequest
        {
            FirstName = "Mona",
            LastName = "Adel",
            Email = $"dr.noname.{Guid.NewGuid():N}@appoynt.com",
            PhoneNumber = "+2010" + Random.Shared.Next(10000000, 99999999).ToString(),
            Password = "ValidPass123!"
        };

        // Act
        var result = await service.CreateDoctorAsync(request, CancellationToken.None);

        // Assert.
        result.Succeeded.Should().BeFalse();
        result.Errors.Should().Contain(error => error.Field == nameof(CreateDoctorRequest.NameAr));
    }

    /// <summary>
    /// A duplicate doctor email must be rejected through the same registration guard as staff.
    /// </summary>
    [Fact]
    public async Task CreateDoctorAsync_DuplicateEmail_ReturnsEmailAlreadyRegistered()
    {
        // Arrange an occupied email address.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        var takenEmail = "doctor.taken@appoynt.com";
        await SeedExistingUserAsync(dbContext, takenEmail, "01022220002");
        var service = CreateService(dbContext, userManagerMock.Object);
        var request = new CreateDoctorRequest
        {
            FirstName = "Mona",
            LastName = "Adel",
            Email = takenEmail,
            PhoneNumber = "+2010" + Random.Shared.Next(10000000, 99999999).ToString(),
            Password = "ValidPass123!",
            NameAr = "د. منى عادل"
        };

        // Act
        var result = await service.CreateDoctorAsync(request, CancellationToken.None);

        // Assert.
        result.Succeeded.Should().BeFalse();
        result.Errors.Should().Contain(error => error.Code == AuthenticationErrorCodes.EmailAlreadyRegistered);
    }

    #endregion

    #region CreateReceptionistAsync

    /// <summary>
    /// Receptionist creation without an authenticated doctor must fail immediately.
    /// </summary>
    [Fact]
    public async Task CreateReceptionistAsync_NoAuthenticatedUser_ReturnsRegistrationFailed()
    {
        // Arrange a service whose current-user accessor reports anonymity.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        var currentUserMock = new Mock<ICurrentUserService>();
        currentUserMock.Setup(currentUser => currentUser.UserId).Returns((Guid?)null);
        var service = CreateService(dbContext, userManagerMock.Object, currentUser: currentUserMock.Object);

        // Act
        var result = await service.CreateReceptionistAsync(BuildValidStaffRequest(), CancellationToken.None);

        // Assert.
        result.Succeeded.Should().BeFalse();
        result.Errors.Should().Contain(error => error.Code == AuthenticationErrorCodes.RegistrationFailed);
    }

    /// <summary>
    /// Receptionist creation for an authenticated user lacking a Doctor record must be refused.
    /// </summary>
    [Fact]
    public async Task CreateReceptionistAsync_DoctorRecordMissing_ReturnsCurrentDoctorNotFound()
    {
        // Arrange an authenticated user without any associated Doctor entity.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        var orphanUserId = Guid.NewGuid();
        var currentUserMock = new Mock<ICurrentUserService>();
        currentUserMock.Setup(currentUser => currentUser.UserId).Returns(orphanUserId);
        var service = CreateService(dbContext, userManagerMock.Object, currentUser: currentUserMock.Object);

        // Act
        var result = await service.CreateReceptionistAsync(BuildValidStaffRequest(), CancellationToken.None);

        // Assert.
        result.Succeeded.Should().BeFalse();
        result.Errors.Should().Contain(error => error.Code == AuthenticationErrorCodes.CurrentDoctorNotFound);
    }

    /// <summary>
    /// A valid receptionist creation must link the Receptionist record to the owning doctor.
    /// </summary>
    [Fact]
    public async Task CreateReceptionistAsync_ValidRequest_LinksReceptionistToDoctor()
    {
        // Arrange an owning doctor plus a passing role check for receptionists.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);

        var ownerUserId = Guid.NewGuid();
        var ownerUser = new ApplicationUser
        {
            Id = ownerUserId,
            FirstName = "Owner",
            LastName = "Doctor",
            Email = "owner.doctor@example.com",
            NormalizedEmail = "OWNER.DOCTOR@EXAMPLE.COM",
            UserName = "owner.doctor@example.com",
            PhoneNumber = "01077778888",
            IsActive = true
        };
        var ownerDoctor = new Doctor { Id = Guid.NewGuid(), UserId = ownerUserId, User = ownerUser };
        dbContext.Users.Add(ownerUser);
        dbContext.Doctors.Add(ownerDoctor);
        await dbContext.SaveChangesAsync();

        var currentUserMock = new Mock<ICurrentUserService>();
        currentUserMock.Setup(currentUser => currentUser.UserId).Returns(ownerUserId);
        var service = CreateService(dbContext, userManagerMock.Object, currentUser: currentUserMock.Object);

        // Act
        var result = await service.CreateReceptionistAsync(BuildValidStaffRequest(), CancellationToken.None);

        // Assert the receptionist joined onto the correct doctor.
        result.Succeeded.Should().BeTrue();
        var receptionist = await dbContext.Receptionists.AsNoTracking().SingleAsync(r => r.UserId == result.UserId);
        receptionist.DoctorId.Should().Be(ownerDoctor.Id);
    }

    #endregion

    #region DeleteUserAsync / DeleteAllUsersAsync

    /// <summary>
    /// Deletion attempted by a non-administrator must be denied with Forbidden.
    /// </summary>
    [Fact]
    public async Task DeleteUserAsync_NonAdminCaller_ReturnsForbidden()
    {
        // Arrange a doctor-role caller context.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        var currentUserMock = new Mock<ICurrentUserService>();
        currentUserMock.Setup(currentUser => currentUser.Role).Returns(RoleConstants.Doctor);
        var service = CreateService(dbContext, userManagerMock.Object, currentUser: currentUserMock.Object);

        // Act
        var result = await service.DeleteUserAsync(Guid.NewGuid(), CancellationToken.None);

        // Assert.
        result.Succeeded.Should().BeFalse();
        result.Errors.Should().Contain(error => error.Code == AuthenticationErrorCodes.Forbidden);
    }

    /// <summary>
    /// Deleting an already-inactive user must yield UserNotFound instead of double deletion.
    /// </summary>
    [Fact]
    public async Task DeleteUserAsync_AlreadyDeleted_ReturnsUserNotFound()
    {
        // Arrange an admin caller plus a previously soft-deleted user row.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        var currentUserMock = new Mock<ICurrentUserService>();
        currentUserMock.Setup(currentUser => currentUser.Role).Returns(RoleConstants.Admin);
        currentUserMock.Setup(currentUser => currentUser.UserId).Returns(Guid.NewGuid());
        var service = CreateService(dbContext, userManagerMock.Object, currentUser: currentUserMock.Object);

        var deletedUserId = Guid.NewGuid();
        dbContext.Users.Add(new ApplicationUser
        {
            Id = deletedUserId,
            FirstName = "Already",
            LastName = "Deleted",
            Email = "already.deleted@example.com",
            UserName = "already.deleted@example.com",
            PhoneNumber = "01066660001",
            IsActive = false
        });
        await dbContext.SaveChangesAsync();

        // Act
        var result = await service.DeleteUserAsync(deletedUserId, CancellationToken.None);

        // Assert.
        result.Succeeded.Should().BeFalse();
        result.Errors.Should().Contain(error => error.Code == AuthenticationErrorCodes.UserNotFound);
    }

    /// <summary>
    /// A successful admin deletion must soft-delete the user with audit fields populated.
    /// </summary>
    [Fact]
    public async Task DeleteUserAsync_AdminDeletesActiveUser_SoftDeletesWithAuditTrail()
    {
        // Arrange an admin caller and an active target user.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        var adminId = Guid.NewGuid();
        var currentUserMock = new Mock<ICurrentUserService>();
        currentUserMock.Setup(currentUser => currentUser.Role).Returns(RoleConstants.Admin);
        currentUserMock.Setup(currentUser => currentUser.UserId).Returns(adminId);
        var service = CreateService(dbContext, userManagerMock.Object, currentUser: currentUserMock.Object);

        var targetUserId = Guid.NewGuid();
        dbContext.Users.Add(new ApplicationUser
        {
            Id = targetUserId,
            FirstName = "Target",
            LastName = "Victim",
            Email = "target.victim@example.com",
            UserName = "target.victim@example.com",
            PhoneNumber = "01066660002",
            IsActive = true
        });
        await dbContext.SaveChangesAsync();

        // Act
        var result = await service.DeleteUserAsync(targetUserId, CancellationToken.None);

        // Assert soft-delete semantics including the acting administrator reference.
        result.Succeeded.Should().BeTrue();
        var deletedUser = await dbContext.Users
            .IgnoreQueryFilters()
            .AsNoTracking()
            .SingleAsync(user => user.Id == targetUserId);
        deletedUser.IsActive.Should().BeFalse();
        deletedUser.DeletedById.Should().Be(adminId);
        deletedUser.DeletedAt.Should().NotBeNull();
    }

    /// <summary>
    /// Bulk deletion must never deactivate the performing administrator (self-lockout guard).
    /// </summary>
    [Fact]
    public async Task DeleteAllUsersAsync_AdminCaller_DeletesOthersButKeepsSelfActive()
    {
        // Arrange an admin caller alongside two other active users.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        var adminId = Guid.NewGuid();
        var currentUserMock = new Mock<ICurrentUserService>();
        currentUserMock.Setup(currentUser => currentUser.Role).Returns(RoleConstants.Admin);
        currentUserMock.Setup(currentUser => currentUser.UserId).Returns(adminId);
        var service = CreateService(dbContext, userManagerMock.Object, currentUser: currentUserMock.Object);

        var adminRowId = Guid.NewGuid();
        dbContext.Users.Add(new ApplicationUser
        {
            Id = adminId,
            FirstName = "Performing",
            LastName = "Admin",
            Email = "performing.admin@example.com",
            UserName = "performing.admin@example.com",
            PhoneNumber = "01066660003",
            IsActive = true
        });
        dbContext.Users.Add(new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Other",
            LastName = "User",
            Email = "other.user@example.com",
            UserName = "other.user@example.com",
            PhoneNumber = "01066660004",
            IsActive = true
        });
        await dbContext.SaveChangesAsync();

        // Act
        var result = await service.DeleteAllUsersAsync(CancellationToken.None);

        // Assert only foreign accounts were deactivated.
        result.Succeeded.Should().BeTrue();
        var remainingActive = await dbContext.Users.AsNoTracking()
            .Where(user => user.IsActive)
            .Select(user => user.Id)
            .ToListAsync();
        remainingActive.Should().BeEquivalentTo(new[] { adminId });
    }

    /// <summary>
    /// Bulk deletion attempted by a non-administrator must be denied outright.
    /// </summary>
    [Fact]
    public async Task DeleteAllUsersAsync_ReceptionistCaller_ReturnsForbidden()
    {
        // Arrange a receptionist-role caller context.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        var currentUserMock = new Mock<ICurrentUserService>();
        currentUserMock.Setup(currentUser => currentUser.Role).Returns(RoleConstants.Receptionist);
        var service = CreateService(dbContext, userManagerMock.Object, currentUser: currentUserMock.Object);

        // Act
        var result = await service.DeleteAllUsersAsync(CancellationToken.None);

        // Assert.
        result.Succeeded.Should().BeFalse();
        result.Errors.Should().Contain(error => error.Code == AuthenticationErrorCodes.Forbidden);
    }

    #endregion

    #region GetUserByIdAsync (Authorization Scope)

    /// <summary>
    /// A patient caller requesting another patient's record must receive null.
    /// </summary>
    [Fact]
    public async Task GetUserByIdAsync_PatientRequestsForeignUser_ReturnsNull()
    {
        // Arrange a patient-role caller and a foreign active user.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        var patientUserId = Guid.NewGuid();
        var currentUserMock = new Mock<ICurrentUserService>();
        currentUserMock.Setup(currentUser => currentUser.UserId).Returns(patientUserId);
        currentUserMock.Setup(currentUser => currentUser.Role).Returns(RoleConstants.Patient);
        var service = CreateService(dbContext, userManagerMock.Object, currentUser: currentUserMock.Object);

        var foreignUserId = Guid.NewGuid();
        dbContext.Users.Add(new ApplicationUser
        {
            Id = foreignUserId,
            FirstName = "Foreign",
            LastName = "Patient",
            Email = "foreign.patient@example.com",
            UserName = "foreign.patient@example.com",
            PhoneNumber = "01066660005",
            IsActive = true
        });
        await dbContext.SaveChangesAsync();

        // Act
        var response = await service.GetUserByIdAsync(foreignUserId, CancellationToken.None);

        // Assert the IDOR attempt yields no data.
        response.Should().BeNull();
    }

    /// <summary>
    /// A patient caller may always read their own record regardless of scope filters.
    /// </summary>
    [Fact]
    public async Task GetUserByIdAsync_PatientRequestsSelf_ReturnsOwnProfile()
    {
        // Arrange a patient-role caller owning an existing record.
        using var dbContext = TestDbContextFactory.Create();
        var userManagerMock = CreateUserManagerMock(dbContext);
        userManagerMock
            .Setup(manager => manager.GetRolesAsync(It.IsAny<ApplicationUser>()))
            .ReturnsAsync(new List<string> { RoleConstants.Patient });
        var patientUserId = Guid.NewGuid();
        var currentUserMock = new Mock<ICurrentUserService>();
        currentUserMock.Setup(currentUser => currentUser.UserId).Returns(patientUserId);
        currentUserMock.Setup(currentUser => currentUser.Role).Returns(RoleConstants.Patient);
        var service = CreateService(dbContext, userManagerMock.Object, currentUser: currentUserMock.Object);

        dbContext.Users.Add(new ApplicationUser
        {
            Id = patientUserId,
            FirstName = "Self",
            LastName = "Patient",
            Email = "self.patient@example.com",
            UserName = "self.patient@example.com",
            PhoneNumber = "01066660006",
            IsActive = true
        });
        await dbContext.SaveChangesAsync();

        // Act
        var response = await service.GetUserByIdAsync(patientUserId, CancellationToken.None);

        // Assert the own profile resolves with mapped roles attached.
        response.Should().NotBeNull();
        response!.Roles.Should().Contain(RoleConstants.Patient);
    }

    #endregion
}

/// <summary>
/// Shared factory producing isolated in-memory application database contexts.
/// </summary>
public static class TestDbContextFactory
{
    /// <summary>
    /// Creates a fresh <see cref="ApplicationDbContext"/> backed by a unique in-memory store.
    /// </summary>
    /// <returns>A ready-to-use context instance.</returns>
    public static ApplicationDbContext Create()
    {
        // Build options bound to a random database name for isolation.
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .ConfigureWarnings(warnings => warnings.Ignore(InMemoryEventId.TransactionIgnoredWarning))
            .Options;

        // Supply mocked cross-cutting services expected by the context.
        var currentUserServiceMock = new Mock<ICurrentUserService>();
        var dateTimeProviderMock = new Mock<IDateTimeProvider>();
        dateTimeProviderMock.Setup(provider => provider.UtcNow).Returns(DateTime.UtcNow);

        return new ApplicationDbContext(options, currentUserServiceMock.Object, dateTimeProviderMock.Object);
    }
}





