/**
 * File Name      : UpdateDoctorProfileValidator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : FluentValidation
 *                  Appoynt.Application.Features.Doctor.Contracts
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-23
 * Description    : Validator for UpdateDoctorProfileRequest.
 */

using System;
using System.Linq;
using Appoynt.Application.Common.Constants;
using Appoynt.Domain.Common.Constants;
using FluentValidation;
using Appoynt.Application.Features.Doctor.Contracts;

namespace Appoynt.Application.Features.Doctor.Validation;

/// <summary>
/// Validates the request to update a doctor's profile.
/// </summary>
public class UpdateDoctorProfileValidator : AbstractValidator<UpdateDoctorProfileRequest>
{
    /// <summary>
    /// Initializes a new instance of the <see cref="UpdateDoctorProfileValidator"/> class.
    /// </summary>
    public UpdateDoctorProfileValidator()
    {
        RuleFor(x => x.FirstName)
            .NotEmpty().WithMessage(AuthenticationErrorCodes.FirstNameRequired)
            .MaximumLength(100).WithMessage(AuthenticationErrorCodes.FirstNameLengthInvalid);

        RuleFor(x => x.LastName)
            .NotEmpty().WithMessage(AuthenticationErrorCodes.LastNameRequired)
            .MaximumLength(100).WithMessage(AuthenticationErrorCodes.LastNameLengthInvalid);

        RuleFor(x => x.NameAr)
            .MaximumLength(100).WithMessage(DoctorErrorCodes.NameArLengthInvalid)
            .When(x => !string.IsNullOrEmpty(x.NameAr));

        RuleFor(x => x.NameEn)
            .MaximumLength(100).WithMessage(DoctorErrorCodes.NameEnLengthInvalid)
            .When(x => !string.IsNullOrEmpty(x.NameEn));

        RuleFor(x => x.Bio)
            .MaximumLength(2000).WithMessage(DoctorErrorCodes.BioLengthInvalid)
            .When(x => !string.IsNullOrEmpty(x.Bio));

        RuleFor(x => x.Education)
            .MaximumLength(1000).WithMessage(DoctorErrorCodes.EducationLengthInvalid)
            .When(x => !string.IsNullOrEmpty(x.Education));

        RuleFor(x => x.BirthDate)
            .LessThan(DateOnly.FromDateTime(DateTime.UtcNow)).WithMessage(DoctorErrorCodes.BirthDateInvalid)
            .When(x => x.BirthDate.HasValue);

        RuleFor(x => x.SpecializationIds)
            .Must(ids => ids != null && ids.Any()).WithMessage(DoctorErrorCodes.SpecializationRequired)
            .Must(ids => ids.Distinct().Count() == ids.Count).WithMessage(DoctorErrorCodes.SpecializationDuplicate);
    }
}


