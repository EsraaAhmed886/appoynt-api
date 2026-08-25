/**
 * File Name      : FavoriteClinicResponse.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : System, Appoynt.Domain.Enums
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-23
 * Description    : Data transfer object representing a favorited clinic summary in mobile patient favorites list.
 */

using System;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.Patient.Contracts;

/// <summary>
/// Represents a summarized clinic card for the patient's favorites list.
/// </summary>
public sealed class FavoriteClinicResponse
{
    /// <summary>
    /// Gets the unique identifier of the clinic.
    /// </summary>
    public Guid Id { get; init; }

    /// <summary>
    /// Gets the name of the clinic.
    /// </summary>
    public string Name { get; init; } = string.Empty;

    /// <summary>
    /// Gets the detailed address and governorate/city information.
    /// </summary>
    public string? Location { get; init; }

    /// <summary>
    /// Gets the consultation fee for an appointment at this clinic.
    /// </summary>
    public decimal ConsultationFee { get; init; }

    /// <summary>
    /// Gets the operational status of the clinic.
    /// </summary>
    public ClinicStatus Status { get; init; }

    /// <summary>
    /// Gets a value indicating whether the clinic is active and non-deleted.
    /// </summary>
    public bool IsActive { get; init; }

    /// <summary>
    /// Gets the name of the managing doctor for this clinic.
    /// </summary>
    public string? DoctorName { get; init; }

    /// <summary>
    /// Gets the timestamp when this clinic was added to the patient's favorites.
    /// </summary>
    public DateTime AddedAt { get; init; }
}
