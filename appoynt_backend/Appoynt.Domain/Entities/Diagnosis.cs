/**
 * File Name      : Diagnosis.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : BaseEntity
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Represents a standard clinical diagnosis from the global reference catalog (ICD-10).
 */

using Appoynt.Domain.Common;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a standardized ICD-10 medical diagnosis in the global catalog.
/// </summary>
public class Diagnosis : BaseEntity
{
    #region Business Properties

    /// <summary>
    /// Gets or sets the standardized ICD-10 alphanumeric code (e.g., E11.9, J06.9).
    /// </summary>
    public string ICD10Code { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the Arabic clinical name of the diagnosis.
    /// </summary>
    public string NameAr { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the English clinical name of the diagnosis.
    /// </summary>
    public string NameEn { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets an optional clinical description or diagnostic guidance notes.
    /// </summary>
    public string? Description { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether this catalog entry is active and selectable.
    /// </summary>
    public bool IsActive { get; set; } = true;

    #endregion
}
