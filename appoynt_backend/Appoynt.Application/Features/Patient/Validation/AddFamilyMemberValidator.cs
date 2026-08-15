/**
 * File Name      : AddFamilyMemberValidator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : FluentValidation, Appoynt.Application.Features.Patient.Contracts, Appoynt.Application.Common.Constants, Appoynt.Domain.Common.Constants, Appoynt.Domain.Enums
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Validator for the add family member request.
 */

using System;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Features.Patient.Contracts;
using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Enums;
using FluentValidation;

namespace Appoynt.Application.Features.Patient.Validation;

/// <summary>
/// Validates the <see cref="AddFamilyMemberRequest"/>.
/// </summary>
public class AddFamilyMemberValidator : AbstractValidator<AddFamilyMemberRequest>
{
    /// <summary>
    /// Initializes a new instance of the <see cref="AddFamilyMemberValidator"/> class.
    /// </summary>
    public AddFamilyMemberValidator()
    {
        // Full Name Validation
        RuleFor(x => x.FullName)
            .NotEmpty()
            .WithMessage(PatientErrorCodes.FamilyMemberFullNameRequired)
            .Length(PatientConstants.FullNameMinLength, PatientConstants.FullNameMaxLength)
            .WithMessage(PatientErrorCodes.FamilyMemberFullNameLengthInvalid);

        // Gender Validation
        RuleFor(x => x.Gender)
            .NotNull()
            .WithMessage(PatientErrorCodes.FamilyMemberGenderRequired)
            .IsInEnum()
            .WithMessage(PatientErrorCodes.FamilyMemberGenderInvalid);

        // Relationship Validation
        RuleFor(x => x.Relationship)
            .NotNull()
            .WithMessage(PatientErrorCodes.FamilyMemberRelationshipRequired)
            .IsInEnum()
            .WithMessage(PatientErrorCodes.FamilyMemberRelationshipInvalid)
            .Must(r => r != FamilyRelationship.User)
            .WithMessage(PatientErrorCodes.FamilyMemberRelationshipInvalid);

        // Birth Date Validation
        RuleFor(x => x.BirthDate)
            .NotNull()
            .WithMessage(PatientErrorCodes.FamilyMemberBirthDateRequired)
            .Must(date => date <= DateOnly.FromDateTime(DateTime.UtcNow))
            .WithMessage(PatientErrorCodes.FamilyMemberBirthDateInvalid);
    }
}
