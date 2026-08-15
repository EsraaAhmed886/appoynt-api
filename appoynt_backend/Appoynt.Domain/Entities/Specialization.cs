/**
 * File Name      : Specialization.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, DoctorSpecialization
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Represents a medical specialization lookup entity that can be
 *                  assigned to multiple doctors.
 */

using System.Collections.Generic;
using Appoynt.Domain.Common;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a medical specialization within the system.
/// </summary>
public class Specialization : BaseEntity
{
    #region Properties

    /// <summary>
    /// Gets or sets the English name of the specialization.
    /// </summary>
    public string NameEn { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the Arabic name of the specialization.
    /// </summary>
    public string NameAr { get; set; } = string.Empty;

    #endregion

    #region Navigation Properties

    /// <summary>
    /// Gets or sets the collection of doctor-specialization join entities.
    /// </summary>
    public ICollection<DoctorSpecialization> DoctorSpecializations { get; set; } = [];

    #endregion
}
