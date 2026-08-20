/**
 * File Name      : ClinicResult.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Represents the outcome of a clinic operation, containing success status, optional clinic ID, and error list.
 */

using System;
using System.Collections.Generic;
using System.Linq;

namespace Appoynt.Application.Features.Clinics.Contracts;

/// <summary>
/// Represents the result of a clinic operation.
/// </summary>
public sealed class ClinicResult
{
    /// <summary>
    /// Initializes a new instance of the <see cref="ClinicResult"/> class.
    /// </summary>
    private ClinicResult(bool succeeded, List<ClinicError>? errors = null, Guid? clinicId = null)
    {
        Succeeded = succeeded;
        Errors = errors ?? [];
        ClinicId = clinicId;
    }

    /// <summary>
    /// Gets a value indicating whether the operation succeeded.
    /// </summary>
    public bool Succeeded { get; init; }

    /// <summary>
    /// Gets the list of errors, if any.
    /// </summary>
    public List<ClinicError> Errors { get; init; }

    /// <summary>
    /// Gets the clinic identifier, if applicable.
    /// </summary>
    public Guid? ClinicId { get; init; }

    /// <summary>
    /// Creates a successful clinic result.
    /// </summary>
    /// <param name="clinicId">The optional clinic ID.</param>
    /// <returns>A successful <see cref="ClinicResult"/>.</returns>
    public static ClinicResult Success(Guid? clinicId = null)
    {
        return new ClinicResult(true, clinicId: clinicId);
    }

    /// <summary>
    /// Creates a failed clinic result with a single error.
    /// </summary>
    /// <param name="code">The error code.</param>
    /// <param name="field">The optional field associated with the error.</param>
    /// <returns>A failed <see cref="ClinicResult"/>.</returns>
    public static ClinicResult Failure(string code, string? field = null)
    {
        return new ClinicResult(false, [new ClinicError(code, field)]);
    }

    /// <summary>
    /// Creates a failed clinic result with multiple errors.
    /// </summary>
    /// <param name="errors">The list of clinic errors.</param>
    /// <returns>A failed <see cref="ClinicResult"/>.</returns>
    public static ClinicResult Failure(IEnumerable<ClinicError> errors)
    {
        return new ClinicResult(false, errors.ToList());
    }
}

/// <summary>
/// Represents an error in a clinic operation.
/// </summary>
/// <param name="Code">The error code.</param>
/// <param name="Field">The field associated with the error.</param>
public sealed record ClinicError(string Code, string? Field = null);

