/**
 * File Name      : MedicalRecordTestRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : BaseEntity, MedicalRecord, TestCatalog, TestCategory, TestPriority, TestRequestStatus
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Represents an ordered lab or diagnostic test request attached to a medical record.
 */

using System;
using Appoynt.Domain.Common;
using Appoynt.Domain.Enums;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a laboratory or diagnostic investigation ordered during a medical record consultation.
/// </summary>
public class MedicalRecordTestRequest : BaseEntity
{
    #region Business Properties

    /// <summary>
    /// Gets or sets the denormalized test name for historical display integrity.
    /// </summary>
    public string TestName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the category of the ordered test (e.g., Laboratory, Radiology, Cardiology).
    /// </summary>
    public TestCategory Category { get; set; }

    /// <summary>
    /// Gets or sets the clinical urgency and priority level (Routine, Urgent, Stat).
    /// </summary>
    public TestPriority Priority { get; set; } = TestPriority.Routine;

    /// <summary>
    /// Gets or sets clinical preparation or sampling instructions for the patient and laboratory.
    /// </summary>
    public string? Instructions { get; set; }

    /// <summary>
    /// Gets or sets optional clinical indication or differential diagnosis driving the test order.
    /// </summary>
    public string? ClinicalIndication { get; set; }

    /// <summary>
    /// Gets or sets the fulfillment lifecycle status of the requested test.
    /// </summary>
    public TestRequestStatus Status { get; set; } = TestRequestStatus.Requested;

    /// <summary>
    /// Gets or sets the date and time when the test was formally ordered.
    /// </summary>
    public DateTime RequestDateUtc { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether this draft test request is incomplete.
    /// </summary>
    public bool IsIncomplete { get; set; }

    #endregion

    #region Relationship Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the parent medical record.
    /// </summary>
    public Guid MedicalRecordId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the parent medical record.
    /// </summary>
    public required MedicalRecord MedicalRecord { get; set; }

    /// <summary>
    /// Gets or sets the foreign key referencing the global test catalog entry.
    /// </summary>
    public Guid TestCatalogId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the global test catalog entry.
    /// </summary>
    public required TestCatalog TestCatalog { get; set; }

    #endregion
}
