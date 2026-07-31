using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Application.Features.Authentication.Otp;
using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Application.Features.Authentication.Registration.Contracts;
using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Authentication;
using Appoynt.Infrastructure.Persistence;
using FluentAssertions;
using Microsoft.Data.Sqlite;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace Appoynt.Tests.UnitTests.Infrastructure;

/// <summary>
/// Tests RegistrationService user creation, patient profile generation, transaction behavior, and OTP issuance.
/// </summary>
public sealed class RegistrationServiceTests : IDisposable
{
    private readonly SqliteConnection _connection;
    private readonly ApplicationDbContext _dbContext;
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly RoleManager<IdentityRole<Guid>> _roleManager;

    public RegistrationServiceTests()
    {
        _connection = new SqliteConnection("DataSource=:memory:");
        _connection.Open();

        DbContextOptions<ApplicationDbContext> options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseSqlite(_connection)
            .Options;

        var currentUserServiceMock = new Mock<ICurrentUserService>();
        var dateTimeProviderMock = new Mock<IDateTimeProvider>();
        dateTimeProviderMock.Setup(d => d.UtcNow).Returns(DateTime.UtcNow);

        _dbContext = new ApplicationDbContext(options, currentUserServiceMock.Object, dateTimeProviderMock.Object);
        _dbContext.Database.EnsureCreated();

        var userStore = new UserStore<ApplicationUser, IdentityRole<Guid>, ApplicationDbContext, Guid>(_dbContext);
        var passwordHasher = new PasswordHasher<ApplicationUser>();
        _userManager = new UserManager<ApplicationUser>(
            userStore, null!, passwordHasher, null!, null!, new UpperInvariantLookupNormalizer(), new IdentityErrorDescriber(), null!, null!);

        var roleStore = new RoleStore<IdentityRole<Guid>, ApplicationDbContext, Guid>(_dbContext);
        _roleManager = new RoleManager<IdentityRole<Guid>>(
            roleStore, null!, new UpperInvariantLookupNormalizer(), new IdentityErrorDescriber(), null!);
    }

    public void Dispose()
    {
        _dbContext.Dispose();
        _connection.Dispose();
    }

    [Fact]
    public async Task RegisterAsync_ShouldReturnValidationErrors_WhenRequestIsInvalid()
    {
        var otpServiceMock = new Mock<IOtpService>();
        var service = new RegistrationService(_userManager, _roleManager, _dbContext, otpServiceMock.Object);

        RegistrationResult result = await service.RegisterAsync(new RegisterRequest
        {
            FirstName = "Mustafa",
            LastName = "Mahmoud",
            Email = "invalid-email",
            PhoneNumber = "01012345678",
            Password = "P@ssword123",
            ConfirmPassword = "P@ssword123"
        });

        result.Succeeded.Should().BeFalse();
        result.Errors.Should().ContainSingle(e => e.Code == AuthenticationErrorCodes.EmailInvalid);
    }

    [Fact]
    public async Task RegisterAsync_ShouldReturnEmailAlreadyRegistered_WhenEmailExists()
    {
        var otpServiceMock = new Mock<IOtpService>();
        var service = new RegistrationService(_userManager, _roleManager, _dbContext, otpServiceMock.Object);

        var existingUser = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "John",
            LastName = "Doe",
            Email = "existing@example.com",
            UserName = "existing@example.com",
            NormalizedEmail = "EXISTING@EXAMPLE.COM",
            PhoneNumber = "01099999999"
        };
        await _userManager.CreateAsync(existingUser, "P@ssword123");

        RegistrationResult result = await service.RegisterAsync(new RegisterRequest
        {
            FirstName = "Mustafa",
            LastName = "Mahmoud",
            Email = "existing@example.com",
            PhoneNumber = "01012345678",
            Password = "P@ssword123",
            ConfirmPassword = "P@ssword123"
        });

