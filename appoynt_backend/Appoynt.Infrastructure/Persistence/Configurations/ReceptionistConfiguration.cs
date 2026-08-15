/**
 * File Name      : ReceptionistConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : Receptionist, BaseAuditableEntityConfiguration<Receptionist>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Configures the Entity Framework Core mapping for the
 *                  Receptionist entity, including table mapping, primary key,
 *                  indexes, and relationships.
 */

using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="Receptionist"/> entity.
/// </summary>
public sealed class ReceptionistConfiguration
    : BaseAuditableEntityConfiguration<Receptionist>
{
    /// <summary>
    /// Configures the Receptionist entity using the Entity Framework Core Fluent API.
    /// </summary>
    /// <param name="builder">
    /// The builder used to configure the entity.
    /// </param>
    public override void Configure(EntityTypeBuilder<Receptionist> builder)
    {
        // Apply the common audit configuration defined in the base class.
        base.Configure(builder);

        #region Table Configuration

        // Map the entity to the "Receptionists" table.
        builder.ToTable("Receptionists");

        #endregion

        #region Primary Key Configuration

        // Configure the primary key.
        builder.HasKey(receptionist => receptionist.Id);

        #endregion

        #region Index Configuration

        // Ensure that each user can be associated with only one receptionist record.
        builder.HasIndex(receptionist => receptionist.UserId)
            .HasDatabaseName("UX_Receptionists_UserId")
            .IsUnique();

        // Create an index to improve queries filtering by doctor.
        builder.HasIndex(receptionist => receptionist.DoctorId)
            .HasDatabaseName("IX_Receptionists_DoctorId");

        #endregion

        #region Relationship Configuration

        // Configure the one-to-one relationship between Receptionist and User.
        builder.HasOne(receptionist => receptionist.User)
            .WithOne(user => user.Receptionist)
            .HasForeignKey<Receptionist>(receptionist => receptionist.UserId)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure the many-to-one relationship between Receptionist and Doctor.
        builder.HasOne(receptionist => receptionist.Doctor)
            .WithMany(doctor => doctor.Receptionists)
            .HasForeignKey(receptionist => receptionist.DoctorId)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion
    }
}