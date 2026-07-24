/**
 * File Name      : PatientConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : Patient, BaseAuditableEntityConfiguration<Patient>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Configures the Entity Framework Core mapping for the
 *                  Patient entity, including table mapping, primary key,
 *                  indexes, and relationships.
 */

using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="Patient"/> entity.
/// </summary>
public sealed class PatientConfiguration
    : BaseAuditableEntityConfiguration<Patient>
{
    /// <summary>
    /// Configures the Patient entity using the Entity Framework Core Fluent API.
    /// </summary>
    /// <param name="builder">
    /// The builder used to configure the entity.
    /// </param>
    public override void Configure(EntityTypeBuilder<Patient> builder)
    {
        // Apply the common audit configuration defined in the base class.
        base.Configure(builder);

        #region Table Configuration

        // Map the entity to the "Patients" table.
        builder.ToTable("Patients");

        #endregion

        #region Primary Key Configuration

        // Configure the primary key.
        builder.HasKey(patient => patient.Id);

        #endregion

        #region Index Configuration

        // Ensure that each user can be associated with only one patient record.
        builder.HasIndex(patient => patient.UserId)
            .HasDatabaseName("UX_Patients_UserId")
            .IsUnique();

        #endregion

        #region Relationship Configuration

        // Configure the one-to-one relationship between Patient and User.
        builder.HasOne(patient => patient.User)
            .WithOne(user => user.Patient)
            .HasForeignKey<Patient>(patient => patient.UserId)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion
    }
}