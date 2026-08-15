/**
 * File Name      : DateTimeProvider.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : IDateTimeProvider
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Provides the current Coordinated Universal Time (UTC)
 *                  for use throughout the application.
 */

using System;
using Appoynt.Application.Common.Interfaces;

namespace Appoynt.Infrastructure.Services;

/// <summary>
/// Provides the current UTC date and time.
/// </summary>
public sealed class DateTimeProvider : IDateTimeProvider
{
    #region Properties

    /// <summary>
    /// Gets the current Coordinated Universal Time (UTC).
    /// </summary>
    public DateTime UtcNow => DateTime.UtcNow;

    #endregion
}