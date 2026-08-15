using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Authentication;
using Appoynt.Infrastructure.Options;
using FluentAssertions;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using Moq;

namespace Appoynt.Tests.UnitTests.Infrastructure;

/// <summary>
/// Tests JWT token issuance, claims generation, and lifetime.
/// </summary>
public sealed class JwtTokenServiceTests
{
    private static Mock<UserManager<ApplicationUser>> CreateMockUserManager()
    {
        var store = new Mock<IUserStore<ApplicationUser>>();
        return new Mock<UserManager<ApplicationUser>>(
            store.Object, null!, null!, null!, null!, null!, null!, null!, null!);
    }

    [Fact]
    public async Task GenerateAccessTokenAsync_ShouldReturnValidJwtToken_WithExpectedClaims()
    {
        Mock<UserManager<ApplicationUser>> userManagerMock = CreateMockUserManager();

        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            Email = "doctor@example.com",
            UserName = "doctor@example.com",
            FirstName = "Jane",
            LastName = "Smith"
        };

        userManagerMock
            .Setup(m => m.GetClaimsAsync(user))
            .ReturnsAsync(new List<Claim>());

        userManagerMock
            .Setup(m => m.GetRolesAsync(user))
            .ReturnsAsync(new List<string> { "Doctor" });

        var jwtOptions = Options.Create(new JwtOptions
        {
            Issuer = "AppoyntAPI",
            Audience = "AppoyntClients",
            SecretKey = "SuperSecretKeyWithMinimum32CharactersLength!",
            AccessTokenExpirationMinutes = 60
        });

        var tokenService = new JwtTokenService(userManagerMock.Object, jwtOptions);

        string tokenString = await tokenService.GenerateAccessTokenAsync(user);

        tokenString.Should().NotBeNullOrWhiteSpace();

        var handler = new JwtSecurityTokenHandler();
        JwtSecurityToken parsedToken = handler.ReadJwtToken(tokenString);

        parsedToken.Issuer.Should().Be("AppoyntAPI");
        parsedToken.Audiences.Should().Contain("AppoyntClients");

        parsedToken.Claims.Should().Contain(c => c.Type == JwtRegisteredClaimNames.Sub && c.Value == user.Id.ToString());
        parsedToken.Claims.Should().Contain(c => c.Type == JwtRegisteredClaimNames.Email && c.Value == "doctor@example.com");
        parsedToken.Claims.Should().Contain(c => c.Type == ClaimTypes.Role && c.Value == "Doctor");
    }

    [Fact]
    public async Task GenerateAccessTokenAsync_ShouldThrowInvalidOperationException_WhenUserHasNoEmail()
    {
        Mock<UserManager<ApplicationUser>> userManagerMock = CreateMockUserManager();
        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Jane",
            LastName = "Smith",
            Email = null
        };

        var jwtOptions = Options.Create(new JwtOptions
        {
            Issuer = "AppoyntAPI",
            Audience = "AppoyntClients",
            SecretKey = "SuperSecretKeyWithMinimum32CharactersLength!",
            AccessTokenExpirationMinutes = 60
        });

        var tokenService = new JwtTokenService(userManagerMock.Object, jwtOptions);

        Func<Task> act = async () => await tokenService.GenerateAccessTokenAsync(user);

        await act.Should().ThrowAsync<InvalidOperationException>()
            .WithMessage("*without an email address*");
    }
}
