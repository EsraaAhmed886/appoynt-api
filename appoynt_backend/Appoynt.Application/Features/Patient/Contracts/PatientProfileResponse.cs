/**
 * File Name      : PatientProfileResponse.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : Appoynt.Domain.Enums
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Data transfer object for patient profile response.
 */

using System;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.Patient.Contracts;

/// <summary>
/// Represents a patient profile response.
/// </summary>
public record PatientProfileResponse
{
    /// <summary>
    /// Gets the unique identifier of the patient.
    /// </summary>
    public Guid Id { get; init; }

    /// <summary>
    /// Gets the patient identifier (PID).
    /// </summary>
    public string PID { get; init; } = string.Empty;

    /// <summary>
    /// Gets the family number.
    /// </summary>
    public string FamilyNumber { get; init; } = string.Empty;

    /// <summary>
    /// Gets the national ID.
    /// </summary>
    public string? NationalId { get; init; }

    /// <summary>
    /// Gets the birth date.
    /// </summary>
    public DateOnly? BirthDate { get; init; }

    /// <summary>
    /// Gets the weight in kilograms.
    /// </summary>
    public decimal? WeightKg { get; init; }

    /// <summary>
    /// Gets the height in centimeters.
    /// </summary>
    public decimal? HeightCm { get; init; }

    /// <summary>
    /// Gets the blood group.
    /// </summary>
    public BloodGroup? BloodGroup { get; init; }

    /// <summary>
    /// Gets the smoking status.
    /// </summary>
    public SmokingStatus? SmokingStatus { get; init; }

    /// <summary>
    /// Gets a value indicating whether the patient has a profile photo.
    /// </summary>
    public bool HasProfilePhoto { get; init; }

    /// <summary>
    /// Gets the first name.
    /// </summary>
    public string FirstName { get; init; } = string.Empty;

    /// <summary>
    /// Gets the last name.
    /// </summary>
    public string LastName { get; init; } = string.Empty;

    /// <summary>
    /// Gets the email address.
    /// </summary>
    public string Email { get; init; } = string.Empty;

    /// <summary>
    /// Gets the phone number.
    /// </summary>
    public string PhoneNumber { get; init; } = string.Empty;

    /// <summary>
    /// Gets the gender.
    /// </summary>
    public Gender? Gender { get; init; }
}
