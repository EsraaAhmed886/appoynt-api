/**
 * File Name      : UserManagementResult.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 28/07/2026
 * Version        : v1.1.0
 * Dependencies   : AuthenticationError
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-24
 * Description    : Represents the outcome of a user management operation,
 *                  reusing the shared success/error foundation while exposing
 *                  the managed user identifier.
 */

using System;
using Appoynt.Application.Common.Models;

namespace Appoynt.Application.Features.UserManagement.Contracts;

/// <summary>
/// Represents either a successful user creation or its errors.
/// </summary>
public sealed class UserManagementResult : ResultBase
{
    /// <summary>
    /// Gets the unique identifier of the newly created user when successful.
    /// </summary>
    public Guid? UserId { get; init; }

    /// <summary>
    /// Initializes a new instance of the <see cref="UserManagementResult"/> class.
    /// </summary>
    /// <param name="succeeded">Indicates whether creation succeeded.</param>
    /// <param name="userId">The identifier of the affected user.</param>
    /// <param name="errors">The validation or business-rule errors.</param>
    [System.Text.Json.Serialization.JsonConstructor]
    public UserManagementResult(bool succeeded, Guid? userId, IReadOnlyList<AuthenticationError>? errors)
        : base(succeeded, errors)
    {
        UserId = userId;
    }

    /// <summary>
    /// Creates a successful user management result.
    /// </summary>
    /// <param name="userId">The unique identifier of the user.</param>
    /// <returns>A successful <see cref="UserManagementResult"/>.</returns>
    public static UserManagementResult Success(Guid userId)
    {
        return new UserManagementResult(true, userId, null);
    }

    /// <summary>
    /// Creates a failed user management result with a single error code and target property.
    /// </summary>
    /// <param name="errorCode">The error code detailing the failure cause.</param>
    /// <param name="propertyName">The name of the property associated with the error.</param>
    /// <returns>A failed <see cref="UserManagementResult"/>.</returns>
    public static UserManagementResult Failure(string errorCode, string propertyName = "")
    {
        return new UserManagementResult(false, null, new[] { new AuthenticationError(errorCode, propertyName) });
    }

    /// <summary>
    /// Creates a failed user management result with a list of errors.
    /// </summary>
    /// <param name="errors">The list of authentication/validation errors.</param>
    /// <returns>A failed <see cref="UserManagementResult"/>.</returns>
    public static UserManagementResult Failure(IReadOnlyList<AuthenticationError> errors)
    {
        return new UserManagementResult(false, null, errors);
    }
}
