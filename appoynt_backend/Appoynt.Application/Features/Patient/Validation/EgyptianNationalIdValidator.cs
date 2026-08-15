/**
 * File Name      : EgyptianNationalIdValidator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Validation logic for Egyptian National ID.
 */

using System;
using System.Collections.Generic;

namespace Appoynt.Application.Features.Patient.Validation;

/// <summary>
/// Represents the result of an Egyptian national ID validation.
/// </summary>
public class NationalIdValidationResult
{
    /// <summary>
    /// Gets a value indicating whether the national ID is valid.
    /// </summary>
    public bool IsValid { get; init; }

    /// <summary>
    /// Gets the list of error messages.
    /// </summary>
    public IReadOnlyList<string> Errors { get; init; } = Array.Empty<string>();

    /// <summary>
    /// Gets the birth date extracted from the national ID if valid.
    /// </summary>
    public DateOnly? ExtractedBirthDate { get; init; }

    /// <summary>
    /// Alias for ExtractedBirthDate.
    /// </summary>
    public DateOnly? BirthDate => ExtractedBirthDate;
}

/// <summary>
/// Provides validation logic for Egyptian National ID format.
/// </summary>
public static class EgyptianNationalIdValidator
{
    /// <summary>
    /// Validates an Egyptian national ID.
    /// </summary>
    /// <param name="nationalId">The national ID to validate.</param>
    /// <returns>A validation result.</returns>
    public static NationalIdValidationResult Validate(string? nationalId)
    {
        var errors = new List<string>();

        // Check for null or whitespace
        if (string.IsNullOrWhiteSpace(nationalId))
        {
            errors.Add("National ID is required.");
            return new NationalIdValidationResult { IsValid = false, Errors = errors };
        }

        // Check length and digits only
        if (nationalId.Length != 14)
        {
            errors.Add("National ID must be exactly 14 characters long.");
            return new NationalIdValidationResult { IsValid = false, Errors = errors };
        }

        foreach (var c in nationalId)
        {
            if (!char.IsDigit(c))
            {
                errors.Add("National ID must contain only digits.");
                return new NationalIdValidationResult { IsValid = false, Errors = errors };
            }
        }

        // Century indicator (2=1900s, 3=2000s)
        var centuryCode = int.Parse(nationalId.Substring(0, 1));
        if (centuryCode < 2 || centuryCode > 3)
        {
            errors.Add("Invalid century code.");
        }

        // Extracted year
        var yearPrefix = centuryCode == 2 ? 1900 : 2000;
        var shortYear = int.Parse(nationalId.Substring(1, 2));
        var year = yearPrefix + shortYear;

        // Month
        var month = int.Parse(nationalId.Substring(3, 2));
        if (month < 1 || month > 12)
        {
            errors.Add("Invalid month.");
        }

        // Day
        var day = int.Parse(nationalId.Substring(5, 2));
        if (day < 1 || day > 31)
        {
            errors.Add("Invalid day.");
        }

        // Governorate Code
        var govCode = int.Parse(nationalId.Substring(7, 2));
        var validGovCodes = new HashSet<int> { 1, 2, 3, 4, 11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 88 };
        if (!validGovCodes.Contains(govCode))
        {
            errors.Add("Invalid governorate code.");
        }

        DateOnly? extractedDate = null;

        // Validate date
        if (errors.Count == 0) // proceed only if basic parts are valid
        {
            try
            {
                extractedDate = new DateOnly(year, month, day);
            }
            catch (ArgumentOutOfRangeException)
            {
                errors.Add("The extracted date is not a valid calendar date.");
            }
        }

        return new NationalIdValidationResult
        {
            IsValid = errors.Count == 0,
            Errors = errors,
            ExtractedBirthDate = extractedDate
        };
    }
}
