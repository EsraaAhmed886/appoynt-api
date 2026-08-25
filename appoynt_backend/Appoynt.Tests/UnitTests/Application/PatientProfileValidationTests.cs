/**
 * File Name      : PatientProfileValidationTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-24
 * Version        : v1.0.0
 * Dependencies   : UpdatePatientProfileValidator, UpdatePatientPhoneNumberValidator,
 *                  UpdateFamilyMemberValidator, Patient Contracts, FluentAssertions
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-24
 * Description    : Unit tests completing coverage of patient-facing validators:
 *                  partial profile updates with medical measurements boundary
 *                  checks, phone number update rules, and family member update rules.
 */

using System;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Features.Patient.Contracts;
using Appoynt.Application.Features.Patient.Validation;
using Appoynt.Domain.Enums;
using FluentAssertions;
using Xunit;

namespace Appoynt.Tests.UnitTests.Application;

/// <summary>
/// Unit tests for patient profile, phone number, and family member update validators.
/// </summary>
public class PatientProfileValidationTests
{
    // Validator under test for patient profile updates.
    private readonly UpdatePatientProfileValidator _profileValidator = new();

    // Validator under test for patient phone number updates.
    private readonly UpdatePatientPhoneNumberValidator _phoneValidator = new();

    // Validator under test for family member updates.
    private readonly UpdateFamilyMemberValidator _familyMemberValidator = new();

    #region UpdatePatientProfileValidator

    /// <summary>
    /// An empty update payload must pass because every field is optional.
    /// </summary>
    [Fact]
    public void Validate_EmptyProfileUpdate_ShouldPass()
    {
        // Arrange with no fields set.
        var request = new UpdatePatientProfileRequest();

        // Act
        var result = _profileValidator.Validate(request);

        // Assert partial updates remain valid.
        result.IsValid.Should().BeTrue();
    }

