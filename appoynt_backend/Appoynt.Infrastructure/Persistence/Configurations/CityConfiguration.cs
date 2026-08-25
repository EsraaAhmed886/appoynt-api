/**
 * File Name      : CityConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : City, BaseAuditableEntityConfiguration<City>, ClinicConstants, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Configures the Entity Framework Core mapping for the
 *                  City entity, including table mapping, properties,
 *                  indexes, and relationships.
 */

using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="City"/> entity.
/// </summary>
public sealed class CityConfiguration
    : BaseAuditableEntityConfiguration<City>
{
    /// <summary>
    /// Configures the City entity using the Entity Framework Core Fluent API.
    /// </summary>
    /// <param name="builder">
    /// The builder used to configure the entity.
    /// </param>
    public override void Configure(EntityTypeBuilder<City> builder)
    {
        // Apply the common audit configuration defined in the base class.
        base.Configure(builder);

        #region Table Configuration

        // Map the entity to the "Cities" table.
        builder.ToTable("Cities");

        #endregion

        #region Primary Key Configuration

        // Configure the primary key.
        builder.HasKey(city => city.Id);

        #endregion

        #region Business Properties Configuration

        // Configure Arabic display name column.
        builder.Property(city => city.NameAr)
            .HasMaxLength(ClinicConstants.CityNameMaxLength)
            .IsRequired();

        // Configure English display name column.
        builder.Property(city => city.NameEn)
            .HasMaxLength(ClinicConstants.CityNameMaxLength)
            .IsRequired();

        #endregion

        #region Index Configuration

        // Ensure unique Arabic name within a governorate for active cities.
        builder.HasIndex(city => new { city.GovernorateId, city.NameAr })
            .HasDatabaseName("UX_Cities_GovernorateId_NameAr")
            .IsUnique()
            .HasFilter("DeletedAt IS NULL");

        #endregion

        #region Relationship Configuration

        // Configure many-to-one relationship with Governorate.
        builder.HasOne(city => city.Governorate)
            .WithMany(governorate => governorate.Cities)
            .HasForeignKey(city => city.GovernorateId)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion
    }
}
