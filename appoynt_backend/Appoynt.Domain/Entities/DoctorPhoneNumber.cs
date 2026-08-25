/**
 * File Name      : DoctorPhoneNumber.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, Doctor
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Represents an additional contact phone number associated with
 *                  a doctor's professional practice or clinic.
 */

using Appoynt.Domain.Common;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents an additional contact phone number for a doctor.
/// </summary>
public class DoctorPhoneNumber : BaseEntity
{
    #region Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the associated doctor.
    /// </summary>
    public Guid DoctorId { get; set; }

    /// <summary>
    /// Gets or sets the phone number.
    /// </summary>
    public string PhoneNumber { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the descriptive label for this phone number (e.g., 'Clinic', 'Emergency', 'Secretary').
    /// </summary>
    public string Label { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets a value indicating whether the phone number has been verified.
    /// </summary>
    public bool IsVerified { get; set; }

    #endregion

    #region Navigation Properties

    /// <summary>
    /// Gets or sets the navigation property to the associated doctor.
    /// </summary>
    public required Doctor Doctor { get; set; }

    #endregion
}
