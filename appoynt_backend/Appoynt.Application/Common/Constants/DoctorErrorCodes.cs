/**
 * File Name      : DoctorErrorCodes.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : None
 * Last Modified  : Mustafa Mahmoud - 2026-08-30
 * Description    : Contains constant error codes for doctor validation, location, and operations.
 */

namespace Appoynt.Application.Common.Constants;

/// <summary>
/// Provides constant error codes for doctor-related validation and processing operations.
/// </summary>
public static class DoctorErrorCodes
{
    #region Profile Errors

    /// <summary>
    /// Indicates that the Arabic name is required.
    /// </summary>
    public const string NameArRequired = "doctor.name_ar.required";

    /// <summary>
    /// Indicates that the Arabic name exceeds the maximum allowed length.
    /// </summary>
    public const string NameArLengthInvalid = "doctor.name_ar.length_invalid";

    /// <summary>
    /// Indicates that the English name is required.
    /// </summary>
    public const string NameEnRequired = "doctor.name_en.required";

    /// <summary>
    /// Indicates that the English name exceeds the maximum allowed length.
    /// </summary>
    public const string NameEnLengthInvalid = "doctor.name_en.length_invalid";

    /// <summary>
    /// Indicates that the biography exceeds the maximum allowed length.
    /// </summary>
    public const string BioLengthInvalid = "doctor.bio.length_invalid";

    /// <summary>
    /// Indicates that the education summary exceeds the maximum allowed length.
    /// </summary>
    public const string EducationLengthInvalid = "doctor.education.length_invalid";

    /// <summary>
    /// Indicates that the specified doctor was not found.
    /// </summary>
    public const string DoctorNotFound = "doctor.not_found";

    #endregion

    #region Phone Number Errors

    /// <summary>
    /// Indicates that the doctor phone number is required.
    /// </summary>
    public const string PhoneNumberRequired = "doctor.phone_number.required";

    /// <summary>
    /// Indicates that the doctor phone number format is invalid.
    /// </summary>
    public const string PhoneNumberFormatInvalid = "doctor.phone_number.format_invalid";

    /// <summary>
    /// Indicates that the doctor phone number label is required.
    /// </summary>
    public const string PhoneLabelRequired = "doctor.phone_label.required";

    /// <summary>
    /// Indicates that the doctor phone number label exceeds the maximum allowed length.
    /// </summary>
    public const string PhoneLabelLengthInvalid = "doctor.phone_label.length_invalid";

    /// <summary>
    /// Indicates that the number of phone numbers exceeds the maximum limit per doctor.
    /// </summary>
    public const string MaxPhoneNumbersExceeded = "doctor.phone_number.max_limit_exceeded";

    /// <summary>
    /// Indicates that duplicate phone numbers were provided.
    /// </summary>
    public const string DuplicatePhoneNumber = "doctor.phone_number.duplicate";

    #endregion

    #region Specialization Errors

    /// <summary>
    /// Indicates that one or more specified specialization IDs do not exist.
    /// </summary>
    public const string SpecializationNotFound = "doctor.specialization.not_found";

    /// <summary>
    /// Indicates that no specializations were supplied when at least one is required.
    /// </summary>
    public const string SpecializationRequired = "doctor.specialization.required";

    /// <summary>
    /// Indicates that duplicate specialization identifiers were supplied.
    /// </summary>
    public const string SpecializationDuplicate = "doctor.specialization.duplicate";

    /// <summary>
    /// Indicates that the supplied birth date is not in the past.
    /// </summary>
    public const string BirthDateInvalid = "doctor.birth_date.invalid";

    #endregion

    #region Location Errors

    /// <summary>
    /// Indicates that the specified governorate was not found.
    /// </summary>
    public const string GovernorateNotFound = "doctor.governorate.not_found";

    /// <summary>
    /// Indicates that the specified city was not found.
    /// </summary>
    public const string CityNotFound = "doctor.city.not_found";

    /// <summary>
    /// Indicates that the specified city does not belong to the governorate.
    /// </summary>
    public const string CityGovernorateMismatch = "doctor.city_governorate_mismatch";

    #endregion
}
