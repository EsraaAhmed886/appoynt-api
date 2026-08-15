/**
 * File Name      : RefreshTokenConstants.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Defines the constant values used by the RefreshToken entity.
 */

namespace Appoynt.Domain.Common.Constants;

/// <summary>
/// Provides constant values used for refresh token validation and storage.
/// </summary>
public static class RefreshTokenConstants
{
    #region Refresh Token Constraints

    // Maximum length allowed for the hashed refresh token.
    public const int TokenHashMaxLength = 500;

    // Maximum length allowed for the token revocation reason.
    public const int RevocationReasonMaxLength = 500;

    // Maximum length allowed for an IPv4 or IPv6 address.
    public const int IpAddressMaxLength = 45;

    #endregion
}