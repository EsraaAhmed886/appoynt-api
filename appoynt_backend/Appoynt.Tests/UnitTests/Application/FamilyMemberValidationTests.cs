/**
 * File Name      : FamilyMemberValidationTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : AddFamilyMemberValidator, AddFamilyMemberRequest
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Unit tests for adding family member validation rules, including
 *                  full name constraints, gender, relationship, and birth date rules.
 */

using System;
using Appoynt.Application.Features.Patient.Contracts;
using Appoynt.Application.Features.Patient.Validation;
using Appoynt.Domain.Enums;
using Xunit;

namespace Appoynt.Tests.UnitTests.Application;

public class FamilyMemberValidationTests
{
    private readonly AddFamilyMemberValidator _validator = new();

    [Fact]
    public void Validate_ValidPayload_ShouldPass()
    {
        // Arrange
        var request = new AddFamilyMemberRequest
        {
            FullName = "Ahmad Mahmoud",
            Gender = Gender.Male,
            Relationship = FamilyRelationship.Son,
            BirthDate = new DateOnly(2015, 6, 12)
        };

        // Act
        var result = _validator.Validate(request);

        // Assert
        Assert.True(result.IsValid);
    }

    [Theory]
    [InlineData(null)]
    [InlineData("")]
    [InlineData("   ")]
    [InlineData("Ab")] // < 3 chars
    public void Validate_InvalidFullName_ShouldFail(string? fullName)
    {
        // Arrange
        var request = new AddFamilyMemberRequest
        {
            FullName = fullName,
            Gender = Gender.Female,
            Relationship = FamilyRelationship.Daughter,
            BirthDate = new DateOnly(2020, 1, 1)
        };

        // Act
        var result = _validator.Validate(request);

        // Assert
        Assert.False(result.IsValid);
    }

    [Fact]
    public void Validate_RelationshipIsUser_ShouldFail()
    {
        // Arrange
        var request = new AddFamilyMemberRequest
        {
            FullName = "Self Name",
            Gender = Gender.Male,
            Relationship = FamilyRelationship.User, // Not allowed for family members
            BirthDate = new DateOnly(1990, 1, 1)
        };

        // Act
        var result = _validator.Validate(request);

        // Assert
        Assert.False(result.IsValid);
    }

    [Fact]
    public void Validate_FutureBirthDate_ShouldFail()
    {
        // Arrange
        var request = new AddFamilyMemberRequest
        {
            FullName = "Future Baby",
            Gender = Gender.Female,
            Relationship = FamilyRelationship.Daughter,
            BirthDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(10))
        };

        // Act
        var result = _validator.Validate(request);

        // Assert
        Assert.False(result.IsValid);
    }
}
