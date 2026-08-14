/**
 * File Name      : SmokingStatus.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Defines the supported smoking status values used for
 *                  patient medical information.
 */

namespace Appoynt.Domain.Enums;

/// <summary>
/// Represents the supported smoking status values in the application.
/// </summary>
public enum SmokingStatus
{
    /// <summary>
    /// The patient is an active smoker.
    /// </summary>
    Smoker = 0,

    /// <summary>
    /// The patient is a non-smoker.
    /// </summary>
    NonSmoker = 1,

    /// <summary>
    /// The patient is a former smoker.
    /// </summary>
    ExSmoker = 2
}
