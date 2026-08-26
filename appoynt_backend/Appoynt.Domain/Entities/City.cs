/**
 * File Name      : City.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, Governorate
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Represents a city geographically, linked to a governorate.
 */

using System;
using Appoynt.Domain.Common;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a geographical city within a governorate.
/// </summary>
public class City : BaseEntity
{
    #region Business Properties

    /// <summary>
    /// Gets or sets the city's name in Arabic.
    /// </summary>
    public string NameAr { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the city's name in English.
    /// </summary>
    public string NameEn { get; set; } = string.Empty;

    #endregion

    #region Relationship Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the associated governorate.
    /// </summary>
    public Guid GovernorateId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the associated governorate.
    /// </summary>
    public required Governorate Governorate { get; set; }

    #endregion
}
