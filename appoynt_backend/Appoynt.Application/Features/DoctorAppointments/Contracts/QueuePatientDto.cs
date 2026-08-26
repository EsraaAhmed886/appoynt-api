/**
 * File Name      : QueuePatientDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : System, BookingType
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-26
 * Description    : Public payload describing one waiting patient row in the
 *                  doctor's appointment queue.
 */

using System;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.DoctorAppointments.Contracts;

/// <summary>
/// Describes one patient waiting in the doctor's appointment queue.
/// </summary>
public sealed class QueuePatientDto
{
    /// <summary>
    /// Gets the appointment identifier for lifecycle actions.
    /// </summary>
    public Guid AppointmentId { get; init; }

    /// <summary>
    /// Gets the patient display name composed from the account identity.
    /// </summary>
    public string PatientName { get; init; } = string.Empty;

    /// <summary>
    /// Gets whether this visit is new or a follow-up.
    /// </summary>
    public BookingType BookingType { get; init; }

    /// <summary>
    /// Gets the scheduled slot start time in "HH:mm" format.
    /// </summary>
    public string ExpectedTime { get; init; } = string.Empty;
}
