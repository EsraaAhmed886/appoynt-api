/**
 * File Name      : FamilyRelationship.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Defines the supported family relationship types used
 *                  for linking family members to the primary patient
 *                  account owner. Each relationship maps to a single-character
 *                  code used in the Patient Identifier (PID).
 */

namespace Appoynt.Domain.Enums;

/// <summary>
/// Represents the supported family relationships in the application.
/// Each value maps to a single-character PID relationship code.
/// </summary>
public enum FamilyRelationship
{
    /// <summary>
    /// The primary account owner (PID code: U).
    /// </summary>
    User = 0,

    /// <summary>
    /// Wife of the primary account owner (PID code: W).
    /// </summary>
    Wife = 1,

    /// <summary>
    /// Husband of the primary account owner (PID code: H).
    /// </summary>
    Husband = 2,

    /// <summary>
    /// Son of the primary account owner (PID code: S).
    /// </summary>
    Son = 3,

    /// <summary>
    /// Daughter of the primary account owner (PID code: D).
    /// </summary>
    Daughter = 4,

    /// <summary>
    /// Parent of the primary account owner (PID code: P).
    /// </summary>
    Parent = 5
}
