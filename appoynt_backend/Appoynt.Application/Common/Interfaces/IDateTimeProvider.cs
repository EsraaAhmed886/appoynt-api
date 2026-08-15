/**
 * File Name      : IDateTimeProvider.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Defines an abstraction for retrieving the current
 *                  Coordinated Universal Time (UTC).
 */

namespace Appoynt.Application.Common.Interfaces;

/// <summary>
/// Defines an abstraction for accessing the current UTC date and time.
/// </summary>
public interface IDateTimeProvider
{
    #region Properties

    // Gets the current Coordinated Universal Time (UTC).
    DateTime UtcNow { get; }

    #endregion
}