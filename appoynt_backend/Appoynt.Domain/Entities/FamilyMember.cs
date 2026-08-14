/**
 * File Name      : FamilyMember.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, Patient, Gender, FamilyRelationship
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Represents a family member associated with a primary
 *                  patient account owner. Each family member shares the
 *                  same family number and receives a unique PID.
 */

using Appoynt.Domain.Common;
using Appoynt.Domain.Enums;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a family member linked to a primary patient account owner.
/// </summary>
public class FamilyMember : BaseEntity
{
    #region Identity Properties

    /// <summary>
    /// Gets or sets the Patient Identifier (PID) for this family member.
    /// Format: 7-digit family number + relationship code + sequence digit.
    /// Example: 1234567W1.
    /// </summary>
    public string PID { get; set; } = string.Empty;

    #endregion

    #region Personal Information

    /// <summary>
    /// Gets or sets the full name of the family member.
    /// </summary>
    public string FullName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the gender of the family member.
    /// </summary>
    public Gender Gender { get; set; }

    /// <summary>
    /// Gets or sets the relationship of this member to the primary account owner.
    /// </summary>
    public FamilyRelationship Relationship { get; set; }

    /// <summary>
    /// Gets or sets the date of birth of the family member.
    /// </summary>
    public DateOnly BirthDate { get; set; }

    #endregion

    #region Relationship Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the primary patient (account owner).
    /// </summary>
    public Guid PatientId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the primary patient.
    /// </summary>
    public required Patient Patient { get; set; }

    #endregion
}
