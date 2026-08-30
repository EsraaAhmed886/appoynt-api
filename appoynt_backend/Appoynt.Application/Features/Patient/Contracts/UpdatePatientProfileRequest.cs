/**
 * File Name      : UpdatePatientProfileRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : System, Appoynt.Domain.Enums
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-30
 * Description    : Data transfer object for updating a patient profile.
 */

using Appoynt.Application.Common.Models;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.Patient.Contracts;

/// <summary>
/// Represents a request to update a patient profile.
/// </summary>
public record UpdatePatientProfileRequest
{
    /// <summary>
    /// Gets the first name.
    /// </summary>
    public string? FirstName { get; init; }

    /// <summary>
    /// Gets the last name.
    /// </summary>
    public string? LastName { get; init; }

    /// <summary>
    /// Gets the gender.
    /// </summary>
    public Gender? Gender { get; init; }

    /// <summary>
    /// Gets the birth date.
    /// </summary>
    public DateOnly? BirthDate { get; init; }

    /// <summary>
    /// Gets the user's location address details.
    /// </summary>
    public UpdateAddressDto? Address { get; init; }

    /// <summary>
    /// Gets the national ID.
    /// </summary>
    public string? NationalId { get; init; }

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
}
