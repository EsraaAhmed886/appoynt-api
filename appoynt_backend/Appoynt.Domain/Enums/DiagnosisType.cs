/**
 * File Name      : DiagnosisType.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Defines whether a diagnosis is Primary, Secondary, or Pending.
 */

namespace Appoynt.Domain.Enums;

/// <summary>
/// Specifies the role and classification of a diagnosis in a medical record.
/// </summary>
public enum DiagnosisType
{
    /// <summary>
    /// The primary condition diagnosed during the consultation.
    /// </summary>
    Primary = 1,

    /// <summary>
    /// Additional or secondary diagnoses identified during the consultation.
    /// </summary>
    Secondary = 2,

    /// <summary>
    /// Provisional diagnosis pending further laboratory, diagnostic, or clinical evaluation.
    /// </summary>
    Pending = 3
}
