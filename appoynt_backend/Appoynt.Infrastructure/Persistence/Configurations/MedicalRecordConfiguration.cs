/**
 * File Name      : MedicalRecordConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : MedicalRecord, BaseAuditableEntityConfiguration<MedicalRecord>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Configures the Entity Framework Core mapping for the MedicalRecord aggregate root entity.
 */

using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="MedicalRecord"/> entity.
/// </summary>
public sealed class MedicalRecordConfiguration : BaseAuditableEntityConfiguration<MedicalRecord>
{
    /// <summary>
    /// Configures the entity properties, indexes, and constraints.
    /// </summary>
    /// <param name="builder">The builder used to configure the entity.</param>
    public override void Configure(EntityTypeBuilder<MedicalRecord> builder)
    {
        // Apply base audit configuration
        base.Configure(builder);

        // Map to table name
        builder.ToTable("MedicalRecords");

        // Primary key
        builder.HasKey(m => m.Id);

        // Status configuration
        builder.Property(m => m.Status)
            .HasDefaultValue(MedicalRecordStatus.Draft)
            .IsRequired();

        // Clinical outcome
        builder.Property(m => m.ClinicalOutcome)
            .IsRequired(false);

        // Clinical notes
        builder.Property(m => m.ClinicalNotes)
            .HasMaxLength(5000)
            .IsRequired(false);

        // Visit date
        builder.Property(m => m.VisitDate)
            .IsRequired();

        // Finalized timestamp
        builder.Property(m => m.FinalizedAtUtc)
            .HasColumnType("datetime2")
            .IsRequired(false);

        // Concurrency token / RowVersion for optimistic locking
        builder.Property(m => m.Version)
            .IsRowVersion();

        #region Relationships

        // One medical record per appointment
        builder.HasOne(m => m.Appointment)
            .WithMany()
            .HasForeignKey(m => m.AppointmentId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(m => m.Patient)
            .WithMany()
            .HasForeignKey(m => m.PatientId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(m => m.Doctor)
            .WithMany()
            .HasForeignKey(m => m.DoctorId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(m => m.Clinic)
            .WithMany()
            .HasForeignKey(m => m.ClinicId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(m => m.SignedBy)
            .WithMany()
            .HasForeignKey(m => m.SignedById)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasMany(m => m.Diagnoses)
            .WithOne(d => d.MedicalRecord)
            .HasForeignKey(d => d.MedicalRecordId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasMany(m => m.Medications)
            .WithOne(med => med.MedicalRecord)
            .HasForeignKey(med => med.MedicalRecordId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasMany(m => m.TestRequests)
            .WithOne(t => t.MedicalRecord)
            .HasForeignKey(t => t.MedicalRecordId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasMany(m => m.Attachments)
            .WithOne(a => a.MedicalRecord)
            .HasForeignKey(a => a.MedicalRecordId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasMany(m => m.ChangeLogs)
            .WithOne(c => c.MedicalRecord)
            .HasForeignKey(c => c.MedicalRecordId)
            .OnDelete(DeleteBehavior.Cascade);

        #endregion

        #region Indexes

        // Uniqueness: exactly one medical record per appointment
        builder.HasIndex(m => m.AppointmentId)
            .HasDatabaseName("IX_MedicalRecords_AppointmentId_Unique")
            .IsUnique();

        // Index for patient history retrieval ordered by visit date
        builder.HasIndex(m => new { m.PatientId, m.VisitDate, m.Status })
            .HasDatabaseName("IX_MedicalRecords_PatientId_VisitDate_Status");

        // Index for doctor history queries
        builder.HasIndex(m => new { m.DoctorId, m.VisitDate })
            .HasDatabaseName("IX_MedicalRecords_DoctorId_VisitDate");

        #endregion
    }
}
