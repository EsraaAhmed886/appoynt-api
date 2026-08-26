/**
 * File Name      : DoctorAppointmentConstants.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-26
 * Description    : Tuning constants for the doctor appointments screen, keeping
 *                  queue paging behavior configurable in one place.
 */

namespace Appoynt.Application.Common.Constants;

/// <summary>
/// Provides paging constants for the doctor appointments endpoints.
/// </summary>
public static class DoctorAppointmentConstants
{
    /// <summary>
    /// The default number of queue patients returned per page.
    /// </summary>
    public const int DefaultQueuePageSize = 5;

    /// <summary>
    /// The maximum number of queue patients accepted per page.
    /// </summary>
    public const int MaxQueuePageSize = 50;
}
