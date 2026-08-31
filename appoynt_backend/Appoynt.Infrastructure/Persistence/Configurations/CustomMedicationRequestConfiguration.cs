/**
 * File Name      : CustomMedicationRequestConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : CustomMedicationRequest, BaseAuditableEntityConfiguration<CustomMedicationRequest>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Configures the Entity Framework Core mapping for the CustomMedicationRequest entity.
 */

using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="CustomMedicationRequest"/> entity.
/// </summary>
public sealed class CustomMedicationRequestConfiguration : BaseAuditableEntityConfiguration<CustomMedicationRequest>
{
    /// <summary>
    /// Configures the entity properties, indexes, and constraints.
    /// </summary>
    /// <param name="builder">The builder used to configure the entity.</param>
    public override void Configure(EntityTypeBuilder<CustomMedicationRequest> builder)
    {
        // Apply base audit configuration
        base.Configure(builder);

        // Map to table name
        builder.ToTable("CustomMedicationRequests");

        // Primary key
        builder.HasKey(c => c.Id);

        // Name configurations
        builder.Property(c => c.Name)
            .HasMaxLength(250)
            .IsRequired();

        builder.Property(c => c.Status)
            .HasDefaultValue(CustomMedicationStatus.PendingAdminApproval)
            .IsRequired();

        builder.Property(c => c.AdminNotes)
            .HasMaxLength(1000)
            .IsRequired(false);

        builder.Property(c => c.DoctorNotes)
            .HasMaxLength(1000)
            .IsRequired(false);

        // Relationships
        builder.HasOne(c => c.Doctor)
            .WithMany()
            .HasForeignKey(c => c.DoctorId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(c => c.LinkedMedicationCatalog)
            .WithMany()
            .HasForeignKey(c => c.LinkedMedicationCatalogId)
            .OnDelete(DeleteBehavior.SetNull);

        // Indexes for doctor lookup and pending admin queue
        builder.HasIndex(c => new { c.DoctorId, c.Status })
            .HasDatabaseName("IX_CustomMedicationRequests_DoctorId_Status");

        builder.HasIndex(c => c.Status)
            .HasDatabaseName("IX_CustomMedicationRequests_Status");
    }
}
