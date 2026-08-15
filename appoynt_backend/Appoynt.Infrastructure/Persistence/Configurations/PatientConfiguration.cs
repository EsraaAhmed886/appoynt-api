/**
 * File Name      : PatientConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v2.0.0
 * Dependencies   : Patient, BaseAuditableEntityConfiguration, EntityTypeBuilder
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : EF Core configuration for Patient entity. Profile photo is now centrally mapped on ApplicationUser.
 */

using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configuration for the Patient entity.
/// </summary>
public class PatientConfiguration : BaseAuditableEntityConfiguration<Patient>
{
    /// <summary>
    /// Configures the entity.
    /// </summary>
    public override void Configure(EntityTypeBuilder<Patient> builder)
    {
        // Call base configuration
        base.Configure(builder);

        // Set table name
        builder.ToTable("Patients");

        // Set primary key
        builder.HasKey(p => p.Id);

        // Configure PID
        builder.Property(p => p.PID)
            .IsRequired()
            .HasMaxLength(9);
            
        // Unique index for PID
        builder.HasIndex(p => p.PID)
            .IsUnique()
            .HasDatabaseName("UX_Patients_PID");

        // Configure FamilyNumber
        builder.Property(p => p.FamilyNumber)
            .IsRequired()
            .HasMaxLength(7);

        // Configure NationalId
        builder.Property(p => p.NationalId)
            .HasMaxLength(14)
            .IsRequired(false);

        // Unique filtered index for NationalId
        builder.HasIndex(p => p.NationalId)
            .IsUnique()
            .HasFilter("[DeletedAt] IS NULL AND [NationalId] IS NOT NULL")
            .HasDatabaseName("UX_Patients_NationalId");

        // Configure BirthDate
        builder.Property(p => p.BirthDate)
            .HasColumnType("date")
            .IsRequired(false);

        // Configure WeightKg
        builder.Property(p => p.WeightKg)
            .HasColumnType("decimal(5,1)")
            .IsRequired(false);

        // Configure HeightCm
        builder.Property(p => p.HeightCm)
            .HasColumnType("decimal(5,1)")
            .IsRequired(false);

        // Configure BloodGroup
        builder.Property(p => p.BloodGroup)
            .IsRequired(false);

        // Configure SmokingStatus
        builder.Property(p => p.SmokingStatus)
            .IsRequired(false);

        // Unique index for UserId
        builder.HasIndex(p => p.UserId)
            .IsUnique()
            .HasDatabaseName("UX_Patients_UserId");

        // Configure relationship with ApplicationUser
        builder.HasOne(p => p.User)
            .WithOne(u => u.Patient)
            .HasForeignKey<Patient>(p => p.UserId)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure relationship with FamilyMembers
        builder.HasMany(p => p.FamilyMembers)
            .WithOne(f => f.Patient)
            .HasForeignKey(f => f.PatientId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}