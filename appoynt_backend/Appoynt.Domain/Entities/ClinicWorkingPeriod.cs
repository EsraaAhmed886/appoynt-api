/**
 * File Name      : ClinicWorkingPeriod.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, Clinic, ClinicBreak
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Represents a working period for a clinic during a specific day of the week.
 */

using System;
using System.Collections.Generic;
using Appoynt.Domain.Common;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a defined working period for a clinic on a particular day.
/// </summary>
public class ClinicWorkingPeriod : BaseEntity
{
    #region Business Properties

    /// <summary>
    /// Gets or sets the day of the week this working period applies to.
    /// </summary>
    public DayOfWeek DayOfWeek { get; set; }

    /// <summary>
    /// Gets or sets the start time of the working period.
    /// </summary>
    public TimeOnly StartTime { get; set; }

    /// <summary>
    /// Gets or sets the end time of the working period.
    /// </summary>
    public TimeOnly EndTime { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether this working period is currently active.
    /// </summary>
    public bool IsActive { get; set; } = true;

    #endregion

    #region Relationship Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the associated clinic.
    /// </summary>
    public Guid ClinicId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the associated clinic.
    /// </summary>
    public required Clinic Clinic { get; set; }

    /// <summary>
    /// Gets or sets the collection of breaks within this working period.
    /// </summary>
    public ICollection<ClinicBreak> Breaks { get; set; } = [];

    #endregion
}
