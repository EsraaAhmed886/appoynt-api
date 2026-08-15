/**
 * File Name      : RegistrationResult.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : AuthenticationError, RegisterResponse
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Represents the outcome of a registration operation.
 */

using Appoynt.Application.Common.Models;

namespace Appoynt.Application.Features.Authentication.Registration.Contracts;

/// <summary>
/// Represents either a successful patient registration or its authentication
/// errors.
/// </summary>
public sealed class RegistrationResult
{
    /// <summary>
    /// Gets a value indicating whether registration succeeded.
    /// </summary>
    public bool Succeeded { get; init; }

    /// <summary>
    /// Gets the successful registration response when registration succeeded.
    /// </summary>
    public RegisterResponse? Response { get; init; }

    /// <summary>
    /// Gets the validation or business-rule errors when registration failed.
    /// </summary>
    public IReadOnlyList<AuthenticationError> Errors { get; init; } = [];
}
