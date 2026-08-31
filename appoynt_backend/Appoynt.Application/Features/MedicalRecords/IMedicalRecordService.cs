/**
 * File Name      : IMedicalRecordService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : MedicalRecords Contracts
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Application service interface for patient summary, medical history,
 *                  draft consultation workflow, finalization, and post-finalization amendments.
 */

using System;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Features.MedicalRecords.Contracts;

namespace Appoynt.Application.Features.MedicalRecords;

/// <summary>
/// Defines electronic medical record query and lifecycle mutation operations.
/// </summary>
public interface IMedicalRecordService
{
    /// <summary>
    /// Gets the patient summary, current appointment info, allergy alerts, record state, and recent visits.
    /// Access requires the appointment to be assigned to the authenticated doctor.
    /// </summary>
    /// <param name="appointmentId">The appointment identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The patient summary payload, or null if unauthorized/not found.</returns>
    Task<PatientSummaryDto?> GetPatientSummaryAsync(Guid appointmentId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Gets the authorized finalized medical history timeline for a patient.
    /// Returns the doctor's own records always, and other doctors' records only if the patient has enabled Full History sharing.
    /// </summary>
    /// <param name="patientId">The patient identifier.</param>
    /// <param name="fromDate">Optional start date filter.</param>
    /// <param name="toDate">Optional end date filter.</param>
    /// <param name="doctorId">Optional doctor filter.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The authorized medical history response.</returns>
    Task<MedicalHistoryResponseDto?> GetMedicalHistoryAsync(
        Guid patientId,
        DateOnly? fromDate = null,
        DateOnly? toDate = null,
        Guid? doctorId = null,
        CancellationToken cancellationToken = default);

    /// <summary>
    /// Gets the full detail of a medical record by ID (for resuming a draft or viewing a finalized record).
    /// Applies strict IDOR access control checks (author always sees own, others only if patient sharing is enabled).
    /// </summary>
    /// <param name="recordId">The medical record identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The detailed medical record, or null if unauthorized/not found.</returns>
    Task<MedicalRecordDetailDto?> GetByIdAsync(Guid recordId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Starts consultation for an eligible appointment and creates an initial Draft medical record.
    /// </summary>
    /// <param name="appointmentId">The appointment identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The operation result carrying the created draft medical record.</returns>
    Task<MedicalRecordOperationResult> StartConsultationAsync(Guid appointmentId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Persists doctor edits into an existing draft medical record across diagnoses, medications, and test requests.
    /// </summary>
    /// <param name="recordId">The medical record identifier.</param>
    /// <param name="request">The draft content payload.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The operation result carrying the refreshed medical record.</returns>
    Task<MedicalRecordOperationResult> SaveDraftAsync(Guid recordId, SaveDraftRequest request, CancellationToken cancellationToken = default);

    /// <summary>
    /// Validates all mandatory clinical rules, ensures no incomplete items remain,
    /// and transitions the draft to an immutable Finalized record.
    /// </summary>
    /// <param name="recordId">The medical record identifier.</param>
    /// <param name="request">The finalization request payload.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The operation result carrying the finalized medical record.</returns>
    Task<MedicalRecordOperationResult> FinalizeAsync(Guid recordId, FinalizeMedicalRecordRequest request, CancellationToken cancellationToken = default);

    /// <summary>
    /// Amends an existing finalized medical record with mandatory clinical justification reason,
    /// logging old and new values into the immutable change log.
    /// </summary>
    /// <param name="recordId">The medical record identifier.</param>
    /// <param name="request">The amendment request with justification reason.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The operation result carrying the amended medical record.</returns>
    Task<MedicalRecordOperationResult> EditFinalizedAsync(Guid recordId, EditFinalizedRecordRequest request, CancellationToken cancellationToken = default);

    /// <summary>
    /// Discards and soft-deletes an in-progress draft medical record.
    /// </summary>
    /// <param name="recordId">The medical record identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The operation result indicating success or failure.</returns>
    Task<MedicalRecordOperationResult> DiscardDraftAsync(Guid recordId, CancellationToken cancellationToken = default);
}
