/**
 * File Name      : ClinicConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : Clinic, BaseAuditableEntityConfiguration<Clinic>, ClinicConstants, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Configures the Entity Framework Core mapping for the
 *                  Clinic entity, including table mapping, properties,
 *                  indexes, and relationships.
 */

using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="Clinic"/> entity.
/// </summary>
public sealed class ClinicConfiguration
    : BaseAuditableEntityConfiguration<Clinic>
{
    /// <summary>
    /// Configures the Clinic entity using the Entity Framework Core Fluent API.
    /// </summary>
    /// <param name="builder">
    /// The builder used to configure the entity.
    /// </param>
    public override void Configure(EntityTypeBuilder<Clinic> builder)
    {
        // Apply the common audit configuration defined in the base class.
        base.Configure(builder);

        #region Table Configuration

        // Map the entity to the "Clinics" table.
        builder.ToTable("Clinics");

        #endregion

        #region Primary Key Configuration

        // Configure the primary key.
        builder.HasKey(clinic => clinic.Id);

        #endregion

        #region Business Properties Configuration

        // Configure clinic name column.
        builder.Property(clinic => clinic.Name)
            .HasMaxLength(ClinicConstants.NameMaxLength)
            .IsRequired();

        // Configure detailed address column.
        builder.Property(clinic => clinic.DetailedAddress)
            .HasMaxLength(ClinicConstants.DetailedAddressMaxLength)
            .IsRequired(false);

        // Configure consultation fee column.
        builder.Property(clinic => clinic.ConsultationFee)
            .HasColumnType("decimal(18,2)")
            .IsRequired();

        // Configure status column.
        builder.Property(clinic => clinic.Status)
            .IsRequired();

        // Configure appointment duration column.
        builder.Property(clinic => clinic.AppointmentDurationMinutes)
            .IsRequired();

        // Configure max advance booking days column.
        builder.Property(clinic => clinic.MaxAdvanceBookingDays)
            .IsRequired();

        #endregion

        #region Index Configuration

        // Add index on DoctorId for faster lookups.
        builder.HasIndex(clinic => clinic.DoctorId)
            .HasDatabaseName("IX_Clinics_DoctorId");

        #endregion

        #region Relationship Configuration

        // Configure many-to-one relationship with Doctor.
        builder.HasOne(clinic => clinic.Doctor)
            .WithMany(doctor => doctor.Clinics)
            .HasForeignKey(clinic => clinic.DoctorId)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure many-to-one relationship with Governorate.
        builder.HasOne(clinic => clinic.Governorate)
            .WithMany()
            .HasForeignKey(clinic => clinic.GovernorateId)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure many-to-one relationship with City.
        builder.HasOne(clinic => clinic.City)
            .WithMany()
            .HasForeignKey(clinic => clinic.CityId)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure one-to-many relationship with PhoneNumbers.
        builder.HasMany(clinic => clinic.PhoneNumbers)
            .WithOne(phone => phone.Clinic)
            .HasForeignKey(phone => phone.ClinicId)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure one-to-many relationship with WorkingPeriods.
        builder.HasMany(clinic => clinic.WorkingPeriods)
            .WithOne(wp => wp.Clinic)
            .HasForeignKey(wp => wp.ClinicId)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure one-to-many relationship with Slots.
        builder.HasMany(clinic => clinic.Slots)
            .WithOne(slot => slot.Clinic)
            .HasForeignKey(slot => slot.ClinicId)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure one-to-many relationship with ClinicReceptionists.
        builder.HasMany(clinic => clinic.ClinicReceptionists)
            .WithOne(cr => cr.Clinic)
            .HasForeignKey(cr => cr.ClinicId)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion
    }
}
