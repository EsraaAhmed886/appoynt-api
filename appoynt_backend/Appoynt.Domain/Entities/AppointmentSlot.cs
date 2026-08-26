/**
 * File Name      : AppointmentSlot.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, Clinic, SlotStatus
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-26
 * Description    : Represents a specific time slot for an appointment within a clinic.
 */

using System;
using Appoynt.Domain.Common;
using Appoynt.Domain.Enums;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents an available, booked, or completed appointment slot for a clinic.
/// </summary>
public class AppointmentSlot : BaseEntity
{
    #region Business Properties

    /// <summary>
    /// Gets or sets the date of the appointment slot.
    /// </summary>
    public DateOnly Date { get; set; }

    /// <summary>
    /// Gets or sets the start time of the appointment slot.
    /// </summary>
    public TimeOnly StartTime { get; set; }

    /// <summary>
    /// Gets or sets the end time of the appointment slot.
    /// </summary>
    public TimeOnly EndTime { get; set; }

    /// <summary>
    /// Gets or sets the current status of the appointment slot.
    /// </summary>
    public SlotStatus Status { get; set; }

    #endregion

    #region Booking Lock Properties

    /// <summary>
    /// Gets or sets the identifier of the patient currently holding a pending
    /// lock on this slot, or null when the slot is not locked.
    /// </summary>
    public Guid? HeldByUserId { get; set; }

    /// <summary>
    /// Gets or sets the UTC instant at which a pending lock expires and the
    /// slot becomes available again, or null when the slot is not locked.
    /// Stored as UTC-only DateTime for cross-provider comparison support.
    /// </summary>
    public DateTime? ExpiresAtUtc { get; set; }

    #endregion

    #region Relationship Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the associated clinic.
    /// </summary>
    public Guid ClinicId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the associated clinic.
    /// </summary>
    public required Clinic Clinic { get; set; }

    /// <summary>
    /// Gets or sets the confirmed appointment bound to this slot, if any.
    /// One slot holds at most one appointment (unique index on the FK side).
    /// </summary>
    public Appointment? Appointment { get; set; }

    #endregion
}

