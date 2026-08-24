/**
 * File Name      : AddDoctorPhoneNumberValidator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : FluentValidation
 *                  Appoynt.Application.Features.Doctor.Contracts
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-23
 * Description    : Validator for AddDoctorPhoneNumberRequest.
 */

using System;
using System.Linq;
using Appoynt.Application.Common.Constants;
using Appoynt.Domain.Common.Constants;
using FluentValidation;
using Appoynt.Application.Features.Doctor.Contracts;

namespace Appoynt.Application.Features.Doctor.Validation;

/// <summary>
/// Validates the request to add a doctor phone number.
/// </summary>
public class AddDoctorPhoneNumberValidator : AbstractValidator<AddDoctorPhoneNumberRequest>
{
    /// <summary>
    /// Initializes a new instance of the <see cref="AddDoctorPhoneNumberValidator"/> class.
    /// </summary>
    public AddDoctorPhoneNumberValidator()
    {
        RuleFor(x => x.PhoneNumber)
            .NotEmpty().WithMessage(DoctorErrorCodes.PhoneNumberRequired)
            .Must(IsValidEgyptianPhoneNumber).WithMessage(DoctorErrorCodes.PhoneNumberFormatInvalid);

        RuleFor(x => x.Label)
            .MaximumLength(50).WithMessage(DoctorErrorCodes.PhoneLabelLengthInvalid)
            .When(x => !string.IsNullOrEmpty(x.Label));
    }

    /// <summary>
    /// Validates if the provided string is a valid Egyptian mobile number.
    /// Matches existing registration rules.
    /// </summary>
    /// <param name="phoneNumber">The phone number to validate.</param>
    /// <returns>True if valid; otherwise, false.</returns>
    private bool IsValidEgyptianPhoneNumber(string phoneNumber)
    {
        if (string.IsNullOrEmpty(phoneNumber))
        {
            return false;
        }
        else
        {
            // No action required.
        }

        string normalized = phoneNumber.StartsWith("+20") ? "0" + phoneNumber.Substring(3) : phoneNumber;

        if (normalized.Length != 11)
        {
            return false;
        }
        else
        {
            // No action required.
        }

        if (!normalized.StartsWith("01", StringComparison.Ordinal))
        {
            return false;
        }
        else
        {
            // No action required.
        }

        if (normalized[2] is not ('0' or '1' or '2' or '5'))
        {
            return false;
        }
        else
        {
            // No action required.
        }

        if (normalized.Any(c => !char.IsDigit(c)))
        {
            return false;
        }
        else
        {
            // No action required.
        }

        return true;
    }
}

