using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Application.Features.Authentication.Login.Contracts;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Authentication;
using Appoynt.Infrastructure.Persistence;
using FluentAssertions;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Moq;

namespace Appoynt.Tests.UnitTests.Infrastructure;

/// <summary>
/// Tests LoginService authentication rules, unconfirmed phone guards, inactive user guards, and JWT issuance.
/// </summary>
public sealed class LoginServiceTests
{
    private static (ApplicationDbContext dbContext, UserManager<ApplicationUser> userManager) CreateIdentityDependencies()
    {
        DbContextOptions<ApplicationDbContext> options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        var currentUserServiceMock = new Mock<ICurrentUserService>();
        var dateTimeProviderMock = new Mock<IDateTimeProvider>();
        dateTimeProviderMock.Setup(d => d.UtcNow).Returns(DateTime.UtcNow);

        var dbContext = new ApplicationDbContext(options, currentUserServiceMock.Object, dateTimeProviderMock.Object);

        var userStore = new UserStore<ApplicationUser, IdentityRole<Guid>, ApplicationDbContext, Guid>(dbContext);
        var passwordHasher = new PasswordHasher<ApplicationUser>();
        var userManager = new UserManager<ApplicationUser>(
            userStore,
            null!,
            passwordHasher,
            null!,
            null!,
            new UpperInvariantLookupNormalizer(),
            new IdentityErrorDescriber(),
            null!,
            new Mock<ILogger<UserManager<ApplicationUser>>>().Object);

        return (dbContext, userManager);
    }

    [Fact]
    public async Task LoginAsync_ShouldReturnInvalidCredentials_WhenRequestIsInvalid()
    {
        var (_, userManager) = CreateIdentityDependencies();
        var tokenServiceMock = new Mock<ITokenService>();
        var service = new LoginService(userManager, tokenServiceMock.Object);

        LoginResult result = await service.LoginAsync(new LoginRequest
        {
            Identifier = "user@example.com",
            Password = ""
        });

        result.Succeeded.Should().BeFalse();
        result.Errors.Should().ContainSingle(e => e.Code == AuthenticationErrorCodes.InvalidCredentials);
    }

    [Fact]
    public async Task LoginAsync_ShouldReturnInvalidCredentials_WhenUserDoesNotExist()
    {
        var (_, userManager) = CreateIdentityDependencies();
        var tokenServiceMock = new Mock<ITokenService>();
        var service = new LoginService(userManager, tokenServiceMock.Object);

        LoginResult result = await service.LoginAsync(new LoginRequest
        {
            Identifier = "nonexistent@example.com",
            Password = "P@ssword123"
        });

        result.Succeeded.Should().BeFalse();
        result.Errors.Should().ContainSingle(e => e.Code == AuthenticationErrorCodes.InvalidCredentials);
    }

    [Fact]
    public async Task LoginAsync_ShouldReturnInvalidCredentials_WhenPhoneIsNotConfirmed()
    {
        var (dbContext, userManager) = CreateIdentityDependencies();
        var tokenServiceMock = new Mock<ITokenService>();
        var service = new LoginService(userManager, tokenServiceMock.Object);

        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Jane",
            LastName = "Doe",
            Email = "unconfirmed@example.com",
            UserName = "unconfirmed@example.com",
            NormalizedEmail = "UNCONFIRMED@EXAMPLE.COM",
            PhoneNumber = "01012345678",
            PhoneNumberConfirmed = false,
            IsActive = true
        };
        await userManager.CreateAsync(user, "P@ssword123");

        LoginResult result = await service.LoginAsync(new LoginRequest
        {
            Identifier = "unconfirmed@example.com",
            Password = "P@ssword123"
        });

        result.Succeeded.Should().BeFalse();
        result.Errors.Should().ContainSingle(e => e.Code == AuthenticationErrorCodes.InvalidCredentials);

