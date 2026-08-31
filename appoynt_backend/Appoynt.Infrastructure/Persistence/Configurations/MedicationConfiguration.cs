/**
 * File Name      : MedicationConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : Medication, BaseAuditableEntityConfiguration<Medication>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Configures the Entity Framework Core mapping for the Medication global catalog entity.
 */

using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="Medication"/> entity.
/// </summary>
public sealed class MedicationConfiguration : BaseAuditableEntityConfiguration<Medication>
{
    /// <summary>
    /// Configures the entity properties, indexes, and constraints.
    /// </summary>
    /// <param name="builder">The builder used to configure the entity.</param>
    public override void Configure(EntityTypeBuilder<Medication> builder)
    {
        // Apply base audit configuration
        base.Configure(builder);

        // Map to table name
        builder.ToTable("Medications");

        // Primary key
        builder.HasKey(m => m.Id);

        // Name configurations
        builder.Property(m => m.NameAr)
            .HasMaxLength(200)
            .IsRequired();

        builder.Property(m => m.NameEn)
            .HasMaxLength(200)
            .IsRequired();

        builder.Property(m => m.ActiveIngredient)
            .HasMaxLength(250)
            .IsRequired();

        builder.Property(m => m.Form)
            .HasMaxLength(100)
            .IsRequired(false);

        builder.Property(m => m.Strength)
            .HasMaxLength(100)
            .IsRequired(false);

        builder.Property(m => m.Description)
            .HasMaxLength(1000)
            .IsRequired(false);

        builder.Property(m => m.IsActive)
            .HasDefaultValue(true)
            .IsRequired();

        // Indexes for search and active ingredient lookups
        builder.HasIndex(m => new { m.NameEn, m.NameAr })
            .HasDatabaseName("IX_Medications_Search");

        builder.HasIndex(m => m.ActiveIngredient)
            .HasDatabaseName("IX_Medications_ActiveIngredient");
    }
}
