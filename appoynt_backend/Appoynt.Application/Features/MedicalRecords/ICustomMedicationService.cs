/**
 * File Name      : ICustomMedicationService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : CustomMedicationDtos
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Application service interface for managing custom unlisted medications,
 *                  doctor private formulary, and administrative merge approvals.
 */

using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Features.MedicalRecords.Contracts;

namespace Appoynt.Application.Features.MedicalRecords;

/// <summary>
/// Service managing custom doctor-submitted medication requests and global catalog merge workflows.
/// </summary>
public interface ICustomMedicationService
{
    /// <summary>
    /// Submits an unlisted custom medication for immediate use by the calling doctor.
    /// </summary>
    /// <param name="request">The creation request payload.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The created custom medication response.</returns>
    Task<CustomMedicationResponseDto?> CreateCustomMedicationAsync(CreateCustomMedicationRequestDto request, CancellationToken cancellationToken = default);

    /// <summary>
    /// Gets all custom medications created by the calling doctor.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The collection of custom medications.</returns>
    Task<IReadOnlyList<CustomMedicationResponseDto>> GetDoctorCustomMedicationsAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Gets all pending custom medication requests awaiting administrative review.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The list of pending requests.</returns>
    Task<IReadOnlyList<CustomMedicationResponseDto>> GetPendingAdminRequestsAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Approves a custom medication, creates a new entry in the global Medication catalog,
    /// sets the LinkedMedicationCatalogId, and backfills all existing MedicalRecordMedication rows transactionally.
    /// </summary>
    /// <param name="requestId">The custom medication request identifier.</param>
    /// <param name="request">The approved catalog details.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>True if approved and merged successfully.</returns>
    Task<bool> ApproveCustomMedicationAsync(Guid requestId, ApproveCustomMedicationRequest request, CancellationToken cancellationToken = default);

    /// <summary>
    /// Rejects a custom medication request with an administrative reason.
    /// </summary>
    /// <param name="requestId">The custom medication request identifier.</param>
    /// <param name="reason">The rejection reason.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>True if rejected successfully.</returns>
    Task<bool> RejectCustomMedicationAsync(Guid requestId, string? reason, CancellationToken cancellationToken = default);
}
