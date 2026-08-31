/**
 * File Name      : MedicalRecordAttachmentDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Data transfer object representing an uploaded medical attachment or document.
 */

using System;

namespace Appoynt.Application.Features.MedicalRecords.Contracts;

/// <summary>
/// Represents a clinical document or imaging attachment linked to a medical record.
/// </summary>
public sealed class MedicalRecordAttachmentDto
{
    /// <summary>
    /// Gets or sets the attachment identifier.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the original file name.
    /// </summary>
    public string FileName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the secure download/viewing URL.
    /// </summary>
    public string FileUrl { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the MIME content type.
    /// </summary>
    public string ContentType { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the file size in bytes.
    /// </summary>
    public long FileSizeBytes { get; set; }

    /// <summary>
    /// Gets or sets optional description or title.
    /// </summary>
    public string? Description { get; set; }

    /// <summary>
    /// Gets or sets the upload timestamp.
    /// </summary>
    public DateTime UploadedAtUtc { get; set; }
}
