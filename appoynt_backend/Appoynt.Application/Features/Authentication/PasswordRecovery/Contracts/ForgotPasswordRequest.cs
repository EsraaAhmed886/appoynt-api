/**
 * File Name      : ForgotPasswordRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 27/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 27/07/2026
 * Description    : Represents the request payload for initiating password recovery.
 */

namespace Appoynt.Application.Features.Authentication.PasswordRecovery.Contracts;

/// <summary>
/// Represents the input model for requesting a password reset challenge.
/// </summary>
public sealed class ForgotPasswordRequest
{
    /// <summary>
    /// Gets or initializes the identifier (email or phone number) associated with the account.
    /// </summary>
    public string Identifier { get; init; } = string.Empty;
}