    /// <summary>
    /// A provided-but-empty first name must be rejected.
    /// </summary>
    [Fact]
    public void Validate_ProfileUpdateEmptyFirstName_ShouldFail()
    {
        // Arrange with an explicitly empty first name.
        var request = new UpdatePatientProfileRequest { FirstName = "" };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == AuthenticationErrorCodes.FirstNameRequired);
    }

    /// <summary>
    /// First names beyond fifty characters must be rejected.
    /// </summary>
    [Fact]
    public void Validate_ProfileUpdateLongFirstName_ShouldFail()
    {
        // Arrange with a fifty-one character first name.
        var request = new UpdatePatientProfileRequest { FirstName = new string('P', 51) };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
    }

    /// <summary>
    /// An out-of-range gender value must be rejected by the enum rule.
    /// </summary>
    [Fact]
    public void Validate_ProfileUpdateInvalidGender_ShouldFail()
    {
        // Arrange with an undefined enum value cast into the request.
        var request = new UpdatePatientProfileRequest { Gender = (Gender)99 };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
    }

    /// <summary>
    /// A birth date of today or later must be rejected.
    /// </summary>
    [Theory]
    [InlineData(0)]
    [InlineData(5)]
    public void Validate_ProfileUpdateFutureBirthDate_ShouldFail(int daysAhead)
    {
        // Arrange with today's or a future date of birth.
        var request = new UpdatePatientProfileRequest
        {
            BirthDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(daysAhead))
        };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
    }

    /// <summary>
    /// An address beyond two hundred fifty characters must be rejected.
    /// </summary>
    [Fact]
    public void Validate_ProfileUpdateLongAddress_ShouldFail()
    {
        // Arrange with an address one character over the enforced limit.
        var request = new UpdatePatientProfileRequest { Address = new string('A', 251) };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == AuthenticationErrorCodes.AddressLengthInvalid);
    }

    /// <summary>
    /// National IDs must be exactly fourteen digits when supplied.
    /// </summary>
    [Theory]
    [InlineData("29810150101")]        // Too short.
    [InlineData("298101501012345")]    // Too long.
    [InlineData("2981015010AB34")]     // Contains letters.
    public void Validate_ProfileUpdateMalformedNationalId_ShouldFail(string nationalId)
    {
        // Arrange with a structurally invalid national ID.
        var request = new UpdatePatientProfileRequest { NationalId = nationalId };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
    }

    /// <summary>
    /// Weight values at the exact boundaries (30 kg / 250 kg) must pass.
    /// </summary>
    [Theory]
    [InlineData(30)]
    [InlineData(250)]
    public void Validate_ProfileUpdateWeightBoundaries_ShouldPass(decimal weight)
    {
        // Arrange with a boundary weight value.
        var request = new UpdatePatientProfileRequest { WeightKg = weight };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert inclusive bounds are accepted.
        result.IsValid.Should().BeTrue();
    }

    /// <summary>
    /// Height values at the exact boundaries (30 cm / 300 cm) must pass.
    /// </summary>
    [Theory]
    [InlineData(30)]
    [InlineData(300)]
    public void Validate_ProfileUpdateHeightBoundaries_ShouldPass(decimal height)
    {
        // Arrange with a boundary height value.
        var request = new UpdatePatientProfileRequest { HeightCm = height };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert inclusive bounds are accepted.
        result.IsValid.Should().BeTrue();
    }

    /// <summary>
    /// An out-of-range blood group enum value must be rejected.
    /// </summary>
    [Fact]
    public void Validate_ProfileUpdateInvalidBloodGroup_ShouldFail()
    {
        // Arrange with an undefined blood group value.
        var request = new UpdatePatientProfileRequest { BloodGroup = (BloodGroup)99 };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
    }

    /// <summary>
    /// An out-of-range smoking status enum value must be rejected.
    /// </summary>
    [Fact]
    public void Validate_ProfileUpdateInvalidSmokingStatus_ShouldFail()
    {
        // Arrange with an undefined smoking status value.
        var request = new UpdatePatientProfileRequest { SmokingStatus = (SmokingStatus)99 };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
    }

    /// <summary>
    /// A fully populated medically valid profile update must pass.
    /// </summary>
    [Fact]
    public void Validate_FullyPopulatedValidProfileUpdate_ShouldPass()
    {
        // Arrange with every field populated to valid values.
        var request = new UpdatePatientProfileRequest
        {
            FirstName = "Youssef",
            LastName = "Tarek",
            Gender = Gender.Male,
            BirthDate = new DateOnly(1994, 2, 20),
            Address = "7 Abbas El Akkad, Nasr City",
            NationalId = "29402200101234",
            WeightKg = 85.5m,
            HeightCm = 178m,
            BloodGroup = BloodGroup.APositive,
            SmokingStatus = SmokingStatus.ExSmoker
        };

        // Act
        var result = _profileValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeTrue();
    }

    #endregion

    #region UpdatePatientPhoneNumberValidator

    /// <summary>
    /// Valid eleven-digit local Egyptian numbers must pass.
    /// </summary>
    [Theory]
    [InlineData("01012345678")]
    [InlineData("01198765432")]
    [InlineData("01255554444")]
    [InlineData("01511119999")]
    public void Validate_ValidPatientPhoneNumber_ShouldPass(string phoneNumber)
    {
        // Arrange with a well-formed local mobile number.
        var request = new UpdatePatientPhoneNumberRequest { PhoneNumber = phoneNumber };

        // Act
        var result = _phoneValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeTrue();
    }

    /// <summary>
    /// Empty numbers must be rejected as required.
    /// </summary>
    [Theory]
    [InlineData("")]
    [InlineData(null)]
    public void Validate_MissingPatientPhoneNumber_ShouldFail(string? phoneNumber)
    {
        // Arrange with an absent number value.
        var request = new UpdatePatientPhoneNumberRequest { PhoneNumber = phoneNumber! };

        // Act
        var result = _phoneValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
    }

    /// <summary>
    /// Numbers whose length differs from eleven digits must be rejected.
    /// </summary>
    [Fact]
    public void Validate_PatientPhoneNumberWrongLength_ShouldFail()
    {
        // Arrange with a ten digit number.
        var request = new UpdatePatientPhoneNumberRequest { PhoneNumber = "0101234567" };

        // Act
        var result = _phoneValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
    }

    /// <summary>
    /// Numbers not starting with the local 01 prefix must be rejected.
    /// </summary>
    [Fact]
    public void Validate_PatientPhoneNumberWrongPrefix_ShouldFail()
    {
        // Arrange with a landline-style number.
        var request = new UpdatePatientPhoneNumberRequest { PhoneNumber = "0223334444" };

        // Act
        var result = _phoneValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
    }

    /// <summary>
    /// Numbers containing alphabetic characters must be rejected.
    /// </summary>
    [Fact]
    public void Validate_PatientPhoneNumberWithLetters_ShouldFail()
    {
        // Arrange with letters embedded inside the number.
        var request = new UpdatePatientPhoneNumberRequest { PhoneNumber = "010ABC45678" };

        // Act
        var result = _phoneValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
    }

    #endregion

    #region UpdateFamilyMemberValidator

    /// <summary>
    /// A valid family member update payload must pass.
    /// </summary>
    [Fact]
    public void Validate_ValidFamilyMemberUpdate_ShouldPass()
    {
        // Arrange with all fields set to acceptable values.
        var request = new UpdateFamilyMemberRequest
        {
            FullName = "Laila Sameer",
            Gender = Gender.Female,
            Relationship = FamilyRelationship.Daughter,
            BirthDate = DateOnly.FromDateTime(DateTime.UtcNow.AddYears(-6))
        };

        // Act
        var result = _familyMemberValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeTrue();
    }

    /// <summary>
    /// An explicitly empty full name must be rejected when provided.
    /// </summary>
    [Fact]
    public void Validate_FamilyMemberEmptyFullName_ShouldFail()
    {
        // Arrange with an empty name string.
        var request = new UpdateFamilyMemberRequest { FullName = "" };

        // Act
        var result = _familyMemberValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
    }

    /// <summary>
    /// A name shorter than three characters must be rejected when provided.
    /// </summary>
    [Fact]
    public void Validate_FamilyMemberShortFullName_ShouldFail()
    {
        // Arrange with a two character name.
        var request = new UpdateFamilyMemberRequest { FullName = "Al" };

        // Act
        var result = _familyMemberValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
    }

    /// <summary>
    /// The User relationship remains forbidden for family members on update.
    /// </summary>
    [Fact]
    public void Validate_FamilyMemberRelationshipUser_ShouldFail()
    {
        // Arrange with the reserved self relationship value.
        var request = new UpdateFamilyMemberRequest { Relationship = FamilyRelationship.User };

        // Act
        var result = _familyMemberValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
    }

    /// <summary>
    /// A birth date later than today must be rejected; today itself is allowed.
    /// </summary>
    [Fact]
    public void Validate_FamilyMemberBirthDateBoundary_ShouldEnforceTodayAllowed()
    {
        // Arrange with today's date which sits at the inclusive boundary.
        var request = new UpdateFamilyMemberRequest
        {
            BirthDate = DateOnly.FromDateTime(DateTime.UtcNow)
        };

        // Act
        var result = _familyMemberValidator.Validate(request);

        // Assert today's date passes because the rule allows equality.
        result.IsValid.Should().BeTrue();
    }

    /// <summary>
    /// A future birth date must be rejected.
    /// </summary>
    [Fact]
    public void Validate_FamilyMemberFutureBirthDate_ShouldFail()
    {
        // Arrange with tomorrow's date.
        var request = new UpdateFamilyMemberRequest
        {
            BirthDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(1))
        };

        // Act
        var result = _familyMemberValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
    }

    #endregion
}
