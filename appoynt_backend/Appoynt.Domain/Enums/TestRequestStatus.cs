/**
 * File Name      : TestRequestStatus.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Defines the fulfillment lifecycle states of a test request.
 */

namespace Appoynt.Domain.Enums;

/// <summary>
/// Lifecycle statuses for medical diagnostic and laboratory test requests.
/// </summary>
public enum TestRequestStatus
{
    /// <summary>Test has been formally ordered and requested by the doctor.</summary>
    Requested = 1,

    /// <summary>Test is in progress, sample collected, awaiting results.</summary>
    AwaitingResult = 2,

    /// <summary>Test result or diagnostic report has been uploaded to the system.</summary>
    ResultUploaded = 3,

    /// <summary>Doctor has reviewed and acknowledged the test result.</summary>
    Reviewed = 4,

    /// <summary>Test request has been cancelled.</summary>
    Cancelled = 5
}
