namespace Appoynt.Domain.Enums;

/// <summary>
/// Specifies the type of operation that generated an audit log.
/// </summary>
public enum AuditType
{
    None = 0,
    Create = 1,
    Update = 2,
    Delete = 3
}
