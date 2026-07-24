/**
 * File Name      : RegisterRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Defines the raw input contract for patient registration.
 */

namespace Appoynt.Application.Features.Authentication.Registration.Contracts;

/// <summary>
/// Represents the raw input submitted to create a patient account.
/// </summary>
/// <remarks>
/// Validation and normalization are intentionally not performed by this
/// contract. They are applied by the registration validation pipeline so that
/// every consumer uses the same approved field rules.
/// </remarks>
public sealed class RegisterRequest
{
    /// <summary>
    /// Gets or initializes the submitted first name.
    /// </summary>
    public string? FirstName { get; init; }

    /// <summary>
    /// Gets or initializes the submitted last name.
    /// </summary>
    public string? LastName { get; init; }

    /// <summary>
    /// Gets or initializes the submitted mobile phone number.
    /// </summary>
    public string? PhoneNumber { get; init; }

    /// <summary>
    /// Gets or initializes the submitted email address.
    /// </summary>
    public string? Email { get; init; }

    /// <summary>
    /// Gets or initializes the submitted password.
    /// </summary>
    public string? Password { get; init; }

    /// <summary>
    /// Gets or initializes the submitted password confirmation.
    /// </summary>
    public string? ConfirmPassword { get; init; }
}
