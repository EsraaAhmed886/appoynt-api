/**
 * File Name      : MedicalRecordAttachment.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, MedicalRecord
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Represents an uploaded file or medical document attachment linked to a medical record consultation.
 */

using System;
using Appoynt.Domain.Common;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a clinical attachment (PDF, report, image) linked to a medical record consultation.
/// </summary>
public class MedicalRecordAttachment : BaseEntity
{
    #region Business Properties

    /// <summary>
    /// Gets or sets the original uploaded file name.
    /// </summary>
    public string FileName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the secure storage URI or file system path of the uploaded file.
    /// </summary>
    public string FileUrl { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the MIME content type (e.g., application/pdf, image/jpeg, image/png).
    /// </summary>
    public string ContentType { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the file size in bytes.
    /// </summary>
    public long FileSizeBytes { get; set; }

    /// <summary>
    /// Gets or sets optional description or title for the attachment.
    /// </summary>
    public string? Description { get; set; }

    /// <summary>
    /// Gets or sets the UTC timestamp when the file was uploaded.
    /// </summary>
    public DateTime UploadedAtUtc { get; set; }

    #endregion

    #region Relationship Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the associated medical record.
    /// </summary>
    public Guid MedicalRecordId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the associated medical record.
    /// </summary>
    public required MedicalRecord MedicalRecord { get; set; }

    #endregion
}
