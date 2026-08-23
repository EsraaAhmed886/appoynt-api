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
            .NotEmpty().WithMessage("First name is required.")
            .MaximumLength(100).WithMessage("First name must not exceed 100 characters.");

        RuleFor(x => x.LastName)
            .NotEmpty().WithMessage("Last name is required.")
            .MaximumLength(100).WithMessage("Last name must not exceed 100 characters.");

        RuleFor(x => x.NameAr)
            .MaximumLength(100).WithMessage("Arabic name must not exceed 100 characters.")
            .When(x => !string.IsNullOrEmpty(x.NameAr));

        RuleFor(x => x.NameEn)
            .MaximumLength(100).WithMessage("English name must not exceed 100 characters.")
            .When(x => !string.IsNullOrEmpty(x.NameEn));

        RuleFor(x => x.Bio)
            .MaximumLength(2000).WithMessage("Bio must not exceed 2000 characters.")
            .When(x => !string.IsNullOrEmpty(x.Bio));

        RuleFor(x => x.Education)
            .MaximumLength(1000).WithMessage("Education must not exceed 1000 characters.")
            .When(x => !string.IsNullOrEmpty(x.Education));

        RuleFor(x => x.BirthDate)
            .LessThan(DateOnly.FromDateTime(DateTime.UtcNow)).WithMessage("Birth date must be in the past.")
            .When(x => x.BirthDate.HasValue);

        RuleFor(x => x.SpecializationIds)
            .Must(ids => ids != null && ids.Any()).WithMessage("At least one specialization is required.")
            .Must(ids => ids.Distinct().Count() == ids.Count).WithMessage("Duplicate specializations are not allowed.");
    }
}
