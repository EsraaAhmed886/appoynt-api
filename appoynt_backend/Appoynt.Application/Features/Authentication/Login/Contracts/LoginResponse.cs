/**
 * File Name      : LoginResponse.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Defines the successful response contract for account login.
 */

namespace Appoynt.Application.Features.Authentication.Login.Contracts;

/// <summary>
/// Represents the result of successfully authenticating an account.
/// </summary>
public sealed class LoginResponse
{
    /// <summary>
    /// Gets or initializes the JWT access token.
    /// </summary>
    public required string AccessToken { get; init; }
}
