/**
 * File Name      : PatientAllergy.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, Patient
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Represents an allergy recorded for a patient, used for clinical alerts and prescription checks.
 */

using Appoynt.Domain.Common;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents an active or historical allergy recorded for a patient.
/// </summary>
public class PatientAllergy : BaseEntity
{
    #region Business Properties

    /// <summary>
    /// Gets or sets the name of the substance, drug, or food causing the allergic reaction.
    /// </summary>
    public string AllergenName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the clinical category of the allergy (e.g., Medication, Food, Environmental).
    /// </summary>
    public string AllergenType { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the clinical severity (e.g., Mild, Moderate, Severe, Life-threatening).
    /// </summary>
    public string? Severity { get; set; }

    /// <summary>
    /// Gets or sets optional clinical notes or specific symptoms observed during exposure.
    /// </summary>
    public string? Notes { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether this allergy is currently active and requires active clinical alerts.
    /// </summary>
    public bool IsActive { get; set; } = true;

    #endregion

    #region Relationship Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the associated patient.
    /// </summary>
    public Guid PatientId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the associated patient.
    /// </summary>
    public required Patient Patient { get; set; }

    #endregion
}
