/**
 * File Name      : AdminOptions.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 22/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 22/07/2026
 * Description    : Represents the default administrator account
 *                  configuration loaded from appsettings.json.
 */

namespace Appoynt.Infrastructure.Options;

/// Represents the default administrator configuration.
public sealed class AdminOptions
{
    /// Administrator first name.
    public string FirstName { get; init; } = string.Empty;

    /// Administrator last name.
    public string LastName { get; init; } = string.Empty;

    /// Administrator email address.
    public string Email { get; init; } = string.Empty;

    /// Administrator phone number.
    public string PhoneNumber { get; init; } = string.Empty;

    /// Administrator password.
    public string Password { get; init; } = string.Empty;
}