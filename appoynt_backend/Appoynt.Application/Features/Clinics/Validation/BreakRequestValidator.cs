/**
 * File Name      : BreakRequestValidator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : FluentValidation, ClinicConstants, ClinicErrorCodes, BreakRequest
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Defines validation rules for a clinic break within a working period.
 */

using System;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Features.Clinics.Contracts;
using FluentValidation;

namespace Appoynt.Application.Features.Clinics.Validation;

/// <summary>
/// Validator for the <see cref="BreakRequest"/> to ensure valid break times.
/// </summary>
public sealed class BreakRequestValidator : AbstractValidator<BreakRequest>
{
    /// <summary>
    /// Initializes a new instance of the <see cref="BreakRequestValidator"/> class.
    /// </summary>
    public BreakRequestValidator()
    {
        #region Time Range Validation

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
