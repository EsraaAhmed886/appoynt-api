using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Authentication;
using Appoynt.Infrastructure.Persistence;
using FluentAssertions;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace Appoynt.Tests.UnitTests.Infrastructure;

/// <summary>
/// Tests OTP service issuance, verification, attempt limits, expiration, and resend rules.
/// </summary>
public sealed class OtpServiceTests
{
    private static ApplicationDbContext CreateDbContext()
    {
        DbContextOptions<ApplicationDbContext> options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        var currentUserServiceMock = new Mock<ICurrentUserService>();
        var dateTimeProviderMock = new Mock<IDateTimeProvider>();
        dateTimeProviderMock.Setup(d => d.UtcNow).Returns(DateTime.UtcNow);

        return new ApplicationDbContext(options, currentUserServiceMock.Object, dateTimeProviderMock.Object);
    }

    private static Mock<UserManager<ApplicationUser>> CreateUserManagerMock()
    {
        var store = new Mock<IUserStore<ApplicationUser>>();
        return new Mock<UserManager<ApplicationUser>>(store.Object, null!, null!, null!, null!, null!, null!, null!, null!);
    }

    [Fact]
    public async Task IssueAsync_ShouldCreateChallengeAndSendSms_WhenValidUser()
    {
        using ApplicationDbContext dbContext = CreateDbContext();
        var smsSenderMock = new Mock<ISmsSender>();
        smsSenderMock
            .Setup(s => s.SendOtpAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        var userManagerMock = CreateUserManagerMock();
        var service = new OtpService(dbContext, smsSenderMock.Object, userManagerMock.Object);

        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Test",
            LastName = "User",
            Email = "testuser@example.com",
            PhoneNumber = "01012345678",
            UserName = "testuser@example.com"
        };
        dbContext.Users.Add(user);
        await dbContext.SaveChangesAsync();

        OtpResult result = await service.IssueAsync(user, OtpPurpose.PhoneConfirmation);

        result.Succeeded.Should().BeTrue();
        result.Challenge.Should().NotBeNull();
        result.Challenge!.ChallengeId.Should().NotBeEmpty();

        OtpChallenge? challenge = await dbContext.OtpChallenges.FindAsync(result.Challenge.ChallengeId);
        challenge.Should().NotBeNull();
        challenge!.UserId.Should().Be(user.Id);
        challenge.Purpose.Should().Be(OtpPurpose.PhoneConfirmation);
    }

    [Fact]
    public async Task VerifyAsync_ShouldReturnOtpInvalid_WhenCodeIsWrong()
    {
        using ApplicationDbContext dbContext = CreateDbContext();
        var smsSenderMock = new Mock<ISmsSender>();
        smsSenderMock
            .Setup(s => s.SendOtpAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        var userManagerMock = CreateUserManagerMock();
        var service = new OtpService(dbContext, smsSenderMock.Object, userManagerMock.Object);

        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Test",
            LastName = "User",
            Email = "testuser@example.com",
            PhoneNumber = "01012345678",
            PhoneNumberConfirmed = false
        };
        dbContext.Users.Add(user);
        await dbContext.SaveChangesAsync();

        OtpResult issueResult = await service.IssueAsync(user, OtpPurpose.PhoneConfirmation);

        OtpResult verifyResult = await service.VerifyAsync(new VerifyOtpRequest
        {
            ChallengeId = issueResult.Challenge!.ChallengeId,
            Code = "000000"
        });

        verifyResult.Succeeded.Should().BeFalse();
        verifyResult.Errors.Should().ContainSingle(e => e.Code == AuthenticationErrorCodes.OtpInvalid);

        OtpChallenge? challenge = await dbContext.OtpChallenges.FindAsync(issueResult.Challenge.ChallengeId);
        challenge!.VerificationAttempts.Should().Be(1);
    }

