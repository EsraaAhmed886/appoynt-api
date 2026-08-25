/**
 * File Name      : ClinicPhoneNumber.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, Clinic
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Represents a contact phone number associated with a specific clinic.
 */

using System;
using Appoynt.Domain.Common;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents an additional contact phone number for a clinic.
/// </summary>
public class ClinicPhoneNumber : BaseEntity
{
    #region Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the associated clinic.
    /// </summary>
    public Guid ClinicId { get; set; }

    /// <summary>
    /// Gets or sets the phone number.
    /// </summary>
    public string PhoneNumber { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the descriptive label for this phone number.
    /// </summary>
    public string Label { get; set; } = string.Empty;

    #endregion

    #region Navigation Properties

    /// <summary>
    /// Gets or sets the navigation property to the associated clinic.
    /// </summary>
    public required Clinic Clinic { get; set; }

    #endregion
}
