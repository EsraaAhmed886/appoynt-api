/**
 * File Name      : ClinicResponse.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : ClinicPhoneNumberDto
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Response DTO containing comprehensive clinic details including phone numbers and working schedules.
 */

using System;
using System.Collections.Generic;

namespace Appoynt.Application.Features.Clinics.Contracts;

/// <summary>
/// Represents the response model for a clinic.
/// </summary>
public sealed class ClinicResponse
    {
        /// <summary>
        /// Gets the clinic unique identifier.
        /// </summary>
        public Guid Id { get; init; }

        /// <summary>
        /// Gets the associated doctor's identifier.
        /// </summary>
        public Guid DoctorId { get; init; }

        /// <summary>
        /// Gets the name of the clinic.
        /// </summary>
        public string Name { get; init; } = string.Empty;

        /// <summary>
        /// Gets the name of the governorate.
        /// </summary>
        public string GovernorateName { get; init; } = string.Empty;

        /// <summary>
        /// Gets the name of the city.
        /// </summary>
        public string CityName { get; init; } = string.Empty;

        /// <summary>
        /// Gets the detailed address of the clinic.
        /// </summary>
        public string? DetailedAddress { get; init; }

        /// <summary>
        /// Gets the consultation fee.
        /// </summary>
        public decimal ConsultationFee { get; init; }

        /// <summary>
        /// Gets the current status of the clinic.
        /// </summary>
        public string Status { get; init; } = string.Empty;

        /// <summary>
        /// Gets the standard appointment duration in minutes.
        /// </summary>
        public int AppointmentDurationMinutes { get; init; }

        /// <summary>
        /// Gets the maximum number of advance booking days.
        /// </summary>
        public int MaxAdvanceBookingDays { get; init; }

        /// <summary>
        /// Gets the list of clinic phone numbers.
        /// </summary>
        public List<ClinicPhoneNumberDto> PhoneNumbers { get; init; } = new();

        /// <summary>
        /// Gets the working periods of the clinic.
        /// </summary>
        public List<WorkingPeriodResponse> WorkingPeriods { get; init; } = new();

        /// <summary>
        /// Represents the working period response model.
        /// </summary>
        public sealed class WorkingPeriodResponse
        {
            /// <summary>
            /// Gets the working period identifier.
            /// </summary>
            public Guid Id { get; init; }

            /// <summary>
            /// Gets the day of the week as an integer.
            /// </summary>
            public int DayOfWeek { get; init; }

            /// <summary>
            /// Gets the name of the day.
            /// </summary>
            public string DayName { get; init; } = string.Empty;

            /// <summary>
            /// Gets the start time.
            /// </summary>
            public string StartTime { get; init; } = string.Empty;

            /// <summary>
            /// Gets the end time.
            /// </summary>
            public string EndTime { get; init; } = string.Empty;

            /// <summary>
            /// Gets a value indicating whether this working period is active.
            /// </summary>
            public bool IsActive { get; init; }

            /// <summary>
            /// Gets the breaks during this working period.
            /// </summary>
            public List<BreakResponse> Breaks { get; init; } = new();
        }

        /// <summary>
        /// Represents the break response model.
        /// </summary>
        public sealed class BreakResponse
        {
            /// <summary>
            /// Gets the break identifier.
            /// </summary>
            public Guid Id { get; init; }

            /// <summary>
            /// Gets the start time of the break.
            /// </summary>
            public string StartTime { get; init; } = string.Empty;

            /// <summary>
            /// Gets the end time of the break.
            /// </summary>
            public string EndTime { get; init; } = string.Empty;
        }
    }
