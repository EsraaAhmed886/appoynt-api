/**
 * File Name      : UpdateUserRequestValidator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 28/07/2026
 * Version        : v1.0.0
 * Dependencies   : FluentValidation
 * Last Modified  : Mustafa Mahmoud - 2026-08-30
 * Description    : Validates the UpdateUserRequest payload.
 */

using Appoynt.Application.Common.Constants;
using Appoynt.Application.Features.UserManagement.Contracts;
using FluentValidation;

namespace Appoynt.Application.Features.UserManagement.Validation;

/// <summary>
/// Validates user profile update request payloads.
/// </summary>
public sealed class UpdateUserRequestValidator : AbstractValidator<UpdateUserRequest>
{
    /// <summary>
    /// Initializes validation rules for user update requests.
    /// </summary>
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
    }
}
