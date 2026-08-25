/**
 * File Name      : ClinicValidationTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-24
 * Version        : v1.0.0
 * Dependencies   : CreateClinicRequestValidator, UpdateClinicRequestValidator,
 *                  WorkingPeriodRequestValidator, BreakRequestValidator,
 *                  Clinics Contracts, ClinicConstants, FluentAssertions
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-24
 * Description    : Unit tests for clinic creation and update validation rules,
 *                  including name and fee constraints, allowed appointment
 *                  durations, advance booking windows, phone number collections,
 *                  working period time ranges, and break time rules.
 */

using System;
using System.Collections.Generic;
using Appoynt.Application.Features.Clinics.Contracts;
using Appoynt.Application.Features.Clinics.Validation;
using Appoynt.Domain.Common.Constants;
using FluentAssertions;
using Xunit;

namespace Appoynt.Tests.UnitTests.Application;

/// <summary>
/// Unit tests for all clinic-related request validators.
/// </summary>
public class ClinicValidationTests
{
    // Validator under test for creating a clinic.
    private readonly CreateClinicRequestValidator _createValidator = new();

    // Validator under test for updating a clinic.
    private readonly UpdateClinicRequestValidator _updateValidator = new();

    // Validator under test for a single working period.
    private readonly WorkingPeriodRequestValidator _workingPeriodValidator = new();

    // Validator under test for a single break.
    private readonly BreakRequestValidator _breakValidator = new();

    /// <summary>
    /// Builds a clinic creation payload, allowing individual overrides per test.
    /// </summary>
    /// <param name="name">Clinic display name.</param>
    /// <param name="governorateId">Governorate identifier.</param>
    /// <param name="cityId">City identifier.</param>
    /// <param name="consultationFee">Consultation fee value.</param>
    /// <param name="detailedAddress">Optional detailed address.</param>
    /// <param name="appointmentDurationMinutes">Appointment duration override.</param>
    /// <param name="maxAdvanceBookingDays">Advance booking window override.</param>
    /// <param name="phoneNumbers">Optional phone number collection.</param>
    /// <param name="workingPeriods">Optional working period collection.</param>
    /// <returns>A <see cref="CreateClinicRequest"/> instance for testing.</returns>
    private static CreateClinicRequest BuildCreateRequest(
        string? name = "El Nour Dental Clinic",
        Guid? governorateId = null,
        Guid? cityId = null,
        decimal? consultationFee = 250m,
        string? detailedAddress = "12 Tahrir Street, Dokki",
        int? appointmentDurationMinutes = 30,
        int? maxAdvanceBookingDays = 14,
        List<ClinicPhoneNumberDto>? phoneNumbers = null,
        List<WorkingPeriodRequest>? workingPeriods = null)
    {
        // Default location identifiers to fresh GUIDs when not overridden.
        return new CreateClinicRequest
        {
            Name = name,
            GovernorateId = governorateId ?? Guid.NewGuid(),
            CityId = cityId ?? Guid.NewGuid(),
            ConsultationFee = consultationFee,
            DetailedAddress = detailedAddress,
            AppointmentDurationMinutes = appointmentDurationMinutes,
            MaxAdvanceBookingDays = maxAdvanceBookingDays,
            PhoneNumbers = phoneNumbers,
            WorkingPeriods = workingPeriods
        };
    }

    #region CreateClinicRequestValidator - Core Fields

    /// <summary>
    /// A minimal valid creation request without optional collections must pass.
    /// </summary>
    [Fact]
    public void Validate_ValidCreateRequest_ShouldPass()
    {
        // Arrange using the valid baseline payload.
        var request = BuildCreateRequest();

        // Act
        var result = _createValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeTrue();
    }

    /// <summary>
    /// A missing clinic name must be rejected with the dedicated error code.
    /// </summary>
    [Theory]
    [InlineData(null)]
    [InlineData("")]
    [InlineData("   ")]
    public void Validate_MissingName_ShouldFail(string? name)
    {
        // Arrange with an absent clinic name.
        var request = BuildCreateRequest(name: name);

        // Act
        var result = _createValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.name.required");
    }

