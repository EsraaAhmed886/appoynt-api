/**
 * File Name      : CurrentAppointmentsDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : System, CurrentPatientDto, QueuePatientDto
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-26
 * Description    : Public payload for the doctor appointments screen: the patient
 *                  currently in consultation plus the backend-paginated queue.
 */

using System;
using System.Collections.Generic;

namespace Appoynt.Application.Features.DoctorAppointments.Contracts;

/// <summary>
/// Aggregates the current patient and the waiting queue for one clinic/day.
/// </summary>
public sealed class CurrentAppointmentsDto
{
    /// <summary>
    /// Gets the patient currently in consultation, or null when none is active.
    /// </summary>
    public CurrentPatientDto? CurrentPatient { get; init; }

    /// <summary>
    /// Gets the page of upcoming patients ordered by slot time.
    /// </summary>
    public List<QueuePatientDto> Queue { get; init; } = [];

    /// <summary>
    /// Gets a value indicating whether more queue rows exist beyond this page.
    /// </summary>
    public bool QueueHasMore { get; init; }

    /// <summary>
    /// Gets the total number of upcoming patients for the day.
    /// </summary>
    public int QueueTotalCount { get; init; }
}
