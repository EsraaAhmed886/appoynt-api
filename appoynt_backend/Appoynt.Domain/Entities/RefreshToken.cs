/**
 * File Name      : RefreshToken.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, ApplicationUser
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Represents a refresh token used to renew user authentication
 *                  without requiring the user to log in again.
 */

using Appoynt.Domain.Common;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a refresh token issued to an application user.
/// </summary>
public class RefreshToken : BaseEntity
{
    #region Properties

    // Foreign key referencing the associated application user.
    public Guid UserId { get; set; }

    // Hashed value of the refresh token.
    public required string TokenHash { get; set; }

    // Date and time when the refresh token expires.
    public DateTime ExpiresAt { get; set; }

    // Date and time when the refresh token was revoked.
    public DateTime? RevokedAt { get; set; }

    // Reason for revoking the refresh token.
    public string? RevocationReason { get; set; }

    // IP address from which the refresh token was created.
    public string? CreatedByIp { get; set; }

    // IP address from which the refresh token was revoked.
    public string? RevokedByIp { get; set; }

    // Navigation property to the associated application user.
    public required ApplicationUser User { get; set; }

    #endregion
}