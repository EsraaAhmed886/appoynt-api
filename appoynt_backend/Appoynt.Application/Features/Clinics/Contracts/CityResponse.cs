/**
 * File Name      : CityResponse.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Response DTO representing an Egyptian city or district belonging to a governorate.
 */

namespace Appoynt.Application.Features.Clinics.Contracts;

using System;

/// <summary>
/// Represents the response model for a city.
/// </summary>
public sealed record CityResponse
{
    /// <summary>
    /// Gets the unique identifier of the city.
    /// </summary>
    public Guid Id { get; init; }

    /// <summary>
    /// Gets the unique identifier of the governorate this city belongs to.
    /// </summary>
    public Guid GovernorateId { get; init; }

    /// <summary>
    /// Gets the Arabic name of the city.
    /// </summary>
    public string NameAr { get; init; } = string.Empty;

    /// <summary>
    /// Gets the English name of the city.
    /// </summary>
    public string NameEn { get; init; } = string.Empty;
}
