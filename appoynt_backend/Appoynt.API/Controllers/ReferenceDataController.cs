/**
 * File Name      : ReferenceDataController.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : ASP.NET Core MVC, IReferenceDataService, MedicalRecords Contracts, TestCategory
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Exposes endpoints for searching standard clinical catalogs (ICD-10 Diagnoses, Medications, Tests).
 */

using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Features.MedicalRecords;
using Appoynt.Application.Features.MedicalRecords.Contracts;
using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Enums;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Appoynt.API.Controllers;

/// <summary>
/// Handles clinical catalog lookup and autocompletion endpoints for doctors.
/// </summary>
[ApiController]
[Route("api/reference")]
[Authorize(Roles = RoleConstants.Doctor)]
public sealed class ReferenceDataController : ControllerBase
{
    private readonly IReferenceDataService _referenceDataService;

    /// <summary>
    /// Initializes a new instance of the <see cref="ReferenceDataController"/> class.
    /// </summary>
    /// <param name="referenceDataService">The reference data catalog application service.</param>
    public ReferenceDataController(IReferenceDataService referenceDataService)
    {
        _referenceDataService = referenceDataService;
    }

    /// <summary>
    /// Searches ICD-10 standard diagnoses by code, English name, or Arabic name.
    /// </summary>
    /// <param name="searchTerm">The search text.</param>
    /// <param name="take">Max results to return (default 20, max 50).</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>Matching diagnoses catalog entries.</returns>
    [HttpGet("diagnoses")]
    [ProducesResponseType(typeof(IReadOnlyList<DiagnosisCatalogDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> SearchDiagnoses(
        [FromQuery] string? searchTerm,
        [FromQuery] int take = 20,
        CancellationToken cancellationToken = default)
    {
        var result = await _referenceDataService.SearchDiagnosesAsync(searchTerm, take, cancellationToken);
        return Ok(result);
    }

    /// <summary>
    /// Searches medications by commercial name, Arabic name, or active ingredient.
    /// Includes the calling doctor's private unapproved custom medications.
    /// </summary>
    /// <param name="searchTerm">The search text.</param>
    /// <param name="take">Max results to return (default 20, max 50).</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>Matching medication catalog entries.</returns>
    [HttpGet("medications")]
    [ProducesResponseType(typeof(IReadOnlyList<MedicationCatalogDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> SearchMedications(
        [FromQuery] string? searchTerm,
        [FromQuery] int take = 20,
        CancellationToken cancellationToken = default)
    {
        var result = await _referenceDataService.SearchMedicationsAsync(searchTerm, take, cancellationToken);
        return Ok(result);
    }

    /// <summary>
    /// Searches diagnostic and laboratory tests by category and name.
    /// </summary>
    /// <param name="category">Optional test category filter.</param>
    /// <param name="searchTerm">The search text.</param>
    /// <param name="take">Max results to return (default 20, max 50).</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>Matching test catalog entries.</returns>
    [HttpGet("tests")]
    [ProducesResponseType(typeof(IReadOnlyList<TestCatalogDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> SearchTests(
        [FromQuery] TestCategory? category,
        [FromQuery] string? searchTerm,
        [FromQuery] int take = 20,
        CancellationToken cancellationToken = default)
    {
        var result = await _referenceDataService.SearchTestsAsync(category, searchTerm, take, cancellationToken);
        return Ok(result);
    }
}
