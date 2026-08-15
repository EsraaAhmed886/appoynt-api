/**
 * File Name      : FamilyMemberConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : EntityTypeBuilder
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : EF Core configuration for FamilyMember entity.
 */

using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configuration for the FamilyMember entity.
/// </summary>
public class FamilyMemberConfiguration : BaseAuditableEntityConfiguration<FamilyMember>
{
    /// <summary>
    /// Configures the entity.
    /// </summary>
    public override void Configure(EntityTypeBuilder<FamilyMember> builder)
    {
        // Call base configuration
        base.Configure(builder);

        // Set table name
        builder.ToTable("FamilyMembers");

        // Set primary key
        builder.HasKey(f => f.Id);

        // Configure PID
        builder.Property(f => f.PID)
            .IsRequired()
            .HasMaxLength(9);

        // Unique index for PID
        builder.HasIndex(f => f.PID)
            .IsUnique()
            .HasDatabaseName("UX_FamilyMembers_PID");

        // Configure FullName
        builder.Property(f => f.FullName)
            .IsRequired()
            .HasMaxLength(100);

        // Configure Gender
        builder.Property(f => f.Gender)
            .IsRequired();

        // Configure Relationship
        builder.Property(f => f.Relationship)
            .IsRequired();

        // Configure BirthDate
        builder.Property(f => f.BirthDate)
            .HasColumnType("date")
            .IsRequired();

        // Index for PatientId
        builder.HasIndex(f => f.PatientId)
            .HasDatabaseName("IX_FamilyMembers_PatientId");

        // Configure relationship with Patient
        builder.HasOne(f => f.Patient)
            .WithMany(p => p.FamilyMembers)
            .HasForeignKey(f => f.PatientId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
