/**
 * File Name      : GovernoratesController.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : ApplicationDbContext, GovernorateResponse, CityResponse
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Exposes lookup endpoints for Egyptian governorates and cities for dropdown selection.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Features.Clinics.Contracts;
using Appoynt.Infrastructure.Persistence;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Appoynt.API.Controllers;

/// <summary>
/// Handles lookup queries for Egyptian governorates and their constituent cities.
/// </summary>
[ApiController]
[Route("api/governorates")]
[Authorize]
public sealed class GovernoratesController : ControllerBase
{
    #region Dependencies

    private readonly ApplicationDbContext _dbContext;

    #endregion

    #region Constructor

    /// <summary>
    /// Initializes a new instance of the <see cref="GovernoratesController"/> class.
    /// </summary>
    /// <param name="dbContext">The application database context.</param>
    public GovernoratesController(ApplicationDbContext dbContext)
    {
        // Store the database context dependency.
        _dbContext = dbContext;
    }

    #endregion

    #region Actions

    /// <summary>
    /// Retrieves the list of all Egyptian governorates.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A list of governorate lookup records.</returns>
    [HttpGet]
    [ProducesResponseType(typeof(List<GovernorateResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> GetAllGovernorates(CancellationToken cancellationToken)
    {
        // Query all governorates using AsNoTracking for fast read-only access.
        var governorates = await _dbContext.Governorates
            .AsNoTracking()
            .Where(g => g.DeletedAt == null)
            .OrderBy(g => g.NameAr)
            .Select(g => new GovernorateResponse
            {
                Id = g.Id,
                NameAr = g.NameAr,
                NameEn = g.NameEn
            })
            .ToListAsync(cancellationToken);

        // Return HTTP 200 OK with the retrieved list of governorates.
        return Ok(governorates);
    }

    /// <summary>
    /// Retrieves all cities/districts belonging to a specific governorate.
    /// </summary>
    /// <param name="governorateId">The unique identifier of the governorate.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A list of city lookup records for the specified governorate.</returns>
    [HttpGet("{governorateId:guid}/cities")]
    [ProducesResponseType(typeof(List<CityResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> GetCitiesByGovernorate(
        [FromRoute] Guid governorateId,
        CancellationToken cancellationToken)
    {
        // Query cities belonging to the specified governorate using AsNoTracking.
        var cities = await _dbContext.Cities
            .AsNoTracking()
            .Where(c => c.GovernorateId == governorateId && c.DeletedAt == null)
            .OrderBy(c => c.NameAr)
            .Select(c => new CityResponse
            {
                Id = c.Id,
                GovernorateId = c.GovernorateId,
                NameAr = c.NameAr,
                NameEn = c.NameEn
            })
            .ToListAsync(cancellationToken);

        // Return HTTP 200 OK with the retrieved list of cities.
        return Ok(cities);
    }

    #endregion
}
