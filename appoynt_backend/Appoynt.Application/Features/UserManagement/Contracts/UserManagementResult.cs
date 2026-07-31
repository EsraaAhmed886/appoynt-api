/**
 * File Name      : UserManagementResult.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 28/07/2026
 * Version        : v1.0.0
 * Dependencies   : AuthenticationError
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-07-31
 * Description    : Represents the outcome of a user management operation.
 */

using Appoynt.Application.Common.Models;

namespace Appoynt.Application.Features.UserManagement.Contracts;

/// <summary>
/// Represents either a successful user creation or its errors.
/// </summary>
public sealed class UserManagementResult
{
    /// <summary>
    /// Gets a value indicating whether the creation succeeded.
    /// </summary>
    public bool Succeeded { get; init; }

    /// <summary>
    /// Gets the unique identifier of the newly created user when successful.
    /// </summary>
    public Guid? UserId { get; init; }

    /// <summary>
    /// Gets the validation or business-rule errors when creation failed.
    /// </summary>
    public IReadOnlyList<AuthenticationError> Errors { get; init; } = [];

    /// <summary>
    /// Creates a successful user management result.
    /// </summary>
    /// <param name="userId">The unique identifier of the user.</param>
    /// <returns>A successful <see cref="UserManagementResult"/>.</returns>
    public static UserManagementResult Success(Guid userId)
    {
        return new UserManagementResult { Succeeded = true, UserId = userId };
    }

    /// <summary>
    /// Creates a failed user management result with a single error code and target property.
    /// </summary>
    /// <param name="errorCode">The error code detailing the failure cause.</param>
    /// <param name="propertyName">The name of the property associated with the error.</param>
    /// <returns>A failed <see cref="UserManagementResult"/>.</returns>
    public static UserManagementResult Failure(string errorCode, string propertyName = "")
    {
        return new UserManagementResult { Errors = [new AuthenticationError(errorCode, propertyName)] };
    }

    /// <summary>
    /// Creates a failed user management result with a list of errors.
    /// </summary>
    /// <param name="errors">The list of authentication/validation errors.</param>
    /// <returns>A failed <see cref="UserManagementResult"/>.</returns>
    public static UserManagementResult Failure(IReadOnlyList<AuthenticationError> errors)
    {
        return new UserManagementResult { Errors = errors };
    }
}
