/**
 * File Name      : ClinicBreakConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : ClinicBreak, BaseAuditableEntityConfiguration<ClinicBreak>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Configures the Entity Framework Core mapping for the
 *                  ClinicBreak entity, including table mapping, properties,
 *                  indexes, and relationships.
 */

using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="ClinicBreak"/> entity.
/// </summary>
public sealed class ClinicBreakConfiguration
    : BaseAuditableEntityConfiguration<ClinicBreak>
{
    /// <summary>
    /// Configures the ClinicBreak entity using the Entity Framework Core Fluent API.
    /// </summary>
    /// <param name="builder">
    /// The builder used to configure the entity.
    /// </param>
    public override void Configure(EntityTypeBuilder<ClinicBreak> builder)
    {
        // Apply the common audit configuration defined in the base class.
        base.Configure(builder);

        #region Table Configuration

        // Map the entity to the "ClinicBreaks" table.
        builder.ToTable("ClinicBreaks");

        #endregion

        #region Primary Key Configuration

        // Configure the primary key.
        builder.HasKey(br => br.Id);

        #endregion

        #region Business Properties Configuration

        // Configure start time column.
        builder.Property(br => br.StartTime)
            .IsRequired();

        // Configure end time column.
        builder.Property(br => br.EndTime)
            .IsRequired();

        #endregion

        #region Relationship Configuration

        // Configure many-to-one relationship with ClinicWorkingPeriod.
        builder.HasOne(br => br.WorkingPeriod)
            .WithMany(wp => wp.Breaks)
            .HasForeignKey(br => br.WorkingPeriodId)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion
    }
}
