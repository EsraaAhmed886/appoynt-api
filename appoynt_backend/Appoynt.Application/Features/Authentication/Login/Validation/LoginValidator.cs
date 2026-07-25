/**
 * File Name      : LoginValidator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : NormalizedLoginRequest
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Validates normalized account-login input without exposing
 *                  field-specific failures.
 */

using System.ComponentModel.DataAnnotations;

namespace Appoynt.Application.Features.Authentication.Login.Validation;

/// <summary>
/// Validates normalized login input according to the approved submit-time
/// login requirements.
/// </summary>
public static class LoginValidator
{
    private const int PhoneNumberLength = 11;

    /// <summary>
    /// Determines whether the submitted login input is structurally valid.
    /// Callers must return the same generic authentication error for every
    /// <see langword="false"/> result.
    /// </summary>
    /// <param name="request">The normalized login input.</param>
    /// <returns><see langword="true"/> when the input is structurally valid.</returns>
    public static bool IsValid(NormalizedLoginRequest request)
    {
        ArgumentNullException.ThrowIfNull(request);

        if (string.IsNullOrEmpty(request.Identifier) ||
            string.IsNullOrEmpty(request.Password))
        {
            return false;
        }

        return request.IsEmailIdentifier
            ? new EmailAddressAttribute().IsValid(request.Identifier)
            : IsValidPhoneNumber(request);
    }

    /// <summary>
    /// Determines whether a normalized phone identifier has the approved
    /// Egyptian mobile-phone format.
    /// </summary>
    private static bool IsValidPhoneNumber(NormalizedLoginRequest request)
    {
        string phoneNumber = request.PhoneNumber;

        return !request.PhoneNumberContainsUnsupportedCharacters &&
               phoneNumber.Length == PhoneNumberLength &&
               phoneNumber.StartsWith("01", StringComparison.Ordinal) &&
               phoneNumber[2] is '0' or '1' or '2' or '5' &&
               phoneNumber.All(character => character is >= '0' and <= '9');
    }
}
