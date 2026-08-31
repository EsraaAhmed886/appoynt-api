/**
 * File Name      : DurationUnit.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Defines duration time units for medication courses.
 */

namespace Appoynt.Domain.Enums;

/// <summary>
/// Time units used for specifying medication course duration.
/// </summary>
public enum DurationUnit
{
    /// <summary>Duration measured in days.</summary>
    Days = 1,

    /// <summary>Duration measured in weeks.</summary>
    Weeks = 2,

    /// <summary>Duration measured in months.</summary>
    Months = 3
}
