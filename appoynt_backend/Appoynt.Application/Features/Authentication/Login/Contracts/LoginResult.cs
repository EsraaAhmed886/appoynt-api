/**
 * File Name      : LoginResult.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : AuthenticationError, LoginResponse
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Represents the outcome of an account-login operation.
 */

using Appoynt.Application.Common.Models;

namespace Appoynt.Application.Features.Authentication.Login.Contracts;

/// <summary>
/// Represents either a successful account login or its generic
/// authentication error.
/// </summary>
public sealed class LoginResult
{
    /// <summary>
    /// Gets a value indicating whether login succeeded.
    /// </summary>
    public bool Succeeded { get; init; }

    /// <summary>
    /// Gets the successful login response when login succeeded.
    /// </summary>
    public LoginResponse? Response { get; init; }

    /// <summary>
    /// Gets the generic authentication errors when login failed.
    /// </summary>
    public IReadOnlyList<AuthenticationError> Errors { get; init; } = [];
}
