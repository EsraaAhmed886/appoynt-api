/**
 * File Name      : AppointmentStatus.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-26
 * Description    : Lifecycle states of an appointment. This enum is the single
 *                  source of truth for consultation state; SlotStatus keeps its
 *                  own independent booking-inventory lifecycle.
 */

namespace Appoynt.Domain.Enums;

/// <summary>
/// Represents the consultation lifecycle of an appointment.
/// </summary>
public enum AppointmentStatus
{
    /// <summary>
    /// Confirmed and waiting for the consultation to begin.
    /// </summary>
    Upcoming = 0,

    /// <summary>
    /// The doctor has started the consultation and it is in progress.
    /// </summary>
    InConsultation = 1,

    /// <summary>
    /// The consultation finished successfully.
    /// </summary>
    Completed = 2,

    /// <summary>
    /// The appointment was cancelled before it took place.
    /// </summary>
    Cancelled = 3,

    /// <summary>
    /// The patient did not attend the appointment.
    /// Dormant value: no write path exists yet (documented deferral).
    /// </summary>
    NoShow = 4
}
