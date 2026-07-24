/**
 * File Name      : BaseEntity.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : ApplicationUser
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Represents the base entity that provides a unique identifier
 *                  and common audit information for all domain entities.
 */

using Appoynt.Domain.Entities;

namespace Appoynt.Domain.Common;

/// <summary>
/// Represents the base entity for all domain entities.
/// </summary>
public abstract class BaseEntity
{
    #region Primary Key

    // Unique identifier for the entity.
    public Guid Id { get; set; }

    #endregion

    #region Audit Properties

    // Date and time when the entity was created.
    public DateTime CreatedAt { get; set; }

    // Identifier of the user who created the entity.
    public Guid? CreatedById { get; set; }

    // Navigation property to the user who created the entity.
    public ApplicationUser? CreatedBy { get; set; }

    // Date and time of the last update.
    public DateTime UpdatedAt { get; set; }

    // Identifier of the user who last updated the entity.
    public Guid? UpdatedById { get; set; }

    // Navigation property to the user who last updated the entity.
    public ApplicationUser? UpdatedBy { get; set; }

    // Date and time when the entity was soft deleted.
    public DateTime? DeletedAt { get; set; }

    // Identifier of the user who performed the soft delete.
    public Guid? DeletedById { get; set; }

    // Navigation property to the user who performed the soft delete.
    public ApplicationUser? DeletedBy { get; set; }

    #endregion
}