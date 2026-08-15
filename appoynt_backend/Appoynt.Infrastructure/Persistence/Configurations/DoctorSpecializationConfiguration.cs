/**
 * File Name      : DoctorSpecializationConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : DoctorSpecialization, IEntityTypeConfiguration
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Configures the EF Core mapping for the DoctorSpecialization lightweight join entity.
 */

using Appoynt.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the lightweight <see cref="DoctorSpecialization"/> join entity.
/// </summary>
public sealed class DoctorSpecializationConfiguration : IEntityTypeConfiguration<DoctorSpecialization>
{
    /// <inheritdoc />
    public void Configure(EntityTypeBuilder<DoctorSpecialization> builder)
    {
        #region Table Configuration

        // Map to the DoctorSpecializations join table.
        builder.ToTable("DoctorSpecializations");

        #endregion

        #region Primary Key Configuration

        // Configure composite primary key.
        builder.HasKey(ds => new { ds.DoctorId, ds.SpecializationId });

        #endregion

        #region Relationships Configuration

        // Configure foreign key relationship with Doctor.
        builder.HasOne(ds => ds.Doctor)
            .WithMany(doctor => doctor.DoctorSpecializations)
            .HasForeignKey(ds => ds.DoctorId)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure foreign key relationship with Specialization.
        builder.HasOne(ds => ds.Specialization)
            .WithMany(specialization => specialization.DoctorSpecializations)
            .HasForeignKey(ds => ds.SpecializationId)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion

        #region Query Filter Configuration

        // Exclude join entries if either the associated doctor or specialization is soft-deleted.
        builder.HasQueryFilter(ds => ds.Doctor.DeletedAt == null && ds.Specialization.DeletedAt == null);

        #endregion
    }
}
