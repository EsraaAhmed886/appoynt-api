/**
 * File Name      : TestPriority.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Defines urgency and clinical priority levels for test requests.
 */

namespace Appoynt.Domain.Enums;

/// <summary>
/// Urgency priorities for requested diagnostic and laboratory tests.
/// </summary>
public enum TestPriority
{
    /// <summary>Standard routine clinical priority.</summary>
    Routine = 1,

    /// <summary>Urgent priority required for accelerated clinical processing.</summary>
    Urgent = 2,

    /// <summary>Stat (immediate/emergency) priority.</summary>
    Stat = 3
}
