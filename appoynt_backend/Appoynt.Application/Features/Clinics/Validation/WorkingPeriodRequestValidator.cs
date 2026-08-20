/**
 * File Name      : WorkingPeriodRequestValidator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : FluentValidation, ClinicConstants, ClinicErrorCodes, WorkingPeriodRequest, BreakRequestValidator
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Defines validation rules for a clinic working period including day of week, hours range, and breaks.
 */

using System;
using System.Linq;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Features.Clinics.Contracts;
using Appoynt.Domain.Common.Constants;
using FluentValidation;

namespace Appoynt.Application.Features.Clinics.Validation;

/// <summary>
/// Validator for the <see cref="WorkingPeriodRequest"/> to validate working hours and breaks.
/// </summary>
public sealed class WorkingPeriodRequestValidator : AbstractValidator<WorkingPeriodRequest>
{
    /// <summary>
    /// Initializes a new instance of the <see cref="WorkingPeriodRequestValidator"/> class.
    /// </summary>
    public WorkingPeriodRequestValidator()
    {
        #region Day and Time Validation

        // Validates the day of week falls within the valid range (0-6).
        RuleFor(x => x.DayOfWeek)
            .NotNull().WithMessage(ClinicErrorCodes.WorkingPeriodNotFound)
            .InclusiveBetween(0, 6).WithMessage(ClinicErrorCodes.WorkingPeriodInvalidTimeRange);

        // Validates the start time is provided and in valid format.
        RuleFor(x => x.StartTime)
            .NotEmpty().WithMessage(ClinicErrorCodes.WorkingPeriodInvalidTimeRange)
            .Must(BeAValidTime).WithMessage(ClinicErrorCodes.WorkingPeriodInvalidTimeRange);

        // Validates the end time is provided and in valid format.
        RuleFor(x => x.EndTime)
            .NotEmpty().WithMessage(ClinicErrorCodes.WorkingPeriodInvalidTimeRange)
            .Must(BeAValidTime).WithMessage(ClinicErrorCodes.WorkingPeriodInvalidTimeRange);

        // Validates that end time is after start time.
        RuleFor(x => x)
            .Must(x => IsEndTimeAfterStartTime(x.StartTime, x.EndTime))
            .WithMessage(ClinicErrorCodes.WorkingPeriodInvalidTimeRange)
            .When(x => BeAValidTime(x.StartTime) && BeAValidTime(x.EndTime));

        #endregion

        #region Breaks Validation

        // Validates breaks if provided.
        When(x => x.Breaks != null && x.Breaks.Count > 0, () =>
        {
            RuleFor(x => x.Breaks)
                .Must(breaks => breaks!.Count <= ClinicConstants.MaxBreaksPerWorkingPeriod)
                .WithMessage(ClinicErrorCodes.BreakMaxExceeded);

            RuleForEach(x => x.Breaks)
                .SetValidator(new BreakRequestValidator());
        });

        #endregion
    }

    /// <summary>
    /// Checks if a string represents a valid time.
    /// </summary>
    /// <param name="timeStr">The time string to check.</param>
    /// <returns>True if the string is a valid time representation; otherwise, false.</returns>
    private static bool BeAValidTime(string? timeStr)
    {
        if (string.IsNullOrWhiteSpace(timeStr))
        {
            return false;
        }
        else
        {
            return TimeOnly.TryParse(timeStr, out _);
        }
    }

    /// <summary>
    /// Checks if the end time is after the start time.
    /// </summary>
    /// <param name="startTimeStr">The start time string.</param>
    /// <param name="endTimeStr">The end time string.</param>
    /// <returns>True if the end time is strictly after the start time; otherwise, false.</returns>
    private static bool IsEndTimeAfterStartTime(string? startTimeStr, string? endTimeStr)
    {
        if (TimeOnly.TryParse(startTimeStr, out var startTime) && TimeOnly.TryParse(endTimeStr, out var endTime))
        {
            return endTime > startTime;
        }
        else
        {
            return false;
        }
    }
}
