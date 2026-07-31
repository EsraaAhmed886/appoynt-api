/**
 * File Name      : OtpPurpose.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Defines the supported purposes for mobile OTP challenges.
 */

namespace Appoynt.Domain.Enums;

/// <summary>
/// Represents the supported purposes for a mobile one-time-password challenge.
/// </summary>
public enum OtpPurpose
{
    /// <summary>
    /// Confirms the mobile phone number supplied during registration.
    /// </summary>
    PhoneConfirmation = 0,

    /// <summary>
    /// Verifies identity to issue a password reset token.
    /// </summary>
    PasswordReset = 1
}
