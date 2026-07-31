using Appoynt.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Appoynt.Infrastructure.Persistence.Configurations;

/// <summary>
/// Configures the Entity Framework Core mapping for the <see cref="AuditLog"/> entity.
/// </summary>
public class AuditLogConfiguration : IEntityTypeConfiguration<AuditLog>
{
    public void Configure(EntityTypeBuilder<AuditLog> builder)
    {
        builder.ToTable("AuditLogs");

        builder.HasKey(a => a.Id);
        builder.Property(a => a.Id)
            .ValueGeneratedNever();

        builder.Property(a => a.TableName)
            .IsRequired()
            .HasMaxLength(128);

        builder.Property(a => a.Type)
            .IsRequired()
            .HasConversion<string>()
            .HasMaxLength(20);

        builder.Property(a => a.PrimaryKey)
            .IsRequired();

        // Optional JSON columns
        builder.Property(a => a.OldValues);
        builder.Property(a => a.NewValues);
        builder.Property(a => a.AffectedColumns);

        // Index on UserId and DateTimeOffset for fast querying
        builder.HasIndex(a => a.UserId);
        builder.HasIndex(a => a.DateTimeOffset);
        builder.HasIndex(a => a.TableName);
    }
}
