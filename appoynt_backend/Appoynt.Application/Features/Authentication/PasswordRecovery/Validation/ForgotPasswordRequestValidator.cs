/**
 * File Name      : ForgotPasswordRequestValidator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 27/07/2026
 * Version        : v1.0.0
 * Dependencies   : AuthenticationErrorCodes, AuthenticationError, ForgotPasswordRequest
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 27/07/2026
 * Description    : Validates the forgot password request payload.
 */

using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Authentication.PasswordRecovery.Contracts;

namespace Appoynt.Application.Features.Authentication.PasswordRecovery.Validation;

/// <summary>
/// Validates forgot password requests.
/// </summary>
public static class ForgotPasswordRequestValidator
{
    /// <summary>
    /// Validates the forgot password request.
    /// </summary>
    /// <param name="request">The request to validate.</param>
    /// <returns>A list of validation errors, if any.</returns>
    public static IReadOnlyList<AuthenticationError> Validate(ForgotPasswordRequest request)
    {
        ArgumentNullException.ThrowIfNull(request);

        var errors = new List<AuthenticationError>();

        if (string.IsNullOrWhiteSpace(request.Identifier))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PasswordRecoveryRequestInvalid,
                nameof(request.Identifier)));
        }

        return errors;
    }
}
