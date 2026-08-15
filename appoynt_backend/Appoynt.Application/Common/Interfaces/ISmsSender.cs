/**
 * File Name      : ISmsSender.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 25/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 25/07/2026
 * Description    : Defines the provider-neutral contract for delivering
 *                  mobile one-time-password messages.
 */

namespace Appoynt.Application.Common.Interfaces;

/// <summary>
/// Defines the contract for delivering mobile one-time-password messages.
/// </summary>
public interface ISmsSender
{
    /// <summary>
    /// Sends an OTP code to the supplied mobile phone number.
    /// </summary>
    /// <param name="phoneNumber">The recipient mobile phone number.</param>
    /// <param name="code">The plaintext OTP code to deliver.</param>
    /// <param name="cancellationToken">A token used to cancel the operation.</param>
    /// <returns>
    /// A task whose result indicates whether the OTP was accepted for delivery.
    /// </returns>
    Task<bool> SendOtpAsync(
        string phoneNumber,
        string code,
        CancellationToken cancellationToken = default);
}
