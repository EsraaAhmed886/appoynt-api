/**
 * File Name      : CreateStaffRequestValidator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 28/07/2026
 * Version        : v1.0.0
 * Dependencies   : FluentValidation, CreateStaffRequest
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 28/07/2026
 * Description    : Defines validation rules for creating a staff account.
 */

using Appoynt.Application.Common.Constants;
using Appoynt.Application.Features.UserManagement.Contracts;
using FluentValidation;

namespace Appoynt.Application.Features.UserManagement.Validation;

/// <summary>
/// Validates the raw input submitted during staff creation.
/// </summary>
public sealed class CreateStaffRequestValidator : AbstractValidator<CreateStaffRequest>
{
    /// <summary>
    /// Initializes a new instance of the <see cref="CreateStaffRequestValidator"/> class.
    /// </summary>
    public CreateStaffRequestValidator()
    {
        RuleFor(request => request.FirstName)
            .NotEmpty().WithMessage(AuthenticationErrorCodes.FirstNameRequired)
            .MaximumLength(50).WithMessage(AuthenticationErrorCodes.FirstNameLengthInvalid);

        RuleFor(request => request.LastName)
            .NotEmpty().WithMessage(AuthenticationErrorCodes.LastNameRequired)
            .MaximumLength(50).WithMessage(AuthenticationErrorCodes.LastNameLengthInvalid);

        RuleFor(request => request.Email)
            .NotEmpty().WithMessage(AuthenticationErrorCodes.EmailRequired)
            .EmailAddress().WithMessage(AuthenticationErrorCodes.EmailInvalid);

        RuleFor(request => request.PhoneNumber)
            .NotEmpty().WithMessage(AuthenticationErrorCodes.PhoneRequired)
            .Matches(@"^\+?[1-9]\d{1,14}$").WithMessage(AuthenticationErrorCodes.PhoneFormatInvalid);

        RuleFor(request => request.Password)
            .NotEmpty().WithMessage(AuthenticationErrorCodes.PasswordRequired)
            .MinimumLength(8).WithMessage(AuthenticationErrorCodes.PasswordComplexityInvalid)
            .Matches(@"[A-Z]+").WithMessage(AuthenticationErrorCodes.PasswordComplexityInvalid)
            .Matches(@"[a-z]+").WithMessage(AuthenticationErrorCodes.PasswordComplexityInvalid)
            .Matches(@"[0-9]+").WithMessage(AuthenticationErrorCodes.PasswordComplexityInvalid)
            .Matches(@"[\!\?\*\.]+").WithMessage(AuthenticationErrorCodes.PasswordComplexityInvalid);
    }
}
