/**
 * File Name      : ClinicPhoneNumberConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : ClinicPhoneNumber, BaseAuditableEntityConfiguration<ClinicPhoneNumber>, ClinicConstants, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Configures the Entity Framework Core mapping for the
 *                  ClinicPhoneNumber entity, including table mapping, properties,
 *                  indexes, and relationships.
 */

using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="ClinicPhoneNumber"/> entity.
/// </summary>
public sealed class ClinicPhoneNumberConfiguration
    : BaseAuditableEntityConfiguration<ClinicPhoneNumber>
{
    /// <summary>
    /// Configures the ClinicPhoneNumber entity using the Entity Framework Core Fluent API.
    /// </summary>
    /// <param name="builder">
    /// The builder used to configure the entity.
    /// </param>
    public override void Configure(EntityTypeBuilder<ClinicPhoneNumber> builder)
    {
        // Apply the common audit configuration defined in the base class.
        base.Configure(builder);

        #region Table Configuration

        // Map the entity to the "ClinicPhoneNumbers" table.
        builder.ToTable("ClinicPhoneNumbers");

        #endregion

        #region Primary Key Configuration

        // Configure the primary key.
        builder.HasKey(phone => phone.Id);

        #endregion

        #region Business Properties Configuration

        // Configure phone number column.
        builder.Property(phone => phone.PhoneNumber)
            .HasMaxLength(20)
            .IsRequired();

        // Configure phone label column.
        builder.Property(phone => phone.Label)
            .HasMaxLength(ClinicConstants.PhoneLabelMaxLength)
            .IsRequired();

        #endregion

        #region Index Configuration

        // Ensure unique phone numbers within a clinic.
        builder.HasIndex(phone => new { phone.ClinicId, phone.PhoneNumber })
            .HasDatabaseName("UX_ClinicPhoneNumbers_ClinicId_PhoneNumber")
            .IsUnique()
            .HasFilter("DeletedAt IS NULL");

        #endregion

        #region Relationship Configuration

        // Configure many-to-one relationship with Clinic.
        builder.HasOne(phone => phone.Clinic)
            .WithMany(clinic => clinic.PhoneNumbers)
            .HasForeignKey(phone => phone.ClinicId)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion
    }
}
