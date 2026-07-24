/**
 * File Name      : RefreshTokenConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : RefreshToken, RefreshTokenConstants,
 *                  BaseAuditableEntityConfiguration<RefreshToken>,
 *                  Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Configures the Entity Framework Core mapping for the
 *                  RefreshToken entity, including table mapping, primary key,
 *                  business properties, indexes, and relationships.
 */

using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="RefreshToken"/> entity.
/// </summary>
public sealed class RefreshTokenConfiguration
    : BaseAuditableEntityConfiguration<RefreshToken>
{
    /// <summary>
    /// Configures the RefreshToken entity using the Entity Framework Core Fluent API.
    /// </summary>
    /// <param name="builder">
    /// The builder used to configure the entity.
    /// </param>
    public override void Configure(EntityTypeBuilder<RefreshToken> builder)
    {
        // Apply the common audit configuration defined in the base class.
        base.Configure(builder);

        #region Table Configuration

        // Map the entity to the "RefreshTokens" table.
        builder.ToTable("RefreshTokens");

        #endregion

        #region Primary Key Configuration

        // Configure the primary key.
        builder.HasKey(refreshToken => refreshToken.Id);

        #endregion

        #region Business Properties Configuration

        // Configure the hashed refresh token value.
        builder.Property(refreshToken => refreshToken.TokenHash)
            .IsRequired()
            .HasMaxLength(RefreshTokenConstants.TokenHashMaxLength);

        // Configure the token expiration date and time.
        builder.Property(refreshToken => refreshToken.ExpiresAt)
            .HasColumnType("datetime2");

        // Configure the token revocation date and time.
        builder.Property(refreshToken => refreshToken.RevokedAt)
            .HasColumnType("datetime2");

        // Configure the maximum length of the revocation reason.
        builder.Property(refreshToken => refreshToken.RevocationReason)
            .HasMaxLength(RefreshTokenConstants.RevocationReasonMaxLength);

        // Configure the IP address used to create the token.
        builder.Property(refreshToken => refreshToken.CreatedByIp)
            .HasMaxLength(RefreshTokenConstants.IpAddressMaxLength);

        // Configure the IP address used to revoke the token.
        builder.Property(refreshToken => refreshToken.RevokedByIp)
            .HasMaxLength(RefreshTokenConstants.IpAddressMaxLength);

        #endregion

        #region Index Configuration

        // Ensure that each refresh token hash is unique.
        builder.HasIndex(refreshToken => refreshToken.TokenHash)
            .HasDatabaseName("UX_RefreshTokens_TokenHash")
            .IsUnique();

        // Create an index to improve queries by user.
        builder.HasIndex(refreshToken => refreshToken.UserId)
            .HasDatabaseName("IX_RefreshTokens_UserId");

        // Create an index to improve expiration date lookups.
        builder.HasIndex(refreshToken => refreshToken.ExpiresAt)
            .HasDatabaseName("IX_RefreshTokens_ExpiresAt");

        // Create an index to improve revoked token lookups.
        builder.HasIndex(refreshToken => refreshToken.RevokedAt)
            .HasDatabaseName("IX_RefreshTokens_RevokedAt");

        #endregion

        #region Relationship Configuration

        // Configure the many-to-one relationship between RefreshToken and ApplicationUser.
        builder.HasOne(refreshToken => refreshToken.User)
            .WithMany(user => user.RefreshTokens)
            .HasForeignKey(refreshToken => refreshToken.UserId)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion
    }
}