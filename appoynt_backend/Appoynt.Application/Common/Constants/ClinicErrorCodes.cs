/**
 * File Name      : ClinicErrorCodes.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Contains constant error codes for clinic validation and operations.
 */

namespace Appoynt.Application.Common.Constants;

/// <summary>
/// Static class containing all clinic-related error codes used across the system.
/// </summary>
public static class ClinicErrorCodes
{
    /// <summary>
    /// Clinic not found error code.
    /// </summary>
    public const string ClinicNotFound = "clinic.not_found";

    /// <summary>
    /// Clinic name required error code.
    /// </summary>
    public const string ClinicNameRequired = "clinic.name.required";

    /// <summary>
    /// Clinic name length invalid error code.
    /// </summary>
    public const string ClinicNameLengthInvalid = "clinic.name.length_invalid";

    /// <summary>
    /// Maximum clinics exceeded error code.
    /// </summary>
    public const string MaxClinicsExceeded = "clinic.max_clinics_exceeded";

    /// <summary>
    /// Not clinic owner error code.
    /// </summary>
    public const string NotOwner = "clinic.not_owner";

    /// <summary>
    /// Consultation fee required error code.
    /// </summary>
    public const string ConsultationFeeRequired = "clinic.consultation_fee.required";

    /// <summary>
    /// Consultation fee invalid error code.
    /// </summary>
    public const string ConsultationFeeInvalid = "clinic.consultation_fee.invalid";

    /// <summary>
    /// City and governorate mismatch error code.
    /// </summary>
    public const string CityGovernorateMismatch = "clinic.city_governorate_mismatch";

    /// <summary>
    /// Clinic duration invalid error code.
    /// </summary>
    public const string DurationInvalid = "clinic.duration.invalid";

    /// <summary>
    /// Advance booking invalid error code.
    /// </summary>
    public const string AdvanceBookingInvalid = "clinic.advance_booking.invalid";

    /// <summary>
    /// Clinic address length invalid error code.
    /// </summary>
    public const string AddressLengthInvalid = "clinic.address.length_invalid";

    /// <summary>
    /// Clinic status invalid error code.
    /// </summary>
    public const string StatusInvalid = "clinic.status.invalid";

    /// <summary>
    /// Schedule overlap detected error code.
    /// </summary>
    public const string ScheduleOverlapDetected = "clinic.schedule.overlap_detected";

    /// <summary>
    /// Cross clinic conflict error code.
    /// </summary>
    public const string CrossClinicConflict = "clinic.schedule.cross_clinic_conflict";

    /// <summary>
    /// Working period not found error code.
    /// </summary>
    public const string WorkingPeriodNotFound = "clinic.working_period.not_found";

    /// <summary>
    /// Invalid time range for working period error code.
    /// </summary>
    public const string WorkingPeriodInvalidTimeRange = "clinic.working_period.invalid_time_range";

    /// <summary>
    /// Break outside period error code.
    /// </summary>
    public const string BreakOutsidePeriod = "clinic.break.outside_period";

    /// <summary>
    /// Maximum breaks exceeded error code.
    /// </summary>
    public const string BreakMaxExceeded = "clinic.break.max_exceeded";

    /// <summary>
    /// Break not found error code.
    /// </summary>
    public const string BreakNotFound = "clinic.break.not_found";

    /// <summary>
    /// Break overlap detected error code.
    /// </summary>
    public const string BreakOverlapDetected = "clinic.break.overlap_detected";

    /// <summary>
    /// Maximum phones exceeded error code.
    /// </summary>
    public const string PhoneMaxExceeded = "clinic.phone.max_exceeded";

    /// <summary>
    /// Duplicate phone error code.
    /// </summary>
    public const string PhoneDuplicate = "clinic.phone.duplicate";

    /// <summary>
    /// Phone not found error code.
    /// </summary>
    public const string PhoneNotFound = "clinic.phone.not_found";

    /// <summary>
    /// Phone number required error code.
    /// </summary>
    public const string PhoneNumberRequired = "clinic.phone.number_required";

    /// <summary>
    /// Phone format invalid error code.
    /// </summary>
    public const string PhoneFormatInvalid = "clinic.phone.format_invalid";

    /// <summary>
    /// Phone label required error code.
    /// </summary>
    public const string PhoneLabelRequired = "clinic.phone.label_required";

    /// <summary>
    /// Phone label length invalid error code.
    /// </summary>
    public const string PhoneLabelLengthInvalid = "clinic.phone.label_length_invalid";

    /// <summary>
    /// Slot not available error code.
    /// </summary>
    public const string SlotNotAvailable = "clinic.slot.not_available";

    /// <summary>
    /// Slot already booked error code.
    /// </summary>
    public const string SlotAlreadyBooked = "clinic.slot.already_booked";

    /// <summary>
    /// Receptionist not same doctor error code.
    /// </summary>
    public const string ReceptionistNotSameDoctor = "clinic.receptionist.not_same_doctor";

    /// <summary>
    /// Receptionist already assigned error code.
    /// </summary>
    public const string ReceptionistAlreadyAssigned = "clinic.receptionist.already_assigned";

    /// <summary>
    /// Receptionist not found error code.
    /// </summary>
    public const string ReceptionistNotFound = "clinic.receptionist.not_found";

    /// <summary>
    /// Governorate not found error code.
    /// </summary>
    public const string GovernorateNotFound = "clinic.governorate.not_found";

    /// <summary>
    /// City not found error code.
    /// </summary>
    public const string CityNotFound = "clinic.city.not_found";
}
