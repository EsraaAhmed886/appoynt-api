/**
 * File Name      : ClinicConstants.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Contains constant values and validation limits related to Clinics.
 */

using System;
using System.Collections.Generic;

namespace Appoynt.Domain.Common.Constants;

/// <summary>
/// Contains constant values and validation limits related to Clinics.
/// </summary>
public static class ClinicConstants
{
    /// <summary>
    /// The local-time cutoff separating morning from afternoon slots.
    /// Slots starting strictly before this time are considered morning slots.
    /// </summary>
    public static readonly TimeOnly MorningCutoff = new(12, 0);
    /// <summary>
    /// The maximum number of clinics a doctor can manage.
    /// </summary>
    public const int MaxClinicsPerDoctor = 15;

    /// <summary>
    /// The maximum length for a clinic name.
    /// </summary>
    public const int NameMaxLength = 200;

    /// <summary>
    /// The maximum length for a detailed address.
    /// </summary>
    public const int DetailedAddressMaxLength = 500;

    /// <summary>
    /// The maximum number of phone numbers per clinic.
    /// </summary>
    public const int MaxPhoneNumbersPerClinic = 5;

    /// <summary>
    /// The maximum length for a phone number label.
    /// </summary>
    public const int PhoneLabelMaxLength = 50;

    /// <summary>
    /// The maximum number of breaks allowed per working period.
    /// </summary>
    public const int MaxBreaksPerWorkingPeriod = 5;

    /// <summary>
    /// The timeout duration in minutes for pending appointment slots.
    /// </summary>
    public const int PendingTimeoutMinutes = 15;

    /// <summary>
    /// The allowed durations in minutes for an appointment slot.
    /// </summary>
    public static readonly int[] AllowedDurationMinutes = [10, 15, 20, 30, 45, 60];

    /// <summary>
    /// The allowed advance booking days for a clinic.
    /// </summary>
    public static readonly int[] AllowedAdvanceBookingDays = [7, 14, 21, 30, 60, 90];

    /// <summary>
    /// The maximum length for a governorate name.
    /// </summary>
    public const int GovernorateNameMaxLength = 100;

    /// <summary>
    /// The maximum length for a city name.
    /// </summary>
    public const int CityNameMaxLength = 100;
}
