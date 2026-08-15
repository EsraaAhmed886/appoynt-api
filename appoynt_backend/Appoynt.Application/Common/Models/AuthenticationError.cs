/**
 * File Name      : AuthenticationError.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Defines a stable, localization-ready error returned by
 *                  authentication application services.
 */

namespace Appoynt.Application.Common.Models;

/// <summary>
/// Represents an authentication validation or business-rule failure.
/// </summary>
/// <param name="code">The stable, client-localizable error code.</param>
/// <param name="field">The optional request field associated with the error.</param>
public sealed class AuthenticationError(string code, string? field = null)
{
    /// <summary>
    /// Gets the stable, client-localizable error code.
    /// </summary>
    public string Code { get; } = code;

    /// <summary>
    /// Gets the optional request field associated with the error.
    /// </summary>
    public string? Field { get; } = field;
}
