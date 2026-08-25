/**
 * File Name      : BreakRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Request contract for defining a break period within a clinic working period.
 */

namespace Appoynt.Application.Features.Clinics.Contracts;

/// <summary>
/// Represents a request to create or update a break within a working period.
/// </summary>
public sealed class BreakRequest
{
    /// <summary>
    /// Gets or sets the start time in "HH:mm" format.
    /// </summary>
    public string? StartTime { get; set; }

    /// <summary>
    /// Gets or sets the end time in "HH:mm" format.
    /// </summary>
    public string? EndTime { get; set; }
}

