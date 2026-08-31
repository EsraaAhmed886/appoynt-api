/**
 * File Name      : MedicalRecordsController.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : ASP.NET Core MVC, IMedicalRecordService, MedicalRecords Contracts
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Exposes endpoints for medical record consultation workflow,
 *                  patient summary, medical history timeline, drafts, and amendments.
 */

using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Features.MedicalRecords;
using Appoynt.Application.Features.MedicalRecords.Contracts;
using Appoynt.Domain.Common.Constants;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Appoynt.API.Controllers;

/// <summary>
/// Handles doctor electronic medical record consultation and history endpoints.
/// </summary>
[ApiController]
[Route("api/medical-records")]
[Authorize(Roles = RoleConstants.Doctor)]
public sealed class MedicalRecordsController : ControllerBase
{
    private readonly IMedicalRecordService _medicalRecordService;

    /// <summary>
    /// Initializes a new instance of the <see cref="MedicalRecordsController"/> class.
    /// </summary>
    /// <param name="medicalRecordService">The medical record application service.</param>
    public MedicalRecordsController(IMedicalRecordService medicalRecordService)
    {
        _medicalRecordService = medicalRecordService;
    }

    /// <summary>
    /// Gets the patient summary, current appointment info, allergy alerts, record state, and recent visits (Tab 1).
    /// </summary>
    /// <param name="appointmentId">The appointment identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The patient summary screen payload.</returns>
    [HttpGet("appointment/{appointmentId:guid}/summary")]
    [ProducesResponseType(typeof(PatientSummaryDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetPatientSummary(Guid appointmentId, CancellationToken cancellationToken)
    {
        var summary = await _medicalRecordService.GetPatientSummaryAsync(appointmentId, cancellationToken);
        if (summary == null)
        {
            return NotFound();
        }
        else
        {
            return Ok(summary);
        }
    }

    /// <summary>
    /// Gets the authorized finalized medical history timeline for a patient (Tab 2).
    /// Respects the patient's Full Medical History sharing preference.
    /// </summary>
    /// <param name="patientId">The patient identifier.</param>
    /// <param name="fromDate">Optional start date filter.</param>
    /// <param name="toDate">Optional end date filter.</param>
    /// <param name="doctorId">Optional doctor filter.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The authorized medical history response.</returns>
    [HttpGet("patient/{patientId:guid}/history")]
    [ProducesResponseType(typeof(MedicalHistoryResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetMedicalHistory(
        Guid patientId,
        [FromQuery] DateOnly? fromDate,
        [FromQuery] DateOnly? toDate,
        [FromQuery] Guid? doctorId,
        CancellationToken cancellationToken)
    {
        var history = await _medicalRecordService.GetMedicalHistoryAsync(patientId, fromDate, toDate, doctorId, cancellationToken);
        if (history == null)
        {
            return NotFound();
        }
        else
        {
            return Ok(history);
        }
    }

    /// <summary>
    /// Gets the complete detail of a medical record by ID (resuming draft or viewing finalized record).
    /// Enforces strict IDOR access control checks.
    /// </summary>
    /// <param name="id">The medical record identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The detailed medical record payload.</returns>
    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(MedicalRecordDetailDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetById(Guid id, CancellationToken cancellationToken)
    {
        var record = await _medicalRecordService.GetByIdAsync(id, cancellationToken);
        if (record == null)
        {
            return NotFound();
        }
        else
        {
            return Ok(record);
        }
    }

    /// <summary>
    /// Starts consultation for an appointment and creates an initial Draft medical record.
    /// </summary>
    /// <param name="appointmentId">The appointment identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The created draft medical record.</returns>
    [HttpPost("start-consultation")]
    [ProducesResponseType(typeof(MedicalRecordDetailDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> StartConsultation([FromQuery] Guid appointmentId, CancellationToken cancellationToken)
    {
        var result = await _medicalRecordService.StartConsultationAsync(appointmentId, cancellationToken);
        return MapResult(result);
    }

    /// <summary>
    /// Persists doctor edits into an in-progress draft medical record (Diagnoses, Medications, Tests).
    /// </summary>
    /// <param name="id">The medical record identifier.</param>
    /// <param name="request">The draft content payload.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The updated draft medical record.</returns>
    [HttpPut("{id:guid}/draft")]
    [ProducesResponseType(typeof(MedicalRecordDetailDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> SaveDraft(Guid id, [FromBody] SaveDraftRequest request, CancellationToken cancellationToken)
    {
        var result = await _medicalRecordService.SaveDraftAsync(id, request, cancellationToken);
        return MapResult(result);
    }

    /// <summary>
    /// Validates all mandatory clinical rules and finalizes the medical record.
    /// </summary>
    /// <param name="id">The medical record identifier.</param>
    /// <param name="request">The finalization payload.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The finalized medical record.</returns>
    [HttpPost("{id:guid}/finalize")]
    [ProducesResponseType(typeof(MedicalRecordDetailDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> FinalizeRecord(Guid id, [FromBody] FinalizeMedicalRecordRequest request, CancellationToken cancellationToken)
    {
        var result = await _medicalRecordService.FinalizeAsync(id, request, cancellationToken);
        return MapResult(result);
    }

    /// <summary>
    /// Submits a post-finalization amendment with mandatory clinical justification reason.
    /// </summary>
    /// <param name="id">The medical record identifier.</param>
    /// <param name="request">The amendment payload with justification.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The amended medical record with change log history.</returns>
    [HttpPut("{id:guid}/edit-finalized")]
    [ProducesResponseType(typeof(MedicalRecordDetailDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> EditFinalized(Guid id, [FromBody] EditFinalizedRecordRequest request, CancellationToken cancellationToken)
    {
        var result = await _medicalRecordService.EditFinalizedAsync(id, request, cancellationToken);
        return MapResult(result);
    }

    /// <summary>
    /// Discards and soft-deletes an in-progress draft medical record.
    /// </summary>
    /// <param name="id">The medical record identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>NoContent on success, or conflict/not found.</returns>
    [HttpDelete("{id:guid}/discard")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> DiscardDraft(Guid id, CancellationToken cancellationToken)
    {
        var result = await _medicalRecordService.DiscardDraftAsync(id, cancellationToken);
        if (result.Succeeded)
        {
            return NoContent();
        }
        else
        {
            return MapResult(result);
        }
    }

    private IActionResult MapResult(MedicalRecordOperationResult result)
    {
        if (result.Succeeded)
        {
            return Ok(result.Record);
        }
        else
        {
        }

        if (result.Errors.Any(e => e.Code == MedicalRecordErrorCodes.NotFound || e.Code == MedicalRecordErrorCodes.AppointmentNotFound))
        {
            return NotFound();
        }
        else
        {
        }

        if (result.Errors.Any(e => e.Code == MedicalRecordErrorCodes.UnauthorizedDoctor))
        {
            return Forbid();
        }
        else
        {
        }

        return Conflict(new { errors = result.Errors });
    }
}
