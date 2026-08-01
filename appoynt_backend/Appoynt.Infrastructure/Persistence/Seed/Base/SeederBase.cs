/**
 * File Name      : SeederBase.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 22/07/2026
 * Version        : v1.0.0
 * Dependencies   : ASP.NET Core Identity
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 22/07/2026
 * Description    : Provides common functionality shared by all database
 *                  seeders, including standardized Identity error handling.
 */

using Microsoft.AspNetCore.Identity;
using System.Text;

namespace Appoynt.Infrastructure.Persistence.Seed.Base;

/// <summary>
/// Provides common functionality for database seeders.
/// </summary>
public abstract class SeederBase
{
    /// <summary>
    /// Throws an exception when an Identity operation fails.
    /// </summary>
    /// <param name="result">
    /// The Identity operation result.
    /// </param>
    /// <param name="message">
    /// The high-level error message.
    /// </param>
    /// <exception cref="InvalidOperationException">
    /// Thrown when the Identity operation fails.
    /// </exception>
    protected static void ThrowIfFailed(
        IdentityResult result,
        string message)
    {
        if (result.Succeeded)
        {
            return;
        }
        else
        {
        }

        StringBuilder builder = new();

        builder.AppendLine(message);
        builder.AppendLine();
        builder.AppendLine("Identity Errors:");

        foreach (IdentityError error in result.Errors)
        {
            builder.AppendLine($"- {error.Code}: {error.Description}");
        }

        throw new InvalidOperationException(builder.ToString());
    }
}