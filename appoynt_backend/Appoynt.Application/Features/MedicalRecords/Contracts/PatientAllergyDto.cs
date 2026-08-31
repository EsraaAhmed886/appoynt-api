/**
 * File Name      : PatientAllergyDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Data transfer object representing a patient's recorded allergy alert.
 */

using System;

namespace Appoynt.Application.Features.MedicalRecords.Contracts;

/// <summary>
/// Represents a patient allergy alert payload for clinical screens.
/// </summary>
public sealed class PatientAllergyDto
{
    /// <summary>
    /// Gets or sets the allergy identifier.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the allergen substance or drug name.
    /// </summary>
    public string AllergenName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the category of allergy (Medication, Food, etc.).
    /// </summary>
    public string AllergenType { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the clinical severity (Mild, Moderate, Severe).
    /// </summary>
    public string? Severity { get; set; }

    /// <summary>
    /// Gets or sets optional clinical notes or symptoms.
    /// </summary>
    public string? Notes { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether this allergy is actively tracked.
    /// </summary>
    public bool IsActive { get; set; }
}
