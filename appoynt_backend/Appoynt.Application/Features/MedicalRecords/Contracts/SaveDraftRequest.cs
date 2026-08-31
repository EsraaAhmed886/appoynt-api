/**
 * File Name      : SaveDraftRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : ClinicalOutcome, DiagnosisType, DosageUnit, Frequency, Route, DurationUnit, TestCategory, TestPriority
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Request payload for saving or updating an in-progress draft medical record.
 */

using System;
using System.Collections.Generic;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.MedicalRecords.Contracts;

/// <summary>
/// Carries the complete payload to save/update a draft medical record across all 3 steps.
/// </summary>
public sealed class SaveDraftRequest
{
    /// <summary>
    /// Gets or sets the optimistic concurrency token (base64) to prevent concurrent overwrite.
    /// </summary>
    public string? Version { get; set; }

    /// <summary>
    /// Gets or sets the selected clinical outcome (optional during early draft steps).
    /// </summary>
    public ClinicalOutcome? ClinicalOutcome { get; set; }

    /// <summary>
    /// Gets or sets clinical notes entered by the doctor.
    /// </summary>
    public string? ClinicalNotes { get; set; }

    /// <summary>
    /// Gets or sets the list of diagnoses (Step 1).
    /// </summary>
    public List<SaveDiagnosisItemRequest> Diagnoses { get; set; } = [];

    /// <summary>
    /// Gets or sets the list of prescribed medications (Step 2).
    /// </summary>
    public List<SaveMedicationItemRequest> Medications { get; set; } = [];

    /// <summary>
    /// Gets or sets the list of diagnostic test requests (Step 3).
    /// </summary>
    public List<SaveTestItemRequest> TestRequests { get; set; } = [];
}

/// <summary>
/// Diagnosis line item in a save draft request.
/// </summary>
public sealed class SaveDiagnosisItemRequest
{
    /// <summary>
    /// Gets or sets the optional line ID (null for new items).
    /// </summary>
    public Guid? Id { get; set; }

    /// <summary>
    /// Gets or sets the optional catalog foreign key.
    /// </summary>
    public Guid? DiagnosisCatalogId { get; set; }

    /// <summary>
    /// Gets or sets the standardized ICD-10 code.
    /// </summary>
    public string ICD10Code { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the diagnosis clinical name.
    /// </summary>
    public string DiagnosisName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the diagnosis classification (Primary, Secondary, Pending).
    /// </summary>
    public DiagnosisType Type { get; set; }

    /// <summary>
    /// Gets or sets optional clinical notes for this diagnosis.
    /// </summary>
    public string? Notes { get; set; }
}

/// <summary>
/// Medication line item in a save draft request.
/// </summary>
public sealed class SaveMedicationItemRequest
{
    /// <summary>
    /// Gets or sets the optional line ID (null for new items).
    /// </summary>
    public Guid? Id { get; set; }

    /// <summary>
    /// Gets or sets the optional global catalog identifier.
    /// </summary>
    public Guid? MedicationCatalogId { get; set; }

    /// <summary>
    /// Gets or sets the optional custom medication request identifier.
    /// </summary>
    public Guid? CustomMedicationId { get; set; }

    /// <summary>
    /// Gets or sets the medication name.
    /// </summary>
    public string MedicationName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the dosage amount (decimal).
    /// </summary>
    public decimal DosageAmount { get; set; }

    /// <summary>
    /// Gets or sets the dosage unit.
    /// </summary>
    public DosageUnit DosageUnit { get; set; }

    /// <summary>
    /// Gets or sets the frequency.
    /// </summary>
    public Frequency Frequency { get; set; }

    /// <summary>
    /// Gets or sets the route.
    /// </summary>
    public Route Route { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether the medication is ongoing indefinitely.
    /// </summary>
    public bool IsOngoing { get; set; }

    /// <summary>
    /// Gets or sets the duration count (e.g. 5).
    /// </summary>
    public int? DurationValue { get; set; }

    /// <summary>
    /// Gets or sets the duration unit (Days, Weeks, Months).
    /// </summary>
    public DurationUnit? DurationUnit { get; set; }

    /// <summary>
    /// Gets or sets instructions (mandatory if Frequency is AsNeeded).
    /// </summary>
    public string? Instructions { get; set; }

    /// <summary>
    /// Gets or sets optional internal medication note.
    /// </summary>
    public string? MedicationNote { get; set; }

    /// <summary>
    /// Gets or sets whether the doctor explicitly acknowledged the allergy risk for custom drugs.
    /// </summary>
    public bool DoctorAcknowledgedRisk { get; set; }

    /// <summary>
    /// Gets or sets whether this draft item is currently incomplete.
    /// </summary>
    public bool IsIncomplete { get; set; }
}

/// <summary>
/// Test request line item in a save draft request.
/// </summary>
public sealed class SaveTestItemRequest
{
    /// <summary>
    /// Gets or sets the optional line ID (null for new items).
    /// </summary>
    public Guid? Id { get; set; }

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
    /// Gets or sets the priority level (Routine, Urgent, Stat).
    /// </summary>
    public TestPriority Priority { get; set; }

    /// <summary>
    /// Gets or sets instructions.
    /// </summary>
    public string? Instructions { get; set; }

    /// <summary>
    /// Gets or sets clinical indication.
    /// </summary>
    public string? ClinicalIndication { get; set; }

    /// <summary>
    /// Gets or sets whether this draft item is incomplete.
    /// </summary>
    public bool IsIncomplete { get; set; }
}
