/**
 * File Name      : ClinicReceptionist.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : Clinic, Receptionist
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Represents a lightweight many-to-many join entity between
 *                  a clinic and a receptionist.
 */

using System;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents the join entity linking a clinic to a receptionist.
/// </summary>
public class ClinicReceptionist
{
    #region Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the associated clinic.
    /// </summary>
    public Guid ClinicId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the associated clinic.
    /// </summary>
    public required Clinic Clinic { get; set; }

    /// <summary>
    /// Gets or sets the foreign key referencing the associated receptionist.
    /// </summary>
    public Guid ReceptionistId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the associated receptionist.
    /// </summary>
    public required Receptionist Receptionist { get; set; }

    #endregion
}
