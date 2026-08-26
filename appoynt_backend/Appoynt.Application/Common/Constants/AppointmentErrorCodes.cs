/**
 * File Name      : AppointmentErrorCodes.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-26
 * Description    : Stable machine-readable error codes for doctor appointment
 *                  lifecycle operations (start/end consultation).
 */

namespace Appoynt.Application.Common.Constants;

/// <summary>
/// Provides error codes returned by appointment lifecycle operations.
/// </summary>
public static class AppointmentErrorCodes
{
    /// <summary>
    /// Indicates the appointment does not exist or is not visible to the caller.
    /// </summary>
    public const string NotFound = "appointment.not_found";

    /// <summary>
    /// Indicates another appointment of the same doctor is already in consultation.
    /// </summary>
    public const string AlreadyInConsultation = "appointment.already_in_consultation";

    /// <summary>
    /// Indicates the requested lifecycle transition is invalid from the current state.
    /// </summary>
    public const string InvalidTransition = "appointment.invalid_transition";
}
