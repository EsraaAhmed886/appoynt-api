/**
 * File Name      : FinalizeMedicalRecordRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : SaveDraftRequest
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Request payload for validating and finalizing a medical record consultation.
 */

namespace Appoynt.Application.Features.MedicalRecords.Contracts;

/// <summary>
/// Carries finalization payload and optimistic concurrency version.
/// Allows passing final state directly at finalization time or finalizing the currently persisted draft.
/// </summary>
public sealed class FinalizeMedicalRecordRequest
{
    /// <summary>
    /// Gets or sets the optimistic concurrency token (base64) to prevent conflicting updates.
    /// </summary>
    public string? Version { get; set; }

    /// <summary>
    /// Gets or sets the optional updated draft data to persist and finalize atomically.
    /// </summary>
    public SaveDraftRequest? DraftData { get; set; }
}
