/**
 * File Name      : ResetPasswordRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 27/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 27/07/2026
 * Description    : Represents the request payload for resetting a password.
 */

namespace Appoynt.Application.Features.Authentication.PasswordRecovery.Contracts;

/// <summary>
/// Represents the input model for resetting a password after OTP verification.
/// </summary>
public sealed class ResetPasswordRequest
{
    /// <summary>
    /// Gets or initializes the identifier (email or phone number) associated with the account.
    /// </summary>
    public string Identifier { get; init; } = string.Empty;

    /// <summary>
    /// Gets or initializes the secure reset token acquired from OTP verification.
    /// </summary>
    public string ResetToken { get; init; } = string.Empty;

    /// <summary>
    /// Gets or initializes the new password.
    /// </summary>
    public string NewPassword { get; init; } = string.Empty;

    /// <summary>
    /// Gets or initializes the confirmation of the new password.
    /// </summary>
    public string ConfirmPassword { get; init; } = string.Empty;
}
