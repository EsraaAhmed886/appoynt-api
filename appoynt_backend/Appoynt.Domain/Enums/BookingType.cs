/**
 * File Name      : BookingType.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-26
 * Description    : Distinguishes first-time visits from follow-up visits when a
 *                  patient confirms an appointment booking.
 */

namespace Appoynt.Domain.Enums;

/// <summary>
/// Specifies whether an appointment is a new visit or a follow-up.
/// </summary>
public enum BookingType
{
    /// <summary>
    /// A first-time visit for this patient with the doctor.
    /// </summary>
    New = 0,

    /// <summary>
    /// A follow-up visit continuing prior treatment.
    /// </summary>
    FollowUp = 1
}
