/**
 * File Name      : UserConstants.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Defines constant values used for user validation
 *                  and business rules throughout the application.
 */

namespace Appoynt.Domain.Common.Constants;

/// <summary>
/// Provides constant values used for user validation.
/// </summary>
public static class UserConstants
{
    #region Name Constants

    // Minimum allowed length for the user's first and last name.
    public const int NameMinLength = 3;

    // Maximum allowed length for the user's first and last name.
    public const int NameMaxLength = 50;

    #endregion

    #region Address Constants

    // Maximum allowed length for the user's address.
    public const int AddressMaxLength = 500;

    #endregion

    #region Phone Constants

    // Required length of an Egyptian phone number.
    public const int PhoneNumberLength = 11;

    // Egyptian mobile number prefix.
    public const string PhonePrefix = "01";

    #endregion

    #region Username Constants

    // Minimum allowed username length.
    public const int UsernameMinLength = 3;

    // Maximum allowed username length.
    public const int UsernameMaxLength = 100;

    #endregion

    #region Password Constants

    // Minimum allowed password length.
    public const int PasswordMinLength = 8;

    // Maximum allowed password length.
    public const int PasswordMaxLength = 128;

    #endregion

    #region OTP Constants

    // Number of digits required for the OTP code.
    public const int OtpLength = 6;

    // OTP expiration time in seconds.
    public const int OtpExpirySeconds = 45;

    // Maximum allowed OTP verification attempts.
    public const int MaxOtpAttempts = 3;

    // Maximum allowed OTP resend attempts per session.
    public const int MaxOtpResends = 3;

    #endregion
}