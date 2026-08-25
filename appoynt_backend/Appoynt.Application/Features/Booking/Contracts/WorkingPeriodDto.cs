/**
 * File Name      : WorkingPeriodDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-25
 * Description    : Public booking payload describing one recurring weekly
 *                  working period, serialized with string fields to match the
 *                  existing ClinicResponse time format.
 */

namespace Appoynt.Application.Features.Booking.Contracts;

/// <summary>
/// Describes a recurring weekly working period on the patient booking screen.
/// </summary>
public sealed class WorkingPeriodDto
{
    /// <summary>
    /// Gets the weekday name, for example "Sunday".
    /// </summary>
    public string Day { get; init; } = string.Empty;

    /// <summary>
    /// Gets the period start time in "HH:mm" format.
    /// </summary>
    public string StartTime { get; init; } = string.Empty;

    /// <summary>
    /// Gets the period end time in "HH:mm" format.
    /// </summary>
    public string EndTime { get; init; } = string.Empty;
}
