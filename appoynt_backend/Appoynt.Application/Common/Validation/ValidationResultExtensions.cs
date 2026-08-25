/**
 * File Name      : ValidationResultExtensions.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-24
 * Version        : v1.0.0
 * Dependencies   : FluentValidation.Results, AuthenticationError
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-25
 * Description    : Provides the single canonical mapping from FluentValidation
 *                  failures to stable authentication errors, ensuring every
 *                  feature emits identical machine-readable error contracts.
 */

using System.Collections.Generic;
using System.Linq;
using Appoynt.Application.Common.Models;
using FluentValidation.Results;

namespace Appoynt.Application.Common.Validation;

/// <summary>
/// Centralizes the conversion of FluentValidation results into structured errors.
/// </summary>
public static class ValidationResultExtensions
{
    /// <summary>
    /// Maps validation failures to authentication errors using the team-wide convention:
    /// <c>Code</c> carries the validator's configured message (which all validators define
    /// as a stable machine-readable code) and <c>Field</c> carries the target property name.
    /// </summary>
    /// <param name="validationResult">The FluentValidation result to convert.</param>
    /// <returns>A materialized list of structured authentication errors.</returns>
    public static List<AuthenticationError> ToAuthenticationErrors(this ValidationResult validationResult)
    {
        // Project every failure into the shared error contract.
        return validationResult.Errors
            .Select(failure => new AuthenticationError(failure.ErrorMessage, failure.PropertyName))
            .ToList();
    }
}
