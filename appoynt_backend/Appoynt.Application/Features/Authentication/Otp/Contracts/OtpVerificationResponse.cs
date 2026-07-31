/**
 * File Name      : OtpVerificationResponse.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 25/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 25/07/2026
 * Description    : Defines the successful result of confirming a phone number
 *                  through an OTP challenge.
 */

namespace Appoynt.Application.Features.Authentication.Otp.Contracts;

/// <summary>
/// Represents the successful result of confirming a mobile phone number.
/// </summary>
public sealed class OtpVerificationResponse
{
    /// <summary>
    /// Gets or initializes a value indicating whether the phone number is
    /// confirmed.
    /// </summary>
    public bool? PhoneNumberConfirmed { get; init; }

    /// <summary>
    /// Gets or initializes the password reset token, populated only when the
    /// OTP purpose is PasswordReset.
    /// </summary>
    public string? PasswordResetToken { get; init; }
}
