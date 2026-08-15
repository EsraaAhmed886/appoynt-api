/**
 * File Name      : AuthenticationErrorCodes.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-07-31
 * Description    : Defines stable error codes for authentication features,
 *                  including registration, login, password recovery, OTP,
 *                  refresh tokens, and account verification.
 */

namespace Appoynt.Application.Common.Constants;

/// <summary>
/// Defines stable error codes for authentication validation and business-rule
/// failures.
/// </summary>
public static class AuthenticationErrorCodes
{
    #region Registration

    /// <summary>
    /// Indicates that the first name is required.
    /// </summary>
    public const string FirstNameRequired = "auth.registration.first_name.required";

    /// <summary>
    /// Indicates that the first name has an invalid length.
    /// </summary>
    public const string FirstNameLengthInvalid = "auth.registration.first_name.length_invalid";

    /// <summary>
    /// Indicates that the first name contains invalid characters.
    /// </summary>
    public const string FirstNameInvalidCharacters = "auth.registration.first_name.invalid_characters";

    /// <summary>
    /// Indicates that the last name is required.
    /// </summary>
    public const string LastNameRequired = "auth.registration.last_name.required";

    /// <summary>
    /// Indicates that the last name has an invalid length.
    /// </summary>
    public const string LastNameLengthInvalid = "auth.registration.last_name.length_invalid";

    /// <summary>
    /// Indicates that the last name contains invalid characters.
    /// </summary>
    public const string LastNameInvalidCharacters = "auth.registration.last_name.invalid_characters";

    /// <summary>
    /// Indicates that the phone number is required.
    /// </summary>
    public const string PhoneRequired = "auth.registration.phone.required";

    /// <summary>
    /// Indicates that the phone number has an invalid length.
    /// </summary>
    public const string PhoneLengthInvalid = "auth.registration.phone.length_invalid";

    /// <summary>
    /// Indicates that the phone number has an invalid prefix.
    /// </summary>
    public const string PhonePrefixInvalid = "auth.registration.phone.prefix_invalid";

    /// <summary>
    /// Indicates that the phone number has an invalid third digit.
    /// </summary>
    public const string PhoneThirdDigitInvalid = "auth.registration.phone.third_digit_invalid";

    /// <summary>
    /// Indicates that the phone number has an invalid format.
    /// </summary>
    public const string PhoneFormatInvalid = "auth.registration.phone.format_invalid";

    /// <summary>
    /// Indicates that the phone number is already registered.
    /// </summary>
    public const string PhoneAlreadyRegistered = "auth.registration.phone.already_registered";

    /// <summary>
    /// Indicates that the email address is required.
    /// </summary>
    public const string EmailRequired = "auth.registration.email.required";

    /// <summary>
    /// Indicates that the email address has an invalid format.
    /// </summary>
    public const string EmailInvalid = "auth.registration.email.invalid";

    /// <summary>
    /// Indicates that the email address is already registered.
    /// </summary>
    public const string EmailAlreadyRegistered = "auth.registration.email.already_registered";

    /// <summary>
    /// Indicates that the password is required.
    /// </summary>
    public const string PasswordRequired = "auth.registration.password.required";

    /// <summary>
    /// Indicates that the password has an invalid length.
    /// </summary>
    public const string PasswordLengthInvalid = "auth.registration.password.length_invalid";

    /// <summary>
    /// Indicates that the password does not meet complexity requirements.
    /// </summary>
    public const string PasswordComplexityInvalid = "auth.registration.password.complexity_invalid";

    /// <summary>
    /// Indicates that the password contains personal information.
    /// </summary>
    public const string PasswordContainsPersonalInformation = "auth.registration.password.contains_personal_information";

    /// <summary>
    /// Indicates that the password contains invalid whitespace or Arabic characters.
    /// </summary>
    public const string PasswordInvalidCharacters = "auth.registration.password.invalid_characters";

    /// <summary>
    /// Indicates that the confirmation password is required.
    /// </summary>
    public const string ConfirmPasswordRequired = "auth.registration.confirm_password.required";

    /// <summary>
    /// Indicates that the password confirmation does not match the password.
    /// </summary>
    public const string PasswordsDoNotMatch = "auth.registration.confirm_password.mismatch";

    /// <summary>
    /// Indicates that registration could not be completed.
    /// </summary>
    public const string RegistrationFailed = "auth.registration.failed";

    /// <summary>
    /// Indicates that the current doctor was not found when creating a receptionist.
    /// </summary>
    public const string CurrentDoctorNotFound = "auth.registration.doctor.not_found";

    /// <summary>
    /// Indicates that the action is forbidden.
    /// </summary>
    public const string Forbidden = "auth.forbidden";

    /// <summary>
    /// Indicates that the address has an invalid length.
    /// </summary>
    public const string AddressLengthInvalid = "auth.registration.address.length_invalid";

    /// <summary>
    /// Indicates that the requested user was not found.
    /// </summary>
    public const string UserNotFound = "auth.user.not_found";

    #endregion

    #region Login

    /// <summary>
    /// Indicates that the supplied login credentials are invalid.
    /// </summary>
    public const string InvalidCredentials = "auth.login.invalid_credentials";

    #endregion

    #region Password Recovery

    /// <summary>
    /// Indicates that the password recovery request is invalid.
    /// </summary>
    public const string PasswordRecoveryRequestInvalid = "auth.password_recovery.request_invalid";

    /// <summary>
    /// Indicates that the current password is invalid.
    /// </summary>
    public const string CurrentPasswordInvalid = "auth.password.current_invalid";

    /// <summary>
    /// Indicates that the new password matches a prohibited password value.
    /// </summary>
    public const string NewPasswordPreviouslyUsed = "auth.password.new_previously_used";

    #endregion

    #region One-Time Password

    /// <summary>
    /// Indicates that the one-time password is invalid.
    /// </summary>
    public const string OtpInvalid = "auth.otp.invalid";

    /// <summary>
    /// Indicates that the one-time password has expired.
    /// </summary>
    public const string OtpExpired = "auth.otp.expired";

    /// <summary>
    /// Indicates that the maximum number of OTP attempts has been reached.
    /// </summary>
    public const string OtpAttemptsExceeded = "auth.otp.attempts_exceeded";

    /// <summary>
    /// Indicates that the OTP resend limit has been reached.
    /// </summary>
    public const string OtpResendLimitReached = "auth.otp.resend_limit_reached";

    /// <summary>
    /// Indicates that an OTP resend request was made before the resend timer elapsed.
    /// </summary>
    public const string OtpResendNotAvailable = "auth.otp.resend_not_available";

    /// <summary>
    /// Indicates that an OTP could not be delivered by the configured sender.
    /// </summary>
    public const string OtpDeliveryUnavailable = "auth.otp.delivery_unavailable";

    #endregion

    #region Refresh Token

    /// <summary>
    /// Indicates that the refresh token is invalid.
    /// </summary>
    public const string RefreshTokenInvalid = "auth.refresh_token.invalid";

    /// <summary>
    /// Indicates that the refresh token has expired.
    /// </summary>
    public const string RefreshTokenExpired = "auth.refresh_token.expired";

    /// <summary>
    /// Indicates that the refresh token has been revoked.
    /// </summary>
    public const string RefreshTokenRevoked = "auth.refresh_token.revoked";

    #endregion
}
