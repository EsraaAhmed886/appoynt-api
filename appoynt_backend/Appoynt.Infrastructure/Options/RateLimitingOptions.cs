/**
 * File Name      : RateLimitingOptions.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 27/07/2026
 * Version        : v1.0.0
 * Dependencies   : System.ComponentModel.DataAnnotations
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 27/07/2026
 * Description    : Configuration options for rate limiting policies.
 */

using System.ComponentModel.DataAnnotations;

namespace Appoynt.Infrastructure.Options;

/// <summary>
/// Contains configuration settings for the rate limiting policies.
/// </summary>
public sealed class RateLimitingOptions
{
    /// <summary>
    /// The name of the configuration section.
    /// </summary>
    public const string SectionName = "RateLimiting";

    /// <summary>
    /// Gets or sets a value indicating whether rate limiting is enabled.
    /// Default is true.
    /// </summary>
    public bool Enabled { get; set; } = true;

    /// <summary>
    /// Gets or sets the policy for the Login endpoint.
    /// </summary>
    [Required]
    public RateLimitPolicyOptions Login { get; set; } = null!;

    /// <summary>
    /// Gets or sets the policy for the Register endpoint.
    /// </summary>
    [Required]
    public RateLimitPolicyOptions Register { get; set; } = null!;

    /// <summary>
    /// Gets or sets the policy for the OTP Verify endpoint.
    /// </summary>
    [Required]
    public RateLimitPolicyOptions OtpVerify { get; set; } = null!;

    /// <summary>
    /// Gets or sets the policy for the OTP Resend endpoint.
    /// </summary>
    [Required]
    public RateLimitPolicyOptions OtpResend { get; set; } = null!;

    /// <summary>
    /// Gets or sets the policy for the Forgot Password endpoint.
    /// </summary>
    [Required]
    public RateLimitPolicyOptions ForgotPassword { get; set; } = null!;

    /// <summary>
    /// Gets or sets the policy for the Reset Password endpoint.
    /// </summary>
    [Required]
    public RateLimitPolicyOptions ResetPassword { get; set; } = null!;
}

/// <summary>
/// Contains settings for a specific rate limit policy.
/// </summary>
public sealed class RateLimitPolicyOptions
{
    /// <summary>
    /// Gets or sets the maximum number of permitted requests.
    /// </summary>
    [Range(1, int.MaxValue)]
    public int PermitLimit { get; set; }

    /// <summary>
    /// Gets or sets the time window in minutes.
    /// </summary>
    [Range(1, int.MaxValue)]
    public int WindowInMinutes { get; set; }
}
