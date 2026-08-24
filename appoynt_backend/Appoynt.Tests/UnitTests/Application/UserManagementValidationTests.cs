/**
 * File Name      : UserManagementValidationTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-24
 * Version        : v1.0.0
 * Dependencies   : CreateStaffRequestValidator, CreateDoctorRequestValidator,
 *                  UpdateUserRequestValidator, ForgotPasswordRequestValidator,
 *                  UserManagement Contracts, PasswordRecovery Contracts, FluentAssertions
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-24
 * Description    : Unit tests for user management and password recovery validation
 *                  rules, covering staff and doctor account creation constraints,
 *                  partial profile update rules, and forgot-password identifier checks.
 */

using System;
using System.Collections.Generic;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Features.Authentication.PasswordRecovery.Contracts;
using Appoynt.Application.Features.Authentication.PasswordRecovery.Validation;
using Appoynt.Application.Features.UserManagement.Contracts;
using Appoynt.Application.Features.UserManagement.Validation;
using Appoynt.Domain.Common.Constants;
using FluentAssertions;
using Xunit;

namespace Appoynt.Tests.UnitTests.Application;

/// <summary>
/// Unit tests for staff, doctor, user-update, and password recovery validators.
/// </summary>
public class UserManagementValidationTests
{
    // Valid password satisfying all complexity rules (upper, lower, digit, special).
    private const string ValidPassword = "Password1!";

    // Validator under test for staff account creation.
    private readonly CreateStaffRequestValidator _staffValidator = new();

    // Validator under test for doctor account creation.
    private readonly CreateDoctorRequestValidator _doctorValidator = new();

    // Validator under test for user profile updates.
    private readonly UpdateUserRequestValidator _updateUserValidator = new();

    #region Test Data Builders

    /// <summary>
    /// Builds a staff creation payload with optional field overrides.
    /// </summary>
    /// <returns>A valid <see cref="CreateStaffRequest"/>.</returns>
    private static CreateStaffRequest BuildValidStaffRequest(
        string? firstName = "Sara",
        string? lastName = "Ibrahim",
        string? email = "sara.ibrahim@appoynt.com",
        string? phoneNumber = "+201098765432",
        string? password = ValidPassword)
    {
        // Construct the request with the supplied overrides.
        return new CreateStaffRequest
        {
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            PhoneNumber = phoneNumber,
            Password = password
        };
    }

    /// <summary>
    /// Builds a doctor creation payload with optional field overrides.
    /// </summary>
    /// <returns>A valid <see cref="CreateDoctorRequest"/>.</returns>
    private static CreateDoctorRequest BuildValidDoctorRequest(
        string? nameAr = "د. منى عبد الله",
        List<Appoynt.Application.Features.UserManagement.Contracts.DoctorPhoneNumberDto>? phoneNumbers = null)
    {
        // Construct the doctor request with identity defaults and supplied profile overrides.
        return new CreateDoctorRequest
        {
            FirstName = "Mona",
            LastName = "Abdullah",
            Email = "mona.abdullah@appoynt.com",
            PhoneNumber = "+201011112222",
            Password = ValidPassword,
            NameAr = nameAr,
            NameEn = "Dr. Mona Abdullah",
            Bio = "Pediatrician.",
            Education = "MBBCh, Ain Shams University",
            PhoneNumbers = phoneNumbers
        };
    }

    #endregion

    #region CreateStaffRequestValidator

    /// <summary>
    /// A complete valid staff payload must pass.
    /// </summary>
    [Fact]
    public void Validate_ValidStaffRequest_ShouldPass()
    {
        // Arrange using the baseline staff payload.
        var request = BuildValidStaffRequest();

        // Act
        var result = _staffValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeTrue();
    }

