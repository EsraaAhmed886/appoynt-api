/**
 * File Name      : WorkingPeriodRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : BreakRequest
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Request contract for defining a weekly working period and its associated breaks.
 */

using System.Collections.Generic;

namespace Appoynt.Application.Features.Clinics.Contracts;

/// <summary>
/// Represents a request to create or update a working period.
/// </summary>
public sealed class WorkingPeriodRequest
{
    /// <summary>
    /// Gets or sets the day of the week (0 = Sunday ... 6 = Saturday).
    /// </summary>
    public int? DayOfWeek { get; set; }

    /// <summary>
    /// Gets or sets the start time in "HH:mm" format.
    /// </summary>
    public string? StartTime { get; set; }

    /// <summary>
    /// Gets or sets the end time in "HH:mm" format.
    /// </summary>
    public string? EndTime { get; set; }

    /// <summary>
    /// Gets or sets the list of breaks during this period.
    /// </summary>
    public List<BreakRequest>? Breaks { get; set; }
}

