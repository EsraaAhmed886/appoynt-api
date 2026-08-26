/**
 * File Name      : DoctorDashboardSlotDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : System
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-26
 * Description    : Public payload for one slot on the doctor's day panel,
 *                  carrying a computed display status joined from SlotStatus
 *                  and the linked appointment's lifecycle state.
 */

using System;

namespace Appoynt.Application.Features.DoctorAppointments.Contracts;

/// <summary>
/// Describes one slot on the doctor's time-slots panel.
/// </summary>
public sealed class DoctorDashboardSlotDto
{
    /// <summary>
    /// Gets the appointment slot identifier.
    /// </summary>
    public Guid SlotId { get; init; }

    /// <summary>
    /// Gets the slot start time in "HH:mm" format.
    /// </summary>
    public string StartTime { get; init; } = string.Empty;

    /// <summary>
    /// Gets the slot end time in "HH:mm" format.
    /// </summary>
    public string EndTime { get; init; } = string.Empty;

    /// <summary>
    /// Gets the computed display status: Available | Pending | Booked |
    /// InConsultation | Break. Never persisted.
    /// </summary>
    public string DisplayStatus { get; init; } = string.Empty;
}
