/**
 * File Name      : AddFamilyMemberRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : Appoynt.Domain.Enums
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Data transfer object for adding a family member.
 */

using System;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.Patient.Contracts;

/// <summary>
/// Represents a request to add a family member.
/// </summary>
public record AddFamilyMemberRequest
{
    /// <summary>
    /// Gets the full name of the family member.
    /// </summary>
    public string? FullName { get; init; }

    /// <summary>
    /// Gets the gender of the family member.
    /// </summary>
    public Gender? Gender { get; init; }

    /// <summary>
    /// Gets the relationship of the family member to the patient.
    /// </summary>
    public FamilyRelationship? Relationship { get; init; }

    /// <summary>
    /// Gets the birth date of the family member.
    /// </summary>
    public DateOnly? BirthDate { get; init; }
}
