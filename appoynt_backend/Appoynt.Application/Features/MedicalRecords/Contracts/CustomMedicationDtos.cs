/**
 * File Name      : CustomMedicationDtos.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : CustomMedicationStatus
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Data transfer objects for requesting, viewing, and approving custom unlisted medications.
 */

using System;
using System.ComponentModel.DataAnnotations;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.MedicalRecords.Contracts;

/// <summary>
/// Payload submitted by a doctor to request an unlisted custom medication for immediate use.
/// </summary>
public sealed class CreateCustomMedicationRequestDto
{
    /// <summary>
    /// Gets or sets the custom medication commercial or chemical name.
    /// </summary>
    [Required]
    [MaxLength(250)]
    public string Name { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets optional notes by the prescribing doctor regarding form, strength, or active ingredients.
    /// </summary>
    [MaxLength(1000)]
    public string? DoctorNotes { get; set; }
}

/// <summary>
/// Response payload representing a custom medication request item.
/// </summary>
public sealed class CustomMedicationResponseDto
{
    /// <summary>
    /// Gets or sets the custom medication request identifier.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the requesting doctor identifier.
    /// </summary>
    public Guid DoctorId { get; set; }

    /// <summary>
    /// Gets or sets the requesting doctor's name.
    /// </summary>
    public string DoctorName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the medication name.
    /// </summary>
    public string Name { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the administrative review status.
    /// </summary>
    public CustomMedicationStatus Status { get; set; }

    /// <summary>
    /// Gets or sets the linked global catalog identifier if approved.
    /// </summary>
    public Guid? LinkedMedicationCatalogId { get; set; }

    /// <summary>
    /// Gets or sets doctor notes.
    /// </summary>
    public string? DoctorNotes { get; set; }

    /// <summary>
    /// Gets or sets administrative notes or rejection reason.
    /// </summary>
    public string? AdminNotes { get; set; }

    /// <summary>
    /// Gets or sets the creation timestamp.
    /// </summary>
    public DateTime CreatedAtUtc { get; set; }
}

/// <summary>
/// Administrative payload to approve and merge a custom medication into the global catalog.
/// </summary>
public sealed class ApproveCustomMedicationRequest
{
    /// <summary>
    /// Gets or sets the approved Arabic name for the global catalog.
    /// </summary>
    [Required]
    [MaxLength(200)]
    public string NameAr { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the approved English name for the global catalog.
    /// </summary>
    [Required]
    [MaxLength(200)]
    public string NameEn { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the active pharmaceutical ingredient (mandatory for allergy checks).
    /// </summary>
    [Required]
    [MaxLength(250)]
    public string ActiveIngredient { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the dosage form (Tablet, Syrup, etc.).
    /// </summary>
    [MaxLength(100)]
    public string? Form { get; set; }

    /// <summary>
    /// Gets or sets the standard strength (e.g. 500mg).
    /// </summary>
    [MaxLength(100)]
    public string? Strength { get; set; }

    /// <summary>
    /// Gets or sets optional administrative notes.
    /// </summary>
    [MaxLength(1000)]
    public string? AdminNotes { get; set; }
}
