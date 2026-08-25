/**
 * File Name      : DoctorBookingSummaryDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : ClinicSummaryDto
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-25
 * Description    : Public booking payload describing a doctor together with the
 *                  clinics patients can book into, ordered default-first.
 */

using System;
using System.Collections.Generic;

namespace Appoynt.Application.Features.Booking.Contracts;

/// <summary>
/// Describes a doctor and their bookable clinics for the patient booking screen.
/// </summary>
public sealed class DoctorBookingSummaryDto
{
    /// <summary>
    /// Gets the doctor identifier.
    /// </summary>
    public Guid DoctorId { get; init; }

    /// <summary>
    /// Gets the doctor's Arabic display name.
    /// </summary>
    public string NameAr { get; init; } = string.Empty;

    /// <summary>
    /// Gets the doctor's English display name.
    /// </summary>
    public string NameEn { get; init; } = string.Empty;

    /// <summary>
    /// Gets the public photo URL for the doctor, when available.
    /// </summary>
    public string? PhotoUrl { get; init; }

    /// <summary>
    /// Gets the doctor's active clinics with the default clinic listed first.
    /// </summary>
    public List<ClinicSummaryDto> Clinics { get; init; } = [];
}
