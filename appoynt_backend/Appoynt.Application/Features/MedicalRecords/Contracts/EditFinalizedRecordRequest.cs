/**
 * File Name      : EditFinalizedRecordRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : SaveDraftRequest
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Request payload for editing a finalized medical record with mandatory clinical justification reason.
 */

using System.ComponentModel.DataAnnotations;

namespace Appoynt.Application.Features.MedicalRecords.Contracts;

/// <summary>
/// Carries the payload for amending a finalized medical record while preserving audit change history.
/// </summary>
public sealed class EditFinalizedRecordRequest
{
    /// <summary>
    /// Gets or sets the optimistic concurrency token (base64).
    /// </summary>
    public string? Version { get; set; }

    /// <summary>
    /// Gets or sets the mandatory doctor amendment reason explaining the clinical justification (10 to 1,000 chars).
    /// </summary>
    [Required]
    [MinLength(10)]
    [MaxLength(1000)]
    public string Reason { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the updated medical record content.
    /// </summary>
    [Required]
    public required SaveDraftRequest UpdatedRecord { get; set; }
}
