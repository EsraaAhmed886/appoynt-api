/**
 * File Name      : IDoctorProfileService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : System.Threading
 *                  System.Threading.Tasks
 *                  Appoynt.Application.Features.Doctor.Contracts
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-23
 * Description    : Service interface for managing doctor profiles.
 */

using System;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Features.Doctor.Contracts;

namespace Appoynt.Application.Features.Doctor;

/// <summary>
/// Defines the contract for doctor profile operations.
/// </summary>
public interface IDoctorProfileService
{
    /// <summary>
    /// Gets the profile of the currently authenticated doctor.
    /// </summary>
    /// <param name="ct">The cancellation token.</param>
    /// <returns>A task that represents the asynchronous operation. The task result contains the doctor profile response.</returns>
    Task<DoctorProfileResponse?> GetProfileAsync(CancellationToken ct);

    /// <summary>
    /// Updates the profile of the currently authenticated doctor.
    /// </summary>
    /// <param name="request">The update request details.</param>
    /// <param name="ct">The cancellation token.</param>
    /// <returns>A task that represents the asynchronous operation. The task result contains the doctor result.</returns>
    Task<DoctorResult> UpdateProfileAsync(UpdateDoctorProfileRequest request, CancellationToken ct);

    /// <summary>
    /// Adds a new phone number to the currently authenticated doctor's profile.
    /// </summary>
    /// <param name="request">The add phone number request details.</param>
    /// <param name="ct">The cancellation token.</param>
    /// <returns>A task that represents the asynchronous operation. The task result contains the doctor result.</returns>
    Task<DoctorResult> AddPhoneNumberAsync(AddDoctorPhoneNumberRequest request, CancellationToken ct);

    /// <summary>
    /// Removes a phone number from the currently authenticated doctor's profile.
    /// </summary>
    /// <param name="phoneNumberId">The identifier of the phone number to remove.</param>
    /// <param name="ct">The cancellation token.</param>
    /// <returns>A task that represents the asynchronous operation. The task result contains the doctor result.</returns>
    Task<DoctorResult> RemovePhoneNumberAsync(Guid phoneNumberId, CancellationToken ct);
}
