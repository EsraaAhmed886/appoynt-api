/**
 * File Name      : IRegistrationService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : RegisterRequest, RegistrationResult
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Defines the application contract for patient account
 *                  registration.
 */

using Appoynt.Application.Features.Authentication.Registration.Contracts;

namespace Appoynt.Application.Features.Authentication.Registration;

/// <summary>
/// Defines the application contract for registering patient accounts.
/// </summary>
public interface IRegistrationService
{
    /// <summary>
    /// Registers a patient account and its associated patient profile.
    /// </summary>
    /// <param name="request">The raw registration request.</param>
    /// <param name="cancellationToken">A token used to cancel the operation.</param>
    /// <returns>The registration result.</returns>
    Task<RegistrationResult> RegisterAsync(
        RegisterRequest request,
        CancellationToken cancellationToken = default);
}