        result.Succeeded.Should().BeFalse();
        result.Errors.Should().ContainSingle(e => e.Code == AuthenticationErrorCodes.EmailAlreadyRegistered);
    }

    [Fact]
    public async Task RegisterAsync_ShouldReturnPhoneAlreadyRegistered_WhenPhoneExists()
    {
        var otpServiceMock = new Mock<IOtpService>();
        var service = new RegistrationService(_userManager, _roleManager, _dbContext, otpServiceMock.Object);

        var existingUser = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "John",
            LastName = "Doe",
            Email = "user1@example.com",
            UserName = "user1@example.com",
            NormalizedEmail = "USER1@EXAMPLE.COM",
            PhoneNumber = "01012345678"
        };
        await _userManager.CreateAsync(existingUser, "P@ssword123");

        RegistrationResult result = await service.RegisterAsync(new RegisterRequest
        {
            FirstName = "Mustafa",
            LastName = "Mahmoud",
            Email = "user2@example.com",
            PhoneNumber = "01012345678",
            Password = "P@ssword123",
            ConfirmPassword = "P@ssword123"
        });

        result.Succeeded.Should().BeFalse();
        result.Errors.Should().ContainSingle(e => e.Code == AuthenticationErrorCodes.PhoneAlreadyRegistered);
    }

    [Fact]
    public async Task RegisterAsync_ShouldReturnRegistrationFailed_WhenPatientRoleDoesNotExist()
    {
        var otpServiceMock = new Mock<IOtpService>();
        var service = new RegistrationService(_userManager, _roleManager, _dbContext, otpServiceMock.Object);

        RegistrationResult result = await service.RegisterAsync(new RegisterRequest
        {
            FirstName = "Mustafa",
            LastName = "Mahmoud",
            Email = "newpatient@example.com",
            PhoneNumber = "01012345678",
            Password = "P@ssword123",
            ConfirmPassword = "P@ssword123"
        });

        result.Succeeded.Should().BeFalse();
        result.Errors.Should().ContainSingle(e => e.Code == AuthenticationErrorCodes.RegistrationFailed);
    }

    [Fact]
    public async Task RegisterAsync_ShouldSucceedAndIssueOtp_WhenRequestIsValidAndRoleExists()
    {
        await _roleManager.CreateAsync(new IdentityRole<Guid>(RoleConstants.Patient));

        var expectedChallengeId = Guid.NewGuid();
        var otpServiceMock = new Mock<IOtpService>();
        otpServiceMock
            .Setup(o => o.IssueAsync(It.IsAny<ApplicationUser>(), OtpPurpose.PhoneConfirmation, It.IsAny<CancellationToken>()))
            .ReturnsAsync(new OtpResult
            {
                Succeeded = true,
                Challenge = new OtpChallengeResponse { ChallengeId = expectedChallengeId }
            });

        var service = new RegistrationService(_userManager, _roleManager, _dbContext, otpServiceMock.Object);

        RegistrationResult result = await service.RegisterAsync(new RegisterRequest
        {
            FirstName = "Mustafa",
            LastName = "Mahmoud",
            Email = "newpatient@example.com",
            PhoneNumber = "01012345678",
            Password = "P@ssword123",
            ConfirmPassword = "P@ssword123"
        });

        result.Succeeded.Should().BeTrue();
        result.Response.Should().NotBeNull();
        result.Response!.ChallengeId.Should().Be(expectedChallengeId);
        result.Response.UserId.Should().NotBeEmpty();

        ApplicationUser? createdUser = await _userManager.FindByEmailAsync("newpatient@example.com");
        createdUser.Should().NotBeNull();
        createdUser!.PhoneNumberConfirmed.Should().BeFalse();

        Patient? patientProfile = await _dbContext.Patients.FirstOrDefaultAsync(p => p.UserId == createdUser.Id);
        patientProfile.Should().NotBeNull();
    }
}
