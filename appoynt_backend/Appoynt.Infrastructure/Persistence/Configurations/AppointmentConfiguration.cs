/**
 * File Name      : AppointmentConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : Appointment, BaseAuditableEntityConfiguration<Appointment>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-26
 * Description    : Configures the Entity Framework Core mapping for the
 *                  Appointment entity, including table mapping, properties,
 *                  indexes, and relationships.
 */

using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="Appointment"/> entity.
/// </summary>
public sealed class AppointmentConfiguration
    : BaseAuditableEntityConfiguration<Appointment>
{
    /// <summary>
    /// Configures the Appointment entity using the Entity Framework Core Fluent API.
    /// </summary>
    /// <param name="builder">
    /// The builder used to configure the entity.
    /// </param>
    public override void Configure(EntityTypeBuilder<Appointment> builder)
    {
        // Apply the common audit configuration defined in the base class.
        base.Configure(builder);

        #region Table Configuration

        // Map the entity to the "Appointments" table.
        builder.ToTable("Appointments");

        #endregion

        #region Primary Key Configuration

        // Configure the primary key.
        builder.HasKey(appointment => appointment.Id);

        #endregion

        #region Business Properties Configuration

        // Configure the denormalized appointment date column.
        builder.Property(appointment => appointment.Date)
            .IsRequired();

        // Configure the booking type column.
        builder.Property(appointment => appointment.Type)
            .HasDefaultValue(BookingType.New)
            .IsRequired();

        // Configure the lifecycle status column.
        builder.Property(appointment => appointment.Status)
            .HasDefaultValue(AppointmentStatus.Upcoming)
            .IsRequired();

        // Configure the actual consultation start column (UTC).
        builder.Property(appointment => appointment.ActualStartTimeUtc)
            .HasColumnType("datetime2")
            .IsRequired(false);

        // Configure the actual consultation end column (UTC).
        builder.Property(appointment => appointment.ActualEndTimeUtc)
            .HasColumnType("datetime2")
            .IsRequired(false);

        #endregion

        #region Index Configuration

        // Enforce the one-slot-one-appointment invariant at the database level.
        builder.HasIndex(appointment => appointment.AppointmentSlotId)
            .HasDatabaseName("IX_Appointments_AppointmentSlotId_Unique")
            .IsUnique();

        // Cover the doctor queue query: clinic + day + status filtering.
        builder.HasIndex(appointment => new { appointment.ClinicId, appointment.Date, appointment.Status })
            .HasDatabaseName("IX_Appointments_ClinicId_Date_Status");

        #endregion

        #region Relationship Configuration

        // Configure many-to-one relationship with Patient; history must survive,
        // so deleting a patient row is restricted rather than cascading.
        builder.HasOne(appointment => appointment.Patient)
            .WithMany()
            .HasForeignKey(appointment => appointment.PatientId)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure the one-to-one relationship with the reserved slot.
        builder.HasOne(appointment => appointment.AppointmentSlot)
            .WithOne(slot => slot.Appointment)
            .HasForeignKey<Appointment>(appointment => appointment.AppointmentSlotId)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure many-to-one relationship with Clinic.
        builder.HasOne(appointment => appointment.Clinic)
            .WithMany()
            .HasForeignKey(appointment => appointment.ClinicId)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion
    }
}
