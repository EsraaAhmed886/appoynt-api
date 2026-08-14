/**
 * File Name      : ApplicationUserConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.1.0
 * Dependencies   : ApplicationUser, UserConstants, ProfilePictureConstants, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Configures the Entity Framework Core mapping for the
 *                  ApplicationUser entity, including business properties,
 *                  profile picture path, identity properties, audit configuration,
 *                  indexes, relationships, and the global soft-delete query filter.
 */

using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="ApplicationUser"/> entity.
/// </summary>
public sealed class ApplicationUserConfiguration
    : IEntityTypeConfiguration<ApplicationUser>
{
    /// <summary>
    /// Configures the ApplicationUser entity using the Entity Framework Core Fluent API.
    /// </summary>
    /// <param name="builder">
    /// The builder used to configure the entity.
    /// </param>
    public void Configure(EntityTypeBuilder<ApplicationUser> builder)
    {
        #region Table Configuration

        // Map the entity to the ASP.NET Identity users table.
        builder.ToTable("AspNetUsers");

        #endregion

        #region Business Properties Configuration

        // Configure the user's first name.
        builder.Property(user => user.FirstName)
            .IsRequired()
            .HasMaxLength(UserConstants.NameMaxLength);

        // Configure the user's last name.
        builder.Property(user => user.LastName)
            .IsRequired()
            .HasMaxLength(UserConstants.NameMaxLength);

        // Store the Gender enum as an integer value.
        builder.Property(user => user.Gender)
            .HasConversion<int>();

        // Store only the date portion for the date of birth.
        builder.Property(user => user.DateOfBirth)
            .HasColumnType("date");

        // Configure the maximum allowed address length.
        builder.Property(user => user.Address)
            .HasMaxLength(UserConstants.AddressMaxLength);

        // Set newly created users as active by default.
        builder.Property(user => user.IsActive)
            .HasDefaultValue(true);

        // Configure the centralized profile picture path.
        builder.Property(user => user.ProfilePicturePath)
            .HasMaxLength(ProfilePictureConstants.PathMaxLength)
            .IsRequired(false);

        #endregion

        #region Identity Properties Configuration

        // Require an email for every user.
        // Email uniqueness is enforced using the NormalizedEmail index.
        builder.Property(user => user.Email)
            .IsRequired();

        // Require a phone number for every user.
        builder.Property(user => user.PhoneNumber)
            .IsRequired()
            .HasMaxLength(UserConstants.PhoneNumberLength);

        // Require email confirmation by default.
        builder.Property(user => user.EmailConfirmed)
            .HasDefaultValue(false);

        // Require phone number confirmation by default.
        builder.Property(user => user.PhoneNumberConfirmed)
            .HasDefaultValue(false);

        // Enable account lockout by default.
        builder.Property(user => user.LockoutEnabled)
            .HasDefaultValue(true);

        // Disable two-factor authentication by default.
        builder.Property(user => user.TwoFactorEnabled)
            .HasDefaultValue(false);

        // Initialize failed login attempts to zero.
        builder.Property(user => user.AccessFailedCount)
            .HasDefaultValue(0);

        #endregion

        #region Audit Properties Configuration

        // Configure the entity creation timestamp.
        builder.Property(user => user.CreatedAt)
            .HasColumnType("datetime2");

        // Configure the entity last update timestamp.
        builder.Property(user => user.UpdatedAt)
            .HasColumnType("datetime2");

        // Configure the entity soft-delete timestamp.
        builder.Property(user => user.DeletedAt)
            .HasColumnType("datetime2");

        #endregion

        #region Index Configuration

        // Ensure that the normalized email address is unique
        // for all active (non-deleted) users.
        builder.HasIndex(user => user.NormalizedEmail)
            .HasDatabaseName("UX_AspNetUsers_Email")
            .IsUnique()
            .HasFilter("[DeletedAt] IS NULL");

        // Ensure that the phone number is unique
        // for all active (non-deleted) users.
        builder.HasIndex(user => user.PhoneNumber)
            .HasDatabaseName("UX_AspNetUsers_PhoneNumber")
            .IsUnique()
            .HasFilter("[DeletedAt] IS NULL");

        #endregion

        #region Audit Relationships Configuration

        // Configure the relationship with the user who created the record.
        builder.HasOne(user => user.CreatedBy)
            .WithMany()
            .HasForeignKey(user => user.CreatedById)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure the relationship with the user who last updated the record.
        builder.HasOne(user => user.UpdatedBy)
            .WithMany()
            .HasForeignKey(user => user.UpdatedById)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure the relationship with the user who soft-deleted the record.
        builder.HasOne(user => user.DeletedBy)
            .WithMany()
            .HasForeignKey(user => user.DeletedById)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion

        #region Global Query Filter

        // Automatically exclude soft-deleted users from all queries.
        builder.HasQueryFilter(user => user.DeletedAt == null);

        #endregion
    }
}