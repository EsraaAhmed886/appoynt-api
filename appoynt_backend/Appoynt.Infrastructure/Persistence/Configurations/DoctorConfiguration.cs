/**
 * File Name      : DoctorConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : Doctor, BaseAuditableEntityConfiguration<Doctor>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Configures the Entity Framework Core mapping for the
 *                  Doctor entity, including table mapping, primary key,
 *                  indexes, and relationships.
 */

using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="Doctor"/> entity.
/// </summary>
public sealed class DoctorConfiguration
    : BaseAuditableEntityConfiguration<Doctor>
{
    /// <summary>
    /// Configures the Doctor entity using the Entity Framework Core Fluent API.
    /// </summary>
    /// <param name="builder">
    /// The builder used to configure the entity.
    /// </param>
    public override void Configure(EntityTypeBuilder<Doctor> builder)
    {
        // Apply the common audit configuration defined in the base class.
        base.Configure(builder);

        #region Table Configuration

        // Map the entity to the "Doctors" table.
        builder.ToTable("Doctors");

        #endregion

        #region Primary Key Configuration

        // Configure the primary key.
        builder.HasKey(doctor => doctor.Id);

        #endregion

        #region Index Configuration

        // Ensure that each user can be associated with only one doctor record.
        builder.HasIndex(doctor => doctor.UserId)
            .HasDatabaseName("UX_Doctors_UserId")
            .IsUnique();

        #endregion

        #region Relationship Configuration

        // Configure the one-to-one relationship between Doctor and User.
        builder.HasOne(doctor => doctor.User)
            .WithOne(user => user.Doctor)
            .HasForeignKey<Doctor>(doctor => doctor.UserId)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion
    }
}