/**
 * File Name      : SlotLockResponseDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : System
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-25
 * Description    : Public booking payload returned after a successful slot lock,
 *                  carrying the absolute expiry plus a pre-computed countdown.
 */

using System;

namespace Appoynt.Application.Features.Booking.Contracts;

/// <summary>
/// Describes an acquired pending lock on an appointment slot.
/// </summary>
public sealed class SlotLockResponseDto
{
    /// <summary>
    /// Gets the locked appointment slot identifier.
    /// </summary>
    public Guid SlotId { get; init; }

    /// <summary>
    /// Gets the absolute UTC lock expiry instant. Re-locking the same slot
    /// returns the ORIGINAL expiry so the countdown never resets.
    /// </summary>
    public DateTime ExpiresAt { get; init; }

    /// <summary>
    /// Gets the remaining seconds until expiry, computed from the real
    /// ExpiresAt value at response time.
    /// </summary>
    public int RemainingSeconds { get; init; }
}