        ApplicationUser? updatedUser = await userManager.FindByEmailAsync("unconfirmed@example.com");
        updatedUser!.AccessFailedCount.Should().Be(0);
    }

    [Fact]
    public async Task LoginAsync_ShouldReturnInvalidCredentials_WhenUserIsInactive()
    {
        var (dbContext, userManager) = CreateIdentityDependencies();
        var tokenServiceMock = new Mock<ITokenService>();
        var service = new LoginService(userManager, tokenServiceMock.Object);

        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Jane",
            LastName = "Doe",
            Email = "inactive@example.com",
            UserName = "inactive@example.com",
            NormalizedEmail = "INACTIVE@EXAMPLE.COM",
            PhoneNumber = "01012345678",
            PhoneNumberConfirmed = true,
            IsActive = false
        };
        await userManager.CreateAsync(user, "P@ssword123");

        LoginResult result = await service.LoginAsync(new LoginRequest
        {
            Identifier = "inactive@example.com",
            Password = "WrongPassword123!"
        });

        result.Succeeded.Should().BeFalse();
        result.Errors.Should().ContainSingle(e => e.Code == AuthenticationErrorCodes.InvalidCredentials);

        ApplicationUser? updatedUser = await userManager.FindByEmailAsync("inactive@example.com");
        updatedUser!.AccessFailedCount.Should().Be(0);
    }

    [Fact]
    public async Task LoginAsync_ShouldReturnAccessToken_WhenEmailCredentialsAreValid()
    {
        var (dbContext, userManager) = CreateIdentityDependencies();
        var tokenServiceMock = new Mock<ITokenService>();
        tokenServiceMock
            .Setup(t => t.GenerateAccessTokenAsync(It.IsAny<ApplicationUser>()))
            .ReturnsAsync("mocked-jwt-token");

        var service = new LoginService(userManager, tokenServiceMock.Object);

        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Jane",
            LastName = "Doe",
            Email = "confirmed@example.com",
            UserName = "confirmed@example.com",
            NormalizedEmail = "CONFIRMED@EXAMPLE.COM",
            PhoneNumber = "01012345678",
            PhoneNumberConfirmed = true,
            IsActive = true
        };
        await userManager.CreateAsync(user, "P@ssword123");

        LoginResult result = await service.LoginAsync(new LoginRequest
        {
            Identifier = "confirmed@example.com",
            Password = "P@ssword123"
        });

        result.Succeeded.Should().BeTrue();
        result.Response.Should().NotBeNull();
        result.Response!.AccessToken.Should().Be("mocked-jwt-token");
    }

    [Fact]
    public async Task LoginAsync_ShouldReturnAccessToken_WhenPhoneCredentialsAreValid()
    {
        var (dbContext, userManager) = CreateIdentityDependencies();
        var tokenServiceMock = new Mock<ITokenService>();
        tokenServiceMock
            .Setup(t => t.GenerateAccessTokenAsync(It.IsAny<ApplicationUser>()))
            .ReturnsAsync("mocked-jwt-token-by-phone");

        var service = new LoginService(userManager, tokenServiceMock.Object);

        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Jane",
            LastName = "Doe",
            Email = "confirmedphone@example.com",
            UserName = "confirmedphone@example.com",
            NormalizedEmail = "CONFIRMEDPHONE@EXAMPLE.COM",
            PhoneNumber = "01012345678",
            PhoneNumberConfirmed = true,
            IsActive = true
        };
        await userManager.CreateAsync(user, "P@ssword123");

        LoginResult result = await service.LoginAsync(new LoginRequest
        {
            Identifier = "+201012345678",
            Password = "P@ssword123"
        });

        result.Succeeded.Should().BeTrue();
        result.Response.Should().NotBeNull();
        result.Response!.AccessToken.Should().Be("mocked-jwt-token-by-phone");
    }

    [Fact]
    public async Task LoginAsync_ShouldIncrementFailedAccessCount_WhenPasswordIsWrong()
    {
        var (dbContext, userManager) = CreateIdentityDependencies();
        var tokenServiceMock = new Mock<ITokenService>();
        var service = new LoginService(userManager, tokenServiceMock.Object);

        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Jane",
            LastName = "Doe",
            Email = "wrongpass@example.com",
            UserName = "wrongpass@example.com",
            NormalizedEmail = "WRONGPASS@EXAMPLE.COM",
            PhoneNumber = "01012345678",
            PhoneNumberConfirmed = true,
            LockoutEnabled = true,
            IsActive = true
        };
        await userManager.CreateAsync(user, "P@ssword123");

        LoginResult result = await service.LoginAsync(new LoginRequest
        {
            Identifier = "wrongpass@example.com",
            Password = "WrongPassword123!"
        });

        result.Succeeded.Should().BeFalse();
        result.Errors.Should().ContainSingle(e => e.Code == AuthenticationErrorCodes.InvalidCredentials);

        ApplicationUser? updatedUser = await userManager.FindByEmailAsync("wrongpass@example.com");
        updatedUser!.AccessFailedCount.Should().Be(1);
    }

    [Fact]
    public async Task LoginAsync_ShouldReturnInvalidCredentials_WhenUserIsLockedOut()
    {
        var (dbContext, userManager) = CreateIdentityDependencies();
        var tokenServiceMock = new Mock<ITokenService>();
        var service = new LoginService(userManager, tokenServiceMock.Object);

        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Jane",
            LastName = "Doe",
            Email = "lockedout@example.com",
            UserName = "lockedout@example.com",
            NormalizedEmail = "LOCKEDOUT@EXAMPLE.COM",
            PhoneNumber = "01012345678",
            PhoneNumberConfirmed = true,
            LockoutEnabled = true,
            LockoutEnd = DateTimeOffset.UtcNow.AddMinutes(15),
            IsActive = true
        };
        await userManager.CreateAsync(user, "P@ssword123");

        LoginResult result = await service.LoginAsync(new LoginRequest
        {
            Identifier = "lockedout@example.com",
            Password = "P@ssword123"
        });

        result.Succeeded.Should().BeFalse();
        result.Errors.Should().ContainSingle(e => e.Code == AuthenticationErrorCodes.InvalidCredentials);
    }
}
