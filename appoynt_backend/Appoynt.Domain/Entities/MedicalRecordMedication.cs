/**
 * File Name      : MedicalRecordMedication.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, MedicalRecord, Medication, CustomMedicationRequest,
 *                  DosageUnit, Frequency, Route, DurationUnit
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Represents a prescribed medication line item within a medical record consultation.
 */

using System;
using Appoynt.Domain.Common;
using Appoynt.Domain.Enums;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents an individual medication prescription recorded within a medical record.
/// </summary>
public class MedicalRecordMedication : BaseEntity
{
    #region Business Properties

    /// <summary>
    /// Gets or sets the denormalized medication name for display and historical snapshot preservation.
    /// </summary>
    public string MedicationName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the numerical dosage amount (e.g., 500, 2.5). Supports fractional pediatric doses.
    /// </summary>
    public decimal DosageAmount { get; set; }

    /// <summary>
    /// Gets or sets the measurement unit of the dosage.
    /// </summary>
    public DosageUnit DosageUnit { get; set; }

    /// <summary>
    /// Gets or sets the administration frequency schedule.
    /// </summary>
    public Frequency Frequency { get; set; }

    /// <summary>
    /// Gets or sets the administration route.
    /// </summary>
    public Route Route { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether the medication course is indefinite or ongoing.
    /// When true, DurationValue and DurationUnit are null.
    /// </summary>
    public bool IsOngoing { get; set; }

    /// <summary>
    /// Gets or sets the duration value (e.g., 5, 14, 30). Null if IsOngoing is true.
    /// </summary>
    public int? DurationValue { get; set; }

    /// <summary>
    /// Gets or sets the duration unit (Days, Weeks, Months). Null if IsOngoing is true.
    /// </summary>
    public DurationUnit? DurationUnit { get; set; }

    /// <summary>
    /// Gets or sets patient-facing directions and intake instructions.
    /// Mandatory when Frequency is <see cref="Frequency.AsNeeded"/>.
    /// </summary>
    public string? Instructions { get; set; }

    /// <summary>
    /// Gets or sets internal clinical notes or physician rationale for this prescription.
    /// </summary>
    public string? MedicationNote { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether the doctor explicitly acknowledged the clinical risk
    /// when prescribing an unlisted custom medication that lacks automated allergy checks.
    /// </summary>
    public bool DoctorAcknowledgedRisk { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether this draft medication item is incomplete and pending further details.
    /// </summary>
    public bool IsIncomplete { get; set; }

    #endregion

    #region Relationship Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the parent medical record.
    /// </summary>
    public Guid MedicalRecordId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the parent medical record.
    /// </summary>
    public required MedicalRecord MedicalRecord { get; set; }

    /// <summary>
    /// Gets or sets the optional foreign key referencing the global medication catalog.
    /// At least one of MedicationCatalogId or CustomMedicationId must be non-null.
    /// </summary>
    public Guid? MedicationCatalogId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the global medication catalog.
    /// </summary>
    public Medication? MedicationCatalog { get; set; }

    /// <summary>
    /// Gets or sets the optional foreign key referencing the custom medication request.
    /// </summary>
    public Guid? CustomMedicationId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the custom medication request.
    /// </summary>
    public CustomMedicationRequest? CustomMedication { get; set; }

    #endregion
}
