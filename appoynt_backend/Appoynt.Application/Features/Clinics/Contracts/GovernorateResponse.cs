/**
 * File Name      : GovernorateResponse.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Response DTO representing an Egyptian governorate lookup entity.
 */

namespace Appoynt.Application.Features.Clinics.Contracts;

using System;

/// <summary>
/// Represents the response model for a governorate.
/// </summary>
public sealed record GovernorateResponse
{
    /// <summary>
    /// Gets the unique identifier of the governorate.
    /// </summary>
    public Guid Id { get; init; }

    /// <summary>
    /// Gets the Arabic name of the governorate.
    /// </summary>
    public string NameAr { get; init; } = string.Empty;

    /// <summary>
    /// Gets the English name of the governorate.
    /// </summary>
    public string NameEn { get; init; } = string.Empty;
}
