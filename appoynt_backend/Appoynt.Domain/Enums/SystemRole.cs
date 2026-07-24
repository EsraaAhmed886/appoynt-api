/**
 * File Name      : SystemRole.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Defines the system roles used for authorization and
 *                  role-based access control.
 */

namespace Appoynt.Domain.Enums;

/// <summary>
/// Represents the available roles within the application.
/// </summary>
public enum SystemRole
{
    // System administrator with full access.
    Admin = 0,

    // Doctor who manages patients and appointments.
    Doctor = 1,

    // Patient who receives healthcare services.
    Patient = 2,

    // Receptionist responsible for scheduling and front-desk operations.
    Receptionist = 3
}