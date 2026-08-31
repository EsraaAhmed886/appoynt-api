/**
 * File Name      : MedicalRecordOperationResult.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : ResultBase, AuthenticationError, MedicalRecordDetailDto
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Operation result envelope for medical record lifecycle actions and mutations.
 */

using System;
using System.Collections.Generic;
using Appoynt.Application.Common.Models;

namespace Appoynt.Application.Features.MedicalRecords.Contracts;

/// <summary>
/// Carries the outcome of a medical record operation (create draft, save, finalize, edit, discard).
/// </summary>
public sealed class MedicalRecordOperationResult : ResultBase
{
    /// <summary>
    /// Gets the resulting medical record detail payload if the operation succeeded.
    /// </summary>
    public MedicalRecordDetailDto? Record { get; private init; }

    /// <summary>
    /// Initializes a new instance of the <see cref="MedicalRecordOperationResult"/> class for success.
    /// </summary>
    /// <param name="record">The populated medical record detail.</param>
    public static MedicalRecordOperationResult Success(MedicalRecordDetailDto record)
    {
        return new MedicalRecordOperationResult(true, null)
        {
            Record = record
        };
    }

    /// <summary>
    /// Initializes a new instance of the <see cref="MedicalRecordOperationResult"/> class for failure.
    /// </summary>
    /// <param name="errors">The list of validation or business rule errors.</param>
    public static MedicalRecordOperationResult Failure(IReadOnlyList<AuthenticationError> errors)
    {
        return new MedicalRecordOperationResult(false, errors);
    }

    /// <summary>
    /// Initializes a new instance of the <see cref="MedicalRecordOperationResult"/> class for a single failure error code.
    /// </summary>
    /// <param name="code">The error code.</param>
    /// <param name="field">Optional property name.</param>
    public static MedicalRecordOperationResult Failure(string code, string? field = null)
    {
        return new MedicalRecordOperationResult(false, [new AuthenticationError(code, field)]);
    }

    private MedicalRecordOperationResult(bool succeeded, IReadOnlyList<AuthenticationError>? errors)
        : base(succeeded, errors)
    {
    }
}
