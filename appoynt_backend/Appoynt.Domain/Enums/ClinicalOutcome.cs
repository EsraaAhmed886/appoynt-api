/**
 * File Name      : ClinicalOutcome.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Defines the clinical outcome options for a Medical Record.
 */

namespace Appoynt.Domain.Enums;

/// <summary>
/// Represents the clinical outcome classification of a medical consultation.
/// </summary>
public enum ClinicalOutcome
{
    /// <summary>
    /// A definitive diagnosis has been established.
    /// </summary>
    ConfirmedDiagnosis = 1,

    /// <summary>
    /// No clinical illness or abnormality was detected during the visit.
    /// </summary>
    NoIllnessDetected = 2,

    /// <summary>
    /// Diagnosis is pending further lab tests, imaging, or subsequent evaluation.
    /// </summary>
    DiagnosisPending = 3
}
