/**
 * File Name      : BaseFavoriteEntity.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : System, Appoynt.Domain.Entities
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-23
 * Description    : Abstract base entity for patient favorites containing shared patient reference and creation timestamp.
 */

using System;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents an abstract base class for all patient favorite join entities.
/// </summary>
public abstract class BaseFavoriteEntity
{
    #region Relationship Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the associated patient.
    /// </summary>
    public Guid PatientId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the associated patient.
    /// </summary>
    public required Patient Patient { get; set; }

    #endregion

    #region Business Properties

    /// <summary>
    /// Gets or sets the timestamp indicating when the entity was added to favorites.
    /// </summary>
    public DateTime AddedAt { get; set; }

    #endregion
}
