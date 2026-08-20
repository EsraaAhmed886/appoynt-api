/**
 * File Name      : Governorate.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, City
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Represents a governorate (state/province) geographically.
 */

using System.Collections.Generic;
using Appoynt.Domain.Common;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a geographical governorate.
/// </summary>
public class Governorate : BaseEntity
{
    #region Business Properties

    /// <summary>
    /// Gets or sets the governorate's name in Arabic.
    /// </summary>
    public string NameAr { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the governorate's name in English.
    /// </summary>
    public string NameEn { get; set; } = string.Empty;

    #endregion

    #region Navigation Properties

    /// <summary>
    /// Gets or sets the collection of cities within this governorate.
    /// </summary>
    public ICollection<City> Cities { get; set; } = [];

    #endregion
}