    [Fact]
    public async Task VerifyAsync_ShouldReturnOtpExpired_WhenExpired()
    {
        using ApplicationDbContext dbContext = CreateDbContext();
        var smsSenderMock = new Mock<ISmsSender>();
        var userManagerMock = CreateUserManagerMock();
        var service = new OtpService(dbContext, smsSenderMock.Object, userManagerMock.Object);

        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Test",
            LastName = "User",
            Email = "testuser@example.com",
            PhoneNumber = "01012345678"
        };
        dbContext.Users.Add(user);

        var expiredChallenge = new OtpChallenge
        {
            Id = Guid.NewGuid(),
            UserId = user.Id,
            User = user,
            Purpose = OtpPurpose.PhoneConfirmation,
            CodeHash = "dummyhash",
            ExpiresAt = DateTime.UtcNow.AddSeconds(-10),
            SentAt = DateTime.UtcNow.AddSeconds(-60)
        };
        dbContext.OtpChallenges.Add(expiredChallenge);
        await dbContext.SaveChangesAsync();

        OtpResult verifyResult = await service.VerifyAsync(new VerifyOtpRequest
        {
            ChallengeId = expiredChallenge.Id,
            Code = "123456"
        });

        verifyResult.Succeeded.Should().BeFalse();
        verifyResult.Errors.Should().ContainSingle(e => e.Code == AuthenticationErrorCodes.OtpExpired);
    }

    [Fact]
    public async Task ResendAsync_ShouldReturnOtpResendNotAvailable_WhenChallengeNotExpired()
    {
        using ApplicationDbContext dbContext = CreateDbContext();
        var smsSenderMock = new Mock<ISmsSender>();
        var userManagerMock = CreateUserManagerMock();
        var service = new OtpService(dbContext, smsSenderMock.Object, userManagerMock.Object);

        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Test",
            LastName = "User",
            Email = "testuser@example.com",
            PhoneNumber = "01012345678"
        };
        dbContext.Users.Add(user);

        var activeChallenge = new OtpChallenge
        {
            Id = Guid.NewGuid(),
            UserId = user.Id,
            User = user,
            Purpose = OtpPurpose.PhoneConfirmation,
            CodeHash = "dummyhash",
            ExpiresAt = DateTime.UtcNow.AddSeconds(30),
            SentAt = DateTime.UtcNow
        };
        dbContext.OtpChallenges.Add(activeChallenge);
        await dbContext.SaveChangesAsync();

        OtpResult resendResult = await service.ResendAsync(new ResendOtpRequest
        {
            ChallengeId = activeChallenge.Id
        });

        resendResult.Succeeded.Should().BeFalse();
        resendResult.Errors.Should().ContainSingle(e => e.Code == AuthenticationErrorCodes.OtpResendNotAvailable);
    }

    [Fact]
    public async Task ResendAsync_ShouldReturnOtpResendLimitReached_WhenMaxResendsExceeded()
    {
        using ApplicationDbContext dbContext = CreateDbContext();
        var smsSenderMock = new Mock<ISmsSender>();
        var userManagerMock = CreateUserManagerMock();
        var service = new OtpService(dbContext, smsSenderMock.Object, userManagerMock.Object);

        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Test",
            LastName = "User",
            Email = "testuser@example.com",
            PhoneNumber = "01012345678"
        };
        dbContext.Users.Add(user);

        var maxResentChallenge = new OtpChallenge
        {
            Id = Guid.NewGuid(),
            UserId = user.Id,
            User = user,
            Purpose = OtpPurpose.PhoneConfirmation,
            CodeHash = "dummyhash",
            ExpiresAt = DateTime.UtcNow.AddSeconds(-10),
            SentAt = DateTime.UtcNow.AddSeconds(-60),
            ResendCount = UserConstants.MaxOtpResends
        };
        dbContext.OtpChallenges.Add(maxResentChallenge);
        await dbContext.SaveChangesAsync();

        OtpResult resendResult = await service.ResendAsync(new ResendOtpRequest
        {
            ChallengeId = maxResentChallenge.Id
        });

        resendResult.Succeeded.Should().BeFalse();
        resendResult.Errors.Should().ContainSingle(e => e.Code == AuthenticationErrorCodes.OtpResendLimitReached);
    }
}