    /// <summary>
    /// Names longer than two hundred characters must be rejected.
    /// </summary>
    [Fact]
    public void Validate_NameExceedsMaxLength_ShouldFail()
    {
        // Arrange with a name one character over the limit.
        var request = BuildCreateRequest(name: new string('N', ClinicConstants.NameMaxLength + 1));

        // Act
        var result = _createValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.name.length_invalid");
    }

    /// <summary>
    /// Missing governorate or city references must be rejected.
    /// </summary>
    [Fact]
    public void Validate_MissingGovernorateOrCity_ShouldFail()
    {
        // Arrange without location identifiers (built inline to preserve explicit nulls).
        var request = new CreateClinicRequest
        {
            Name = "El Nour Dental Clinic",
            GovernorateId = null,
            CityId = null,
            ConsultationFee = 250m,
            AppointmentDurationMinutes = 30,
            MaxAdvanceBookingDays = 14
        };

        // Act
        var result = _createValidator.Validate(request);

        // Assert both location rules fail.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.governorate.not_found");
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.city.not_found");
    }

    /// <summary>
    /// A missing consultation fee must be rejected.
    /// </summary>
    [Fact]
    public void Validate_MissingConsultationFee_ShouldFail()
    {
        // Arrange without a fee value.
        var request = BuildCreateRequest(consultationFee: null);

        // Act
        var result = _createValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.consultation_fee.required");
    }

    /// <summary>
    /// Zero or negative consultation fees must be rejected.
    /// </summary>
    [Theory]
    [InlineData(0)]
    [InlineData(-50)]
    public void Validate_NonPositiveConsultationFee_ShouldFail(decimal fee)
    {
        // Arrange with a non-positive fee.
        var request = BuildCreateRequest(consultationFee: fee);

        // Act
        var result = _createValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.consultation_fee.invalid");
    }

    /// <summary>
    /// Detailed address longer than five hundred characters must be rejected.
    /// </summary>
    [Fact]
    public void Validate_DetailedAddressExceedsMaxLength_ShouldFail()
    {
        // Arrange with an address one character over the limit.
        var request = BuildCreateRequest(detailedAddress: new string('A', ClinicConstants.DetailedAddressMaxLength + 1));

        // Act
        var result = _createValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.address.length_invalid");
    }

    #endregion

    #region CreateClinicRequestValidator - Booking Settings

    /// <summary>
    /// Every documented allowed appointment duration must pass.
    /// </summary>
    [Theory]
    [InlineData(10)]
    [InlineData(15)]
    [InlineData(20)]
    [InlineData(30)]
    [InlineData(45)]
    [InlineData(60)]
    public void Validate_AllowedDurationMinutes_ShouldPass(int duration)
    {
        // Arrange with an allowed duration value.
        var request = BuildCreateRequest(appointmentDurationMinutes: duration);

        // Act
        var result = _createValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeTrue();
    }

    /// <summary>
    /// Durations outside the allowed set must be rejected.
    /// </summary>
    [Theory]
    [InlineData(25)]
    [InlineData(90)]
    public void Validate_DisallowedDurationMinutes_ShouldFail(int duration)
    {
        // Arrange with a duration that is not in the allowed set.
        var request = BuildCreateRequest(appointmentDurationMinutes: duration);

        // Act
        var result = _createValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.duration.invalid");
    }

    /// <summary>
    /// Every documented allowed advance booking window must pass.
    /// </summary>
    [Theory]
    [InlineData(7)]
    [InlineData(14)]
    [InlineData(21)]
    [InlineData(30)]
    [InlineData(60)]
    [InlineData(90)]
    public void Validate_AllowedAdvanceBookingDays_ShouldPass(int days)
    {
        // Arrange with an allowed advance booking value.
        var request = BuildCreateRequest(maxAdvanceBookingDays: days);

        // Act
        var result = _createValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeTrue();
    }

    /// <summary>
    /// Advance booking windows outside the allowed set must be rejected.
    /// </summary>
    [Theory]
    [InlineData(10)]
    [InlineData(120)]
    public void Validate_DisallowedAdvanceBookingDays_ShouldFail(int days)
    {
        // Arrange with a disallowed booking window.
        var request = BuildCreateRequest(maxAdvanceBookingDays: days);

        // Act
        var result = _createValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.advance_booking.invalid");
    }

