/**
 * File Name      : AppointmentOperationResult.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : ResultBase, AuthenticationError, AppointmentStateDto
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-26
 * Description    : Operation result for appointment lifecycle mutations,
 *                  carrying the updated state on success. Internal to the
 *                  service boundary; controllers map it onto HTTP responses.
 */

using System.Collections.Generic;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.DoctorAppointments.Contracts;

namespace Appoynt.Application.Features.DoctorAppointments.Contracts;

/// <summary>
/// Represents the outcome of an appointment lifecycle mutation.
/// </summary>
public sealed class AppointmentOperationResult : ResultBase
{
    /// <summary>
    /// Gets the updated appointment state when the action succeeded.
    /// </summary>
    public AppointmentStateDto? Appointment { get; init; }

    /// <summary>
    /// Initializes a new instance of the <see cref="AppointmentOperationResult"/> class.
    /// </summary>
    /// <param name="succeeded">Indicates success.</param>
    /// <param name="appointment">The updated state for successful actions.</param>
    /// <param name="errors">The errors for failed actions.</param>
    private AppointmentOperationResult(bool succeeded, AppointmentStateDto? appointment, IReadOnlyList<AuthenticationError>? errors)
        : base(succeeded, errors)
    {
        Appointment = appointment;
    }

    /// <summary>
    /// Creates a successful result carrying the updated appointment state.
    /// </summary>
    /// <param name="state">The updated state payload.</param>
    /// <returns>A successful <see cref="AppointmentOperationResult"/>.</returns>
    public static AppointmentOperationResult Success(AppointmentStateDto state)
    {
        return new AppointmentOperationResult(true, state, null);
    }

    /// <summary>
    /// Creates a failed result with a single error code and target field.
    /// </summary>
    /// <param name="errorCode">The stable error code.</param>
    /// <param name="propertyName">The optional property associated with the failure.</param>
    /// <returns>A failed <see cref="AppointmentOperationResult"/>.</returns>
    public static AppointmentOperationResult Failure(string errorCode, string propertyName = "")
    {
        return new AppointmentOperationResult(false, null, new[] { new AuthenticationError(errorCode, propertyName) });
    }
}
