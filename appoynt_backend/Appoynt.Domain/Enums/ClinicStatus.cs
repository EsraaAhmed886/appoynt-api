/**
 * File Name      : ClinicStatus.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Defines the operational statuses of a clinic.
 */

namespace Appoynt.Domain.Enums;

/// <summary>
/// Represents the operational status of a clinic.
/// </summary>
public enum ClinicStatus
{
    /// <summary>
    /// Indicates that the clinic is active and operational.
    /// </summary>
    Active = 0,

    /// <summary>
    /// Indicates that the clinic is currently inactive.
    /// </summary>
    Inactive = 1
}
