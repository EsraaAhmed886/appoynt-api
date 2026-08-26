/**
 * File Name      : PatientFavoriteClinic.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : System, BaseFavoriteEntity, Clinic
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-23
 * Description    : Lightweight join entity linking a patient to a favorited clinic.
 */

using System;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a clinic favorited by a patient.
/// </summary>
public class PatientFavoriteClinic : BaseFavoriteEntity
{
    #region Relationship Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the favorited clinic.
    /// </summary>
    public Guid ClinicId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the favorited clinic.
    /// </summary>
    public required Clinic Clinic { get; set; }

    #endregion
}
