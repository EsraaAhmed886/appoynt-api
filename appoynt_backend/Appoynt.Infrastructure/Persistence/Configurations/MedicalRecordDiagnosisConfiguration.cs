/**
 * File Name      : MedicalRecordDiagnosisConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : MedicalRecordDiagnosis, BaseAuditableEntityConfiguration<MedicalRecordDiagnosis>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Configures the Entity Framework Core mapping for the MedicalRecordDiagnosis line entity.
 */

using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="MedicalRecordDiagnosis"/> entity.
/// </summary>
public sealed class MedicalRecordDiagnosisConfiguration : BaseAuditableEntityConfiguration<MedicalRecordDiagnosis>
{
    /// <summary>
    /// Configures the entity properties, indexes, and constraints.
    /// </summary>
    /// <param name="builder">The builder used to configure the entity.</param>
    public override void Configure(EntityTypeBuilder<MedicalRecordDiagnosis> builder)
    {
        // Apply base audit configuration
        base.Configure(builder);

        // Map to table name
        builder.ToTable("MedicalRecordDiagnoses");

        // Primary key
        builder.HasKey(d => d.Id);

        // Properties
        builder.Property(d => d.ICD10Code)
            .HasMaxLength(20)
            .IsRequired();

        builder.Property(d => d.DiagnosisName)
            .HasMaxLength(250)
            .IsRequired();

        builder.Property(d => d.Type)
            .IsRequired();

        builder.Property(d => d.Notes)
            .HasMaxLength(1000)
            .IsRequired(false);

        // Relationships
        builder.HasOne(d => d.MedicalRecord)
            .WithMany(m => m.Diagnoses)
            .HasForeignKey(d => d.MedicalRecordId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(d => d.DiagnosisCatalog)
            .WithMany()
            .HasForeignKey(d => d.DiagnosisCatalogId)
            .OnDelete(DeleteBehavior.SetNull);

        // Indexes
        builder.HasIndex(d => new { d.MedicalRecordId, d.Type })
            .HasDatabaseName("IX_MedicalRecordDiagnoses_MedicalRecordId_Type");
    }
}
