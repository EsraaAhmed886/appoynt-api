using Appoynt.Application.Features.Authentication.Login.Contracts;
using Appoynt.Application.Features.Authentication.Login.Validation;
using FluentAssertions;

namespace Appoynt.Tests.UnitTests.Application;

/// <summary>
/// Tests Login input normalization and structural validation.
/// </summary>
public sealed class LoginValidationTests
{
    [Fact]
    public void Normalize_ShouldTrimAndRecognizeEmailIdentifier()
    {
        NormalizedLoginRequest result = LoginInputNormalizer.Normalize(
            new LoginRequest
            {
                Identifier = "  USER@EXAMPLE.COM  ",
                Password = "password"
            });

        result.Identifier.Should().Be("USER@EXAMPLE.COM");
        result.IsEmailIdentifier.Should().BeTrue();
        LoginValidator.IsValid(result).Should().BeTrue();
    }

    [Fact]
    public void Normalize_ShouldCanonicalizePhoneIdentifier()
    {
        NormalizedLoginRequest result = LoginInputNormalizer.Normalize(
            new LoginRequest
            {
                Identifier = "+201012345678",
                Password = "password"
            });

        result.IsEmailIdentifier.Should().BeFalse();
        result.PhoneNumber.Should().Be("01012345678");
        LoginValidator.IsValid(result).Should().BeTrue();
    }

    [Fact]
    public void IsValid_ShouldRejectEmptyPassword()
    {
        NormalizedLoginRequest result = LoginInputNormalizer.Normalize(
            new LoginRequest { Identifier = "user@example.com", Password = "" });

        LoginValidator.IsValid(result).Should().BeFalse();
    }
}
