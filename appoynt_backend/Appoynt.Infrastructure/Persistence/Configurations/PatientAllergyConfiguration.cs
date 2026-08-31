/**
 * File Name      : PatientAllergyConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : PatientAllergy, BaseAuditableEntityConfiguration<PatientAllergy>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Configures the Entity Framework Core mapping for the PatientAllergy entity.
 */

using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="PatientAllergy"/> entity.
/// </summary>
public sealed class PatientAllergyConfiguration : BaseAuditableEntityConfiguration<PatientAllergy>
{
    /// <summary>
    /// Configures the entity properties, indexes, and constraints.
    /// </summary>
    /// <param name="builder">The builder used to configure the entity.</param>
    public override void Configure(EntityTypeBuilder<PatientAllergy> builder)
    {
        // Apply base audit configuration
        base.Configure(builder);

        // Map to table name
        builder.ToTable("PatientAllergies");

        // Primary key
        builder.HasKey(a => a.Id);

        // Properties
        builder.Property(a => a.AllergenName)
            .HasMaxLength(200)
            .IsRequired();

        builder.Property(a => a.AllergenType)
            .HasMaxLength(100)
            .IsRequired();

        builder.Property(a => a.Severity)
            .HasMaxLength(50)
            .IsRequired(false);

        builder.Property(a => a.Notes)
            .HasMaxLength(1000)
            .IsRequired(false);

        builder.Property(a => a.IsActive)
            .HasDefaultValue(true)
            .IsRequired();

        // Relationships
        builder.HasOne(a => a.Patient)
            .WithMany(p => p.Allergies)
            .HasForeignKey(a => a.PatientId)
            .OnDelete(DeleteBehavior.Cascade);

        // Indexes
        builder.HasIndex(a => new { a.PatientId, a.IsActive })
            .HasDatabaseName("IX_PatientAllergies_PatientId_IsActive");
    }
}
