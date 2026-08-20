/**
 * File Name      : AppointmentSlotConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : AppointmentSlot, BaseAuditableEntityConfiguration<AppointmentSlot>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Configures the Entity Framework Core mapping for the
 *                  AppointmentSlot entity, including table mapping, properties,
 *                  indexes, and relationships.
 */

using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="AppointmentSlot"/> entity.
/// </summary>
public sealed class AppointmentSlotConfiguration
    : BaseAuditableEntityConfiguration<AppointmentSlot>
{
    /// <summary>
    /// Configures the AppointmentSlot entity using the Entity Framework Core Fluent API.
    /// </summary>
    /// <param name="builder">
    /// The builder used to configure the entity.
    /// </param>
    public override void Configure(EntityTypeBuilder<AppointmentSlot> builder)
    {
        // Apply the common audit configuration defined in the base class.
        base.Configure(builder);

        #region Table Configuration

        // Map the entity to the "AppointmentSlots" table.
        builder.ToTable("AppointmentSlots");

        #endregion

        #region Primary Key Configuration

        // Configure the primary key.
        builder.HasKey(slot => slot.Id);

        #endregion

        #region Business Properties Configuration

        // Configure date column.
        builder.Property(slot => slot.Date)
            .IsRequired();

        // Configure start time column.
        builder.Property(slot => slot.StartTime)
            .IsRequired();

        // Configure end time column.
        builder.Property(slot => slot.EndTime)
            .IsRequired();

        // Configure status column.
        builder.Property(slot => slot.Status)
            .HasDefaultValue(Appoynt.Domain.Enums.SlotStatus.Available)
            .IsRequired();

        #endregion

        #region Index Configuration

        // Critical index for fast patient slot queries.
        builder.HasIndex(slot => new { slot.ClinicId, slot.Date, slot.Status })
            .HasDatabaseName("IX_AppointmentSlots_ClinicId_Date_Status");

        // Index for pending timeout queries.
        builder.HasIndex(slot => new { slot.Status, slot.UpdatedAt })
            .HasDatabaseName("IX_AppointmentSlots_Status_UpdatedAt");

        #endregion

        #region Relationship Configuration

        // Configure many-to-one relationship with Clinic.
        builder.HasOne(slot => slot.Clinic)
            .WithMany(clinic => clinic.Slots)
            .HasForeignKey(slot => slot.ClinicId)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion
    }
}
