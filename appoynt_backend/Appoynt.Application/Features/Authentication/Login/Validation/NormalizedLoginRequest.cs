/**
 * File Name      : NormalizedLoginRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Represents sanitized account-login input used by the
 *                  login validation and application services.
 */

namespace Appoynt.Application.Features.Authentication.Login.Validation;

/// <summary>
/// Represents the normalized form of an account-login request.
/// </summary>
public sealed class NormalizedLoginRequest
{
    /// <summary>
    /// Gets or initializes the trimmed submitted identifier.
    /// </summary>
    public required string Identifier { get; init; }

    /// <summary>
    /// Gets or initializes a value indicating whether the identifier is to be
    /// validated as an email address.
    /// </summary>
    public required bool IsEmailIdentifier { get; init; }

    /// <summary>
    /// Gets or initializes the canonical phone number when the identifier is
    /// to be validated as a phone number.
    /// </summary>
    public required string PhoneNumber { get; init; }

    /// <summary>
    /// Gets or initializes a value indicating whether phone input included
    /// unsupported characters.
    /// </summary>
    public required bool PhoneNumberContainsUnsupportedCharacters { get; init; }

    /// <summary>
    /// Gets or initializes the submitted password without sanitization.
    /// </summary>
    public required string Password { get; init; }
}
