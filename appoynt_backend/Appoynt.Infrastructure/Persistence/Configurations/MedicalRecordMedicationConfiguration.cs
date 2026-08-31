/**
 * File Name      : MedicalRecordMedicationConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : MedicalRecordMedication, BaseAuditableEntityConfiguration<MedicalRecordMedication>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Configures the Entity Framework Core mapping for the MedicalRecordMedication entity.
 */

using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="MedicalRecordMedication"/> entity.
/// </summary>
public sealed class MedicalRecordMedicationConfiguration : BaseAuditableEntityConfiguration<MedicalRecordMedication>
{
    /// <summary>
    /// Configures the entity properties, indexes, and constraints.
    /// </summary>
    /// <param name="builder">The builder used to configure the entity.</param>
    public override void Configure(EntityTypeBuilder<MedicalRecordMedication> builder)
    {
        // Apply base audit configuration
        base.Configure(builder);

        // Map to table name
        builder.ToTable("MedicalRecordMedications");

        // Primary key
        builder.HasKey(med => med.Id);

        // Properties
        builder.Property(med => med.MedicationName)
            .HasMaxLength(250)
            .IsRequired();

        builder.Property(med => med.DosageAmount)
            .HasColumnType("decimal(8,2)")
            .IsRequired();

        builder.Property(med => med.DosageUnit)
            .IsRequired();

        builder.Property(med => med.Frequency)
            .IsRequired();

        builder.Property(med => med.Route)
            .IsRequired();

        builder.Property(med => med.IsOngoing)
            .HasDefaultValue(false)
            .IsRequired();

        builder.Property(med => med.DurationValue)
            .IsRequired(false);

        builder.Property(med => med.DurationUnit)
            .IsRequired(false);

        builder.Property(med => med.Instructions)
            .HasMaxLength(1000)
            .IsRequired(false);

        builder.Property(med => med.MedicationNote)
            .HasMaxLength(1000)
            .IsRequired(false);

        builder.Property(med => med.DoctorAcknowledgedRisk)
            .HasDefaultValue(false)
            .IsRequired();

        builder.Property(med => med.IsIncomplete)
            .HasDefaultValue(false)
            .IsRequired();

        // Relationships
        builder.HasOne(med => med.MedicalRecord)
            .WithMany(m => m.Medications)
            .HasForeignKey(med => med.MedicalRecordId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(med => med.MedicationCatalog)
            .WithMany()
            .HasForeignKey(med => med.MedicationCatalogId)
            .OnDelete(DeleteBehavior.SetNull);

        builder.HasOne(med => med.CustomMedication)
            .WithMany()
            .HasForeignKey(med => med.CustomMedicationId)
            .OnDelete(DeleteBehavior.SetNull);

        // Check constraint enforcing that at least one of CatalogId or CustomMedicationId is set
        builder.ToTable(t => t.HasCheckConstraint(
            "CK_MedicalRecordMedications_AtLeastOneSource",
            "([MedicationCatalogId] IS NOT NULL OR [CustomMedicationId] IS NOT NULL)"));

        // Indexes
        builder.HasIndex(med => med.MedicalRecordId)
            .HasDatabaseName("IX_MedicalRecordMedications_MedicalRecordId");

        builder.HasIndex(med => med.MedicationCatalogId)
            .HasDatabaseName("IX_MedicalRecordMedications_MedicationCatalogId");

        builder.HasIndex(med => med.CustomMedicationId)
            .HasDatabaseName("IX_MedicalRecordMedications_CustomMedicationId");
    }
}
