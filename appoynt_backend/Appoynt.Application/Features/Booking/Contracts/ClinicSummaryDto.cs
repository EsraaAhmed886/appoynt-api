/**
 * File Name      : ClinicSummaryDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : WorkingPeriodDto
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-25
 * Description    : Public booking payload describing a single bookable clinic,
 *                  including location, fee, default flag, and weekly schedule.
 */

using System;
using System.Collections.Generic;

namespace Appoynt.Application.Features.Booking.Contracts;

/// <summary>
/// Describes one clinic of a doctor on the patient booking screen.
/// </summary>
public sealed class ClinicSummaryDto
{
    /// <summary>
    /// Gets the clinic identifier.
    /// </summary>
    public Guid ClinicId { get; init; }

    /// <summary>
    /// Gets the clinic display name.
    /// </summary>
    public string Name { get; init; } = string.Empty;

    /// <summary>
    /// Gets the detailed street address, when provided.
    /// </summary>
    public string? DetailedAddress { get; init; }

    /// <summary>
    /// Gets the geographic latitude, when pinned.
    /// </summary>
    public double? Latitude { get; init; }

    /// <summary>
    /// Gets the geographic longitude, when pinned.
    /// </summary>
    public double? Longitude { get; init; }

    /// <summary>
    /// Gets the consultation fee charged per appointment.
    /// </summary>
    public decimal ConsultationFee { get; init; }

    /// <summary>
    /// Gets a value indicating whether this clinic is the doctor's primary clinic.
    /// </summary>
    public bool IsDefault { get; init; }

    /// <summary>
    /// Gets the recurring weekly working periods during which slots exist.
    /// </summary>
    public List<WorkingPeriodDto> WorkingDays { get; init; } = [];
}
