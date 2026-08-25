/**
 * File Name      : AvailableDatesResponseDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : System
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-25
 * Description    : Public booking payload listing the dates that currently have
 *                  at least one available slot, bounded by the clinic's own
 *                  maximum advance booking window.
 */

using System;
using System.Collections.Generic;

namespace Appoynt.Application.Features.Booking.Contracts;

/// <summary>
/// Describes the lit-up dates on the patient booking calendar.
/// </summary>
public sealed class AvailableDatesResponseDto
{
    /// <summary>
    /// Gets the distinct dates, ascending, that hold at least one available slot.
    /// </summary>
    public List<DateOnly> AvailableDates { get; init; } = [];
}
