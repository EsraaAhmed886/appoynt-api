/**
 * File Name      : EgyptianNationalIdValidationTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : EgyptianNationalIdValidator, PatientConstants
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Unit tests for 14-digit Egyptian National ID format,
 *                  governorate codes, date extraction, and check digit validation.
 */

using System;
using Appoynt.Application.Features.Patient.Validation;
using Xunit;

namespace Appoynt.Tests.UnitTests.Application;

public class EgyptianNationalIdValidationTests
{
    [Theory]
    [InlineData("29810150101234", true, 1998, 10, 15)] // 1998-10-15, Cairo (01)
    [InlineData("30105202104567", true, 2001, 5, 20)]  // 2001-05-20, Giza (21)
    public void Validate_ValidNationalId_ShouldSucceedAndExtractBirthDate(
        string nationalId,
        bool expectedIsValid,
        int expectedYear,
        int expectedMonth,
        int expectedDay)
    {
        // Act
        var result = EgyptianNationalIdValidator.Validate(nationalId);

        // Assert
        Assert.Equal(expectedIsValid, result.IsValid);
        Assert.True(result.ExtractedBirthDate.HasValue);
        Assert.Equal(new DateOnly(expectedYear, expectedMonth, expectedDay), result.ExtractedBirthDate.Value);
    }

    [Theory]
    [InlineData(null)]
    [InlineData("")]
    [InlineData("   ")]
    [InlineData("2981015010123")]   // 13 digits
    [InlineData("298101501012345")] // 15 digits
    [InlineData("2981015010123A")] // Contains letter
    public void Validate_InvalidLengthOrFormat_ShouldFail(string? nationalId)
    {
        // Act
        var result = EgyptianNationalIdValidator.Validate(nationalId);

        // Assert
        Assert.False(result.IsValid);
        Assert.Null(result.ExtractedBirthDate);
    }

    [Theory]
    [InlineData("19810150101234")] // Century = 1 (invalid)
    [InlineData("49810150101234")] // Century = 4 (invalid)
    [InlineData("29813150101234")] // Month = 13 (invalid)
    [InlineData("29802300101234")] // Feb 30 (invalid)
    [InlineData("29810159901234")] // Governorate = 99 (invalid)
    public void Validate_InvalidComponents_ShouldFail(string nationalId)
    {
        // Act
        var result = EgyptianNationalIdValidator.Validate(nationalId);

        // Assert
        Assert.False(result.IsValid);
    }
}
