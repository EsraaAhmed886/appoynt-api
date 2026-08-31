/**
 * File Name      : MedicalRecord.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, Appointment, Patient, Doctor, Clinic, ApplicationUser,
 *                  MedicalRecordStatus, ClinicalOutcome, MedicalRecordDiagnosis,
 *                  MedicalRecordMedication, MedicalRecordTestRequest,
 *                  MedicalRecordAttachment, MedicalRecordChangeLog
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Represents the complete clinical medical record for an appointment consultation,
 *                  including clinical outcome, diagnoses, prescriptions, test requests, and attachments.
 */

using System;
using System.Collections.Generic;
using Appoynt.Domain.Common;
using Appoynt.Domain.Enums;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents the formal electronic medical record created for a patient appointment consultation.
/// </summary>
public class MedicalRecord : BaseEntity
{
    #region Business Properties

    /// <summary>
    /// Gets or sets the lifecycle state of the medical record (Draft, Finalized, Discarded).
    /// </summary>
    public MedicalRecordStatus Status { get; set; } = MedicalRecordStatus.Draft;

    /// <summary>
    /// Gets or sets the clinical outcome classification of the consultation.
    /// </summary>
    public ClinicalOutcome? ClinicalOutcome { get; set; }

    /// <summary>
    /// Gets or sets free-text clinical notes, observations, examination findings, and medical rationale.
    /// </summary>
    public string? ClinicalNotes { get; set; }

    /// <summary>
    /// Gets or sets the clinical visit date copied from the appointment date.
    /// Immutable once finalized.
    /// </summary>
    public DateOnly VisitDate { get; set; }

    /// <summary>
    /// Gets or sets the UTC timestamp when the record was finalized and signed.
    /// </summary>
    public DateTime? FinalizedAtUtc { get; set; }

    /// <summary>
    /// Gets or sets the optimistic concurrency token used to detect conflicting updates across browser tabs/sessions.
    /// </summary>
    public byte[] Version { get; set; } = [];

    #endregion

    #region Relationship Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the associated appointment.
    /// One appointment can have at most one medical record.
    /// </summary>
    public Guid AppointmentId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the associated appointment.
    /// </summary>
    public required Appointment Appointment { get; set; }

    /// <summary>
    /// Gets or sets the foreign key referencing the patient.
    /// </summary>
    public Guid PatientId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the patient.
    /// </summary>
    public required Patient Patient { get; set; }

    /// <summary>
    /// Gets or sets the foreign key referencing the doctor who created this medical record.
    /// </summary>
    public Guid DoctorId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the creator doctor.
    /// </summary>
    public required Doctor Doctor { get; set; }

    /// <summary>
    /// Gets or sets the foreign key referencing the clinic where the consultation occurred.
    /// </summary>
    public Guid ClinicId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the clinic.
    /// </summary>
    public required Clinic Clinic { get; set; }

    /// <summary>
    /// Gets or sets the foreign key referencing the user who digitally finalized and signed the record.
    /// </summary>
    public Guid? SignedById { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the signing user.
    /// </summary>
    public ApplicationUser? SignedBy { get; set; }

    /// <summary>
    /// Gets or sets the collection of diagnoses assigned during this consultation.
    /// </summary>
    public ICollection<MedicalRecordDiagnosis> Diagnoses { get; set; } = [];

    /// <summary>
    /// Gets or sets the collection of medications prescribed during this consultation.
    /// </summary>
    public ICollection<MedicalRecordMedication> Medications { get; set; } = [];

    /// <summary>
    /// Gets or sets the collection of diagnostic tests requested during this consultation.
    /// </summary>
    public ICollection<MedicalRecordTestRequest> TestRequests { get; set; } = [];

    /// <summary>
    /// Gets or sets the collection of attachments and medical documents linked to this consultation.
    /// </summary>
    public ICollection<MedicalRecordAttachment> Attachments { get; set; } = [];

    /// <summary>
    /// Gets or sets the audit change log history tracking all post-finalization edits.
    /// </summary>
    public ICollection<MedicalRecordChangeLog> ChangeLogs { get; set; } = [];

    #endregion
}
