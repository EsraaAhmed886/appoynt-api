/**
 * File Name      : ITokenService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : ApplicationUser
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Defines the contract for generating access tokens for
 *                  authenticated application users.
 */

using Appoynt.Domain.Entities;

namespace Appoynt.Application.Common.Interfaces;

/// <summary>
/// Defines the contract for generating access tokens for application users.
/// </summary>
public interface ITokenService
{
    /// <summary>
    /// Generates an access token for the specified application user.
    /// </summary>
    /// <param name="user">
    /// The authenticated application user for whom to generate the token.
    /// </param>
    /// <returns>
    /// A task that represents the asynchronous operation. The task result
    /// contains the generated access token.
    /// </returns>
    Task<string> GenerateAccessTokenAsync(ApplicationUser user);
}
