/**
 * File Name      : MedicalRecordDiagnosis.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, MedicalRecord, Diagnosis, DiagnosisType
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Represents a diagnosis line item attached to a medical record.
 */

using System;
using Appoynt.Domain.Common;
using Appoynt.Domain.Enums;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents an individual diagnosis recorded within a medical record consultation.
/// </summary>
public class MedicalRecordDiagnosis : BaseEntity
{
    #region Business Properties

    /// <summary>
    /// Gets or sets the standardized ICD-10 code (denormalized for permanent snapshot integrity).
    /// </summary>
    public string ICD10Code { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the clinical name of the diagnosis (denormalized for permanent snapshot integrity).
    /// </summary>
    public string DiagnosisName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the type of diagnosis (Primary, Secondary, Pending).
    /// </summary>
    public DiagnosisType Type { get; set; }

    /// <summary>
    /// Gets or sets optional clinical notes or stage/severity details specific to this diagnosis.
    /// </summary>
    public string? Notes { get; set; }

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
    /// Gets or sets the optional foreign key referencing the global diagnosis catalog item.
    /// </summary>
    public Guid? DiagnosisCatalogId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the diagnosis catalog item.
    /// </summary>
    public Diagnosis? DiagnosisCatalog { get; set; }

    #endregion
}
