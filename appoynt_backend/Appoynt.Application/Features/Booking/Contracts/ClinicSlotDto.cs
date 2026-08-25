/**
 * File Name      : ClinicSlotDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : System
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-25
 * Description    : Public booking payload for a single appointment slot as seen
 *                  by the anonymous booking screen, including the simplified
 *                  public status and the caller's own-lock indicators.
 */

using System;

namespace Appoynt.Application.Features.Booking.Contracts;

/// <summary>
/// Describes one appointment slot on the patient booking day view.
/// </summary>
public sealed class ClinicSlotDto
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
    /// Gets the simplified public status. The full internal SlotStatus enum is
    /// never exposed through anonymous booking responses.
    /// </summary>
    public string Status { get; init; } = string.Empty;

    /// <summary>
    /// Gets a value indicating whether the slot starts before the morning cutoff.
    /// </summary>
    public bool IsMorning { get; init; }

    /// <summary>
    /// Gets a value indicating whether the slot is effectively locked by the
    /// calling patient. Always false for unauthenticated callers.
    /// </summary>
    public bool IsLockedByMe { get; init; }

    /// <summary>
    /// Gets the UTC expiry of the caller's pending lock. Only populated while
    /// an effective lock is held on this slot.
    /// </summary>
    public DateTime? ExpiresAt { get; init; }
}