    #endregion

    #region CreateClinicRequestValidator - Phone Numbers

    /// <summary>
    /// More phone numbers than the configured maximum must be rejected.
    /// </summary>
    [Fact]
    public void Validate_TooManyPhoneNumbers_ShouldFail()
    {
        // Arrange with six distinct phone numbers (one over the limit of five).
        var phones = new List<ClinicPhoneNumberDto>();
        for (int index = 0; index <= ClinicConstants.MaxPhoneNumbersPerClinic; index++)
        {
            // Add a unique valid phone entry per iteration.
            phones.Add(new ClinicPhoneNumberDto { PhoneNumber = $"+20101234{index:D4}", Label = $"Line {index}" });
        }

        var request = BuildCreateRequest(phoneNumbers: phones);

        // Act
        var result = _createValidator.Validate(request);

        // Assert the maximum-count rule fails.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.phone.max_exceeded");
    }

    /// <summary>
    /// Duplicate phone numbers within the collection must be rejected.
    /// </summary>
    [Fact]
    public void Validate_DuplicatePhoneNumbers_ShouldFail()
    {
        // Arrange with the same number repeated twice.
        var duplicatedNumber = "+20101234567";
        var request = BuildCreateRequest(phoneNumbers: new List<ClinicPhoneNumberDto>
        {
            new() { PhoneNumber = duplicatedNumber, Label = "Main" },
            new() { PhoneNumber = duplicatedNumber, Label = "Backup" }
        });

        // Act
        var result = _createValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.phone.duplicate");
    }

    /// <summary>
    /// An individual phone entry without a number must be rejected.
    /// </summary>
    [Fact]
    public void Validate_PhoneEntryMissingNumber_ShouldFail()
    {
        // Arrange with one entry lacking its number.
        var request = BuildCreateRequest(phoneNumbers: new List<ClinicPhoneNumberDto>
        {
            new() { PhoneNumber = "", Label = "Main" }
        });

        // Act
        var result = _createValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.phone.number_required");
    }

    /// <summary>
    /// A malformed phone number must be rejected by the format rule.
    /// </summary>
    [Fact]
    public void Validate_PhoneEntryInvalidFormat_ShouldFail()
    {
        // Arrange with letters embedded in the number.
        var request = BuildCreateRequest(phoneNumbers: new List<ClinicPhoneNumberDto>
        {
            new() { PhoneNumber = "not-a-phone", Label = "Main" }
        });

        // Act
        var result = _createValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.phone.format_invalid");
    }

    /// <summary>
    /// A phone entry without a label must be rejected.
    /// </summary>
    [Fact]
    public void Validate_PhoneEntryMissingLabel_ShouldFail()
    {
        // Arrange with a number but no label.
        var request = BuildCreateRequest(phoneNumbers: new List<ClinicPhoneNumberDto>
        {
            new() { PhoneNumber = "+201012345678", Label = "" }
        });

        // Act
        var result = _createValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.phone.label_required");
    }

    /// <summary>
    /// A label exceeding fifty characters must be rejected.
    /// </summary>
    [Fact]
    public void Validate_PhoneLabelExceedsMaxLength_ShouldFail()
    {
        // Arrange with an over-limit label.
        var request = BuildCreateRequest(phoneNumbers: new List<ClinicPhoneNumberDto>
        {
            new() { PhoneNumber = "+201012345678", Label = new string('L', ClinicConstants.PhoneLabelMaxLength + 1) }
        });

        // Act
        var result = _createValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.phone.label_length_invalid");
    }

    #endregion

    #region CreateClinicRequestValidator - Working Periods

    /// <summary>
    /// An invalid nested working period must surface through the create validator.
    /// </summary>
    [Fact]
    public void Validate_CreateWithInvalidWorkingPeriod_ShouldFail()
    {
        // Arrange with a period whose end precedes its start.
        var request = BuildCreateRequest(workingPeriods: new List<WorkingPeriodRequest>
        {
            new() { DayOfWeek = 6, StartTime = "18:00", EndTime = "09:00" }
        });

        // Act
        var result = _createValidator.Validate(request);

        // Assert the nested validator failure propagates.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.working_period.invalid_time_range");
    }

    #endregion

