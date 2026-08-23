/**
 * File Name      : UpdatePatientPhoneNumberValidator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : FluentValidation, Appoynt.Application.Common.Constants, Appoynt.Domain.Common.Constants
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-23
 * Description    : Validator for the update patient phone number request.
 */

using Appoynt.Application.Common.Constants;
using Appoynt.Application.Features.Patient.Contracts;
using Appoynt.Domain.Common.Constants;
using FluentValidation;

namespace Appoynt.Application.Features.Patient.Validation;

/// <summary>
/// Validates the <see cref="UpdatePatientPhoneNumberRequest"/>.
/// </summary>
public class UpdatePatientPhoneNumberValidator : AbstractValidator<UpdatePatientPhoneNumberRequest>
{
    /// <summary>
    /// Initializes a new instance of the <see cref="UpdatePatientPhoneNumberValidator"/> class.
    /// </summary>
    public UpdatePatientPhoneNumberValidator()
    {
        RuleFor(x => x.PhoneNumber)
            .NotEmpty().WithMessage(AuthenticationErrorCodes.PhoneRequired)
            .Length(UserConstants.PhoneNumberLength).WithMessage(AuthenticationErrorCodes.PhoneLengthInvalid)
            .Must(x => x != null && x.StartsWith(UserConstants.PhonePrefix)).WithMessage(AuthenticationErrorCodes.PhonePrefixInvalid)
            .Matches("^[0-9]+$").WithMessage(AuthenticationErrorCodes.PhoneFormatInvalid);
    }
}
