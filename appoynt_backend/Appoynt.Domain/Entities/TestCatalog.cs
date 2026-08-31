/**
 * File Name      : TestCatalog.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, TestCategory
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Represents a standardized diagnostic, lab, or imaging test in the global catalog.
 */

using Appoynt.Domain.Common;
using Appoynt.Domain.Enums;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a standardized diagnostic or laboratory test in the global catalog.
/// </summary>
public class TestCatalog : BaseEntity
{
    #region Business Properties

    /// <summary>
    /// Gets or sets the Arabic name of the test or diagnostic procedure.
    /// </summary>
    public string NameAr { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the English name of the test or diagnostic procedure.
    /// </summary>
    public string NameEn { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the classification category of this test (e.g., Laboratory, Radiology, Cardiology).
    /// </summary>
    public TestCategory Category { get; set; }

    /// <summary>
    /// Gets or sets clinical preparation instructions or description for the patient/laboratory.
    /// </summary>
    public string? Description { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether this test is currently active and orderable.
    /// </summary>
    public bool IsActive { get; set; } = true;

    #endregion
}
