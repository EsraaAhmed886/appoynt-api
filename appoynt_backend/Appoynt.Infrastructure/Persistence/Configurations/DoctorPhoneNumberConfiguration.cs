/**
 * File Name      : DoctorPhoneNumberConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : DoctorPhoneNumber, BaseAuditableEntityConfiguration, DoctorConstants
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Configures the EF Core mapping for the DoctorPhoneNumber entity.
 */

using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="DoctorPhoneNumber"/> entity.
/// </summary>
public sealed class DoctorPhoneNumberConfiguration : BaseAuditableEntityConfiguration<DoctorPhoneNumber>
{
    /// <inheritdoc />
    public override void Configure(EntityTypeBuilder<DoctorPhoneNumber> builder)
    {
        // Apply base audit and soft-delete configuration.
        base.Configure(builder);

        #region Table Configuration

        // Map to the DoctorPhoneNumbers table.
        builder.ToTable("DoctorPhoneNumbers");

        #endregion

        #region Primary Key Configuration

        // Configure primary key.
        builder.HasKey(phone => phone.Id);

        #endregion

        #region Property Configuration

        // Configure phone number column.
        builder.Property(phone => phone.PhoneNumber)
            .IsRequired()
            .HasMaxLength(20);

        // Configure label column.
        builder.Property(phone => phone.Label)
            .IsRequired()
            .HasMaxLength(DoctorConstants.PhoneLabelMaxLength);

        #endregion

        #region Index Configuration

        // Ensure unique phone number per doctor.
        builder.HasIndex(phone => new { phone.DoctorId, phone.PhoneNumber })
            .HasDatabaseName("UX_DoctorPhoneNumbers_DoctorId_PhoneNumber")
            .IsUnique()
            .HasFilter("[DeletedAt] IS NULL");

        #endregion

        #region Relationship Configuration

        // Configure relationship back to Doctor.
        builder.HasOne(phone => phone.Doctor)
            .WithMany(doctor => doctor.PhoneNumbers)
            .HasForeignKey(phone => phone.DoctorId)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion
    }
}
