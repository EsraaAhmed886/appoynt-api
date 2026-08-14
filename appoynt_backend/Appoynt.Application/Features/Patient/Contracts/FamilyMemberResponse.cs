/**
 * File Name      : FamilyMemberResponse.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : Appoynt.Domain.Enums
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Data transfer object for family member response.
 */

using System;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.Patient.Contracts;

/// <summary>
/// Represents a family member response.
/// </summary>
public record FamilyMemberResponse
{
    /// <summary>
    /// Gets the unique identifier of the family member.
    /// </summary>
    public Guid Id { get; init; }

    /// <summary>
    /// Gets the patient identifier (PID).
    /// </summary>
    public string PID { get; init; } = string.Empty;

    /// <summary>
    /// Gets the full name.
    /// </summary>
    public string FullName { get; init; } = string.Empty;

    /// <summary>
    /// Gets the gender.
    /// </summary>
    public Gender Gender { get; init; }

    /// <summary>
    /// Gets the relationship to the patient.
    /// </summary>
    public FamilyRelationship Relationship { get; init; }

    /// <summary>
    /// Gets the birth date.
    /// </summary>
    public DateOnly BirthDate { get; init; }
}
