/**
 * File Name      : MedicalRecordTestRequestConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : MedicalRecordTestRequest, BaseAuditableEntityConfiguration<MedicalRecordTestRequest>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Configures the Entity Framework Core mapping for the MedicalRecordTestRequest entity.
 */

using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="MedicalRecordTestRequest"/> entity.
/// </summary>
public sealed class MedicalRecordTestRequestConfiguration : BaseAuditableEntityConfiguration<MedicalRecordTestRequest>
{
    /// <summary>
    /// Configures the entity properties, indexes, and constraints.
    /// </summary>
    /// <param name="builder">The builder used to configure the entity.</param>
    public override void Configure(EntityTypeBuilder<MedicalRecordTestRequest> builder)
    {
        // Apply base audit configuration
        base.Configure(builder);

        // Map to table name
        builder.ToTable("MedicalRecordTestRequests");

        // Primary key
        builder.HasKey(t => t.Id);

        // Properties
        builder.Property(t => t.TestName)
            .HasMaxLength(250)
            .IsRequired();

        builder.Property(t => t.Category)
            .IsRequired();

        builder.Property(t => t.Priority)
            .HasDefaultValue(TestPriority.Routine)
            .IsRequired();

        builder.Property(t => t.Instructions)
            .HasMaxLength(1000)
            .IsRequired(false);

        builder.Property(t => t.ClinicalIndication)
            .HasMaxLength(1000)
            .IsRequired(false);

        builder.Property(t => t.Status)
            .HasDefaultValue(TestRequestStatus.Requested)
            .IsRequired();

        builder.Property(t => t.RequestDateUtc)
            .HasColumnType("datetime2")
            .IsRequired();

        builder.Property(t => t.IsIncomplete)
            .HasDefaultValue(false)
            .IsRequired();

        // Relationships
        builder.HasOne(t => t.MedicalRecord)
            .WithMany(m => m.TestRequests)
            .HasForeignKey(t => t.MedicalRecordId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(t => t.TestCatalog)
            .WithMany()
            .HasForeignKey(t => t.TestCatalogId)
            .OnDelete(DeleteBehavior.Restrict);

        // Indexes
        builder.HasIndex(t => t.MedicalRecordId)
            .HasDatabaseName("IX_MedicalRecordTestRequests_MedicalRecordId");

        builder.HasIndex(t => new { t.TestCatalogId, t.Status })
            .HasDatabaseName("IX_MedicalRecordTestRequests_TestCatalogId_Status");
    }
}
