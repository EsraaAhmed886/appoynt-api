/**
 * File Name      : RoleConstants.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 22/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 22/07/2026
 * Description    : Defines all application role names used throughout
 *                  the system. This class serves as the single source
 *                  of truth for ASP.NET Identity role names.
 */

namespace Appoynt.Domain.Common.Constants;

/// Provides the names of all application roles.
public static class RoleConstants
{
    // System administrator.
    public const string Admin = "Admin";

    // Doctor.
    public const string Doctor = "Doctor";

    // Receptionist.
    public const string Receptionist = "Receptionist";

    // Patient.
    public const string Patient = "Patient";
    
    // Returns all application roles.
    
    public static readonly IReadOnlyList<string> All =
    [
        Admin,
        Doctor,
        Receptionist,
        Patient
    ];
}