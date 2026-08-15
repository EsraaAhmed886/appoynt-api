/**
 * File Name      : LoginInputNormalizer.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : LoginRequest, NormalizedLoginRequest,
 *                  PhoneNumberNormalizer
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Provides deterministic input normalization for account
 *                  login before validation.
 */

using Appoynt.Application.Common.Validation;
using Appoynt.Application.Features.Authentication.Login.Contracts;

namespace Appoynt.Application.Features.Authentication.Login.Validation;

/// <summary>
/// Provides deterministic normalization for account-login input.
/// </summary>
public static class LoginInputNormalizer
{
    /// <summary>
    /// Trims the submitted identifier and normalizes phone identifiers to the
    /// canonical format used by registration and storage.
    /// </summary>
    /// <param name="request">The raw login request.</param>
    /// <returns>The normalized login input.</returns>
    public static NormalizedLoginRequest Normalize(LoginRequest request)
    {
        ArgumentNullException.ThrowIfNull(request);

        string identifier = request.Identifier?.Trim() ?? string.Empty;
        bool isEmailIdentifier = identifier.Contains('@', StringComparison.Ordinal);

        PhoneNumberNormalizationResult phoneNumberResult =
            isEmailIdentifier
                ? new PhoneNumberNormalizationResult(string.Empty, false)
                : PhoneNumberNormalizer.Normalize(identifier);

        return new NormalizedLoginRequest
        {
            Identifier = identifier,
            IsEmailIdentifier = isEmailIdentifier,
            PhoneNumber = phoneNumberResult.PhoneNumber,
            PhoneNumberContainsUnsupportedCharacters =
                phoneNumberResult.ContainsUnsupportedCharacters,
            Password = request.Password ?? string.Empty
        };
    }
}
