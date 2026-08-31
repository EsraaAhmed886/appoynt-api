/**
 * File Name      : MedicalRecordChangeLogConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : MedicalRecordChangeLog, BaseAuditableEntityConfiguration<MedicalRecordChangeLog>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Configures the Entity Framework Core mapping for the MedicalRecordChangeLog entity.
 */

using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="MedicalRecordChangeLog"/> entity.
/// </summary>
public sealed class MedicalRecordChangeLogConfiguration : BaseAuditableEntityConfiguration<MedicalRecordChangeLog>
{
    /// <summary>
    /// Configures the entity properties, indexes, and constraints.
    /// </summary>
    /// <param name="builder">The builder used to configure the entity.</param>
    public override void Configure(EntityTypeBuilder<MedicalRecordChangeLog> builder)
    {
        // Apply base audit configuration
        base.Configure(builder);

        // Map to table name
        builder.ToTable("MedicalRecordChangeLogs");

        // Primary key
        builder.HasKey(c => c.Id);

        // Properties
        builder.Property(c => c.Field)
            .HasMaxLength(150)
            .IsRequired();

        builder.Property(c => c.OldValue)
            .IsRequired(false);

        builder.Property(c => c.NewValue)
            .IsRequired(false);

        builder.Property(c => c.Reason)
            .HasMaxLength(1000)
            .IsRequired();

        builder.Property(c => c.ChangedAtUtc)
            .HasColumnType("datetime2")
            .IsRequired();

        // Relationships
        builder.HasOne(c => c.MedicalRecord)
            .WithMany(m => m.ChangeLogs)
            .HasForeignKey(c => c.MedicalRecordId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(c => c.ChangedBy)
            .WithMany()
            .HasForeignKey(c => c.ChangedById)
            .OnDelete(DeleteBehavior.Restrict);

        // Indexes
        builder.HasIndex(c => new { c.MedicalRecordId, c.ChangedAtUtc })
            .HasDatabaseName("IX_MedicalRecordChangeLogs_MedicalRecordId_ChangedAtUtc");
    }
}
