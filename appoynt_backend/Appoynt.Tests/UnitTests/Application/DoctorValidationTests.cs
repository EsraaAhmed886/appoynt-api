/**
 * File Name      : DoctorValidationTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-24
 * Version        : v1.0.0
 * Dependencies   : UpdateDoctorProfileValidator, AddDoctorPhoneNumberValidator,
 *                  UpdateDoctorProfileRequest, AddDoctorPhoneNumberRequest, FluentAssertions
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-24
 * Description    : Unit tests for doctor profile update and doctor phone number
 *                  validation rules, including name limits, biography and education
 *                  constraints, birth date rules, specialization requirements,
 *                  and Egyptian phone number format enforcement.
 */

using System;
using System.Collections.Generic;
using Appoynt.Application.Features.Doctor.Contracts;
using Appoynt.Application.Features.Doctor.Validation;
using FluentAssertions;
using Xunit;

namespace Appoynt.Tests.UnitTests.Application;

/// <summary>
/// Unit tests for the doctor profile and phone number validators.
/// </summary>
public class DoctorValidationTests
{
    // Validator under test for doctor profile updates.
    private readonly UpdateDoctorProfileValidator _profileValidator = new();

    // Validator under test for adding a doctor phone number.
    private readonly AddDoctorPhoneNumberValidator _phoneValidator = new();

    #region UpdateDoctorProfileValidator - Valid Payloads

    /// <summary>
    /// A fully populated valid request must pass all rules.
    /// </summary>
    [Fact]
    public void Validate_ValidProfileUpdate_ShouldPass()
    {
        // Arrange a complete and valid profile update request.
        var request = new UpdateDoctorProfileRequest
        {
            FirstName = "Ahmed",
            LastName = "Hassan",
            NameAr = "د. أحمد حسن",
            NameEn = "Dr. Ahmed Hassan",
            Bio = "Consultant cardiologist with 15 years of experience.",
            Education = "MD, Cairo University",
            BirthDate = new DateOnly(1985, 4, 12),
            SpecializationIds = new List<Guid> { Guid.NewGuid(), Guid.NewGuid() }
        };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert the request passes every rule.
        result.IsValid.Should().BeTrue();
    }

