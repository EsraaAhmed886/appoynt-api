/**
 * File Name      : AuditLog.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-07-27
 * Version        : v1.0.0
 * Dependencies   : AuditType, Guid, DateTimeOffset
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Represents an audit log entry recording entity mutations across the system.
 */

using System;
using Appoynt.Domain.Enums;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents an audit log entry for changes made to entities within the system.
/// </summary>
public class AuditLog
{
    /// <summary>
    /// Gets or sets the unique identifier of the audit log entry.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the identifier of the user who performed the operation.
    /// Can be null for system or background operations.
    /// </summary>
    public Guid? UserId { get; set; }

    /// <summary>
    /// Gets or sets the type of operation performed (Create, Update, Delete).
    /// </summary>
    public AuditType Type { get; set; }

    /// <summary>
    /// Gets or sets the name of the table that was modified.
    /// </summary>
    public string TableName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the UTC date and time when the operation occurred.
    /// </summary>
    public DateTimeOffset DateTimeOffset { get; set; }

    /// <summary>
    /// Gets or sets the JSON representation of the old values.
    /// </summary>
    public string? OldValues { get; set; }

    /// <summary>
    /// Gets or sets the JSON representation of the new values.
    /// </summary>
    public string? NewValues { get; set; }

    /// <summary>
    /// Gets or sets the JSON array of affected column names.
    /// </summary>
    public string? AffectedColumns { get; set; }

    /// <summary>
    /// Gets or sets the JSON representation of the primary key.
    /// </summary>
    public string PrimaryKey { get; set; } = string.Empty;
}
