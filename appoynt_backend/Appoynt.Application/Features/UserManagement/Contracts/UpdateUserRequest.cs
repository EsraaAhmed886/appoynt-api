/**
 * File Name      : UpdateUserRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 28/07/2026
 * Version        : v1.0.0
 * Dependencies   : System, Gender
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-30
 * Description    : Payload for updating basic user information.
 */

using Appoynt.Application.Common.Models;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.UserManagement.Contracts;

/// <summary>
/// Represents the payload for updating user information.
/// </summary>
public sealed class UpdateUserRequest
{
    /// <summary>
    /// Gets the updated first name of the user.
    /// </summary>
    public string? FirstName { get; init; }

    /// <summary>
    /// Gets the updated last name of the user.
    /// </summary>
    public string? LastName { get; init; }

    /// <summary>
    /// Gets the updated gender of the user.
    /// </summary>
    public Gender? Gender { get; init; }

    /// <summary>
    /// Gets the updated date of birth of the user.
    /// </summary>
    public DateOnly? DateOfBirth { get; init; }

    /// <summary>
    /// Gets the user's location address details.
    /// </summary>
    public UpdateAddressDto? Address { get; init; }
}
