/**
 * File Name      : AppointmentStateDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : System, AppointmentStatus
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-26
 * Description    : Public payload returned after a lifecycle action (start/end)
 *                  so clients can refresh the appointment card without refetching.
 */

using System;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.DoctorAppointments.Contracts;

/// <summary>
/// Describes the post-action state of an appointment.
/// </summary>
public sealed class AppointmentStateDto
{
    /// <summary>
    /// Gets the appointment identifier.
    /// </summary>
    public Guid AppointmentId { get; init; }

    /// <summary>
    /// Gets the new lifecycle status after the action.
    /// </summary>
    public AppointmentStatus Status { get; init; }

    /// <summary>
    /// Gets the UTC instant the consultation started, when applicable.
    /// </summary>
    public DateTime? ActualStartTimeUtc { get; init; }

    /// <summary>
    /// Gets the UTC instant the consultation ended, when applicable.
    /// </summary>
    public DateTime? ActualEndTimeUtc { get; init; }
}
