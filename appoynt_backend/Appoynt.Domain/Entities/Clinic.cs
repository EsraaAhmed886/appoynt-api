/**
 * File Name      : Clinic.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, Doctor, Governorate, City, ClinicPhoneNumber, ClinicWorkingPeriod, AppointmentSlot, ClinicReceptionist, ClinicStatus
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Represents a doctor's clinic with its operational details and associated relationships.
 */

using System;
using System.Collections.Generic;
using Appoynt.Domain.Common;
using Appoynt.Domain.Enums;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a clinic managed by a doctor.
/// </summary>
public class Clinic : BaseEntity
{
    #region Business Properties

    /// <summary>
    /// Gets or sets the name of the clinic.
    /// </summary>
    public required string Name { get; set; }

    /// <summary>
    /// Gets or sets the detailed address of the clinic.
    /// </summary>
    public string? DetailedAddress { get; set; }

    /// <summary>
    /// Gets or sets the consultation fee for an appointment at this clinic.
    /// </summary>
    public decimal ConsultationFee { get; set; }

    /// <summary>
    /// Gets or sets the operational status of the clinic.
    /// </summary>
    public ClinicStatus Status { get; set; }

    /// <summary>
    /// Gets or sets the duration of an appointment slot in minutes.
    /// </summary>
    public int AppointmentDurationMinutes { get; set; }

    /// <summary>
    /// Gets or sets the maximum number of days in advance an appointment can be booked.
    /// </summary>
    public int MaxAdvanceBookingDays { get; set; }

    #endregion

    #region Relationship Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the associated doctor.
    /// </summary>
    public Guid DoctorId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the associated doctor.
    /// </summary>
    public required Doctor Doctor { get; set; }

    /// <summary>
    /// Gets or sets the foreign key referencing the associated governorate.
    /// </summary>
    public Guid GovernorateId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the associated governorate.
    /// </summary>
    public required Governorate Governorate { get; set; }

    /// <summary>
    /// Gets or sets the foreign key referencing the associated city.
    /// </summary>
    public Guid CityId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the associated city.
    /// </summary>
    public required City City { get; set; }

    /// <summary>
    /// Gets or sets the collection of phone numbers associated with this clinic.
    /// </summary>
    public ICollection<ClinicPhoneNumber> PhoneNumbers { get; set; } = [];

    /// <summary>
    /// Gets or sets the collection of working periods for this clinic.
    /// </summary>
    public ICollection<ClinicWorkingPeriod> WorkingPeriods { get; set; } = [];

    /// <summary>
    /// Gets or sets the collection of appointment slots for this clinic.
    /// </summary>
    public ICollection<AppointmentSlot> Slots { get; set; } = [];

    /// <summary>
    /// Gets or sets the collection of clinic receptionists assigned to this clinic.
    /// </summary>
    public ICollection<ClinicReceptionist> ClinicReceptionists { get; set; } = [];

    #endregion
}
