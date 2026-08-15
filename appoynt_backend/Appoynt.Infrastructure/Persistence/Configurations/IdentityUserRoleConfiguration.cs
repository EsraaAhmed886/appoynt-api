/**
 * File Name      : IdentityUserRoleConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : IdentityUserRole<Guid>, Entity Framework Core, ASP.NET Core Identity
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Configures the Entity Framework Core mapping for the
 *                  ASP.NET Core Identity user-role relationship by enforcing
 *                  that each user can be assigned to only one role.
 */

using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the
/// <see cref="IdentityUserRole{TKey}"/> entity.
/// </summary>
public sealed class IdentityUserRoleConfiguration
    : IEntityTypeConfiguration<IdentityUserRole<Guid>>
{
    /// <summary>
    /// Configures the IdentityUserRole entity using the Entity Framework Core Fluent API.
    /// </summary>
    /// <param name="builder">
    /// The builder used to configure the entity.
    /// </param>
    public void Configure(EntityTypeBuilder<IdentityUserRole<Guid>> builder)
    {
        #region Index Configuration

        // Ensure that each user can be assigned to only one role.
        builder.HasIndex(userRole => userRole.UserId)
            .HasDatabaseName("UX_AspNetUserRoles_UserId")
            .IsUnique();

        #endregion
    }
}