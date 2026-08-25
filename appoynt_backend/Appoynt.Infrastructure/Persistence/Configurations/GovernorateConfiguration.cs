/**
 * File Name      : GovernorateConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : Governorate, BaseAuditableEntityConfiguration<Governorate>, ClinicConstants, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Configures the Entity Framework Core mapping for the
 *                  Governorate entity, including table mapping, properties,
 *                  indexes, and relationships.
 */

using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="Governorate"/> entity.
/// </summary>
public sealed class GovernorateConfiguration
    : BaseAuditableEntityConfiguration<Governorate>
{
    /// <summary>
    /// Configures the Governorate entity using the Entity Framework Core Fluent API.
    /// </summary>
    /// <param name="builder">
    /// The builder used to configure the entity.
    /// </param>
    public override void Configure(EntityTypeBuilder<Governorate> builder)
    {
        // Apply the common audit configuration defined in the base class.
        base.Configure(builder);

        #region Table Configuration

        // Map the entity to the "Governorates" table.
        builder.ToTable("Governorates");

        #endregion

        #region Primary Key Configuration

        // Configure the primary key.
        builder.HasKey(governorate => governorate.Id);

        #endregion

        #region Business Properties Configuration

        // Configure Arabic display name column.
        builder.Property(governorate => governorate.NameAr)
            .HasMaxLength(ClinicConstants.GovernorateNameMaxLength)
            .IsRequired();

        // Configure English display name column.
        builder.Property(governorate => governorate.NameEn)
            .HasMaxLength(ClinicConstants.GovernorateNameMaxLength)
            .IsRequired();

        #endregion

        #region Index Configuration

        // Ensure unique Arabic name for active governorates.
        builder.HasIndex(governorate => governorate.NameAr)
            .HasDatabaseName("UX_Governorates_NameAr")
            .IsUnique()
            .HasFilter("DeletedAt IS NULL");

        // Ensure unique English name for active governorates.
        builder.HasIndex(governorate => governorate.NameEn)
            .HasDatabaseName("UX_Governorates_NameEn")
            .IsUnique()
            .HasFilter("DeletedAt IS NULL");

        #endregion

        #region Relationship Configuration

        // Configure one-to-many relationship with Cities.
        builder.HasMany(governorate => governorate.Cities)
            .WithOne(city => city.Governorate)
            .HasForeignKey(city => city.GovernorateId)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion
    }
}