    #region UpdateClinicRequestValidator

    /// <summary>
    /// A partial update containing only nullable fields must pass.
    /// </summary>
    [Fact]
    public void Validate_EmptyUpdateRequest_ShouldPass()
    {
        // Arrange with every field left unset.
        var request = new UpdateClinicRequest();

        // Act
        var result = _updateValidator.Validate(request);

        // Assert partial updates are accepted.
        result.IsValid.Should().BeTrue();
    }

    /// <summary>
    /// An updated name over the maximum length must be rejected.
    /// </summary>
    [Fact]
    public void Validate_UpdateNameExceedsMaxLength_ShouldFail()
    {
        // Arrange with an over-limit name on update.
        var request = new UpdateClinicRequest { Name = new string('N', ClinicConstants.NameMaxLength + 1) };

        // Act
        var result = _updateValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.name.length_invalid");
    }

    /// <summary>
    /// A non-positive fee supplied to an update must be rejected.
    /// </summary>
    [Fact]
    public void Validate_UpdateNonPositiveFee_ShouldFail()
    {
        // Arrange with a zero fee on update.
        var request = new UpdateClinicRequest { ConsultationFee = 0m };

        // Act
        var result = _updateValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.consultation_fee.invalid");
    }

    /// <summary>
    /// A disallowed duration supplied to an update must be rejected.
    /// </summary>
    [Fact]
    public void Validate_UpdateDisallowedDuration_ShouldFail()
    {
        // Arrange with a duration not in the allowed set.
        var request = new UpdateClinicRequest { AppointmentDurationMinutes = 35 };

        // Act
        var result = _updateValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.duration.invalid");
    }

    /// <summary>
    /// A disallowed advance booking window supplied to an update must be rejected.
    /// </summary>
    [Fact]
    public void Validate_UpdateDisallowedAdvanceBookingDays_ShouldFail()
    {
        // Arrange with a booking window not in the allowed set.
        var request = new UpdateClinicRequest { MaxAdvanceBookingDays = 45 };

        // Act
        var result = _updateValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.advance_booking.invalid");
    }

    /// <summary>
    /// Only Active (0) and Inactive (1) statuses are accepted on update.
    /// </summary>
    [Theory]
    [InlineData(0, true)]
    [InlineData(1, true)]
    [InlineData(2, false)]
    [InlineData(-1, false)]
    public void Validate_UpdateStatusValues_ShouldMatchExpectedOutcome(int status, bool expectedValid)
    {
        // Arrange with the status under test.
        var request = new UpdateClinicRequest { Status = status };

        // Act
        var result = _updateValidator.Validate(request);

        // Assert only defined enum values pass.
        result.IsValid.Should().Be(expectedValid);
        if (!expectedValid)
        {
            // Verify the dedicated status error is present on failure.
            result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.status.invalid");
        }
        else
        {
            // No action needed.
        }
    }

    /// <summary>
    /// A fully populated valid update payload must pass every rule.
    /// </summary>
    [Fact]
    public void Validate_FullyPopulatedUpdateRequest_ShouldPass()
    {
        // Arrange with every field populated to a valid value.
        var request = new UpdateClinicRequest
        {
            Name = "Updated Clinic",
            GovernorateId = Guid.NewGuid(),
            CityId = Guid.NewGuid(),
            DetailedAddress = "New address",
            ConsultationFee = 300m,
            AppointmentDurationMinutes = 45,
            MaxAdvanceBookingDays = 30,
            Status = 1
        };

        // Act
        var result = _updateValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeTrue();
    }

    #endregion

    #region WorkingPeriodRequestValidator

    /// <summary>
    /// A well-formed working period must pass.
    /// </summary>
    [Fact]
    public void Validate_ValidWorkingPeriod_ShouldPass()
    {
        // Arrange with a normal business-hours period.
        var request = new WorkingPeriodRequest { DayOfWeek = 0, StartTime = "09:00", EndTime = "17:00" };

        // Act
        var result = _workingPeriodValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeTrue();
    }

