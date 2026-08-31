/**
 * File Name      : MedicalRecordMedicationDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : DosageUnit, Frequency, Route, DurationUnit
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Data transfer object representing a prescribed medication line item on a medical record.
 */

using System;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.MedicalRecords.Contracts;

/// <summary>
/// Represents a prescribed medication line item.
/// </summary>
public sealed class MedicalRecordMedicationDto
{
    /// <summary>
    /// Gets or sets the prescription line identifier.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the optional global catalog identifier.
    /// </summary>
    public Guid? MedicationCatalogId { get; set; }

    /// <summary>
    /// Gets or sets the optional custom medication request identifier.
    /// </summary>
    public Guid? CustomMedicationId { get; set; }

    /// <summary>
    /// Gets or sets the display name of the medication.
    /// </summary>
    public string MedicationName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the dosage amount (supports decimal fractions).
    /// </summary>
    public decimal DosageAmount { get; set; }

    /// <summary>
    /// Gets or sets the dosage measurement unit.
    /// </summary>
    public DosageUnit DosageUnit { get; set; }

    /// <summary>
    /// Gets or sets the administration frequency.
    /// </summary>
    public Frequency Frequency { get; set; }

    /// <summary>
    /// Gets or sets the administration route.
    /// </summary>
    public Route Route { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether the medication is ongoing indefinitely.
    /// </summary>
    public bool IsOngoing { get; set; }

    /// <summary>
    /// Gets or sets the course duration value.
    /// </summary>
    public int? DurationValue { get; set; }

    /// <summary>
    /// Gets or sets the duration unit (Days, Weeks, Months).
    /// </summary>
    public DurationUnit? DurationUnit { get; set; }

    /// <summary>
    /// Gets or sets patient directions (mandatory if Frequency is AsNeeded).
    /// </summary>
    public string? Instructions { get; set; }

    /// <summary>
    /// Gets or sets optional internal clinical notes.
    /// </summary>
    public string? MedicationNote { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether the doctor acknowledged the allergy check risk for custom drugs.
    /// </summary>
    public bool DoctorAcknowledgedRisk { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether this draft item is incomplete.
    /// </summary>
    public bool IsIncomplete { get; set; }
}
