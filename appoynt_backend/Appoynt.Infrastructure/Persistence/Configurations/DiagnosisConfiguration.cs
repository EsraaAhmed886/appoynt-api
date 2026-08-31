/**
 * File Name      : DiagnosisConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : Diagnosis, BaseAuditableEntityConfiguration<Diagnosis>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Configures the Entity Framework Core mapping for the Diagnosis catalog entity.
 */

using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="Diagnosis"/> entity.
/// </summary>
public sealed class DiagnosisConfiguration : BaseAuditableEntityConfiguration<Diagnosis>
{
    /// <summary>
    /// Configures the entity properties, indexes, and constraints.
    /// </summary>
    /// <param name="builder">The builder used to configure the entity.</param>
    public override void Configure(EntityTypeBuilder<Diagnosis> builder)
    {
        // Apply base audit configuration
        base.Configure(builder);

        // Map to table name
        builder.ToTable("Diagnoses");

        // Primary key
        builder.HasKey(d => d.Id);

        // ICD10Code configuration
        builder.Property(d => d.ICD10Code)
            .HasMaxLength(20)
            .IsRequired();

        // Name configurations
        builder.Property(d => d.NameAr)
            .HasMaxLength(200)
            .IsRequired();

        builder.Property(d => d.NameEn)
            .HasMaxLength(200)
            .IsRequired();

        builder.Property(d => d.Description)
            .HasMaxLength(1000)
            .IsRequired(false);

        builder.Property(d => d.IsActive)
            .HasDefaultValue(true)
            .IsRequired();

        // Indexes for search and uniqueness
        builder.HasIndex(d => d.ICD10Code)
            .HasDatabaseName("IX_Diagnoses_ICD10Code_Unique")
            .IsUnique();

        builder.HasIndex(d => new { d.NameEn, d.NameAr })
            .HasDatabaseName("IX_Diagnoses_Search");
    }
}
