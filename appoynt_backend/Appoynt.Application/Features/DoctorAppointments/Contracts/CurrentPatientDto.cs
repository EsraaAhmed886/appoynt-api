/**
 * File Name      : CurrentPatientDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : System, BookingType
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-26
 * Description    : Public payload describing the patient currently in
 *                  consultation on the doctor's appointments screen.
 */

using System;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.DoctorAppointments.Contracts;

/// <summary>
/// Describes the patient whose consultation is currently in progress.
/// </summary>
public sealed class CurrentPatientDto
{
    /// <summary>
    /// Gets the appointment identifier for lifecycle actions (start/end).
    /// </summary>
    public Guid AppointmentId { get; init; }

    /// <summary>
    /// Gets the patient display name composed from the account identity.
    /// </summary>
    public string PatientName { get; init; } = string.Empty;

    /// <summary>
    /// Gets the contact phone number of the patient's account.
    /// </summary>
    public string? PhoneNumber { get; init; }

    /// <summary>
    /// Gets whether this visit is new or a follow-up.
    /// </summary>
    public BookingType BookingType { get; init; }

    /// <summary>
    /// Gets the scheduled slot start time in "HH:mm" format.
    /// </summary>
    public string ExpectedTime { get; init; } = string.Empty;

    /// <summary>
    /// Gets the UTC instant the consultation started; drives the live
    /// duration counter computed client-side.
    /// </summary>
    public DateTime? ActualStartTimeUtc { get; init; }

    // Quick snapshot fields arrive with the Medical Record module; always null today.

    /// <summary>
    /// Gets the chronic diseases snapshot. Reserved for the Medical Record task.
    /// </summary>
    public List<string>? ChronicDiseases => null;

    /// <summary>
    /// Gets the allergies snapshot. Reserved for the Medical Record task.
    /// </summary>
    public List<string>? Allergies => null;

    /// <summary>
    /// Gets the last visit date. Reserved for the Medical Record task.
    /// </summary>
    public DateTime? LastVisitDate => null;
}
