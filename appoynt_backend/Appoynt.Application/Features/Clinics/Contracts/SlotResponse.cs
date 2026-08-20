/**
 * File Name      : SlotResponse.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Response DTO representing an appointment time slot.
 */

using System;

namespace Appoynt.Application.Features.Clinics.Contracts;

/// <summary>
/// Represents the response model for an appointment time slot.
/// </summary>
public sealed class SlotResponse
{
    /// <summary>
    /// Gets the slot identifier.
    /// </summary>
    public Guid Id { get; init; }

    /// <summary>
    /// Gets the date of the slot in "yyyy-MM-dd" format.
    /// </summary>
    public string Date { get; init; } = string.Empty;

    /// <summary>
    /// Gets the start time of the slot in "HH:mm" format.
    /// </summary>
    public string StartTime { get; init; } = string.Empty;

    /// <summary>
    /// Gets the end time of the slot in "HH:mm" format.
    /// </summary>
    public string EndTime { get; init; } = string.Empty;

    /// <summary>
    /// Gets the status of the slot.
    /// </summary>
    public string Status { get; init; } = string.Empty;
}

