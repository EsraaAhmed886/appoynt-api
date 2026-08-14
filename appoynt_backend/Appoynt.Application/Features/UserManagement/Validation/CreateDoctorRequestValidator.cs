/**
 * File Name      : CreateDoctorRequestValidator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : FluentValidation, CreateDoctorRequest, DoctorConstants, UserConstants, DoctorErrorCodes, AuthenticationErrorCodes
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Defines validation rules for creating a doctor account, including
 *                  Identity fields, display names, biography, education, and phone numbers.
 */

using System.Linq;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Features.UserManagement.Contracts;
using Appoynt.Domain.Common.Constants;
using FluentValidation;

namespace Appoynt.Application.Features.UserManagement.Validation;

/// <summary>
/// Validates the input submitted during doctor account creation.
/// </summary>
public sealed class CreateDoctorRequestValidator : AbstractValidator<CreateDoctorRequest>
{
    /// <summary>
    /// Initializes a new instance of the <see cref="CreateDoctorRequestValidator"/> class.
    /// </summary>
    public CreateDoctorRequestValidator()
    {
        #region Base User Fields

        RuleFor(request => request.FirstName)
            .NotEmpty().WithMessage(AuthenticationErrorCodes.FirstNameRequired)
            .MaximumLength(UserConstants.NameMaxLength).WithMessage(AuthenticationErrorCodes.FirstNameLengthInvalid);

        RuleFor(request => request.LastName)
            .NotEmpty().WithMessage(AuthenticationErrorCodes.LastNameRequired)
            .MaximumLength(UserConstants.NameMaxLength).WithMessage(AuthenticationErrorCodes.LastNameLengthInvalid);

        RuleFor(request => request.Email)
            .NotEmpty().WithMessage(AuthenticationErrorCodes.EmailRequired)
            .EmailAddress().WithMessage(AuthenticationErrorCodes.EmailInvalid);

        RuleFor(request => request.PhoneNumber)
            .NotEmpty().WithMessage(AuthenticationErrorCodes.PhoneRequired)
            .Matches(@"^\+?[1-9]\d{1,14}$").WithMessage(AuthenticationErrorCodes.PhoneFormatInvalid);

        RuleFor(request => request.Password)
            .NotEmpty().WithMessage(AuthenticationErrorCodes.PasswordRequired)
            .MinimumLength(UserConstants.PasswordMinLength).WithMessage(AuthenticationErrorCodes.PasswordComplexityInvalid)
            .Matches(@"[A-Z]+").WithMessage(AuthenticationErrorCodes.PasswordComplexityInvalid)
            .Matches(@"[a-z]+").WithMessage(AuthenticationErrorCodes.PasswordComplexityInvalid)
            .Matches(@"[0-9]+").WithMessage(AuthenticationErrorCodes.PasswordComplexityInvalid)
            .Matches(@"[\!\?\*\.]+").WithMessage(AuthenticationErrorCodes.PasswordComplexityInvalid);

        #endregion

        #region Doctor Profile Fields

        RuleFor(request => request.NameAr)
            .NotEmpty().WithMessage(DoctorErrorCodes.NameArRequired)
            .MaximumLength(DoctorConstants.NameMaxLength).WithMessage(DoctorErrorCodes.NameArLengthInvalid);

        RuleFor(request => request.NameEn)
            .NotEmpty().WithMessage(DoctorErrorCodes.NameEnRequired)
            .MaximumLength(DoctorConstants.NameMaxLength).WithMessage(DoctorErrorCodes.NameEnLengthInvalid);

        RuleFor(request => request.Bio)
            .MaximumLength(DoctorConstants.BioMaxLength).WithMessage(DoctorErrorCodes.BioLengthInvalid)
            .When(request => !string.IsNullOrEmpty(request.Bio));

        RuleFor(request => request.Education)
            .MaximumLength(DoctorConstants.EducationMaxLength).WithMessage(DoctorErrorCodes.EducationLengthInvalid)
            .When(request => !string.IsNullOrEmpty(request.Education));

        #endregion

        #region Phone Numbers Collection

        When(request => request.PhoneNumbers != null && request.PhoneNumbers.Count > 0, () =>
        {
            RuleFor(request => request.PhoneNumbers!.Count)
                .LessThanOrEqualTo(DoctorConstants.MaxPhoneNumbersPerDoctor)
                .WithMessage(DoctorErrorCodes.MaxPhoneNumbersExceeded);

            RuleFor(request => request.PhoneNumbers!)
                .Must(phones => phones.Select(p => p.PhoneNumber).Distinct().Count() == phones.Count)
                .WithMessage(DoctorErrorCodes.DuplicatePhoneNumber);

            RuleForEach(request => request.PhoneNumbers)
                .ChildRules(phone =>
                {
                    phone.RuleFor(p => p.PhoneNumber)
                        .NotEmpty().WithMessage(DoctorErrorCodes.PhoneNumberRequired)
                        .Matches(@"^\+?[1-9]\d{1,14}$").WithMessage(DoctorErrorCodes.PhoneNumberFormatInvalid);

                    phone.RuleFor(p => p.Label)
                        .NotEmpty().WithMessage(DoctorErrorCodes.PhoneLabelRequired)
                        .MaximumLength(DoctorConstants.PhoneLabelMaxLength).WithMessage(DoctorErrorCodes.PhoneLabelLengthInvalid);
                });
        });

        #endregion
    }
}
