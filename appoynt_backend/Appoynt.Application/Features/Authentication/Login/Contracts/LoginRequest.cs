/**
 * File Name      : LoginRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Defines the raw input contract for account login.
 */

namespace Appoynt.Application.Features.Authentication.Login.Contracts;

/// <summary>
/// Represents the raw input submitted to authenticate an account.
/// </summary>
public sealed class LoginRequest
{
    /// <summary>
    /// Gets or initializes the submitted email address or phone number.
    /// </summary>
    public string? Identifier { get; init; }

    /// <summary>
    /// Gets or initializes the submitted password.
    /// </summary>
    public string? Password { get; init; }
}
