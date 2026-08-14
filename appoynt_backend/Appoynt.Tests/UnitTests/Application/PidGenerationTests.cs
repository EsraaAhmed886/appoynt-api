/**
 * File Name      : PidGenerationTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : PidGenerator, PatientConstants, FamilyRelationship
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Unit tests for PID generation logic, relationship codes,
 *                  sequence numbers, and gender consistency validation.
 */

using System;
using System.Collections.Generic;
using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Authentication.Patient;
using Xunit;

namespace Appoynt.Tests.UnitTests.Application;

public class PidGenerationTests
{
    [Fact]
    public void GenerateRandomFamilyNumber_ShouldReturn7DigitString()
    {
        // Arrange
        var random = new Random(42);

        // Act
        string familyNumber = PidGenerator.GenerateRandomFamilyNumber(random);

        // Assert
        Assert.Equal(PatientConstants.FamilyNumberLength, familyNumber.Length);
        Assert.True(int.TryParse(familyNumber, out int val));
        Assert.InRange(val, PatientConstants.FamilyNumberMinValue, PatientConstants.FamilyNumberMaxValue);
    }

    [Theory]
    [InlineData(FamilyRelationship.User, 'U')]
    [InlineData(FamilyRelationship.Wife, 'W')]
    [InlineData(FamilyRelationship.Husband, 'H')]
    [InlineData(FamilyRelationship.Son, 'S')]
    [InlineData(FamilyRelationship.Daughter, 'D')]
    [InlineData(FamilyRelationship.Parent, 'P')]
    public void GetRelationshipCode_ShouldReturnCorrectCharacter(FamilyRelationship relationship, char expectedCode)
    {
        // Act
        char code = PidGenerator.GetRelationshipCode(relationship);

        // Assert
        Assert.Equal(expectedCode, code);
    }

    [Fact]
    public void GeneratePid_ShouldFormatCorrectly()
    {
        // Arrange
        string familyNumber = "1234567";
        var relationship = FamilyRelationship.Wife;
        int sequence = 1;

        // Act
        string pid = PidGenerator.GeneratePid(familyNumber, relationship, sequence);

        // Assert
        Assert.Equal("1234567W1", pid);
        Assert.Equal(PatientConstants.PidLength, pid.Length);
    }

    [Fact]
    public void FindLowestAvailableSequence_ShouldReturn0_WhenNoSequencesUsed()
    {
        // Arrange
        var used = new List<int>();

        // Act
        int sequence = PidGenerator.FindLowestAvailableSequence(used);

        // Assert
        Assert.Equal(0, sequence);
    }

    [Fact]
    public void FindLowestAvailableSequence_ShouldReturnFirstGap()
    {
        // Arrange
        var used = new List<int> { 0, 1, 3, 4 };

        // Act
        int sequence = PidGenerator.FindLowestAvailableSequence(used);

        // Assert
        Assert.Equal(2, sequence);
    }

    [Fact]
    public void FindLowestAvailableSequence_ShouldThrowException_WhenAllSequencesUsed()
    {
        // Arrange
        var used = new List<int> { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

        // Act & Assert
        Assert.Throws<InvalidOperationException>(() => PidGenerator.FindLowestAvailableSequence(used));
    }

    [Theory]
    [InlineData(Gender.Female, FamilyRelationship.Wife, true)]
    [InlineData(Gender.Male, FamilyRelationship.Wife, false)]
    [InlineData(Gender.Male, FamilyRelationship.Husband, true)]
    [InlineData(Gender.Female, FamilyRelationship.Husband, false)]
    [InlineData(Gender.Male, FamilyRelationship.Son, true)]
    [InlineData(Gender.Female, FamilyRelationship.Son, false)]
    [InlineData(Gender.Female, FamilyRelationship.Daughter, true)]
    [InlineData(Gender.Male, FamilyRelationship.Daughter, false)]
    [InlineData(Gender.Male, FamilyRelationship.Parent, true)]
    [InlineData(Gender.Female, FamilyRelationship.Parent, true)]
    public void ValidateGenderRelationshipConsistency_ShouldValidateCorrectly(Gender gender, FamilyRelationship relationship, bool expectedResult)
    {
        // Act
        bool result = PidGenerator.ValidateGenderRelationshipConsistency(gender, relationship);

        // Assert
        Assert.Equal(expectedResult, result);
    }
}
