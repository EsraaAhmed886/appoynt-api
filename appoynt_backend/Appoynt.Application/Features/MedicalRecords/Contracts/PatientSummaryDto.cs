/**
 * File Name      : PatientSummaryDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : PatientAllergyDto, RecentVisitDto, Gender, BookingType, AppointmentStatus
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Data transfer object for the first tab of the Medical Record screen (Patient Summary).
 */

using System;
using System.Collections.Generic;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.MedicalRecords.Contracts;

/// <summary>
/// Payload providing the patient summary, current appointment info, allergy alerts,
/// record state, and recent visits for the consultation screen.
/// </summary>
public sealed class PatientSummaryDto
{
    #region Patient Demographics

    /// <summary>
    /// Gets or sets the patient identifier.
    /// </summary>
    public Guid PatientId { get; set; }

    /// <summary>
    /// Gets or sets the 7-character formatted Patient Identifier (PID).
    /// </summary>
    public string PID { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the full patient display name.
    /// </summary>
    public string PatientName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the patient's biological gender.
    /// </summary>
    public Gender? Gender { get; set; }

    /// <summary>
    /// Gets or sets the patient's birth date.
    /// </summary>
    public DateOnly? BirthDate { get; set; }

    /// <summary>
    /// Gets or sets the dynamically calculated patient age in years.
    /// </summary>
    public int? Age { get; set; }

    /// <summary>
    /// Gets or sets the patient's contact phone number.
    /// </summary>
    public string PhoneNumber { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets a value indicating whether the patient enables full medical history sharing with other physicians.
    /// </summary>
    public bool IsMedicalHistorySharingEnabled { get; set; }

    #endregion

    #region Appointment Context

    /// <summary>
    /// Gets or sets the selected appointment identifier.
    /// </summary>
    public Guid AppointmentId { get; set; }

    /// <summary>
    /// Gets or sets the clinical appointment date.
    /// </summary>
    public DateOnly AppointmentDate { get; set; }

    /// <summary>
    /// Gets or sets the scheduled appointment time formatted as HH:mm.
    /// </summary>
    public string AppointmentTime { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the appointment consultation lifecycle status.
    /// </summary>
    public AppointmentStatus AppointmentStatus { get; set; }

    /// <summary>
    /// Gets or sets whether this visit is a new or follow-up booking.
    /// </summary>
    public BookingType BookingType { get; set; }

    /// <summary>
    /// Gets or sets the clinic name where the appointment is held.
    /// </summary>
    public string ClinicName { get; set; } = string.Empty;

    #endregion

    #region Medical Record Action State

    /// <summary>
    /// Gets or sets the display state of the medical record ("NotStarted", "Draft", "Finalized").
    /// </summary>
    public string MedicalRecordDisplayState { get; set; } = "NotStarted";

    /// <summary>
    /// Gets or sets the existing medical record identifier if one exists.
    /// </summary>
    public Guid? MedicalRecordId { get; set; }

    #endregion

    #region Alerts & History

    /// <summary>
    /// Gets or sets the collection of active allergies recorded for this patient.
    /// </summary>
    public IReadOnlyList<PatientAllergyDto> Allergies { get; set; } = [];

    /// <summary>
    /// Gets or sets the latest up to 3 authorized historical consultation visits.
    /// </summary>
    public IReadOnlyList<RecentVisitDto> RecentVisits { get; set; } = [];

    #endregion
}
