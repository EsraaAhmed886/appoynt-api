/**
 * File Name      : DoctorSpecialization.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : Doctor, Specialization
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Represents a lightweight many-to-many join entity between
 *                  a doctor and a medical specialization.
 */

using System;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents the join entity linking a doctor to a medical specialization.
/// </summary>
public class DoctorSpecialization
{
    #region Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the associated doctor.
    /// </summary>
    public Guid DoctorId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the associated doctor.
    /// </summary>
    public required Doctor Doctor { get; set; }

    /// <summary>
    /// Gets or sets the foreign key referencing the associated specialization.
    /// </summary>
    public Guid SpecializationId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the associated specialization.
    /// </summary>
    public required Specialization Specialization { get; set; }

    #endregion
}