    /// <summary>
    /// Missing or empty first names must be rejected.
    /// </summary>
    [Theory]
    [InlineData(null)]
    [InlineData("")]
    public void Validate_StaffMissingFirstName_ShouldFail(string? firstName)
    {
        // Arrange with an absent first name.
        var request = BuildValidStaffRequest(firstName: firstName);

        // Act
        var result = _staffValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == AuthenticationErrorCodes.FirstNameRequired);
    }

    /// <summary>
    /// First names beyond fifty characters must be rejected.
    /// </summary>
    [Fact]
    public void Validate_StaffFirstNameExceedsMaxLength_ShouldFail()
    {
        // Arrange with a fifty-one character first name.
        var request = BuildValidStaffRequest(firstName: new string('F', UserConstants.NameMaxLength + 1));

        // Act
        var result = _staffValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == AuthenticationErrorCodes.FirstNameLengthInvalid);
    }

    /// <summary>
    /// Missing emails must be rejected.
    /// </summary>
    [Theory]
    [InlineData(null)]
    [InlineData("")]
    public void Validate_StaffMissingEmail_ShouldFail(string? email)
    {
        // Arrange with an absent email address.
        var request = BuildValidStaffRequest(email: email);

        // Act
        var result = _staffValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == AuthenticationErrorCodes.EmailRequired);
    }

    /// <summary>
    /// Malformed email addresses must be rejected.
    /// </summary>
    [Fact]
    public void Validate_StaffInvalidEmailFormat_ShouldFail()
    {
        // Arrange with a syntactically invalid email.
        var request = BuildValidStaffRequest(email: "not-an-email");

        // Act
        var result = _staffValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == AuthenticationErrorCodes.EmailInvalid);
    }

    /// <summary>
    /// Phone numbers violating the E.164-like format must be rejected.
    /// </summary>
    [Fact]
    public void Validate_StaffInvalidPhoneFormat_ShouldFail()
    {
        // Arrange with letters inside the phone number.
        var request = BuildValidStaffRequest(phoneNumber: "01ABC234567");

        // Act
        var result = _staffValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == AuthenticationErrorCodes.PhoneFormatInvalid);
    }

    /// <summary>
    /// Passwords shorter than eight characters must be rejected with the complexity code.
    /// </summary>
    [Fact]
    public void Validate_StaffShortPassword_ShouldFail()
    {
        // Arrange with a seven character password.
        var request = BuildValidStaffRequest(password: "Pass1!");

        // Act
        var result = _staffValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == AuthenticationErrorCodes.PasswordComplexityInvalid);
    }

    /// <summary>
    /// Passwords missing each required character class must be rejected individually.
    /// </summary>
    [Theory]
    [InlineData("password1!")]  // Missing uppercase.
    [InlineData("PASSWORD1!")]  // Missing lowercase.
    [InlineData("Password!!")]  // Missing digit.
    [InlineData("Password12")]  // Missing special character.
    public void Validate_StaffPasswordMissingComplexityClass_ShouldFail(string password)
    {
        // Arrange with a password missing one required class.
        var request = BuildValidStaffRequest(password: password);

        // Act
        var result = _staffValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == AuthenticationErrorCodes.PasswordComplexityInvalid);
    }

    #endregion

    #region CreateDoctorRequestValidator

    /// <summary>
    /// A fully populated valid doctor payload must pass.
    /// </summary>
    [Fact]
    public void Validate_ValidDoctorRequest_ShouldPass()
    {
        // Arrange using the baseline doctor payload.
        var request = BuildValidDoctorRequest();

        // Act
        var result = _doctorValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeTrue();
    }

    /// <summary>
    /// The Arabic display name is mandatory for doctors.
    /// </summary>
    [Theory]
    [InlineData(null)]
    [InlineData("")]
    public void Validate_DoctorMissingNameAr_ShouldFail(string? nameAr)
    {
        // Arrange without the required Arabic name.
        var request = BuildValidDoctorRequest(nameAr: nameAr);

        // Act
        var result = _doctorValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == DoctorErrorCodes.NameArRequired);
    }

    /// <summary>
    /// An Arabic name beyond one hundred characters must be rejected.
    /// </summary>
    [Fact]
    public void Validate_DoctorNameArExceedsMaxLength_ShouldFail()
    {
        // Arrange with an over-limit Arabic name.
        var request = BuildValidDoctorRequest(nameAr: new string('د', DoctorConstants.NameMaxLength + 1));

        // Act
        var result = _doctorValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == DoctorErrorCodes.NameArLengthInvalid);
    }

    /// <summary>
    /// More than five additional phone numbers must be rejected.
    /// </summary>
    [Fact]
    public void Validate_DoctorTooManyPhoneNumbers_ShouldFail()
    {
        // Arrange with six distinct labeled phone entries.
        var phones = new List<Appoynt.Application.Features.UserManagement.Contracts.DoctorPhoneNumberDto>();
        for (int index = 0; index <= DoctorConstants.MaxPhoneNumbersPerDoctor; index++)
        {
            // Add a unique entry per iteration to trip only the count rule.
            phones.Add(new Appoynt.Application.Features.UserManagement.Contracts.DoctorPhoneNumberDto
            {
                PhoneNumber = $"+20105000{index:D4}",
                Label = $"Number {index}"
            });
        }

        var request = BuildValidDoctorRequest(phoneNumbers: phones);

        // Act
        var result = _doctorValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == DoctorErrorCodes.MaxPhoneNumbersExceeded);
    }

    /// <summary>
    /// Duplicate doctor phone numbers must be rejected.
    /// </summary>
    [Fact]
    public void Validate_DoctorDuplicatePhoneNumbers_ShouldFail()
    {
        // Arrange with the same number under two labels.
        var duplicated = "+20105555666";
        var request = BuildValidDoctorRequest(phoneNumbers: new List<Appoynt.Application.Features.UserManagement.Contracts.DoctorPhoneNumberDto>
        {
            new() { PhoneNumber = duplicated, Label = "Clinic" },
            new() { PhoneNumber = duplicated, Label = "Emergency" }
        });

        // Act
        var result = _doctorValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == DoctorErrorCodes.DuplicatePhoneNumber);
    }

    /// <summary>
    /// A doctor phone entry missing its label must be rejected.
    /// </summary>
    [Fact]
    public void Validate_DoctorPhoneEntryMissingLabel_ShouldFail()
    {
        // Arrange with an unlabeled phone entry.
        var request = BuildValidDoctorRequest(phoneNumbers: new List<Appoynt.Application.Features.UserManagement.Contracts.DoctorPhoneNumberDto>
        {
            new() { PhoneNumber = "+20105555666", Label = "" }
        });

        // Act
        var result = _doctorValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == DoctorErrorCodes.PhoneLabelRequired);
    }

    /// <summary>
    /// Optional biography content beyond two thousand characters must be rejected.
    /// </summary>
    [Fact]
    public void Validate_DoctorBioExceedsMaxLength_ShouldFail()
    {
        // Arrange with an over-limit biography.
        var request = BuildValidDoctorRequest();
        var overflowingBio = new string('b', DoctorConstants.BioMaxLength + 1);
        var requestWithBio = new CreateDoctorRequest
        {
            FirstName = request.FirstName,
            LastName = request.LastName,
            Email = request.Email,
            PhoneNumber = request.PhoneNumber,
            Password = request.Password,
            NameAr = request.NameAr,
            Bio = overflowingBio
        };

        // Act
        var result = _doctorValidator.Validate(requestWithBio);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == DoctorErrorCodes.BioLengthInvalid);
    }

    /// <summary>
    /// Optional education content beyond one thousand characters must be rejected.
    /// </summary>
    [Fact]
    public void Validate_DoctorEducationExceedsMaxLength_ShouldFail()
    {
        // Arrange with an over-limit education summary.
        var baseRequest = BuildValidDoctorRequest();
        var requestWithEducation = new CreateDoctorRequest
        {
            FirstName = baseRequest.FirstName,
            LastName = baseRequest.LastName,
            Email = baseRequest.Email,
            PhoneNumber = baseRequest.PhoneNumber,
            Password = baseRequest.Password,
            NameAr = baseRequest.NameAr,
            Education = new string('e', DoctorConstants.EducationMaxLength + 1)
        };

        // Act
        var result = _doctorValidator.Validate(requestWithEducation);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == DoctorErrorCodes.EducationLengthInvalid);
    }

    #endregion

    #region UpdateUserRequestValidator

    /// <summary>
    /// An empty update payload must pass because all fields are optional.
    /// </summary>
    [Fact]
    public void Validate_EmptyUpdateUserRequest_ShouldPass()
    {
        // Arrange with every field left unset.
        var request = new UpdateUserRequest();

        // Act
        var result = _updateUserValidator.Validate(request);

        // Assert partial updates remain valid.
        result.IsValid.Should().BeTrue();
    }

    /// <summary>
    /// A provided-but-empty first name must be rejected.
    /// </summary>
    [Fact]
    public void Validate_UpdateUserEmptyFirstName_ShouldFail()
    {
        // Arrange with an explicitly empty first name.
        var request = new UpdateUserRequest { FirstName = "" };

        // Act
        var result = _updateUserValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == AuthenticationErrorCodes.FirstNameRequired);
    }

    /// <summary>
    /// A last name beyond fifty characters must be rejected.
    /// </summary>
    [Fact]
    public void Validate_UpdateUserLastNameExceedsMaxLength_ShouldFail()
    {
        // Arrange with an over-limit last name.
        var request = new UpdateUserRequest { LastName = new string('L', UserConstants.NameMaxLength + 1) };

        // Act
        var result = _updateUserValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == AuthenticationErrorCodes.LastNameLengthInvalid);
    }

    /// <summary>
    /// An address beyond two hundred characters must be rejected per the update rule.
    /// </summary>
    [Fact]
    public void Validate_UpdateUserAddressExceedsMaxLength_ShouldFail()
    {
        // Arrange with an address one character over the enforced limit of 200.
        var request = new UpdateUserRequest { Address = new string('A', 201) };

        // Act
        var result = _updateUserValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == AuthenticationErrorCodes.AddressLengthInvalid);
    }

    /// <summary>
    /// Fully populated valid update payloads must pass.
    /// </summary>
    [Fact]
    public void Validate_FullyPopulatedUpdateUserRequest_ShouldPass()
    {
        // Arrange with every optional field populated to valid values.
        var request = new UpdateUserRequest
        {
            FirstName = "Omar",
            LastName = "Khaled",
            Address = "5 Nile Corniche, Maadi"
        };

        // Act
        var result = _updateUserValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeTrue();
    }

    #endregion

    #region ForgotPasswordRequestValidator (static helper)

    /// <summary>
    /// A non-empty identifier produces no validation errors.
    /// </summary>
    [Fact]
    public void ForgotPasswordValidate_ValidIdentifier_ShouldReturnNoErrors()
    {
        // Arrange with a normal identifier value.
        var request = new ForgotPasswordRequest { Identifier = "patient@example.com" };

        // Act
        var errors = ForgotPasswordRequestValidator.Validate(request);

        // Assert no errors are produced.
        errors.Should().BeEmpty();
    }

    /// <summary>
    /// Null, empty, or whitespace identifiers must produce the request-invalid error.
    /// </summary>
    [Theory]
    [InlineData(null)]
    [InlineData("")]
    [InlineData("   ")]
    public void ForgotPasswordValidate_MissingIdentifier_ShouldReturnError(string? identifier)
    {
        // Arrange with an absent identifier.
        var request = new ForgotPasswordRequest { Identifier = identifier! };

        // Act
        var errors = ForgotPasswordRequestValidator.Validate(request);

        // Assert the dedicated recovery error is returned targeting the identifier field.
        errors.Should().HaveCount(1);
        errors[0].Code.Should().Be(AuthenticationErrorCodes.PasswordRecoveryRequestInvalid);
        errors[0].Field.Should().Be(nameof(ForgotPasswordRequest.Identifier));
    }

    /// <summary>
    /// Passing a null request must throw ArgumentNullException.
    /// </summary>
    [Fact]
    public void ForgotPasswordValidate_NullRequest_ShouldThrowArgumentNullException()
    {
        // Act and assert the guard clause fires.
        Assert.Throws<ArgumentNullException>(() =>
            ForgotPasswordRequestValidator.Validate(null!));
    }

    #endregion
}
