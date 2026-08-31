/**
 * File Name      : CatalogDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : TestCategory
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Data transfer objects for global diagnosis, medication, and test catalog search queries.
 */

using System;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.MedicalRecords.Contracts;

/// <summary>
/// Reference item representing an ICD-10 diagnosis search result.
/// </summary>
public sealed class DiagnosisCatalogDto
{
    /// <summary>
    /// Gets or sets the diagnosis catalog identifier.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the ICD-10 code.
    /// </summary>
    public string ICD10Code { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the Arabic name.
    /// </summary>
    public string NameAr { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the English name.
    /// </summary>
    public string NameEn { get; set; } = string.Empty;
}

/// <summary>
/// Reference item representing a medication catalog search result.
/// </summary>
public sealed class MedicationCatalogDto
{
    /// <summary>
    /// Gets or sets the catalog identifier.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the medication Arabic name.
    /// </summary>
    public string NameAr { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the medication English name.
    /// </summary>
    public string NameEn { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the active pharmaceutical ingredient.
    /// </summary>
    public string ActiveIngredient { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the form (Tablet, Injection, etc.).
    /// </summary>
    public string? Form { get; set; }

    /// <summary>
    /// Gets or sets the strength.
    /// </summary>
    public string? Strength { get; set; }

    /// <summary>
    /// Gets or sets whether this is a doctor-specific custom medication.
    /// </summary>
    public bool IsCustom { get; set; }

    /// <summary>
    /// Gets or sets the custom medication identifier if IsCustom is true.
    /// </summary>
    public Guid? CustomMedicationId { get; set; }
}

/// <summary>
/// Reference item representing a test catalog search result.
/// </summary>
public sealed class TestCatalogDto
{
    /// <summary>
    /// Gets or sets the test catalog identifier.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the Arabic name.
    /// </summary>
    public string NameAr { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the English name.
    /// </summary>
    public string NameEn { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the test category.
    /// </summary>
    public TestCategory Category { get; set; }

    /// <summary>
    /// Gets or sets description or clinical guidance.
    /// </summary>
    public string? Description { get; set; }
}
