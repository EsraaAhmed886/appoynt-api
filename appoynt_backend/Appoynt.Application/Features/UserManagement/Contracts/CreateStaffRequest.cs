/**
 * File Name      : CreateStaffRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 28/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 28/07/2026
 * Description    : Defines the contract for creating internal staff users.
 */

namespace Appoynt.Application.Features.UserManagement.Contracts;

/// <summary>
/// Represents the input submitted to create a staff or admin account.
/// </summary>
public sealed class CreateStaffRequest
{
    /// <summary>
    /// Gets or initializes the first name.
    /// </summary>
    public string? FirstName { get; init; }

    /// <summary>
    /// Gets or initializes the last name.
    /// </summary>
    public string? LastName { get; init; }

    /// <summary>
    /// Gets or initializes the mobile phone number.
    /// </summary>
    public string? PhoneNumber { get; init; }

    /// <summary>
    /// Gets or initializes the email address.
    /// </summary>
    public string? Email { get; init; }

    /// <summary>
    /// Gets or initializes the account password.
    /// </summary>
    public string? Password { get; init; }
}