    /// <summary>
    /// Boundary values at exactly the maximum allowed lengths must pass.
    /// </summary>
    [Fact]
    public void Validate_MaximumLengthFields_ShouldPass()
    {
        // Arrange using strings that sit exactly at each documented limit.
        var request = new UpdateDoctorProfileRequest
        {
            FirstName = new string('A', 100),
            LastName = new string('B', 100),
            NameAr = new string('ع', 100),
            NameEn = new string('E', 100),
            Bio = new string('x', 2000),
            Education = new string('e', 1000),
            BirthDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(-1)),
            SpecializationIds = new List<Guid> { Guid.NewGuid() }
        };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert boundary values are accepted.
        result.IsValid.Should().BeTrue();
    }

    #endregion

    #region UpdateDoctorProfileValidator - Required Names

    /// <summary>
    /// Empty or whitespace first names must be rejected.
    /// </summary>
    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    public void Validate_EmptyFirstName_ShouldFail(string firstName)
    {
        // Arrange with an invalid first name.
        var request = new UpdateDoctorProfileRequest
        {
            FirstName = firstName,
            LastName = "Hassan",
            SpecializationIds = new List<Guid> { Guid.NewGuid() }
        };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert the first name rule fails.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == nameof(UpdateDoctorProfileRequest.FirstName));
    }

    /// <summary>
    /// First names longer than 100 characters must be rejected.
    /// </summary>
    [Fact]
    public void Validate_FirstNameExceedsMaxLength_ShouldFail()
    {
        // Arrange with a first name one character over the limit.
        var request = new UpdateDoctorProfileRequest
        {
            FirstName = new string('A', 101),
            LastName = "Hassan",
            SpecializationIds = new List<Guid> { Guid.NewGuid() }
        };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "First name must not exceed 100 characters.");
    }

    /// <summary>
    /// Empty last names must be rejected because they are required.
    /// </summary>
    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    public void Validate_EmptyLastName_ShouldFail(string lastName)
    {
        // Arrange with an invalid last name.
        var request = new UpdateDoctorProfileRequest
        {
            FirstName = "Ahmed",
            LastName = lastName,
            SpecializationIds = new List<Guid> { Guid.NewGuid() }
        };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == nameof(UpdateDoctorProfileRequest.LastName));
    }

    /// <summary>
    /// Last names longer than 100 characters must be rejected.
    /// </summary>
    [Fact]
    public void Validate_LastNameExceedsMaxLength_ShouldFail()
    {
        // Arrange with a last name one character over the limit.
        var request = new UpdateDoctorProfileRequest
        {
            FirstName = "Ahmed",
            LastName = new string('B', 101),
            SpecializationIds = new List<Guid> { Guid.NewGuid() }
        };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "Last name must not exceed 100 characters.");
    }

    #endregion

    #region UpdateDoctorProfileValidator - Optional Field Limits

    /// <summary>
    /// Arabic display name longer than 100 characters must be rejected.
    /// </summary>
    [Fact]
    public void Validate_NameArExceedsMaxLength_ShouldFail()
    {
        // Arrange with an Arabic name over the documented limit.
        var request = new UpdateDoctorProfileRequest
        {
            FirstName = "Ahmed",
            LastName = "Hassan",
            NameAr = new string('ع', 101),
            SpecializationIds = new List<Guid> { Guid.NewGuid() }
        };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "Arabic name must not exceed 100 characters.");
    }

    /// <summary>
    /// English display name longer than 100 characters must be rejected.
    /// </summary>
    [Fact]
    public void Validate_NameEnExceedsMaxLength_ShouldFail()
    {
        // Arrange with an English name over the documented limit.
        var request = new UpdateDoctorProfileRequest
        {
            FirstName = "Ahmed",
            LastName = "Hassan",
            NameEn = new string('E', 101),
            SpecializationIds = new List<Guid> { Guid.NewGuid() }
        };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "English name must not exceed 100 characters.");
    }

    /// <summary>
    /// Biography longer than 2000 characters must be rejected.
    /// </summary>
    [Fact]
    public void Validate_BioExceedsMaxLength_ShouldFail()
    {
        // Arrange with a biography over the documented limit.
        var request = new UpdateDoctorProfileRequest
        {
            FirstName = "Ahmed",
            LastName = "Hassan",
            Bio = new string('x', 2001),
            SpecializationIds = new List<Guid> { Guid.NewGuid() }
        };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "Bio must not exceed 2000 characters.");
    }

    /// <summary>
    /// Education summary longer than 1000 characters must be rejected.
    /// </summary>
    [Fact]
    public void Validate_EducationExceedsMaxLength_ShouldFail()
    {
        // Arrange with an education summary over the documented limit.
        var request = new UpdateDoctorProfileRequest
        {
            FirstName = "Ahmed",
            LastName = "Hassan",
            Education = new string('e', 1001),
            SpecializationIds = new List<Guid> { Guid.NewGuid() }
        };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "Education must not exceed 1000 characters.");
    }

    #endregion

    #region UpdateDoctorProfileValidator - Birth Date

    /// <summary>
    /// A birth date of today or in the future must be rejected.
    /// </summary>
    [Theory]
    [InlineData(0)]
    [InlineData(1)]
    public void Validate_BirthDateTodayOrFuture_ShouldFail(int daysAhead)
    {
        // Arrange with a birth date equal to today or tomorrow.
        var request = new UpdateDoctorProfileRequest
        {
            FirstName = "Ahmed",
            LastName = "Hassan",
            BirthDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(daysAhead)),
            SpecializationIds = new List<Guid> { Guid.NewGuid() }
        };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert the past-only rule fails.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "Birth date must be in the past.");
    }

    /// <summary>
    /// A birth date strictly in the past must pass.
    /// </summary>
    [Fact]
    public void Validate_BirthDateInPast_ShouldPass()
    {
        // Arrange with yesterday as the birth date.
        var request = new UpdateDoctorProfileRequest
        {
            FirstName = "Ahmed",
            LastName = "Hassan",
            BirthDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(-1)),
            SpecializationIds = new List<Guid> { Guid.NewGuid() }
        };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert no validation errors are produced.
        result.IsValid.Should().BeTrue();
    }

    #endregion

    #region UpdateDoctorProfileValidator - Specializations

    /// <summary>
    /// An empty specialization list must be rejected (at least one required).
    /// </summary>
    [Fact]
    public void Validate_EmptySpecializations_ShouldFail()
    {
        // Arrange without any specializations.
        var request = new UpdateDoctorProfileRequest
        {
            FirstName = "Ahmed",
            LastName = "Hassan",
            SpecializationIds = new List<Guid>()
        };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert at least one failure mentions the missing specialization requirement.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "At least one specialization is required.");
    }

    /// <summary>
    /// Duplicate specialization identifiers must be rejected.
    /// </summary>
    [Fact]
    public void Validate_DuplicateSpecializations_ShouldFail()
    {
        // Arrange with the same specialization identifier repeated twice.
        Guid duplicatedId = Guid.NewGuid();
        var request = new UpdateDoctorProfileRequest
        {
            FirstName = "Ahmed",
            LastName = "Hassan",
            SpecializationIds = new List<Guid> { duplicatedId, duplicatedId }
        };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert the duplicate rule produces a failure.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "Duplicate specializations are not allowed.");
    }

    #endregion

    #region AddDoctorPhoneNumberValidator - Phone Number Format

    /// <summary>
    /// Local Egyptian mobile numbers must pass.
    /// </summary>
    [Theory]
    [InlineData("01012345678")]
    [InlineData("01112345678")]
    [InlineData("01212345678")]
    [InlineData("01512345678")]
    public void Validate_ValidLocalEgyptianPhoneNumber_ShouldPass(string phoneNumber)
    {
        // Arrange with a valid local Egyptian mobile number.
        var request = new AddDoctorPhoneNumberRequest { PhoneNumber = phoneNumber, Label = "Clinic" };

        // Act
        var result = _phoneValidator.Validate(request);

        // Assert the number is accepted.
        result.IsValid.Should().BeTrue();
    }

    /// <summary>
    /// International (+20) formatted Egyptian mobile numbers must pass.
    /// </summary>
    [Fact]
    public void Validate_InternationalEgyptianPhoneNumber_ShouldPass()
    {
        // Arrange using the +20 international prefix.
        var request = new AddDoctorPhoneNumberRequest { PhoneNumber = "+201012345678", Label = "Personal" };

        // Act
        var result = _phoneValidator.Validate(request);

        // Assert the international format is accepted.
        result.IsValid.Should().BeTrue();
    }

    /// <summary>
    /// Empty phone numbers must be rejected.
    /// </summary>
    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    public void Validate_EmptyPhoneNumber_ShouldFail(string phoneNumber)
    {
        // Arrange with a missing phone number.
        var request = new AddDoctorPhoneNumberRequest { PhoneNumber = phoneNumber };

        // Act
        var result = _phoneValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "Phone number is required.");
    }

    /// <summary>
    /// Phone numbers whose length differs from eleven digits must be rejected.
    /// </summary>
    [Theory]
    [InlineData("0101234567")]
    [InlineData("010123456789")]
    public void Validate_PhoneNumberWithWrongLength_ShouldFail(string phoneNumber)
    {
        // Arrange with a wrong-length local number.
        var request = new AddDoctorPhoneNumberRequest { PhoneNumber = phoneNumber };

        // Act
        var result = _phoneValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "Invalid Egyptian phone number format.");
    }

    /// <summary>
    /// Landline prefixes such as 02 must be rejected; only mobile prefixes are allowed.
    /// </summary>
    [Fact]
    public void Validate_LandlinePrefix_ShouldFail()
    {
        // Arrange with a landline-style number.
        var request = new AddDoctorPhoneNumberRequest { PhoneNumber = "0223334444" };

        // Act
        var result = _phoneValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
    }

    /// <summary>
    /// An invalid third digit (not 0/1/2/5) must be rejected.
    /// </summary>
    [Fact]
    public void Validate_InvalidThirdDigit_ShouldFail()
    {
        // Arrange with '9' as the carrier digit.
        var request = new AddDoctorPhoneNumberRequest { PhoneNumber = "0191234567" };

        // Act
        var result = _phoneValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
    }

    /// <summary>
    /// Non-digit characters inside the phone number must be rejected.
    /// </summary>
    [Fact]
    public void Validate_PhoneNumberContainingLetters_ShouldFail()
    {
        // Arrange with alphabetic characters embedded in the number.
        var request = new AddDoctorPhoneNumberRequest { PhoneNumber = "01012ABC67" };

        // Act
        var result = _phoneValidator.Validate(request);

        // Assert the digits-only check fails.
        result.IsValid.Should().BeFalse();
    }

    /// <summary>
    /// A +20 number whose remaining digits are invalid must still be rejected.
    /// </summary>
    [Fact]
    public void Validate_InternationalPhoneWithInvalidBody_ShouldFail()
    {
        // Arrange with an invalid body after normalization to local format.
        var request = new AddDoctorPhoneNumberRequest { PhoneNumber = "+20223334444" };

        // Act
        var result = _phoneValidator.Validate(request);

        // Assert the normalized landline is rejected.
        result.IsValid.Should().BeFalse();
    }

    #endregion

    #region AddDoctorPhoneNumberValidator - Label

    /// <summary>
    /// Labels up to fifty characters are optional but bounded.
    /// </summary>
    [Theory]
    [InlineData(null)]
    [InlineData("Clinic")]
    public void Validate_MissingOrShortLabel_ShouldPass(string? label)
    {
        // Arrange with either no label or a short label.
        var request = new AddDoctorPhoneNumberRequest { PhoneNumber = "01012345678", Label = label };

        // Act
        var result = _phoneValidator.Validate(request);

        // Assert the request remains valid.
        result.IsValid.Should().BeTrue();
    }

    /// <summary>
    /// Labels longer than fifty characters must be rejected.
    /// </summary>
    [Fact]
    public void Validate_LabelExceedsMaxLength_ShouldFail()
    {
        // Arrange with a fifty-one character label.
        var request = new AddDoctorPhoneNumberRequest { PhoneNumber = "01012345678", Label = new string('L', 51) };

        // Act
        var result = _phoneValidator.Validate(request);

        // Assert the maximum length rule fails.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "Label must not exceed 50 characters.");
    }

    #endregion
}
