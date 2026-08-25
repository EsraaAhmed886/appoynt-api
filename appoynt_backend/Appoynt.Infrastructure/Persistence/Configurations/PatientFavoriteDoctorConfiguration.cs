/**
 * File Name      : PatientFavoriteDoctorConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : PatientFavoriteDoctor, IEntityTypeConfiguration
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-23
 * Description    : Configures the EF Core mapping for the PatientFavoriteDoctor join entity.
 */

using Appoynt.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="PatientFavoriteDoctor"/> join entity.
/// </summary>
public sealed class PatientFavoriteDoctorConfiguration : IEntityTypeConfiguration<PatientFavoriteDoctor>
{
    /// <inheritdoc />
    public void Configure(EntityTypeBuilder<PatientFavoriteDoctor> builder)
    {
        #region Table Configuration

        // Map to the PatientFavoriteDoctors join table.
        builder.ToTable("PatientFavoriteDoctors");

        #endregion

        #region Primary Key Configuration

        // Configure composite primary key.
        builder.HasKey(pfd => new { pfd.PatientId, pfd.DoctorId });

        #endregion

        #region Index Configuration

        // Configure index on DoctorId for performance when querying favorites by doctor.
        builder.HasIndex(pfd => pfd.DoctorId)
            .HasDatabaseName("IX_PatientFavoriteDoctors_DoctorId");

        #endregion

        #region Business Properties Configuration

        // Configure AddedAt timestamp column.
        builder.Property(pfd => pfd.AddedAt)
            .HasColumnType("datetime2")
            .IsRequired();

        #endregion

        #region Relationships Configuration

        // Configure foreign key relationship with Patient.
        builder.HasOne(pfd => pfd.Patient)
            .WithMany(patient => patient.FavoriteDoctors)
            .HasForeignKey(pfd => pfd.PatientId)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure foreign key relationship with Doctor.
        builder.HasOne(pfd => pfd.Doctor)
            .WithMany(doctor => doctor.FavoritedByPatients)
            .HasForeignKey(pfd => pfd.DoctorId)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion

        #region Query Filter Configuration

        // Exclude join entries if either the associated patient or doctor is soft-deleted.
        builder.HasQueryFilter(pfd => pfd.Patient.DeletedAt == null && pfd.Doctor.DeletedAt == null);

        #endregion
    }
}