    /// <summary>
    /// Day-of-week values outside zero-to-six must be rejected.
    /// </summary>
    [Theory]
    [InlineData(-1)]
    [InlineData(7)]
    public void Validate_WorkingPeriodDayOutOfRange_ShouldFail(int dayOfWeek)
    {
        // Arrange with an out-of-range weekday.
        var request = new WorkingPeriodRequest { DayOfWeek = dayOfWeek, StartTime = "09:00", EndTime = "17:00" };

        // Act
        var result = _workingPeriodValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.working_period.invalid_time_range");
    }

    /// <summary>
    /// Malformed start or end time strings must be rejected.
    /// </summary>
    [Theory]
    [InlineData("notatime", "17:00")]
    [InlineData("09:00", "25:99")]
    public void Validate_WorkingPeriodInvalidTimeFormat_ShouldFail(string startTime, string endTime)
    {
        // Arrange with unparseable time strings.
        var request = new WorkingPeriodRequest { DayOfWeek = 1, StartTime = startTime, EndTime = endTime };

        // Act
        var result = _workingPeriodValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.working_period.invalid_time_range");
    }

    /// <summary>
    /// End times equal to or earlier than the start time must be rejected.
    /// </summary>
    [Theory]
    [InlineData("09:00", "09:00")]
    [InlineData("10:00", "09:30")]
    public void Validate_WorkingPeriodEndNotAfterStart_ShouldFail(string startTime, string endTime)
    {
        // Arrange with an inverted or zero-length period.
        var request = new WorkingPeriodRequest { DayOfWeek = 2, StartTime = startTime, EndTime = endTime };

        // Act
        var result = _workingPeriodValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.working_period.invalid_time_range");
    }

    /// <summary>
    /// More breaks than the configured maximum must be rejected.
    /// </summary>
    [Fact]
    public void Validate_TooManyBreaks_ShouldFail()
    {
        // Arrange with six identical breaks (one over the limit of five).
        var breaks = new List<BreakRequest>();
        for (int index = 0; index <= ClinicConstants.MaxBreaksPerWorkingPeriod; index++)
        {
            // Add a valid break per iteration up to the overflowing count.
            breaks.Add(new BreakRequest { StartTime = $"0{index}:00", EndTime = $"0{index}:15" });
        }

        var request = new WorkingPeriodRequest { DayOfWeek = 3, StartTime = "08:00", EndTime = "20:00", Breaks = breaks };

        // Act
        var result = _workingPeriodValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.break.max_exceeded");
    }

    /// <summary>
    /// A period containing valid breaks must pass.
    /// </summary>
    [Fact]
    public void Validate_WorkingPeriodWithValidBreaks_ShouldPass()
    {
        // Arrange with a lunch break inside business hours.
        var request = new WorkingPeriodRequest
        {
            DayOfWeek = 4,
            StartTime = "09:00",
            EndTime = "17:00",
            Breaks = new List<BreakRequest> { new() { StartTime = "13:00", EndTime = "14:00" } }
        };

        // Act
        var result = _workingPeriodValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeTrue();
    }

    #endregion

    #region BreakRequestValidator

    /// <summary>
    /// A well-formed break must pass.
    /// </summary>
    [Fact]
    public void Validate_ValidBreak_ShouldPass()
    {
        // Arrange with a short break range.
        var request = new BreakRequest { StartTime = "13:00", EndTime = "13:30" };

        // Act
        var result = _breakValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeTrue();
    }

    /// <summary>
    /// Break end times equal to or before the start time must be rejected.
    /// </summary>
    [Theory]
    [InlineData("13:00", "13:00")]
    [InlineData("14:00", "13:00")]
    public void Validate_BreakEndNotAfterStart_ShouldFail(string startTime, string endTime)
    {
        // Arrange with an invalid break range.
        var request = new BreakRequest { StartTime = startTime, EndTime = endTime };

        // Act
        var result = _breakValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.ErrorMessage == "clinic.working_period.invalid_time_range");
    }

    /// <summary>
    /// Empty or malformed break times must be rejected.
    /// </summary>
    [Fact]
    public void Validate_BreakInvalidTimeFormat_ShouldFail()
    {
        // Arrange with an unparseable start time.
        var request = new BreakRequest { StartTime = "", EndTime = "14:00" };

        // Act
        var result = _breakValidator.Validate(request);

        // Assert.
        result.IsValid.Should().BeFalse();
    }

    #endregion
}
