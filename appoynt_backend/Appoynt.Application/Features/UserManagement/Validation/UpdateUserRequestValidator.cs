/**
 * File Name      : UpdateUserRequestValidator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 28/07/2026
 * Version        : v1.0.0
 * Dependencies   : FluentValidation
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 28/07/2026
 * Description    : Validates the UpdateUserRequest payload.
 */

using Appoynt.Application.Common.Constants;
using Appoynt.Application.Features.UserManagement.Contracts;
using FluentValidation;

namespace Appoynt.Application.Features.UserManagement.Validation;

public sealed class UpdateUserRequestValidator : AbstractValidator<UpdateUserRequest>
{
    public UpdateUserRequestValidator()
    {
        RuleFor(request => request.FirstName)
            .NotEmpty().WithMessage(AuthenticationErrorCodes.FirstNameRequired)
            .MaximumLength(50).WithMessage(AuthenticationErrorCodes.FirstNameLengthInvalid)
            .When(r => r.FirstName != null);

        RuleFor(request => request.LastName)
            .NotEmpty().WithMessage(AuthenticationErrorCodes.LastNameRequired)
            .MaximumLength(50).WithMessage(AuthenticationErrorCodes.LastNameLengthInvalid)
            .When(r => r.LastName != null);

        RuleFor(request => request.Address)
            .MaximumLength(200).WithMessage("Address must not exceed 200 characters.")
            .When(r => r.Address != null);
    }
}
