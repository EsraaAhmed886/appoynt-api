/**
 * File Name      : JwtOptions.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : DataAnnotations
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Represents the JSON Web Token configuration used to
 *                  issue and validate application access tokens.
 */

using System.ComponentModel.DataAnnotations;

namespace Appoynt.Infrastructure.Options;

/// <summary>
/// Represents the configuration values used for JSON Web Token authentication.
/// </summary>
public sealed class JwtOptions
{
    /// <summary>
    /// Gets the configuration section name for JWT options.
    /// </summary>
    public const string SectionName = "Jwt";

    /// <summary>
    /// Gets the token issuer.
    /// </summary>
    [Required]
    public string Issuer { get; init; } = string.Empty;

    /// <summary>
    /// Gets the token audience.
    /// </summary>
    [Required]
    public string Audience { get; init; } = string.Empty;

    /// <summary>
    /// Gets the secret key used to sign access tokens.
    /// </summary>
    [Required]
    [MinLength(32)]
    public string SecretKey { get; init; } = string.Empty;

    /// <summary>
    /// Gets the access-token lifetime, in minutes.
    /// </summary>
    [Range(1, int.MaxValue)]
    public int AccessTokenExpirationMinutes { get; init; }
}
