/**
 * File Name      : DoctorResult.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.1.0
 * Dependencies   : Appoynt.Application.Common.Models
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-25
 * Description    : Result object for doctor operations, reusing the shared
 *                  success/error foundation while exposing the doctor identifier.
 */

using System;
using System.Collections.Generic;
using Appoynt.Application.Common.Models;

namespace Appoynt.Application.Features.Doctor.Contracts;

/// <summary>
/// Represents the result of a doctor operation.
/// </summary>
public class DoctorResult : ResultBase
{
    /// <summary>
    /// Gets the doctor identifier if the operation was successful.
    /// </summary>
    public Guid? DoctorId { get; init; }

    /// <summary>
    /// Initializes a new instance of the <see cref="DoctorResult"/> class.
    /// </summary>
    /// <param name="succeeded">Indicates success.</param>
    /// <param name="doctorId">The doctor ID.</param>
    /// <param name="errors">The errors.</param>
    [System.Text.Json.Serialization.JsonConstructor]
    public DoctorResult(bool succeeded, Guid? doctorId, IReadOnlyList<AuthenticationError>? errors)
        : base(succeeded, errors)
    {
        DoctorId = doctorId;
    }

    /// <summary>
    /// Creates a successful result.
    /// </summary>
    /// <param name="doctorId">The doctor identifier.</param>
    /// <returns>A successful doctor result.</returns>
    public static DoctorResult Success(Guid? doctorId = null)
    {
        return new DoctorResult(true, doctorId, null);
    }

    /// <summary>
    /// Creates a failure result with a single error.
    /// </summary>
    /// <param name="errorCode">The error code.</param>
    /// <param name="propertyName">The property name.</param>
    /// <returns>A failed doctor result.</returns>
    public static DoctorResult Failure(string errorCode, string propertyName = "")
    {
        return new DoctorResult(false, null, new[] { new AuthenticationError(errorCode, propertyName) });
    }

    /// <summary>
    /// Creates a failure result with multiple errors.
    /// </summary>
    /// <param name="errors">The errors.</param>
    /// <returns>A failed doctor result.</returns>
    public static DoctorResult Failure(IReadOnlyList<AuthenticationError> errors)
    {
        return new DoctorResult(false, null, errors);
    }
}
