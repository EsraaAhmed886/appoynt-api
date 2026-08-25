/**
 * File Name      : BookingOperationResult.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : ResultBase, AuthenticationError, SlotLockResponseDto
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-25
 * Description    : Operation result for booking mutations, carrying the lock
 *                  payload on success. This type is internal to the service
 *                  boundary; controllers map it onto HTTP responses.
 */

using System.Collections.Generic;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Booking.Contracts;

namespace Appoynt.Application.Features.Booking.Contracts;

/// <summary>
/// Represents the outcome of a booking mutation such as locking a slot.
/// </summary>
public sealed class BookingOperationResult : ResultBase
{
    /// <summary>
    /// Gets the acquired lock details when the operation succeeded.
    /// </summary>
    public SlotLockResponseDto? Lock { get; init; }

    /// <summary>
    /// Initializes a new instance of the <see cref="BookingOperationResult"/> class.
    /// </summary>
    /// <param name="succeeded">Indicates success.</param>
    /// <param name="lock">The lock payload for successful locks.</param>
    /// <param name="errors">The errors for failed operations.</param>
    private BookingOperationResult(bool succeeded, SlotLockResponseDto? @lock, IReadOnlyList<AuthenticationError>? errors)
        : base(succeeded, errors)
    {
        Lock = @lock;
    }

    /// <summary>
    /// Creates a successful result carrying the acquired lock.
    /// </summary>
    /// <param name="lock">The acquired lock details.</param>
    /// <returns>A successful <see cref="BookingOperationResult"/>.</returns>
    public static BookingOperationResult Success(SlotLockResponseDto @lock)
    {
        return new BookingOperationResult(true, @lock, null);
    }

    /// <summary>
    /// Creates a failed result with a single error code and target field.
    /// </summary>
    /// <param name="errorCode">The stable error code.</param>
    /// <param name="propertyName">The optional property associated with the failure.</param>
    /// <returns>A failed <see cref="BookingOperationResult"/>.</returns>
    public static BookingOperationResult Failure(string errorCode, string propertyName = "")
    {
        return new BookingOperationResult(false, null, new[] { new AuthenticationError(errorCode, propertyName) });
    }
}
