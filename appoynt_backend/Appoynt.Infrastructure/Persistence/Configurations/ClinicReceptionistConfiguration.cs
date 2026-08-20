/**
 * File Name      : ClinicReceptionistConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : ClinicReceptionist, IEntityTypeConfiguration<ClinicReceptionist>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Configures the EF Core mapping for the ClinicReceptionist lightweight join entity.
 */

using Appoynt.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the lightweight <see cref="ClinicReceptionist"/> join entity.
/// </summary>
public sealed class ClinicReceptionistConfiguration : IEntityTypeConfiguration<ClinicReceptionist>
{
    /// <inheritdoc />
    public void Configure(EntityTypeBuilder<ClinicReceptionist> builder)
    {
        #region Table Configuration

        // Map to the ClinicReceptionists join table.
        builder.ToTable("ClinicReceptionists");

        #endregion

        #region Primary Key Configuration

        // Configure composite primary key.
        builder.HasKey(cr => new { cr.ClinicId, cr.ReceptionistId });

        #endregion

        #region Relationships Configuration

        // Configure foreign key relationship with Clinic.
        builder.HasOne(cr => cr.Clinic)
            .WithMany(clinic => clinic.ClinicReceptionists)
            .HasForeignKey(cr => cr.ClinicId)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure foreign key relationship with Receptionist.
        builder.HasOne(cr => cr.Receptionist)
            .WithMany(receptionist => receptionist.ClinicReceptionists)
            .HasForeignKey(cr => cr.ReceptionistId)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion

        #region Query Filter Configuration

        // Exclude join entries if either the associated clinic or receptionist is soft-deleted.
        builder.HasQueryFilter(cr => cr.Clinic.DeletedAt == null && cr.Receptionist.DeletedAt == null);

        #endregion
    }
}
