/**
 * File Name      : AdminConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : Admin, BaseAuditableEntityConfiguration<Admin>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Configures the Entity Framework Core mapping for the Admin
 *                  entity, including table mapping, primary key, indexes,
 *                  and relationships.
 */

using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="Admin"/> entity.
/// </summary>
public sealed class AdminConfiguration
    : BaseAuditableEntityConfiguration<Admin>
{
    /// <summary>
    /// Configures the Admin entity using the Entity Framework Core Fluent API.
    /// </summary>
    /// <param name="builder">
    /// The builder used to configure the entity.
    /// </param>
    public override void Configure(EntityTypeBuilder<Admin> builder)
    {
        // Apply the common audit configuration defined in the base class.
        base.Configure(builder);

        #region Table Configuration

        // Map the entity to the "Admins" table.
        builder.ToTable("Admins");

        #endregion

        #region Primary Key Configuration

        // Configure the primary key.
        builder.HasKey(admin => admin.Id);

        #endregion

        #region Index Configuration

        // Ensure that each user can be associated with only one admin record.
        builder.HasIndex(admin => admin.UserId)
            .HasDatabaseName("UX_Admins_UserId")
            .IsUnique();

        #endregion

        #region Relationship Configuration

        // Configure the one-to-one relationship between Admin and User.
        builder.HasOne(admin => admin.User)
            .WithOne(user => user.Admin)
            .HasForeignKey<Admin>(admin => admin.UserId)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion
    }
}