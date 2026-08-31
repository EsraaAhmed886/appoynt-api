/**
 * File Name      : MedicalRecordTestRequestDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : TestCategory, TestPriority, TestRequestStatus
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Data transfer object representing an ordered test request on a medical record.
 */

using System;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.MedicalRecords.Contracts;

/// <summary>
/// Represents an ordered laboratory or diagnostic test item.
/// </summary>
public sealed class MedicalRecordTestRequestDto
{
    /// <summary>
    /// Gets or sets the test request identifier.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the global test catalog identifier.
    /// </summary>
    public Guid TestCatalogId { get; set; }

    /// <summary>
    /// Gets or sets the test name.
    /// </summary>
    public string TestName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the test category.
    /// </summary>
    public TestCategory Category { get; set; }

    /// <summary>
    /// Gets or sets the test priority level.
    /// </summary>
    public TestPriority Priority { get; set; }

    /// <summary>
    /// Gets or sets clinical preparation or sampling instructions.
    /// </summary>
    public string? Instructions { get; set; }

    /// <summary>
    /// Gets or sets the clinical indication.
    /// </summary>
    public string? ClinicalIndication { get; set; }

    /// <summary>
    /// Gets or sets the fulfillment lifecycle status.
    /// </summary>
    public TestRequestStatus Status { get; set; }

    /// <summary>
    /// Gets or sets the date and time when the test was ordered.
    /// </summary>
    public DateTime RequestDateUtc { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether this draft item is incomplete.
    /// </summary>
    public bool IsIncomplete { get; set; }
}
