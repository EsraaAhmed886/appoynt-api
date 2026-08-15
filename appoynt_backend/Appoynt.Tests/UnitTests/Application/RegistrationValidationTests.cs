using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Authentication.Registration.Contracts;
using Appoynt.Application.Features.Authentication.Registration.Validation;
using FluentAssertions;

namespace Appoynt.Tests.UnitTests.Application;

/// <summary>
/// Tests Registration input normalization and detailed validation rules.
/// </summary>
public sealed class RegistrationValidationTests
{
    [Fact]
    public void Normalize_ShouldTrimNamesAndNormalizeEmailAndPhone()
    {
        var rawRequest = new RegisterRequest
        {
            FirstName = "  John  ",
            LastName = "  Doe  ",
            Email = "  JOHN.DOE@EXAMPLE.COM  ",
            PhoneNumber = "+20 10 1234 5678",
            Password = "P@ssword123",
            ConfirmPassword = "P@ssword123"
        };

        NormalizedRegisterRequest normalized = RegistrationInputNormalizer.Normalize(rawRequest);

        normalized.FirstName.Should().Be("John");
        normalized.LastName.Should().Be("Doe");
        normalized.Email.Should().Be("john.doe@example.com");
        normalized.PhoneNumber.Should().Be("01012345678");
        normalized.PhoneNumberContainsUnsupportedCharacters.Should().BeFalse();
        normalized.Password.Should().Be("P@ssword123");
        normalized.ConfirmPassword.Should().Be("P@ssword123");
    }

    [Fact]
    public void Validate_ShouldPassForValidRequest()
    {
        var normalized = RegistrationInputNormalizer.Normalize(new RegisterRequest
        {
            FirstName = "Mustafa",
            LastName = "Mahmoud",
            Email = "mustafa@example.com",
            PhoneNumber = "01012345678",
            Password = "P@ssword123",
            ConfirmPassword = "P@ssword123"
        });

        IReadOnlyList<AuthenticationError> errors = RegistrationValidator.Validate(normalized);

        errors.Should().BeEmpty();
    }

    [Theory]
    [InlineData("", "", AuthenticationErrorCodes.FirstNameRequired)]
    [InlineData("A", "LastName", AuthenticationErrorCodes.FirstNameLengthInvalid)]
    [InlineData("John123", "LastName", AuthenticationErrorCodes.FirstNameInvalidCharacters)]
    public void Validate_ShouldReturnCorrectFirstNameErrors(
        string firstName,
        string lastName,
        string expectedErrorCode)
    {
        var normalized = RegistrationInputNormalizer.Normalize(new RegisterRequest
        {
            FirstName = firstName,
            LastName = lastName,
            Email = "valid@example.com",
            PhoneNumber = "01012345678",
            Password = "P@ssword123",
            ConfirmPassword = "P@ssword123"
        });

        IReadOnlyList<AuthenticationError> errors = RegistrationValidator.Validate(normalized);

        errors.Should().ContainSingle(e => e.Code == expectedErrorCode && e.Field == "FirstName");
    }

    [Theory]
    [InlineData("", AuthenticationErrorCodes.PhoneRequired)]
    [InlineData("0101234", AuthenticationErrorCodes.PhoneLengthInvalid)]
    [InlineData("02012345678", AuthenticationErrorCodes.PhonePrefixInvalid)]
    [InlineData("01312345678", AuthenticationErrorCodes.PhoneThirdDigitInvalid)]
    public void Validate_ShouldReturnCorrectPhoneErrors(
        string rawPhone,
        string expectedErrorCode)
    {
        var normalized = RegistrationInputNormalizer.Normalize(new RegisterRequest
        {
            FirstName = "John",
            LastName = "Doe",
            Email = "valid@example.com",
            PhoneNumber = rawPhone,
            Password = "P@ssword123",
            ConfirmPassword = "P@ssword123"
        });

        IReadOnlyList<AuthenticationError> errors = RegistrationValidator.Validate(normalized);

        errors.Should().ContainSingle(e => e.Code == expectedErrorCode && e.Field == "PhoneNumber");
    }

    [Theory]
    [InlineData("", AuthenticationErrorCodes.EmailRequired)]
    [InlineData("not-an-email", AuthenticationErrorCodes.EmailInvalid)]
    public void Validate_ShouldReturnCorrectEmailErrors(
        string rawEmail,
        string expectedErrorCode)
    {
        var normalized = RegistrationInputNormalizer.Normalize(new RegisterRequest
        {
            FirstName = "John",
            LastName = "Doe",
            Email = rawEmail,
            PhoneNumber = "01012345678",
            Password = "P@ssword123",
            ConfirmPassword = "P@ssword123"
        });

        IReadOnlyList<AuthenticationError> errors = RegistrationValidator.Validate(normalized);

        errors.Should().ContainSingle(e => e.Code == expectedErrorCode && e.Field == "Email");
    }

    [Theory]
    [InlineData("", AuthenticationErrorCodes.PasswordRequired)]
    [InlineData("Short1!", AuthenticationErrorCodes.PasswordLengthInvalid)]
    [InlineData("password123", AuthenticationErrorCodes.PasswordComplexityInvalid)]
    [InlineData("P@ssword 123", AuthenticationErrorCodes.PasswordInvalidCharacters)]
    public void Validate_ShouldReturnCorrectPasswordErrors(
        string password,
        string expectedErrorCode)
    {
        var normalized = RegistrationInputNormalizer.Normalize(new RegisterRequest
        {
            FirstName = "John",
            LastName = "Doe",
            Email = "valid@example.com",
            PhoneNumber = "01012345678",
            Password = password,
            ConfirmPassword = password
        });

        IReadOnlyList<AuthenticationError> errors = RegistrationValidator.Validate(normalized);

        errors.Should().ContainSingle(e => e.Code == expectedErrorCode && e.Field == "Password");
    }

    [Fact]
    public void Validate_ShouldRejectPasswordContainingFirstName()
    {
        var normalized = RegistrationInputNormalizer.Normalize(new RegisterRequest
        {
            FirstName = "John",
            LastName = "Doe",
            Email = "valid@example.com",
            PhoneNumber = "01012345678",
            Password = "JohnP@ssword123",
            ConfirmPassword = "JohnP@ssword123"
        });

        IReadOnlyList<AuthenticationError> errors = RegistrationValidator.Validate(normalized);

        errors.Should().ContainSingle(e => e.Code == AuthenticationErrorCodes.PasswordContainsPersonalInformation && e.Field == "Password");
    }

    [Fact]
    public void Validate_ShouldRejectMismatchedConfirmPassword()
    {
        var normalized = RegistrationInputNormalizer.Normalize(new RegisterRequest
        {
            FirstName = "John",
            LastName = "Doe",
            Email = "valid@example.com",
            PhoneNumber = "01012345678",
            Password = "P@ssword123",
            ConfirmPassword = "DifferentPassword123!"
        });

        IReadOnlyList<AuthenticationError> errors = RegistrationValidator.Validate(normalized);

        errors.Should().ContainSingle(e => e.Code == AuthenticationErrorCodes.PasswordsDoNotMatch && e.Field == "ConfirmPassword");
    }
}
