/**
 * File Name      : BloodGroup.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Defines the supported blood group types used for
 *                  patient medical information.
 */

namespace Appoynt.Domain.Enums;

/// <summary>
/// Represents the supported blood group types in the application.
/// </summary>
public enum BloodGroup
{
    /// <summary>
    /// Blood group A positive (A+).
    /// </summary>
    APositive = 0,

    /// <summary>
    /// Blood group A negative (A-).
    /// </summary>
    ANegative = 1,

    /// <summary>
    /// Blood group B positive (B+).
    /// </summary>
    BPositive = 2,

    /// <summary>
    /// Blood group B negative (B-).
    /// </summary>
    BNegative = 3,

    /// <summary>
    /// Blood group AB positive (AB+).
    /// </summary>
    ABPositive = 4,

    /// <summary>
    /// Blood group AB negative (AB-).
    /// </summary>
    ABNegative = 5,

    /// <summary>
    /// Blood group O positive (O+).
    /// </summary>
    OPositive = 6,

    /// <summary>
    /// Blood group O negative (O-).
    /// </summary>
    ONegative = 7
}
