/**
 * File Name      : PatientFavoriteDoctor.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : System, BaseFavoriteEntity, Doctor
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-23
 * Description    : Lightweight join entity linking a patient to a favorited doctor.
 */

using System;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a doctor favorited by a patient.
/// </summary>
public class PatientFavoriteDoctor : BaseFavoriteEntity
{
    #region Relationship Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the favorited doctor.
    /// </summary>
    public Guid DoctorId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the favorited doctor.
    /// </summary>
    public required Doctor Doctor { get; set; }

    #endregion
}
