/**
 * File Name      : Appointment.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, Patient, AppointmentSlot, Clinic, BookingType, AppointmentStatus
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-26
 * Description    : Represents a confirmed appointment binding one patient to one
 *                  appointment slot, tracking the consultation lifecycle.
 */

using System;
using Appoynt.Domain.Common;
using Appoynt.Domain.Enums;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a booked appointment between a patient and a doctor's clinic.
/// </summary>
public class Appointment : BaseEntity
{
    #region Business Properties

    /// <summary>
    /// Gets or sets the appointment date copied (denormalized) from the slot at
    /// creation time so day-scoped queries avoid joins. Never taken from client input.
    /// </summary>
    public DateOnly Date { get; set; }

    /// <summary>
    /// Gets or sets whether this visit is new or a follow-up.
    /// </summary>
    public BookingType Type { get; set; }

    /// <summary>
    /// Gets or sets the consultation lifecycle state of this appointment.
    /// </summary>
    public AppointmentStatus Status { get; set; }

    /// <summary>
    /// Gets or sets the UTC instant the consultation actually started.
    /// </summary>
    public DateTime? ActualStartTimeUtc { get; set; }

    /// <summary>
    /// Gets or sets the UTC instant the consultation actually ended.
    /// </summary>
    public DateTime? ActualEndTimeUtc { get; set; }

    #endregion

    #region Relationship Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the booking patient.
    /// </summary>
    public Guid PatientId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the booking patient.
    /// </summary>
    public required Patient Patient { get; set; }

    /// <summary>
    /// Gets or sets the foreign key referencing the reserved slot. One slot can
    /// hold at most one appointment; enforced by a unique database index.
    /// </summary>
    public Guid AppointmentSlotId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the reserved slot.
    /// </summary>
    public required AppointmentSlot AppointmentSlot { get; set; }

    /// <summary>
    /// Gets or sets the foreign key referencing the clinic where the visit happens.
    /// Copied from the slot's clinic at creation time.
    /// </summary>
    public Guid ClinicId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the clinic.
    /// </summary>
    public required Clinic Clinic { get; set; }

    #endregion
}
