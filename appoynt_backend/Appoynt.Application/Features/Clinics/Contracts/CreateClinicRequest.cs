/**
 * File Name      : CreateClinicRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : ClinicPhoneNumberDto, WorkingPeriodRequest
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Request contract for creating a new clinic along with optional contact phone numbers and weekly schedule templates.
 */

namespace Appoynt.Application.Features.Clinics.Contracts;

using System;
using System.Collections.Generic;

/// <summary>
/// Represents the data required to create a new clinic.
/// </summary>
public sealed class CreateClinicRequest
{
    #region Clinic Properties

    /// <summary>
    /// Gets the name of the clinic.
    /// </summary>
    public string? Name { get; init; }

    /// <summary>
    /// Gets the consultation fee.
    /// </summary>
    public decimal? ConsultationFee { get; init; }

    #endregion

    #region Booking Settings

    /// <summary>
    /// Gets the duration of an appointment in minutes.
    /// </summary>
    public int? AppointmentDurationMinutes { get; init; }

    /// <summary>
    /// Gets the maximum advance booking days.
    /// </summary>
    public int? MaxAdvanceBookingDays { get; init; }

    #endregion

    #region Relationship Properties

    /// <summary>
    /// Gets the ID of the governorate.
    /// </summary>
    public Guid? GovernorateId { get; init; }

    /// <summary>
    /// Gets the ID of the city.
    /// </summary>
    public Guid? CityId { get; init; }

    /// <summary>
    /// Gets the detailed address of the clinic.
    /// </summary>
    public string? DetailedAddress { get; init; }

    /// <summary>
    /// Gets the list of phone numbers associated with the clinic.
    /// </summary>
    public List<ClinicPhoneNumberDto>? PhoneNumbers { get; init; }

    /// <summary>
    /// Gets the list of working periods.
    /// </summary>
    public List<WorkingPeriodRequest>? WorkingPeriods { get; init; }

    #endregion
}
