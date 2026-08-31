/**
 * File Name      : TestCatalogConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : TestCatalog, BaseAuditableEntityConfiguration<TestCatalog>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Configures the Entity Framework Core mapping for the TestCatalog global catalog entity.
 */

using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="TestCatalog"/> entity.
/// </summary>
public sealed class TestCatalogConfiguration : BaseAuditableEntityConfiguration<TestCatalog>
{
    /// <summary>
    /// Configures the entity properties, indexes, and constraints.
    /// </summary>
    /// <param name="builder">The builder used to configure the entity.</param>
    public override void Configure(EntityTypeBuilder<TestCatalog> builder)
    {
        // Apply base audit configuration
        base.Configure(builder);

        // Map to table name
        builder.ToTable("TestCatalogs");

        // Primary key
        builder.HasKey(t => t.Id);

        // Name configurations
        builder.Property(t => t.NameAr)
            .HasMaxLength(200)
            .IsRequired();

        builder.Property(t => t.NameEn)
            .HasMaxLength(200)
            .IsRequired();

        builder.Property(t => t.Category)
            .IsRequired();

        builder.Property(t => t.Description)
            .HasMaxLength(1000)
            .IsRequired(false);

        builder.Property(t => t.IsActive)
            .HasDefaultValue(true)
            .IsRequired();

        // Indexes for category filtering and name searches
        builder.HasIndex(t => new { t.Category, t.NameEn, t.NameAr })
            .HasDatabaseName("IX_TestCatalogs_Category_Search");
    }
}
