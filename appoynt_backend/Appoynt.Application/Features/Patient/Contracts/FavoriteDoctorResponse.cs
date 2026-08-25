/**
 * File Name      : FavoriteDoctorResponse.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : System
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-23
 * Description    : Data transfer object representing a favorited doctor summary in mobile patient favorites list.
 */

using System;

namespace Appoynt.Application.Features.Patient.Contracts;

/// <summary>
/// Represents a summarized doctor card for the patient's favorites list.
/// </summary>
public sealed class FavoriteDoctorResponse
{
    /// <summary>
    /// Gets the unique identifier of the doctor.
    /// </summary>
    public Guid Id { get; init; }

    /// <summary>
    /// Gets the doctor's name in Arabic.
    /// </summary>
    public string? NameAr { get; init; }

    /// <summary>
    /// Gets the doctor's name in English.
    /// </summary>
    public string? NameEn { get; init; }

    /// <summary>
    /// Gets the URL of the doctor's profile photo.
    /// </summary>
    public string? PhotoUrl { get; init; }

    /// <summary>
    /// Gets the primary specialization title of the doctor.
    /// </summary>
    public string? Specialty { get; init; }

    /// <summary>
    /// Gets the primary clinic location or address for the doctor.
    /// </summary>
    public string? Location { get; init; }

    /// <summary>
    /// Gets the average rating of the doctor.
    /// </summary>
    public decimal Rating { get; init; }

    /// <summary>
    /// Gets the consultation fee starting price.
    /// </summary>
    public decimal Price { get; init; }

    /// <summary>
    /// Gets a value indicating whether the doctor has available appointment slots today.
    /// </summary>
    /// <remarks>
    /// Currently derived from doctor account active state. Will be bound to real-time slot generation in future release.
    /// </remarks>
    public bool IsAvailableToday { get; init; }

    /// <summary>
    /// Gets a value indicating whether the doctor is currently active and non-deleted.
    /// </summary>
    public bool IsActive { get; init; }

    /// <summary>
    /// Gets the timestamp when this doctor was added to the patient's favorites.
    /// </summary>
    public DateTime AddedAt { get; init; }
}
