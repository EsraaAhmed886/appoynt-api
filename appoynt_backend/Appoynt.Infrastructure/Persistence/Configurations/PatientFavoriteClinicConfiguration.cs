/**
 * File Name      : PatientFavoriteClinicConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : PatientFavoriteClinic, IEntityTypeConfiguration
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-23
 * Description    : Configures the EF Core mapping for the PatientFavoriteClinic join entity.
 */

using Appoynt.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="PatientFavoriteClinic"/> join entity.
/// </summary>
public sealed class PatientFavoriteClinicConfiguration : IEntityTypeConfiguration<PatientFavoriteClinic>
{
    /// <inheritdoc />
    public void Configure(EntityTypeBuilder<PatientFavoriteClinic> builder)
    {
        #region Table Configuration

        // Map to the PatientFavoriteClinics join table.
        builder.ToTable("PatientFavoriteClinics");

        #endregion

        #region Primary Key Configuration

        // Configure composite primary key.
        builder.HasKey(pfc => new { pfc.PatientId, pfc.ClinicId });

        #endregion

        #region Index Configuration

        // Configure index on ClinicId for performance when querying favorites by clinic.
        builder.HasIndex(pfc => pfc.ClinicId)
            .HasDatabaseName("IX_PatientFavoriteClinics_ClinicId");

        #endregion

        #region Business Properties Configuration

        // Configure AddedAt timestamp column.
        builder.Property(pfc => pfc.AddedAt)
            .HasColumnType("datetime2")
            .IsRequired();

        #endregion

        #region Relationships Configuration

        // Configure foreign key relationship with Patient.
        builder.HasOne(pfc => pfc.Patient)
            .WithMany(patient => patient.FavoriteClinics)
            .HasForeignKey(pfc => pfc.PatientId)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure foreign key relationship with Clinic.
        builder.HasOne(pfc => pfc.Clinic)
            .WithMany(clinic => clinic.FavoritedByPatients)
            .HasForeignKey(pfc => pfc.ClinicId)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion

        #region Query Filter Configuration

        // Exclude join entries if either the associated patient or clinic is soft-deleted.
        builder.HasQueryFilter(pfc => pfc.Patient.DeletedAt == null && pfc.Clinic.DeletedAt == null);

        #endregion
    }
}
