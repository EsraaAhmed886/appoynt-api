/**
 * File Name      : Frequency.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Defines standard medication administration frequencies.
 */

namespace Appoynt.Domain.Enums;

/// <summary>
/// Managed frequency intervals for medication administration.
/// </summary>
public enum Frequency
{
    /// <summary>Once daily (QD).</summary>
    OnceDaily = 1,

    /// <summary>Twice daily (BID).</summary>
    TwiceDaily = 2,

    /// <summary>Three times daily (TID).</summary>
    ThreeTimesDaily = 3,

    /// <summary>Four times daily (QID).</summary>
    FourTimesDaily = 4,

    /// <summary>Every 4 hours (Q4H).</summary>
    Every4Hours = 5,

    /// <summary>Every 6 hours (Q6H).</summary>
    Every6Hours = 6,

    /// <summary>Every 8 hours (Q8H).</summary>
    Every8Hours = 7,

    /// <summary>Every 12 hours (Q12H).</summary>
    Every12Hours = 8,

    /// <summary>Once weekly.</summary>
    OnceWeekly = 9,

    /// <summary>As needed (PRN). Mandatory clinical instructions apply.</summary>
    AsNeeded = 10
}
