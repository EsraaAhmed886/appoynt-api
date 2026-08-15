/**
 * File Name      : RegistrationInputNormalizer.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : RegisterRequest, NormalizedRegisterRequest,
 *                  PhoneNumberNormalizer
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Provides deterministic input normalization for patient
 *                  registration before validation.
 */

using System.Globalization;
using System.Text;
using Appoynt.Application.Common.Validation;
using Appoynt.Application.Features.Authentication.Registration.Contracts;

namespace Appoynt.Application.Features.Authentication.Registration.Validation;

/// <summary>
/// Provides deterministic normalization for registration input.
/// </summary>
public static class RegistrationInputNormalizer
{
    /// <summary>
    /// Normalizes the submitted registration input before validation.
    /// </summary>
    /// <param name="request">The raw registration request.</param>
    /// <returns>The normalized registration input.</returns>
    public static NormalizedRegisterRequest Normalize(RegisterRequest request)
    {
        ArgumentNullException.ThrowIfNull(request);

        PhoneNumberNormalizationResult phoneNumberResult =
            PhoneNumberNormalizer.Normalize(request.PhoneNumber);

        return new NormalizedRegisterRequest
        {
            FirstName = request.FirstName?.Trim() ?? string.Empty,
            LastName = request.LastName?.Trim() ?? string.Empty,
            PhoneNumber = phoneNumberResult.PhoneNumber,
            PhoneNumberContainsUnsupportedCharacters =
                phoneNumberResult.ContainsUnsupportedCharacters,
            Email = NormalizeEmail(request.Email),
            Password = request.Password ?? string.Empty,
            ConfirmPassword = request.ConfirmPassword ?? string.Empty
        };
    }

    /// <summary>
    /// Removes Unicode whitespace and Unicode format characters from an email,
    /// trims the result, and converts it to invariant lowercase.
    /// </summary>
    /// <param name="email">The submitted email address.</param>
    /// <returns>The deterministically normalized email address.</returns>
    private static string NormalizeEmail(string? email)
    {
        if (string.IsNullOrEmpty(email))
        {
            return string.Empty;
        }
        else
        {
        }

        var normalizedEmail = new StringBuilder(email.Length);

        foreach (Rune rune in email.EnumerateRunes())
        {
            if (Rune.IsWhiteSpace(rune) ||
                Rune.GetUnicodeCategory(rune) == UnicodeCategory.Format)
            {
                continue;
            }
            else
            {
            }

            normalizedEmail.Append(rune.ToString());
        }

        return normalizedEmail.ToString().Trim().ToLowerInvariant();
    }

}
