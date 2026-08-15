using System.Text.Json;
using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;

namespace Appoynt.Infrastructure.Persistence;

/// <summary>
/// A temporary holding class used during SaveChanges to capture entity modifications
/// and convert them into an <see cref="AuditLog"/> entity.
/// </summary>
public class AuditEntry
{
    public EntityEntry Entry { get; }
    public AuditType AuditType { get; set; }
    public string TableName { get; set; }
    public Dictionary<string, object?> KeyValues { get; } = new();
    public Dictionary<string, object?> OldValues { get; } = new();
    public Dictionary<string, object?> NewValues { get; } = new();
    public List<PropertyEntry> TemporaryProperties { get; } = new();
    public List<string> ChangedColumns { get; } = new();
    public Guid? UserId { get; set; }
    public DateTimeOffset DateTimeOffset { get; set; }

    public AuditEntry(EntityEntry entry)
    {
        Entry = entry;
        TableName = entry.Metadata.GetTableName() ?? entry.Metadata.Name;
    }

    /// <summary>
    /// Indicates whether this entry has temporary properties (e.g., database-generated IDs)
    /// that need to be updated after SaveChanges is called.
    /// </summary>
    public bool HasTemporaryProperties => TemporaryProperties.Any();

    /// <summary>
    /// Converts the collected audit data into an <see cref="AuditLog"/> entity.
    /// </summary>
    public AuditLog ToAuditLog()
    {
        return new AuditLog
        {
            Id = Guid.NewGuid(),
            UserId = UserId,
            Type = AuditType,
            TableName = TableName,
            DateTimeOffset = DateTimeOffset,
            PrimaryKey = JsonSerializer.Serialize(KeyValues),
            OldValues = OldValues.Count == 0 ? null : JsonSerializer.Serialize(OldValues),
            NewValues = NewValues.Count == 0 ? null : JsonSerializer.Serialize(NewValues),
            AffectedColumns = ChangedColumns.Count == 0 ? null : JsonSerializer.Serialize(ChangedColumns)
        };
    }
}
