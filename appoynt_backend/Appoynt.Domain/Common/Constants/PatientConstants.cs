/**
 * File Name      : PatientConstants.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-25
 * Description    : Defines constant values used for patient validation,
 *                  PID generation, family member management, National ID
 *                  validation, and profile photo storage rules.
 */

namespace Appoynt.Domain.Common.Constants;

/// <summary>
/// Provides constant values used for patient validation and business rules.
/// </summary>
public static class PatientConstants
{
    #region PID Constants

    /// <summary>
    /// The exact length of the Patient Identifier (PID).
    /// Format: 7-digit family number + 1-char relationship code + 1-digit sequence.
    /// </summary>
    public const int PidLength = 9;

    /// <summary>
    /// The exact length of the family number portion of the PID.
    /// </summary>
    public const int FamilyNumberLength = 7;

    /// <summary>
    /// The minimum value for a generated family number (7 digits).
    /// </summary>
    public const int FamilyNumberMinValue = 1000000;

    /// <summary>
    /// The maximum value for a generated family number (7 digits).
    /// </summary>
    public const int FamilyNumberMaxValue = 9999999;

    /// <summary>
    /// The maximum sequence number for family members within a single family.
    /// Sequence numbers range from 0 to 9.
    /// </summary>
    public const int MaxFamilyMemberSequence = 9;

    /// <summary>
    /// The valid PID relationship codes.
    /// </summary>
    public const string ValidRelationshipCodes = "UWHSDP";

    #endregion

    #region National ID Constants

    /// <summary>
    /// The exact length of an Egyptian National ID number.
    /// </summary>
    public const int NationalIdLength = 14;

    #endregion

    #region Name Constants

    /// <summary>
    /// The minimum length for a family member's full name.
    /// </summary>
    public const int FullNameMinLength = 3;

    /// <summary>
    /// The maximum length for a family member's full name.
    /// </summary>
    public const int FullNameMaxLength = 100;

    #endregion

    #region Measurement Constants

    /// <summary>
    /// The minimum allowed weight in kilograms.
    /// </summary>
    public const decimal WeightMinKg = 30m;

    /// <summary>
    /// The maximum allowed weight in kilograms.
    /// </summary>
    public const decimal WeightMaxKg = 250m;

    /// <summary>
    /// The minimum allowed height in centimeters.
    /// </summary>
    public const decimal HeightMinCm = 30m;

    /// <summary>
    /// The maximum allowed height in centimeters.
    /// </summary>
    public const decimal HeightMaxCm = 300m;

    #endregion

    #region Profile Photo Constants

    /// <summary>
    /// The maximum allowed profile photo file size in bytes (5 MB).
    /// </summary>
    public const long ProfilePhotoMaxSizeBytes = 5 * 1024 * 1024;

    /// <summary>
    /// The maximum page size accepted when listing favorite doctors or clinics.
    /// </summary>
    public const int MaxFavoritesPageSize = 50;

    /// <summary>
    /// The allowed file extensions for profile photos.
    /// </summary>
    public static readonly IReadOnlyList<string> AllowedPhotoExtensions =
    [
        ".jpg",
        ".jpeg",
        ".png",
        ".webp"
    ];

    /// <summary>
    /// The maximum length for the profile photo storage path.
    /// </summary>
    public const int ProfilePhotoPathMaxLength = 500;

    /// <summary>
    /// The storage subdirectory name for patient files.
    /// </summary>
    public const string PatientStorageDirectory = "patients";

    #endregion
}
