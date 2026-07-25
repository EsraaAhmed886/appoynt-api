/**
 * File Name      : OtpChallenge.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 25/07/2026
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, ApplicationUser, OtpPurpose
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 25/07/2026
 * Description    : Represents a persisted mobile one-time-password challenge
 *                  for phone confirmation or login verification.
 */

using Appoynt.Domain.Common;
using Appoynt.Domain.Enums;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a persisted mobile one-time-password challenge.
/// </summary>
public class OtpChallenge : BaseEntity
{
    /// <summary>
    /// Gets or sets the identifier of the user who owns the challenge.
    /// </summary>
    public Guid UserId { get; set; }

    /// <summary>
    /// Gets or sets the user who owns the challenge.
    /// </summary>
    public required ApplicationUser User { get; set; }

    /// <summary>
    /// Gets or sets the purpose for which the challenge was issued.
    /// </summary>
    public OtpPurpose Purpose { get; set; }

    /// <summary>
    /// Gets or sets the one-way hash of the generated OTP code.
    /// </summary>
    public required string CodeHash { get; set; }

    /// <summary>
    /// Gets or sets the UTC timestamp when the challenge expires.
    /// </summary>
    public DateTime ExpiresAt { get; set; }

    /// <summary>
    /// Gets or sets the number of verification attempts made for the challenge.
    /// </summary>
    public int VerificationAttempts { get; set; }

    /// <summary>
    /// Gets or sets the number of resends made for the challenge session.
    /// </summary>
    public int ResendCount { get; set; }

    /// <summary>
    /// Gets or sets the UTC timestamp when the challenge was sent.
    /// </summary>
    public DateTime SentAt { get; set; }

    /// <summary>
    /// Gets or sets the UTC timestamp when the challenge was successfully used.
    /// </summary>
    public DateTime? ConsumedAt { get; set; }

    /// <summary>
    /// Gets or sets the UTC timestamp when the challenge was invalidated by a
    /// replacement OTP.
    /// </summary>
    public DateTime? InvalidatedAt { get; set; }
}
