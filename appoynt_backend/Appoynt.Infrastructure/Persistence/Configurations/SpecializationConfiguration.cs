/**
 * File Name      : SpecializationConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : Specialization, BaseAuditableEntityConfiguration, DoctorConstants
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Configures the EF Core mapping for the Specialization entity.
 */

using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="Specialization"/> entity.
/// </summary>
public sealed class SpecializationConfiguration : BaseAuditableEntityConfiguration<Specialization>
{
    /// <inheritdoc />
    public override void Configure(EntityTypeBuilder<Specialization> builder)
    {
        // Apply base audit and soft-delete configuration.
        base.Configure(builder);

        #region Table Configuration

        // Map to the Specializations table.
        builder.ToTable("Specializations");

        #endregion

        #region Primary Key Configuration

        // Configure primary key.
        builder.HasKey(spec => spec.Id);

        #endregion

        #region Property Configuration

        // Configure English name.
        builder.Property(spec => spec.NameEn)
            .IsRequired()
            .HasMaxLength(DoctorConstants.SpecializationNameMaxLength);

        // Configure Arabic name.
        builder.Property(spec => spec.NameAr)
            .IsRequired()
            .HasMaxLength(DoctorConstants.SpecializationNameMaxLength);

        #endregion

        #region Index Configuration

        // Unique filtered index for English specialization name.
        builder.HasIndex(spec => spec.NameEn)
            .HasDatabaseName("UX_Specializations_NameEn")
            .IsUnique()
            .HasFilter("[DeletedAt] IS NULL");

        // Unique filtered index for Arabic specialization name.
        builder.HasIndex(spec => spec.NameAr)
            .HasDatabaseName("UX_Specializations_NameAr")
            .IsUnique()
            .HasFilter("[DeletedAt] IS NULL");

        #endregion
    }
}
