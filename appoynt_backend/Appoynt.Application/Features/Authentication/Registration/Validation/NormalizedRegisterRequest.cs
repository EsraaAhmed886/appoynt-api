/**
 * File Name      : NormalizedRegisterRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Represents sanitized registration input used by the
 *                  registration validation and application services.
 */

namespace Appoynt.Application.Features.Authentication.Registration.Validation;

/// <summary>
/// Represents the normalized form of a registration request.
/// </summary>
public sealed class NormalizedRegisterRequest
{
    /// <summary>
    /// Gets or initializes the normalized first name.
    /// </summary>
    public required string FirstName { get; init; }

    /// <summary>
    /// Gets or initializes the normalized last name.
    /// </summary>
    public required string LastName { get; init; }

    /// <summary>
    /// Gets or initializes the normalized Egyptian mobile phone number.
    /// </summary>
    public required string PhoneNumber { get; init; }

    /// <summary>
    /// Gets or initializes a value indicating whether the submitted phone
    /// input included characters that cannot be sanitized as permitted input.
    /// </summary>
    public required bool PhoneNumberContainsUnsupportedCharacters { get; init; }

    /// <summary>
    /// Gets or initializes the normalized email address.
    /// </summary>
    public required string Email { get; init; }

    /// <summary>
    /// Gets or initializes the submitted password without sanitization.
    /// </summary>
    public required string Password { get; init; }

    /// <summary>
    /// Gets or initializes the submitted password confirmation without
    /// sanitization.
    /// </summary>
    public required string ConfirmPassword { get; init; }
}
