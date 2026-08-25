/**
 * File Name      : ProfileImageResult.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.1.0
 * Dependencies   : AuthenticationError, System.Text.Json.Serialization
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-25
 * Description    : Result object for profile image upload, retrieval, and deletion
 *                  operations, reusing the shared success/error foundation while
 *                  exposing the stored image path.
 */

using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace Appoynt.Application.Common.Models;

/// <summary>
/// Represents the result of a profile image management operation.
/// </summary>
public sealed class ProfileImageResult : ResultBase
{
    /// <summary>
    /// Gets the relative storage path of the profile image if the operation was successful.
    /// </summary>
    public string? StoredPath { get; init; }

    /// <summary>
    /// Initializes a new instance of the <see cref="ProfileImageResult"/> class.
    /// </summary>
    /// <param name="succeeded">Indicates success.</param>
    /// <param name="storedPath">The stored relative path.</param>
    /// <param name="errors">The collection of errors.</param>
    [JsonConstructor]
    public ProfileImageResult(bool succeeded, string? storedPath, IReadOnlyList<AuthenticationError>? errors)
        : base(succeeded, errors)
    {
        StoredPath = storedPath;
    }

    /// <summary>
    /// Parameterless constructor for serialization and property initialization.
    /// </summary>
    public ProfileImageResult()
        : base(false, null)
    {
    }

    /// <summary>
    /// Creates a successful profile image result.
    /// </summary>
    /// <param name="storedPath">The saved image path.</param>
    /// <returns>A successful <see cref="ProfileImageResult"/>.</returns>
    public static ProfileImageResult Success(string storedPath = "")
    {
        return new ProfileImageResult(true, storedPath, null);
    }

    /// <summary>
    /// Creates a failed profile image result with a single error.
    /// </summary>
    /// <param name="errorCode">The error code detailing the cause of failure.</param>
    /// <param name="propertyName">The property name associated with the error.</param>
    /// <returns>A failed <see cref="ProfileImageResult"/>.</returns>
    public static ProfileImageResult Failure(string errorCode, string propertyName = "")
    {
        return new ProfileImageResult(false, null, [new AuthenticationError(errorCode, propertyName)]);
    }

    /// <summary>
    /// Creates a failed profile image result with multiple errors.
    /// </summary>
    /// <param name="errors">The collection of errors.</param>
    /// <returns>A failed <see cref="ProfileImageResult"/>.</returns>
    public static ProfileImageResult Failure(IReadOnlyList<AuthenticationError> errors)
    {
        return new ProfileImageResult(false, null, errors);
    }
}
