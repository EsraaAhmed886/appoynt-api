/**
 * File Name      : PatientResult.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : Appoynt.Application.Common.Models
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Result object for patient operations.
 */

using System;
using System.Collections.Generic;
using Appoynt.Application.Common.Models;

namespace Appoynt.Application.Features.Patient.Contracts;

/// <summary>
/// Represents the result of a patient operation.
/// </summary>
public class PatientResult
{
    /// <summary>
    /// Gets a value indicating whether the operation succeeded.
    /// </summary>
    public bool Succeeded { get; init; }

    /// <summary>
    /// Gets the patient identifier if the operation was successful.
    /// </summary>
    public Guid? PatientId { get; init; }

    /// <summary>
    /// Gets the list of errors if the operation failed.
    /// </summary>
    public IReadOnlyList<AuthenticationError> Errors { get; init; }

    /// <summary>
    /// Initializes a new instance of the <see cref="PatientResult"/> class.
    /// </summary>
    /// <param name="succeeded">Indicates success.</param>
    /// <param name="patientId">The patient ID.</param>
    /// <param name="errors">The errors.</param>
    [System.Text.Json.Serialization.JsonConstructor]
    public PatientResult(bool succeeded, Guid? patientId, IReadOnlyList<AuthenticationError>? errors)
    {
        Succeeded = succeeded;
        PatientId = patientId;
        Errors = errors ?? Array.Empty<AuthenticationError>();
    }

    /// <summary>
    /// Creates a successful result.
    /// </summary>
    /// <param name="patientId">The patient identifier.</param>
    /// <returns>A successful patient result.</returns>
    public static PatientResult Success(Guid patientId)
    {
        return new PatientResult(true, patientId, null);
    }

    /// <summary>
    /// Creates a failure result with a single error.
    /// </summary>
    /// <param name="errorCode">The error code.</param>
    /// <param name="propertyName">The property name.</param>
    /// <returns>A failed patient result.</returns>
    public static PatientResult Failure(string errorCode, string propertyName = "")
    {
        return new PatientResult(false, null, new[] { new AuthenticationError(errorCode, propertyName) });
    }

    /// <summary>
    /// Creates a failure result with multiple errors.
    /// </summary>
    /// <param name="errors">The collection of errors.</param>
    /// <returns>A failed patient result.</returns>
    public static PatientResult Failure(IReadOnlyList<AuthenticationError> errors)
    {
        return new PatientResult(false, null, errors);
    }
}
