/**
 * File Name      : ILoginService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : LoginRequest, LoginResult
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Defines the application contract for account login.
 */

using Appoynt.Application.Features.Authentication.Login.Contracts;

namespace Appoynt.Application.Features.Authentication.Login;

/// <summary>
/// Defines the application contract for authenticating accounts.
/// </summary>
public interface ILoginService
{
    /// <summary>
    /// Authenticates an account and returns an access token when successful.
    /// </summary>
    /// <param name="request">The raw login request.</param>
    /// <param name="cancellationToken">A token used to cancel the operation.</param>
    /// <returns>The login result.</returns>
    Task<LoginResult> LoginAsync(
        LoginRequest request,
        CancellationToken cancellationToken = default);
}
