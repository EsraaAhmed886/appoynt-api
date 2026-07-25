/**
 * File Name      : OtpChallengeConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 25/07/2026
 * Version        : v1.0.0
 * Dependencies   : OtpChallenge, BaseAuditableEntityConfiguration,
 *                  Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 25/07/2026
 * Description    : Configures the Entity Framework Core mapping for persisted
 *                  mobile OTP challenges.
 */

using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="OtpChallenge"/> entity.
/// </summary>
public sealed class OtpChallengeConfiguration
    : BaseAuditableEntityConfiguration<OtpChallenge>
{
    /// <summary>
    /// Configures the OTP challenge entity using the Entity Framework Core
    /// Fluent API.
    /// </summary>
    /// <param name="builder">The builder used to configure the entity.</param>
    public override void Configure(EntityTypeBuilder<OtpChallenge> builder)
    {
        base.Configure(builder);

        builder.ToTable("OtpChallenges");

        builder.HasKey(challenge => challenge.Id);

        builder.Property(challenge => challenge.Purpose)
            .HasConversion<int>();

        builder.Property(challenge => challenge.CodeHash)
            .IsRequired()
            .HasMaxLength(512);

        builder.Property(challenge => challenge.ExpiresAt)
            .HasColumnType("datetime2");

        builder.Property(challenge => challenge.SentAt)
            .HasColumnType("datetime2");

        builder.Property(challenge => challenge.ConsumedAt)
            .HasColumnType("datetime2");

        builder.Property(challenge => challenge.InvalidatedAt)
            .HasColumnType("datetime2");

        builder.HasIndex(challenge => new
            {
                challenge.UserId,
                challenge.Purpose,
                challenge.ConsumedAt,
                challenge.InvalidatedAt,
                challenge.ExpiresAt
            })
            .HasDatabaseName("IX_OtpChallenges_ActiveChallenge");

        builder.HasOne(challenge => challenge.User)
            .WithMany()
            .HasForeignKey(challenge => challenge.UserId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
