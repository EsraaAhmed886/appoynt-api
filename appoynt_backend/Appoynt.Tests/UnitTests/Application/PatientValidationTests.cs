/**
 * File Name      : PatientValidationTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : UpdatePatientProfileValidator, UpdatePatientProfileRequest
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Unit tests for patient profile update validation, including
 *                  weight, height boundaries, blood group, and smoking status enums.
 */

using Appoynt.Application.Features.Patient.Contracts;
using Appoynt.Application.Features.Patient.Validation;
using Appoynt.Domain.Enums;
using Xunit;

namespace Appoynt.Tests.UnitTests.Application;

public class PatientValidationTests
{
    private readonly UpdatePatientProfileValidator _validator = new();

    [Fact]
    public void Validate_ValidPayload_ShouldPass()
    {
        // Arrange
        var request = new UpdatePatientProfileRequest
        {
            NationalId = "29810150101234",
            WeightKg = 70.5m,
            HeightCm = 175.0m,
            BloodGroup = BloodGroup.APositive,
            SmokingStatus = SmokingStatus.NonSmoker
        };

        // Act
        var result = _validator.Validate(request);

        // Assert
        Assert.True(result.IsValid);
    }

    [Theory]
    [InlineData(29.9)]
    [InlineData(250.1)]
    public void Validate_WeightOutOfRange_ShouldFail(decimal weight)
    {
        // Arrange
        var request = new UpdatePatientProfileRequest
        {
            WeightKg = weight
        };

        // Act
        var result = _validator.Validate(request);

        // Assert
        Assert.False(result.IsValid);
    }

    [Theory]
    [InlineData(29.9)]
    [InlineData(300.1)]
    public void Validate_HeightOutOfRange_ShouldFail(decimal height)
    {
        // Arrange
        var request = new UpdatePatientProfileRequest
        {
            HeightCm = height
        };

        // Act
        var result = _validator.Validate(request);

        // Assert
        Assert.False(result.IsValid);
    }
}
