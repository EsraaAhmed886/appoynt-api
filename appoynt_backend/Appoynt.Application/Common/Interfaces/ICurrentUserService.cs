/**
 * File Name      : ICurrentUserService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Defines an abstraction for accessing information about
 *                  the currently authenticated user.
 */

namespace Appoynt.Application.Common.Interfaces;

/// <summary>
/// Defines an abstraction for accessing the current authenticated user.
/// </summary>
public interface ICurrentUserService
{
    #region Properties

    // Gets the unique identifier of the currently authenticated user.
    Guid? UserId { get; }

    // Gets the role of the currently authenticated user.
    string? Role { get; }

    #endregion
}