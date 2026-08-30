/**
 * File Name      : UserResponse.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 28/07/2026
 * Version        : v1.0.0
 * Dependencies   : System, Gender
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-30
 * Description    : Response DTO for user profile.
 */

using Appoynt.Application.Common.Models;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.UserManagement.Contracts;

/// <summary>
/// Represents a response containing user details.
/// </summary>
public sealed class UserResponse
{
    /// <summary>
    /// Gets the unique identifier of the user.
    /// </summary>
    public Guid Id { get; init; }

    /// <summary>
    /// Gets the first name of the user.
    /// </summary>
    public string FirstName { get; init; } = string.Empty;

    /// <summary>
    /// Gets the last name of the user.
    /// </summary>
    public string LastName { get; init; } = string.Empty;

    /// <summary>
    /// Gets the email address of the user.
    /// </summary>
    public string Email { get; init; } = string.Empty;

    /// <summary>
    /// Gets the phone number of the user.
    /// </summary>
    public string? PhoneNumber { get; init; }

    /// <summary>
    /// Gets the gender of the user.
    /// </summary>
    public Gender? Gender { get; init; }

    /// <summary>
    /// Gets the date of birth of the user.
    /// </summary>
    public DateOnly? DateOfBirth { get; init; }

    /// <summary>
    /// Gets the user's location address details.
    /// </summary>
    public AddressDto? Address { get; init; }

    /// <summary>
    /// Gets a value indicating whether the user account is active.
    /// </summary>
    public bool IsActive { get; init; }

    /// <summary>
    /// Gets the date and time when the user was created.
    /// </summary>
    public DateTime CreatedAt { get; init; }

    /// <summary>
    /// Gets the list of roles assigned to the user.
    /// </summary>
    public List<string> Roles { get; init; } = [];
}
