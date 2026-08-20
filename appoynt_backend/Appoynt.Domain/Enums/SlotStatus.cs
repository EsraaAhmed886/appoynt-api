/**
 * File Name      : SlotStatus.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Defines the possible statuses for an appointment slot.
 */

namespace Appoynt.Domain.Enums;

/// <summary>
/// Represents the status of an appointment slot.
/// </summary>
public enum SlotStatus
{
    /// <summary>
    /// Indicates that the slot is available for booking.
    /// </summary>
    Available = 0,

    /// <summary>
    /// Indicates that the slot booking is pending confirmation.
    /// </summary>
    Pending = 1,

    /// <summary>
    /// Indicates that the slot has been booked.
    /// </summary>
    Booked = 2,

    /// <summary>
    /// Indicates that the slot is unavailable for booking.
    /// </summary>
    Unavailable = 3,

    /// <summary>
    /// Indicates that the booking for this slot was cancelled.
    /// </summary>
    Cancelled = 4,

    /// <summary>
    /// Indicates that the appointment for this slot has been completed.
    /// </summary>
    Completed = 5,

    /// <summary>
    /// Indicates that the patient did not show up for the appointment.
    /// </summary>
    NoShow = 6
}
