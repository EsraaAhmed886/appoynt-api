/**
 * File Name      : DoctorConstants.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Defines constant values used for doctor validation,
 *                  profile fields, phone numbers, and specializations.
 */

namespace Appoynt.Domain.Common.Constants;

/// <summary>
/// Provides constant values used for doctor validation and business rules.
/// </summary>
public static class DoctorConstants
{
    #region Profile Constants

    /// <summary>
    /// The maximum allowed length for doctor display names (Arabic and English).
    /// </summary>
    public const int NameMaxLength = 100;

    /// <summary>
    /// The maximum allowed length for doctor biography.
    /// </summary>
    public const int BioMaxLength = 2000;

    /// <summary>
    /// The maximum allowed length for doctor education and qualifications summary.
    /// </summary>
    public const int EducationMaxLength = 1000;

    #endregion

    #region Phone Number Constants

    /// <summary>
    /// The maximum allowed length for a doctor phone number label (e.g., 'Clinic', 'Emergency').
    /// </summary>
    public const int PhoneLabelMaxLength = 50;

    /// <summary>
    /// The maximum number of additional phone numbers a doctor can have.
    /// </summary>
    public const int MaxPhoneNumbersPerDoctor = 5;

    #endregion

    #region Specialization Constants

    /// <summary>
    /// The maximum allowed length for a specialization name (Arabic and English).
    /// </summary>
    public const int SpecializationNameMaxLength = 100;

    #endregion
}
