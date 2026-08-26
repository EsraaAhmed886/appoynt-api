/**
 * File Name      : ClinicBreak.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, ClinicWorkingPeriod
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Represents a break period within a specific clinic working period.
 */

using System;
using Appoynt.Domain.Common;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a break within a clinic's working period.
/// </summary>
public class ClinicBreak : BaseEntity
{
    #region Business Properties

    /// <summary>
    /// Gets or sets the start time of the break.
    /// </summary>
    public TimeOnly StartTime { get; set; }

    /// <summary>
    /// Gets or sets the end time of the break.
    /// </summary>
    public TimeOnly EndTime { get; set; }

    #endregion

    #region Relationship Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the associated working period.
    /// </summary>
    public Guid WorkingPeriodId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the associated working period.
    /// </summary>
    public required ClinicWorkingPeriod WorkingPeriod { get; set; }

    #endregion
}
