/**
 * File Name      : BaseAuditableEntityConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, IEntityTypeConfiguration<TEntity>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Provides a base Entity Framework Core configuration for all
 *                  auditable entities by configuring audit fields, audit
 *                  relationships, and the global soft-delete query filter.
 */

using Appoynt.Domain.Common;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations.Base;

/// <summary>
/// Provides a base configuration for all auditable entities.
/// </summary>
/// <typeparam name="TEntity">
/// The entity type that inherits from <see cref="BaseEntity"/>.
/// </typeparam>
public abstract class BaseAuditableEntityConfiguration<TEntity>
    : IEntityTypeConfiguration<TEntity>
    where TEntity : BaseEntity
{
    /// <summary>
    /// Configures the common audit properties, relationships, and
    /// soft-delete behavior for the specified entity.
    /// </summary>
    /// <param name="builder">
    /// The builder used to configure the entity.
    /// </param>
    public virtual void Configure(EntityTypeBuilder<TEntity> builder)
    {
        #region Audit Properties

        // Configure the creation timestamp column.
        builder.Property(entity => entity.CreatedAt)
            .HasColumnType("datetime2");

        // Configure the last update timestamp column.
        builder.Property(entity => entity.UpdatedAt)
            .HasColumnType("datetime2");

        // Configure the soft-delete timestamp column.
        builder.Property(entity => entity.DeletedAt)
            .HasColumnType("datetime2");

        #endregion

        #region Audit Relationships

        // Configure the relationship with the user who created the entity.
        builder.HasOne(entity => entity.CreatedBy)
            .WithMany()
            .HasForeignKey(entity => entity.CreatedById)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure the relationship with the user who last updated the entity.
        builder.HasOne(entity => entity.UpdatedBy)
            .WithMany()
            .HasForeignKey(entity => entity.UpdatedById)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure the relationship with the user who soft-deleted the entity.
        builder.HasOne(entity => entity.DeletedBy)
            .WithMany()
            .HasForeignKey(entity => entity.DeletedById)
            .OnDelete(DeleteBehavior.Restrict);

        #endregion

        #region Global Query Filter

        // Exclude soft-deleted records from all queries by default.
        builder.HasQueryFilter(entity => entity.DeletedAt == null);

        #endregion
    }
}