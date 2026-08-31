/**
 * File Name      : MedicalRecordAttachmentConfiguration.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : MedicalRecordAttachment, BaseAuditableEntityConfiguration<MedicalRecordAttachment>, Entity Framework Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Configures the Entity Framework Core mapping for the MedicalRecordAttachment entity.
 */

using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Configurations.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the database mapping for the <see cref="MedicalRecordAttachment"/> entity.
/// </summary>
public sealed class MedicalRecordAttachmentConfiguration : BaseAuditableEntityConfiguration<MedicalRecordAttachment>
{
    /// <summary>
    /// Configures the entity properties, indexes, and constraints.
    /// </summary>
    /// <param name="builder">The builder used to configure the entity.</param>
    public override void Configure(EntityTypeBuilder<MedicalRecordAttachment> builder)
    {
        // Apply base audit configuration
        base.Configure(builder);

        // Map to table name
        builder.ToTable("MedicalRecordAttachments");

        // Primary key
        builder.HasKey(a => a.Id);

        // Properties
        builder.Property(a => a.FileName)
            .HasMaxLength(260)
            .IsRequired();

        builder.Property(a => a.FileUrl)
            .HasMaxLength(1000)
            .IsRequired();

        builder.Property(a => a.ContentType)
            .HasMaxLength(100)
            .IsRequired();

        builder.Property(a => a.FileSizeBytes)
            .IsRequired();

        builder.Property(a => a.Description)
            .HasMaxLength(500)
            .IsRequired(false);

        builder.Property(a => a.UploadedAtUtc)
            .HasColumnType("datetime2")
            .IsRequired();

        // Relationships
        builder.HasOne(a => a.MedicalRecord)
            .WithMany(m => m.Attachments)
            .HasForeignKey(a => a.MedicalRecordId)
            .OnDelete(DeleteBehavior.Cascade);

        // Indexes
        builder.HasIndex(a => a.MedicalRecordId)
            .HasDatabaseName("IX_MedicalRecordAttachments_MedicalRecordId");
    }
}
