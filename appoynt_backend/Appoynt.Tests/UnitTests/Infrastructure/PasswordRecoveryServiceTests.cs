using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Authentication.Otp;
using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Application.Features.Authentication.PasswordRecovery.Contracts;
using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Authentication;
using FluentAssertions;
using Microsoft.AspNetCore.Identity;
using Moq;

namespace Appoynt.Tests.UnitTests.Infrastructure;

public sealed class PasswordRecoveryServiceTests
{
    private static Mock<UserManager<ApplicationUser>> CreateUserManagerMock()
    {
        var store = new Mock<IUserStore<ApplicationUser>>();
        return new Mock<UserManager<ApplicationUser>>(store.Object, null!, null!, null!, null!, null!, null!, null!, null!);
    }

    [Fact]
    public async Task ForgotPasswordAsync_ShouldReturnError_WhenIdentifierIsInvalid()
    {
        var userManagerMock = CreateUserManagerMock();
        var otpServiceMock = new Mock<IOtpService>();
        var service = new PasswordRecoveryService(userManagerMock.Object, otpServiceMock.Object);

        var result = await service.ForgotPasswordAsync(new ForgotPasswordRequest { Identifier = " " });

        result.Errors.Should().ContainSingle(e => e.Code == AuthenticationErrorCodes.PasswordRecoveryRequestInvalid);
    }

    [Fact]
    public async Task ForgotPasswordAsync_ShouldReturnError_WhenUserNotFound()
    {
        var userManagerMock = CreateUserManagerMock();
        userManagerMock.Setup(um => um.FindByEmailAsync(It.IsAny<string>()))
                       .ReturnsAsync((ApplicationUser?)null);

        var otpServiceMock = new Mock<IOtpService>();
        var service = new PasswordRecoveryService(userManagerMock.Object, otpServiceMock.Object);

        var result = await service.ForgotPasswordAsync(new ForgotPasswordRequest { Identifier = "nonexistent@example.com" });

        result.Errors.Should().ContainSingle(e => e.Code == AuthenticationErrorCodes.PasswordRecoveryRequestInvalid);
    }

    [Fact]
    public async Task ForgotPasswordAsync_ShouldIssueOtp_WhenUserFoundAndActive()
    {
        var user = new ApplicationUser { Id = Guid.NewGuid(), FirstName = "Test", LastName = "User", Email = "test@example.com", IsActive = true };
        var userManagerMock = CreateUserManagerMock();
        userManagerMock.Setup(um => um.FindByEmailAsync("test@example.com"))
                       .ReturnsAsync(user);

        var otpServiceMock = new Mock<IOtpService>();
        otpServiceMock.Setup(o => o.IssueAsync(user, OtpPurpose.PasswordReset, It.IsAny<CancellationToken>()))
                      .ReturnsAsync(new OtpResult { Succeeded = true });

        var service = new PasswordRecoveryService(userManagerMock.Object, otpServiceMock.Object);

        var result = await service.ForgotPasswordAsync(new ForgotPasswordRequest { Identifier = "test@example.com" });

        result.Succeeded.Should().BeTrue();
    }

    [Fact]
    public async Task ResetPasswordAsync_ShouldReturnError_WhenUserNotFound()
    {
        var userManagerMock = CreateUserManagerMock();
        userManagerMock.Setup(um => um.FindByEmailAsync(It.IsAny<string>()))
                       .ReturnsAsync((ApplicationUser?)null);

        var otpServiceMock = new Mock<IOtpService>();
        var service = new PasswordRecoveryService(userManagerMock.Object, otpServiceMock.Object);

        var (succeeded, errors) = await service.ResetPasswordAsync(new ResetPasswordRequest 
        { 
            Identifier = "test@example.com",
            ResetToken = "token",
            NewPassword = "Password123!",
            ConfirmPassword = "Password123!"
        });

        succeeded.Should().BeFalse();
        errors.Should().ContainSingle(e => e.Code == AuthenticationErrorCodes.PasswordRecoveryRequestInvalid);
    }

    [Fact]
    public async Task ResetPasswordAsync_ShouldReturnSuccess_WhenValid()
    {
        var user = new ApplicationUser { Id = Guid.NewGuid(), FirstName = "Test", LastName = "User", Email = "test@example.com", IsActive = true };
        var userManagerMock = CreateUserManagerMock();
        userManagerMock.Setup(um => um.FindByEmailAsync("test@example.com"))
                       .ReturnsAsync(user);
        userManagerMock.Setup(um => um.ResetPasswordAsync(user, "token", "Password123!"))
                       .ReturnsAsync(IdentityResult.Success);

        var otpServiceMock = new Mock<IOtpService>();
        var service = new PasswordRecoveryService(userManagerMock.Object, otpServiceMock.Object);

        var (succeeded, errors) = await service.ResetPasswordAsync(new ResetPasswordRequest 
        { 
            Identifier = "test@example.com",
            ResetToken = "token",
            NewPassword = "Password123!",
            ConfirmPassword = "Password123!"
        });

        succeeded.Should().BeTrue();
        errors.Should().BeEmpty();
    }
}
