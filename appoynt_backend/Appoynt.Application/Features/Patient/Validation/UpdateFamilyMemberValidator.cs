/**
 * File Name      : UpdateFamilyMemberValidator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : FluentValidation, Appoynt.Application.Features.Patient.Contracts, Appoynt.Application.Common.Constants, Appoynt.Domain.Common.Constants, Appoynt.Domain.Enums
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Validator for the update family member request.
 */

using System;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Features.Patient.Contracts;
using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Enums;
using FluentValidation;

namespace Appoynt.Application.Features.Patient.Validation;

/// <summary>
/// Validates the <see cref="UpdateFamilyMemberRequest"/>.
/// </summary>
public class UpdateFamilyMemberValidator : AbstractValidator<UpdateFamilyMemberRequest>
{
    /// <summary>
    /// Initializes a new instance of the <see cref="UpdateFamilyMemberValidator"/> class.
    /// </summary>
    public UpdateFamilyMemberValidator()
    {
        // Full Name Validation
        RuleFor(x => x.FullName)
            .NotEmpty()
            .WithMessage(PatientErrorCodes.FamilyMemberFullNameRequired)
            .Length(PatientConstants.FullNameMinLength, PatientConstants.FullNameMaxLength)
            .WithMessage(PatientErrorCodes.FamilyMemberFullNameLengthInvalid)
            .When(x => x.FullName != null);

        // Gender Validation
        RuleFor(x => x.Gender)
            .IsInEnum()
            .WithMessage(PatientErrorCodes.FamilyMemberGenderInvalid)
            .When(x => x.Gender.HasValue);

        // Relationship Validation
        RuleFor(x => x.Relationship)
            .IsInEnum()
            .WithMessage(PatientErrorCodes.FamilyMemberRelationshipInvalid)
            .Must(r => r != FamilyRelationship.User)
            .WithMessage(PatientErrorCodes.FamilyMemberRelationshipInvalid)
            .When(x => x.Relationship.HasValue);

        // Birth Date Validation
        RuleFor(x => x.BirthDate)
            .Must(date => date <= DateOnly.FromDateTime(DateTime.UtcNow))
            .WithMessage(PatientErrorCodes.FamilyMemberBirthDateInvalid)
            .When(x => x.BirthDate.HasValue);
    }
}
