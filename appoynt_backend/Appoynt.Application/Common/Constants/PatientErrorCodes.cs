/**
 * File Name      : PatientErrorCodes.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.1.0
 * Dependencies   : None
 * Last Modified  : Mustafa Mahmoud - 2026-08-30
 * Description    : Contains constant error codes for patient, family member, location, and favorite operations.
 */

namespace Appoynt.Application.Common.Constants;

/// <summary>
/// Provides constant error code strings for patient-related validation and processing errors.
/// </summary>
public static class PatientErrorCodes
{
    // Patient General Errors
    public const string NotFound = "patient.not_found";
    public const string Forbidden = "patient.forbidden";
    public const string PidInvalid = "patient.pid.invalid";
    public const string PidDuplicate = "patient.pid.duplicate";

    // National ID Errors
    public const string NationalIdRequired = "patient.national_id.required";
    public const string NationalIdInvalidFormat = "patient.national_id.invalid_format";
    public const string NationalIdInvalidLength = "patient.national_id.invalid_length";
    public const string NationalIdInvalidDate = "patient.national_id.invalid_date";
    public const string NationalIdInvalidGovernorate = "patient.national_id.invalid_governorate";
    public const string NationalIdInvalidCheckDigit = "patient.national_id.invalid_check_digit";
    public const string NationalIdDuplicate = "patient.national_id.duplicate";

    // Measurement Errors
    public const string WeightOutOfRange = "patient.weight.out_of_range";
    public const string HeightOutOfRange = "patient.height.out_of_range";

    // Enumeration Errors
    public const string BloodGroupInvalid = "patient.blood_group.invalid";
    public const string SmokingStatusInvalid = "patient.smoking_status.invalid";

    // Profile Photo Errors
    public const string ProfilePhotoTooLarge = "patient.profile_photo.too_large";
    public const string ProfilePhotoUnsupportedType = "patient.profile_photo.unsupported_type";
    public const string ProfilePhotoEmpty = "patient.profile_photo.empty";
    public const string ProfilePhotoNotFound = "patient.profile_photo.not_found";
    public const string ProfilePhotoInvalidContent = "patient.profile_photo.invalid_content";

    // Family Member Errors
    public const string FamilyMemberFullNameRequired = "family_member.full_name.required";
    public const string FamilyMemberFullNameLengthInvalid = "family_member.full_name.length_invalid";
    public const string FamilyMemberGenderRequired = "family_member.gender.required";
    public const string FamilyMemberGenderInvalid = "family_member.gender.invalid";
    public const string FamilyMemberRelationshipRequired = "family_member.relationship.required";
    public const string FamilyMemberRelationshipInvalid = "family_member.relationship.invalid";
    public const string FamilyMemberRelationshipGenderMismatch = "family_member.relationship.gender_mismatch";
    public const string FamilyMemberBirthDateRequired = "family_member.birth_date.required";
    public const string FamilyMemberBirthDateInvalid = "family_member.birth_date.invalid";
    public const string FamilyMemberNotFound = "family_member.not_found";
    public const string FamilyMemberSequenceLimitReached = "family_member.sequence_limit_reached";

    // Patient Favorites Errors
    public const string FavoriteDoctorNotFound = "favorite.doctor_not_found";
    public const string FavoriteClinicNotFound = "favorite.clinic_not_found";
    public const string FavoriteAlreadyAdded = "favorite.already_added";
    public const string FavoriteNotInFavorites = "favorite.not_in_favorites";

    // Location Errors
    public const string GovernorateNotFound = "patient.governorate.not_found";
    public const string CityNotFound = "patient.city.not_found";
    public const string CityGovernorateMismatch = "patient.city_governorate_mismatch";
}
