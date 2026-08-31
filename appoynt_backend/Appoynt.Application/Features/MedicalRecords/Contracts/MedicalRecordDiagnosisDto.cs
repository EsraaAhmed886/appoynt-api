/**
 * File Name      : MedicalRecordDiagnosisDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : DiagnosisType
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Data transfer object representing a diagnosis line item on a medical record.
 */

using System;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.MedicalRecords.Contracts;

/// <summary>
/// Represents a diagnosis attached to a medical record.
/// </summary>
public sealed class MedicalRecordDiagnosisDto
{
    /// <summary>
    /// Gets or sets the line item identifier.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the optional catalog foreign key.
    /// </summary>
    public Guid? DiagnosisCatalogId { get; set; }

    /// <summary>
    /// Gets or sets the ICD-10 code.
    /// </summary>
    public string ICD10Code { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the clinical name of the diagnosis.
    /// </summary>
    public string DiagnosisName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the diagnosis type (Primary, Secondary, Pending).
    /// </summary>
    public DiagnosisType Type { get; set; }

    /// <summary>
    /// Gets or sets optional clinical notes.
    /// </summary>
    public string? Notes { get; set; }
}
