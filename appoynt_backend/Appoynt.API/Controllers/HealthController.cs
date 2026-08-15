/**
 * File Name      : HealthController.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : ASP.NET Core MVC, AllowAnonymousAttribute
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Exposes a lightweight health check endpoint for monitoring application status.
 */

using System;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Appoynt.API.Controllers;

/// <summary>
/// Handles application health check probes and service liveness queries.
/// </summary>
[ApiController]
[Route("api/health")]
[Tags("Health")]
public sealed class HealthController : ControllerBase
{
    /// <summary>
    /// Returns the current health and liveness status of the API service.
    /// </summary>
    /// <returns>An HTTP 200 OK response with the service health metadata.</returns>
    [HttpGet]
    [AllowAnonymous]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public IActionResult CheckHealth()
    {
        // Build health status payload with current UTC timestamp
        var healthStatus = new
        {
            Status = "Healthy",
            Timestamp = DateTimeOffset.UtcNow,
            Service = "Appoynt API"
        };

        // Return HTTP 200 OK with health status information
        return Ok(healthStatus);
    }
}
