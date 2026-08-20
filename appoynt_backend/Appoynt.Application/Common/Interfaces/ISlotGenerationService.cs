/**
 * File Name      : ISlotGenerationService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Defines the contract for generating, extending, and maintaining appointment slots.
 */

namespace Appoynt.Application.Common.Interfaces;

using System;
using System.Threading;
using System.Threading.Tasks;

/// <summary>
/// Service interface for handling slot generation logic.
/// </summary>
public interface ISlotGenerationService
{
    /// <summary>
    /// Generates slots for a specific clinic.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    Task GenerateSlotsForClinicAsync(Guid clinicId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Extends slots for all clinics.
    /// </summary>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    Task ExtendSlotsForAllClinicsAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Resets expired pending slots.
    /// </summary>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    Task ResetExpiredPendingSlotsAsync(CancellationToken cancellationToken = default);
}
