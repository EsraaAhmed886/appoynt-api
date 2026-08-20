/**
 * File Name      : ClinicWorkingPeriodConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : ClinicWorkingPeriod, BaseAuditableEntityConfiguration<ClinicWorkingPeriod>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Configures the Entity Framework Core mapping for the
 *                  ClinicWorkingPeriod entity, including table mapping, properties,
 *                  indexes, and relationships.
 */

using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="ClinicWorkingPeriod"/> entity.
/// </summary>
public sealed class ClinicWorkingPeriodConfiguration
    : BaseAuditableEntityConfiguration<ClinicWorkingPeriod>
{
    /// <summary>
    /// Configures the ClinicWorkingPeriod entity using the Entity Framework Core Fluent API.
    /// </summary>
    /// <param name="builder">
    /// The builder used to configure the entity.
    /// </param>
    public override void Configure(EntityTypeBuilder<ClinicWorkingPeriod> builder)
    {
        // Apply the common audit configuration defined in the base class.
        base.Configure(builder);

        #region Table Configuration

        // Map the entity to the "ClinicWorkingPeriods" table.
        builder.ToTable("ClinicWorkingPeriods");

        #endregion

        #region Primary Key Configuration

        // Configure the primary key.
        builder.HasKey(wp => wp.Id);

        #endregion

        #region Business Properties Configuration

        // Configure day of week column.
        builder.Property(wp => wp.DayOfWeek)
            .IsRequired();

        // Configure start time column.
        builder.Property(wp => wp.StartTime)
            .IsRequired();

        // Configure end time column.
        builder.Property(wp => wp.EndTime)
            .IsRequired();

        // Configure is active column.
        builder.Property(wp => wp.IsActive)
            .HasDefaultValue(true)
            .IsRequired();

        #endregion

        #region Index Configuration

        // Add index on ClinicId and DayOfWeek for faster lookups.
        builder.HasIndex(wp => new { wp.ClinicId, wp.DayOfWeek })
            .HasDatabaseName("IX_ClinicWorkingPeriods_ClinicId_DayOfWeek");

        #endregion

        #region Relationship Configuration

        // Configure many-to-one relationship with Clinic.
        builder.HasOne(wp => wp.Clinic)
            .WithMany(clinic => clinic.WorkingPeriods)
            .HasForeignKey(wp => wp.ClinicId)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure one-to-many relationship with ClinicBreaks.
        builder.HasMany(wp => wp.Breaks)
            .WithOne(br => br.WorkingPeriod)
            .HasForeignKey(br => br.WorkingPeriodId)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion
    }
}
