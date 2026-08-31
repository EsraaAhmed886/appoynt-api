/**
 * File Name      : Medication.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : BaseEntity
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Represents a standardized medication in the global catalog.
 */

using Appoynt.Domain.Common;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a standardized pharmaceutical medication in the global catalog.
/// </summary>
public class Medication : BaseEntity
{
    #region Business Properties

    /// <summary>
    /// Gets or sets the commercial or brand name of the medication in Arabic.
    /// </summary>
    public string NameAr { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the commercial or brand name of the medication in English.
    /// </summary>
    public string NameEn { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the scientific generic name or active pharmaceutical ingredient (API).
    /// Used for allergy cross-referencing and contraindication checks.
    /// </summary>
    public string ActiveIngredient { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the dosage form (e.g., Tablet, Syrup, Injection, Cream).
    /// </summary>
    public string? Form { get; set; }

    /// <summary>
    /// Gets or sets the standard strength (e.g., 500mg, 10mg/5ml).
    /// </summary>
    public string? Strength { get; set; }

    /// <summary>
    /// Gets or sets an optional clinical description or therapeutic notes.
    /// </summary>
    public string? Description { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether this medication catalog entry is active and selectable.
    /// </summary>
    public bool IsActive { get; set; } = true;

    #endregion
}
