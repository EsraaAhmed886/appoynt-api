/**
 * File Name      : MedicalRecordService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : IMedicalRecordService, ApplicationDbContext, ICurrentUserService, IDateTimeProvider,
 *                  MedicalRecord, MedicalRecordDiagnosis, MedicalRecordMedication, MedicalRecordTestRequest,
 *                  MedicalRecordChangeLog, PatientAllergy, Appointment, Patient, Doctor
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Implements the full electronic medical record consultation lifecycle:
 *                  patient summary, authorized history, draft workflow, validations, finalization, and amendments.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.MedicalRecords;
using Appoynt.Application.Features.MedicalRecords.Contracts;
using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace Appoynt.Infrastructure.Services;

/// <summary>
/// Implements medical record query and consultation mutation operations.
/// </summary>
public sealed class MedicalRecordService : IMedicalRecordService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly ICurrentUserService _currentUserService;
    private readonly IDateTimeProvider _dateTimeProvider;

    /// <summary>
    /// Initializes a new instance of the <see cref="MedicalRecordService"/> class.
    /// </summary>
    /// <param name="dbContext">The database context.</param>
    /// <param name="currentUserService">The current authenticated user accessor.</param>
    /// <param name="dateTimeProvider">The deterministic clock provider.</param>
    public MedicalRecordService(
        ApplicationDbContext dbContext,
        ICurrentUserService currentUserService,
        IDateTimeProvider dateTimeProvider)
    {
        _dbContext = dbContext;
        _currentUserService = currentUserService;
        _dateTimeProvider = dateTimeProvider;
    }

    #region Read Operations

    /// <inheritdoc />
    public async Task<PatientSummaryDto?> GetPatientSummaryAsync(Guid appointmentId, CancellationToken cancellationToken = default)
    {
        Doctor? doctor = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctor == null)
        {
            return null;
        }
        else
        {
        }

        // Verify appointment exists and is assigned to the authenticated doctor
        var appointment = await _dbContext.Appointments
            .AsNoTracking()
            .Include(a => a.Clinic)
            .Include(a => a.AppointmentSlot)
            .Include(a => a.Patient)
                .ThenInclude(p => p.User)
            .FirstOrDefaultAsync(a => a.Id == appointmentId && a.Clinic.DoctorId == doctor.Id, cancellationToken);

        if (appointment == null)
        {
            return null;
        }
        else
        {
        }

        Patient patient = appointment.Patient;

        // Calculate age dynamically from BirthDate
        int? age = CalculateAge(patient.BirthDate, _dateTimeProvider.UtcNow);

        // Check if an existing medical record exists for this appointment
        var existingRecord = await _dbContext.MedicalRecords
            .AsNoTracking()
            .FirstOrDefaultAsync(m => m.AppointmentId == appointmentId, cancellationToken);

        string displayState = "NotStarted";
        if (existingRecord != null)
        {
            displayState = existingRecord.Status switch
            {
                MedicalRecordStatus.Draft => "Draft",
                MedicalRecordStatus.Finalized => "Finalized",
                _ => "NotStarted"
            };
        }
        else
        {
        }

        // Retrieve active allergies recorded for this patient
        var allergies = await _dbContext.PatientAllergies
            .AsNoTracking()
            .Where(a => a.PatientId == patient.Id && a.IsActive)
            .OrderBy(a => a.AllergenName)
            .Select(a => new PatientAllergyDto
            {
                Id = a.Id,
                AllergenName = a.AllergenName,
                AllergenType = a.AllergenType,
                Severity = a.Severity,
                Notes = a.Notes,
                IsActive = a.IsActive
            })
            .ToListAsync(cancellationToken);

        // Query authorized recent visits (up to 3 finalized records)
        IQueryable<MedicalRecord> historyQuery = _dbContext.MedicalRecords
            .AsNoTracking()
            .Include(m => m.Clinic)
            .Include(m => m.Doctor)
                .ThenInclude(d => d.User)
            .Include(m => m.Diagnoses)
            .Where(m => m.PatientId == patient.Id && m.Status == MedicalRecordStatus.Finalized && m.AppointmentId != appointmentId);

        // Access control: if patient sharing is disabled, return only caller's records
        if (!patient.IsMedicalHistorySharingEnabled)
        {
            historyQuery = historyQuery.Where(m => m.DoctorId == doctor.Id);
        }
        else
        {
        }

        var recentVisits = await historyQuery
            .OrderByDescending(m => m.VisitDate)
            .Take(3)
            .Select(m => new RecentVisitDto
            {
                MedicalRecordId = m.Id,
                AppointmentId = m.AppointmentId,
                VisitDate = m.VisitDate,
                DoctorName = $"{m.Doctor.NameEn ?? m.Doctor.NameAr ?? (m.Doctor.User.FirstName + " " + m.Doctor.User.LastName)}".Trim(),
                ClinicName = m.Clinic.Name,
                PrimaryDiagnosis = m.Diagnoses.Where(d => d.Type == DiagnosisType.Primary).Select(d => d.DiagnosisName).FirstOrDefault(),
                Status = "Finalized"
            })
            .ToListAsync(cancellationToken);

        string patientName = $"{patient.User.FirstName} {patient.User.LastName}".Trim();

        return new PatientSummaryDto
        {
            PatientId = patient.Id,
            PID = patient.PID,
            PatientName = patientName,
            Gender = patient.User.Gender,
            BirthDate = patient.BirthDate,
            Age = age,
            PhoneNumber = patient.User.PhoneNumber ?? string.Empty,
            IsMedicalHistorySharingEnabled = patient.IsMedicalHistorySharingEnabled,
            AppointmentId = appointment.Id,
            AppointmentDate = appointment.Date,
            AppointmentTime = appointment.AppointmentSlot.StartTime.ToString("HH:mm"),
            AppointmentStatus = appointment.Status,
            BookingType = appointment.Type,
            ClinicName = appointment.Clinic.Name,
            MedicalRecordDisplayState = displayState,
            MedicalRecordId = existingRecord?.Id,
            Allergies = allergies,
            RecentVisits = recentVisits
        };
    }

    /// <inheritdoc />
    public async Task<MedicalHistoryResponseDto?> GetMedicalHistoryAsync(
        Guid patientId,
        DateOnly? fromDate = null,
        DateOnly? toDate = null,
        Guid? doctorId = null,
        CancellationToken cancellationToken = default)
    {
        Doctor? callerDoctor = await ResolveCurrentDoctorAsync(cancellationToken);
        if (callerDoctor == null)
        {
            return null;
        }
        else
        {
        }

        var patient = await _dbContext.Patients
            .AsNoTracking()
            .Include(p => p.User)
            .FirstOrDefaultAsync(p => p.Id == patientId, cancellationToken);

        if (patient == null)
        {
            return null;
        }
        else
        {
        }

        // Active allergies
        var allergies = await _dbContext.PatientAllergies
            .AsNoTracking()
            .Where(a => a.PatientId == patientId && a.IsActive)
            .Select(a => new PatientAllergyDto
            {
                Id = a.Id,
                AllergenName = a.AllergenName,
                AllergenType = a.AllergenType,
                Severity = a.Severity,
                Notes = a.Notes,
                IsActive = a.IsActive
            })
            .ToListAsync(cancellationToken);

        // Query finalized records
        IQueryable<MedicalRecord> query = _dbContext.MedicalRecords
            .AsNoTracking()
            .Include(m => m.Clinic)
            .Include(m => m.Doctor)
                .ThenInclude(d => d.User)
            .Include(m => m.Diagnoses)
            .Include(m => m.Medications)
            .Include(m => m.TestRequests)
            .Include(m => m.ChangeLogs)
            .Where(m => m.PatientId == patientId && m.Status == MedicalRecordStatus.Finalized);

        // Enforce patient sharing preference
        if (!patient.IsMedicalHistorySharingEnabled)
        {
            query = query.Where(m => m.DoctorId == callerDoctor.Id);
        }
        else
        {
        }

        // Apply filters
        if (fromDate.HasValue)
        {
            query = query.Where(m => m.VisitDate >= fromDate.Value);
        }
        else
        {
        }

        if (toDate.HasValue)
        {
            query = query.Where(m => m.VisitDate <= toDate.Value);
        }
        else
        {
        }

        if (doctorId.HasValue)
        {
            query = query.Where(m => m.DoctorId == doctorId.Value);
        }
        else
        {
        }

        var records = await query
            .OrderByDescending(m => m.VisitDate)
            .Select(m => new MedicalHistoryItemDto
            {
                MedicalRecordId = m.Id,
                AppointmentId = m.AppointmentId,
                VisitDate = m.VisitDate,
                ClinicName = m.Clinic.Name,
                DoctorName = $"{m.Doctor.NameEn ?? m.Doctor.NameAr ?? (m.Doctor.User.FirstName + " " + m.Doctor.User.LastName)}".Trim(),
                PrimaryDiagnosis = m.Diagnoses.Where(d => d.Type == DiagnosisType.Primary).Select(d => d.DiagnosisName).FirstOrDefault(),
                PrimaryDiagnosisCode = m.Diagnoses.Where(d => d.Type == DiagnosisType.Primary).Select(d => d.ICD10Code).FirstOrDefault(),
                ClinicalOutcome = m.ClinicalOutcome.HasValue ? m.ClinicalOutcome.Value.ToString() : string.Empty,
                DisplayStatus = m.ChangeLogs.Any() ? "Finalized with Amendments" : "Finalized",
                HasAmendments = m.ChangeLogs.Any(),
                MedicationsCount = m.Medications.Count,
                TestsCount = m.TestRequests.Count,
                IsCreatedByCaller = m.DoctorId == callerDoctor.Id
            })
            .ToListAsync(cancellationToken);

        string patientName = $"{patient.User.FirstName} {patient.User.LastName}".Trim();
        Guid? latestId = records.FirstOrDefault()?.MedicalRecordId;

        return new MedicalHistoryResponseDto
        {
            PatientId = patient.Id,
            PatientName = patientName,
            PID = patient.PID,
            TotalAuthorizedRecordsCount = records.Count,
            IsSharingEnabled = patient.IsMedicalHistorySharingEnabled,
            LatestMedicalRecordId = latestId,
            Allergies = allergies,
            Records = records
        };
    }

    /// <inheritdoc />
    public async Task<MedicalRecordDetailDto?> GetByIdAsync(Guid recordId, CancellationToken cancellationToken = default)
    {
        Doctor? callerDoctor = await ResolveCurrentDoctorAsync(cancellationToken);
        if (callerDoctor == null)
        {
            return null;
        }
        else
        {
        }

        var record = await _dbContext.MedicalRecords
            .AsNoTracking()
            .Include(m => m.Appointment)
            .Include(m => m.Clinic)
            .Include(m => m.Doctor)
                .ThenInclude(d => d.User)
            .Include(m => m.Patient)
                .ThenInclude(p => p.User)
            .Include(m => m.SignedBy)
            .Include(m => m.Diagnoses)
            .Include(m => m.Medications)
            .Include(m => m.TestRequests)
            .Include(m => m.Attachments)
            .Include(m => m.ChangeLogs)
                .ThenInclude(c => c.ChangedBy)
            .FirstOrDefaultAsync(m => m.Id == recordId, cancellationToken);

        if (record == null)
        {
            return null;
        }
        else
        {
        }

        // IDOR Access Control:
        // 1. Author doctor can always view their own draft or finalized records.
        // 2. Foreign doctor can only view if status is Finalized AND patient has full sharing enabled.
        bool isAuthor = record.DoctorId == callerDoctor.Id;
        if (!isAuthor)
        {
            if (record.Status != MedicalRecordStatus.Finalized || !record.Patient.IsMedicalHistorySharingEnabled)
            {
                return null;
            }
            else
            {
            }
        }
        else
        {
        }

        return MapToDetailDto(record, isAuthor);
    }

    #endregion

    #region Mutation Operations

    /// <inheritdoc />
    public async Task<MedicalRecordOperationResult> StartConsultationAsync(Guid appointmentId, CancellationToken cancellationToken = default)
    {
        Doctor? doctor = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctor == null)
        {
            return MedicalRecordOperationResult.Failure(MedicalRecordErrorCodes.UnauthorizedDoctor);
        }
        else
        {
        }

        var appointment = await _dbContext.Appointments
            .Include(a => a.Clinic)
            .Include(a => a.Patient)
                .ThenInclude(p => p.User)
            .FirstOrDefaultAsync(a => a.Id == appointmentId && a.Clinic.DoctorId == doctor.Id, cancellationToken);

        if (appointment == null)
        {
            return MedicalRecordOperationResult.Failure(MedicalRecordErrorCodes.AppointmentNotFound);
        }
        else
        {
        }

        // Check appointment eligibility
        if (appointment.Status != AppointmentStatus.Upcoming && appointment.Status != AppointmentStatus.InConsultation)
        {
            return MedicalRecordOperationResult.Failure(MedicalRecordErrorCodes.AppointmentNotEligible);
        }
        else
        {
        }

        // Ensure no record already exists for this appointment
        bool alreadyExists = await _dbContext.MedicalRecords
            .AnyAsync(m => m.AppointmentId == appointmentId && m.Status != MedicalRecordStatus.Discarded, cancellationToken);

        if (alreadyExists)
        {
            return MedicalRecordOperationResult.Failure(MedicalRecordErrorCodes.RecordAlreadyExists);
        }
        else
        {
        }

        DateTime utcNow = _dateTimeProvider.UtcNow;

        // Transition appointment to InConsultation if it was upcoming
        if (appointment.Status == AppointmentStatus.Upcoming)
        {
            appointment.Status = AppointmentStatus.InConsultation;
            appointment.ActualStartTimeUtc = utcNow;
        }
        else
        {
        }

        // Create new draft medical record
        var newRecord = new MedicalRecord
        {
            Id = Guid.NewGuid(),
            AppointmentId = appointment.Id,
            PatientId = appointment.PatientId,
            DoctorId = doctor.Id,
            ClinicId = appointment.ClinicId,
            Status = MedicalRecordStatus.Draft,
            VisitDate = appointment.Date,
            Appointment = appointment,
            Patient = appointment.Patient,
            Doctor = doctor,
            Clinic = appointment.Clinic
        };

        _dbContext.MedicalRecords.Add(newRecord);
        await _dbContext.SaveChangesAsync(cancellationToken);

        var detail = await GetByIdAsync(newRecord.Id, cancellationToken);
        return MedicalRecordOperationResult.Success(detail!);
    }

    /// <inheritdoc />
    public async Task<MedicalRecordOperationResult> SaveDraftAsync(Guid recordId, SaveDraftRequest request, CancellationToken cancellationToken = default)
    {
        Doctor? doctor = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctor == null)
        {
            return MedicalRecordOperationResult.Failure(MedicalRecordErrorCodes.UnauthorizedDoctor);
        }
        else
        {
        }

        var record = await _dbContext.MedicalRecords
            .Include(m => m.Diagnoses)
            .Include(m => m.Medications)
            .Include(m => m.TestRequests)
            .FirstOrDefaultAsync(m => m.Id == recordId && m.DoctorId == doctor.Id, cancellationToken);

        if (record == null)
        {
            return MedicalRecordOperationResult.Failure(MedicalRecordErrorCodes.NotFound);
        }
        else
        {
        }

        if (record.Status == MedicalRecordStatus.Finalized)
        {
            return MedicalRecordOperationResult.Failure(MedicalRecordErrorCodes.CannotModifyFinalized);
        }
        else
        {
        }

        // Apply draft updates
        await ApplyDraftContentAsync(record, request, cancellationToken);

        await _dbContext.SaveChangesAsync(cancellationToken);

        var detail = await GetByIdAsync(record.Id, cancellationToken);
        return MedicalRecordOperationResult.Success(detail!);
    }

    /// <inheritdoc />
    public async Task<MedicalRecordOperationResult> FinalizeAsync(Guid recordId, FinalizeMedicalRecordRequest request, CancellationToken cancellationToken = default)
    {
        Doctor? doctor = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctor == null)
        {
            return MedicalRecordOperationResult.Failure(MedicalRecordErrorCodes.UnauthorizedDoctor);
        }
        else
        {
        }

        var record = await _dbContext.MedicalRecords
            .Include(m => m.Appointment)
            .Include(m => m.Diagnoses)
            .Include(m => m.Medications)
            .Include(m => m.TestRequests)
            .FirstOrDefaultAsync(m => m.Id == recordId && m.DoctorId == doctor.Id, cancellationToken);

        if (record == null)
        {
            return MedicalRecordOperationResult.Failure(MedicalRecordErrorCodes.NotFound);
        }
        else
        {
        }

        if (record.Status == MedicalRecordStatus.Finalized)
        {
            return MedicalRecordOperationResult.Failure(MedicalRecordErrorCodes.CannotModifyFinalized);
        }
        else
        {
        }

        // If updated draft payload is passed in finalization request, apply it first
        if (request.DraftData != null)
        {
            await ApplyDraftContentAsync(record, request.DraftData, cancellationToken);
        }
        else
        {
        }

        // Run comprehensive clinical validation rules
        var validationErrors = ValidateRecordForFinalization(record);
        if (validationErrors.Count > 0)
        {
            return MedicalRecordOperationResult.Failure(validationErrors);
        }
        else
        {
        }

        DateTime utcNow = _dateTimeProvider.UtcNow;

        // Transition record to Finalized
        record.Status = MedicalRecordStatus.Finalized;
        record.FinalizedAtUtc = utcNow;
        record.SignedById = _currentUserService.UserId;

        // If the appointment is currently InConsultation, mark it Completed
        if (record.Appointment.Status == AppointmentStatus.InConsultation)
        {
            record.Appointment.Status = AppointmentStatus.Completed;
            record.Appointment.ActualEndTimeUtc = utcNow;
        }
        else
        {
        }

        await _dbContext.SaveChangesAsync(cancellationToken);

        var detail = await GetByIdAsync(record.Id, cancellationToken);
        return MedicalRecordOperationResult.Success(detail!);
    }

    /// <inheritdoc />
    public async Task<MedicalRecordOperationResult> EditFinalizedAsync(Guid recordId, EditFinalizedRecordRequest request, CancellationToken cancellationToken = default)
    {
        Doctor? doctor = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctor == null)
        {
            return MedicalRecordOperationResult.Failure(MedicalRecordErrorCodes.UnauthorizedDoctor);
        }
        else
        {
        }

        var record = await _dbContext.MedicalRecords
            .Include(m => m.Diagnoses)
            .Include(m => m.Medications)
            .Include(m => m.TestRequests)
            .Include(m => m.ChangeLogs)
            .FirstOrDefaultAsync(m => m.Id == recordId && m.DoctorId == doctor.Id, cancellationToken);

        if (record == null)
        {
            return MedicalRecordOperationResult.Failure(MedicalRecordErrorCodes.NotFound);
        }
        else
        {
        }

        if (record.Status != MedicalRecordStatus.Finalized)
        {
            return MedicalRecordOperationResult.Failure(MedicalRecordErrorCodes.NotFound);
        }
        else
        {
        }

        // Validate amendment reason
        string trimmedReason = (request.Reason ?? string.Empty).Trim();
        if (trimmedReason.Length < 10)
        {
            return MedicalRecordOperationResult.Failure(MedicalRecordErrorCodes.AmendmentReasonTooShort, nameof(request.Reason));
        }
        else if (trimmedReason.Length > 1000)
        {
            return MedicalRecordOperationResult.Failure(MedicalRecordErrorCodes.AmendmentReasonTooLong, nameof(request.Reason));
        }
        else
        {
        }

        DateTime utcNow = _dateTimeProvider.UtcNow;
        Guid currentUserId = _currentUserService.UserId ?? Guid.Empty;

        // Track previous snapshots for change logging
        string oldClinicalNotes = record.ClinicalNotes ?? string.Empty;
        string oldOutcome = record.ClinicalOutcome?.ToString() ?? string.Empty;
        var oldDiagnosesJson = JsonSerializer.Serialize(record.Diagnoses.Select(d => new { d.ICD10Code, d.DiagnosisName, d.Type }));
        var oldMedicationsJson = JsonSerializer.Serialize(record.Medications.Select(m => new { m.MedicationName, m.DosageAmount, m.DosageUnit, m.Frequency, m.Route, m.DurationValue, m.DurationUnit, m.Instructions }));
        var oldTestsJson = JsonSerializer.Serialize(record.TestRequests.Select(t => new { t.TestName, t.Category, t.Priority, t.Instructions }));

        // Apply new content
        await ApplyDraftContentAsync(record, request.UpdatedRecord, cancellationToken);

        // Validate new content passes finalization rules
        var validationErrors = ValidateRecordForFinalization(record);
        if (validationErrors.Count > 0)
        {
            return MedicalRecordOperationResult.Failure(validationErrors);
        }
        else
        {
        }

        bool hasAnyChanges = false;

        // Check Clinical Outcome changes
        string newOutcome = record.ClinicalOutcome?.ToString() ?? string.Empty;
        if (oldOutcome != newOutcome)
        {
            hasAnyChanges = true;
            _dbContext.MedicalRecordChangeLogs.Add(new MedicalRecordChangeLog
            {
                Id = Guid.NewGuid(),
                MedicalRecordId = record.Id,
                Field = "ClinicalOutcome",
                OldValue = oldOutcome,
                NewValue = newOutcome,
                Reason = trimmedReason,
                ChangedById = currentUserId,
                ChangedAtUtc = utcNow,
                MedicalRecord = record,
                ChangedBy = null!
            });
        }
        else
        {
        }

        // Check Clinical Notes changes
        string newClinicalNotes = record.ClinicalNotes ?? string.Empty;
        if (oldClinicalNotes != newClinicalNotes)
        {
            hasAnyChanges = true;
            _dbContext.MedicalRecordChangeLogs.Add(new MedicalRecordChangeLog
            {
                Id = Guid.NewGuid(),
                MedicalRecordId = record.Id,
                Field = "ClinicalNotes",
                OldValue = oldClinicalNotes,
                NewValue = newClinicalNotes,
                Reason = trimmedReason,
                ChangedById = currentUserId,
                ChangedAtUtc = utcNow,
                MedicalRecord = record,
                ChangedBy = null!
            });
        }
        else
        {
        }

        // Check Diagnoses changes
        var newDiagnosesJson = JsonSerializer.Serialize(record.Diagnoses.Select(d => new { d.ICD10Code, d.DiagnosisName, d.Type }));
        if (oldDiagnosesJson != newDiagnosesJson)
        {
            hasAnyChanges = true;
            _dbContext.MedicalRecordChangeLogs.Add(new MedicalRecordChangeLog
            {
                Id = Guid.NewGuid(),
                MedicalRecordId = record.Id,
                Field = "Diagnoses",
                OldValue = oldDiagnosesJson,
                NewValue = newDiagnosesJson,
                Reason = trimmedReason,
                ChangedById = currentUserId,
                ChangedAtUtc = utcNow,
                MedicalRecord = record,
                ChangedBy = null!
            });
        }
        else
        {
        }

        // Check Medications changes
        var newMedicationsJson = JsonSerializer.Serialize(record.Medications.Select(m => new { m.MedicationName, m.DosageAmount, m.DosageUnit, m.Frequency, m.Route, m.DurationValue, m.DurationUnit, m.Instructions }));
        if (oldMedicationsJson != newMedicationsJson)
        {
            hasAnyChanges = true;
            _dbContext.MedicalRecordChangeLogs.Add(new MedicalRecordChangeLog
            {
                Id = Guid.NewGuid(),
                MedicalRecordId = record.Id,
                Field = "Medications",
                OldValue = oldMedicationsJson,
                NewValue = newMedicationsJson,
                Reason = trimmedReason,
                ChangedById = currentUserId,
                ChangedAtUtc = utcNow,
                MedicalRecord = record,
                ChangedBy = null!
            });
        }
        else
        {
        }

        // Check TestRequests changes
        var newTestsJson = JsonSerializer.Serialize(record.TestRequests.Select(t => new { t.TestName, t.Category, t.Priority, t.Instructions }));
        if (oldTestsJson != newTestsJson)
        {
            hasAnyChanges = true;
            _dbContext.MedicalRecordChangeLogs.Add(new MedicalRecordChangeLog
            {
                Id = Guid.NewGuid(),
                MedicalRecordId = record.Id,
                Field = "TestRequests",
                OldValue = oldTestsJson,
                NewValue = newTestsJson,
                Reason = trimmedReason,
                ChangedById = currentUserId,
                ChangedAtUtc = utcNow,
                MedicalRecord = record,
                ChangedBy = null!
            });
        }
        else
        {
        }

        if (!hasAnyChanges)
        {
            return MedicalRecordOperationResult.Failure(MedicalRecordErrorCodes.NoEffectiveChanges);
        }
        else
        {
        }

        await _dbContext.SaveChangesAsync(cancellationToken);

        var detail = await GetByIdAsync(record.Id, cancellationToken);
        return MedicalRecordOperationResult.Success(detail!);
    }

    /// <inheritdoc />
    public async Task<MedicalRecordOperationResult> DiscardDraftAsync(Guid recordId, CancellationToken cancellationToken = default)
    {
        Doctor? doctor = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctor == null)
        {
            return MedicalRecordOperationResult.Failure(MedicalRecordErrorCodes.UnauthorizedDoctor);
        }
        else
        {
        }

        var record = await _dbContext.MedicalRecords
            .FirstOrDefaultAsync(m => m.Id == recordId && m.DoctorId == doctor.Id, cancellationToken);

        if (record == null)
        {
            return MedicalRecordOperationResult.Failure(MedicalRecordErrorCodes.NotFound);
        }
        else
        {
        }

        if (record.Status != MedicalRecordStatus.Draft)
        {
            return MedicalRecordOperationResult.Failure(MedicalRecordErrorCodes.CannotModifyFinalized);
        }
        else
        {
        }

        record.Status = MedicalRecordStatus.Discarded;
        await _dbContext.SaveChangesAsync(cancellationToken);

        return MedicalRecordOperationResult.Success(null!);
    }

    #endregion

    #region Helper Methods

    private async Task ApplyDraftContentAsync(MedicalRecord record, SaveDraftRequest request, CancellationToken cancellationToken)
    {
        record.ClinicalOutcome = request.ClinicalOutcome;
        record.ClinicalNotes = request.ClinicalNotes?.Trim();

        // 1. Sync Diagnoses
        _dbContext.MedicalRecordDiagnoses.RemoveRange(record.Diagnoses);
        record.Diagnoses.Clear();

        foreach (var diag in request.Diagnoses)
        {
            record.Diagnoses.Add(new MedicalRecordDiagnosis
            {
                Id = diag.Id ?? Guid.NewGuid(),
                MedicalRecordId = record.Id,
                DiagnosisCatalogId = diag.DiagnosisCatalogId,
                ICD10Code = diag.ICD10Code.Trim(),
                DiagnosisName = diag.DiagnosisName.Trim(),
                Type = diag.Type,
                Notes = diag.Notes?.Trim(),
                MedicalRecord = record
            });
        }

        // 2. Sync Medications
        _dbContext.MedicalRecordMedications.RemoveRange(record.Medications);
        record.Medications.Clear();

        foreach (var med in request.Medications)
        {
            Guid? catalogId = med.MedicationCatalogId;
            Guid? customMedId = med.CustomMedicationId;

            // Write-time race condition resolution: If custom medication is passed, check if it was approved in the meantime
            if (customMedId.HasValue && !catalogId.HasValue)
            {
                var customReq = await _dbContext.CustomMedicationRequests
                    .AsNoTracking()
                    .FirstOrDefaultAsync(c => c.Id == customMedId.Value, cancellationToken);

                if (customReq?.LinkedMedicationCatalogId != null)
                {
                    catalogId = customReq.LinkedMedicationCatalogId;
                }
                else
                {
                }
            }
            else
            {
            }

            record.Medications.Add(new MedicalRecordMedication
            {
                Id = med.Id ?? Guid.NewGuid(),
                MedicalRecordId = record.Id,
                MedicationCatalogId = catalogId,
                CustomMedicationId = customMedId,
                MedicationName = med.MedicationName.Trim(),
                DosageAmount = med.DosageAmount,
                DosageUnit = med.DosageUnit,
                Frequency = med.Frequency,
                Route = med.Route,
                IsOngoing = med.IsOngoing,
                DurationValue = med.IsOngoing ? null : med.DurationValue,
                DurationUnit = med.IsOngoing ? null : med.DurationUnit,
                Instructions = med.Instructions?.Trim(),
                MedicationNote = med.MedicationNote?.Trim(),
                DoctorAcknowledgedRisk = med.DoctorAcknowledgedRisk,
                IsIncomplete = med.IsIncomplete,
                MedicalRecord = record
            });
        }

        // 3. Sync TestRequests
        _dbContext.MedicalRecordTestRequests.RemoveRange(record.TestRequests);
        record.TestRequests.Clear();

        DateTime utcNow = _dateTimeProvider.UtcNow;
        foreach (var test in request.TestRequests)
        {
            record.TestRequests.Add(new MedicalRecordTestRequest
            {
                Id = test.Id ?? Guid.NewGuid(),
                MedicalRecordId = record.Id,
                TestCatalogId = test.TestCatalogId,
                TestName = test.TestName.Trim(),
                Category = test.Category,
                Priority = test.Priority,
                Instructions = test.Instructions?.Trim(),
                ClinicalIndication = test.ClinicalIndication?.Trim(),
                Status = TestRequestStatus.Requested,
                RequestDateUtc = utcNow,
                IsIncomplete = test.IsIncomplete,
                MedicalRecord = record,
                TestCatalog = null!
            });
        }
    }

    private static List<AuthenticationError> ValidateRecordForFinalization(MedicalRecord record)
    {
        var errors = new List<AuthenticationError>();

        // Check incomplete items
        if (record.Medications.Any(m => m.IsIncomplete) || record.TestRequests.Any(t => t.IsIncomplete))
        {
            errors.Add(new AuthenticationError(MedicalRecordErrorCodes.IncompleteItemsExist));
        }
        else
        {
        }

        // Clinical outcome validation
        if (!record.ClinicalOutcome.HasValue)
        {
            errors.Add(new AuthenticationError("medical_record.clinical_outcome_required", nameof(record.ClinicalOutcome)));
            return errors;
        }
        else
        {
        }

        switch (record.ClinicalOutcome.Value)
        {
            case ClinicalOutcome.ConfirmedDiagnosis:
                // Must have exactly 1 Primary Diagnosis
                int primaryCount = record.Diagnoses.Count(d => d.Type == DiagnosisType.Primary);
                if (primaryCount != 1)
                {
                    errors.Add(new AuthenticationError(MedicalRecordErrorCodes.PrimaryDiagnosisRequired, "Diagnoses"));
                }
                else
                {
                }

                // Max 10 secondary diagnoses
                int secondaryCount = record.Diagnoses.Count(d => d.Type == DiagnosisType.Secondary);
                if (secondaryCount > 10)
                {
                    errors.Add(new AuthenticationError(MedicalRecordErrorCodes.MaxSecondaryDiagnosesExceeded, "Diagnoses"));
                }
                else
                {
                }

                // Duplicate diagnoses check
                var duplicateCodes = record.Diagnoses
                    .GroupBy(d => d.ICD10Code, StringComparer.OrdinalIgnoreCase)
                    .Where(g => g.Count() > 1)
                    .Select(g => g.Key)
                    .ToList();

                if (duplicateCodes.Count > 0)
                {
                    errors.Add(new AuthenticationError(MedicalRecordErrorCodes.DuplicateDiagnosis, "Diagnoses"));
                }
                else
                {
                }

                break;

            case ClinicalOutcome.NoIllnessDetected:
                // Clinical notes required (min 10 non-whitespace characters)
                string notes = (record.ClinicalNotes ?? string.Empty).Trim();
                if (notes.Length < 10)
                {
                    errors.Add(new AuthenticationError(MedicalRecordErrorCodes.ClinicalNotesTooShort, nameof(record.ClinicalNotes)));
                }
                else if (notes.Length > 5000)
                {
                    errors.Add(new AuthenticationError(MedicalRecordErrorCodes.ClinicalNotesTooLong, nameof(record.ClinicalNotes)));
                }
                else
                {
                }
                break;

            case ClinicalOutcome.DiagnosisPending:
                // Must have either clinical notes (>= 10 chars) OR at least one test request
                string pendingNotes = (record.ClinicalNotes ?? string.Empty).Trim();
                bool hasValidNotes = pendingNotes.Length >= 10;
                bool hasTest = record.TestRequests.Count > 0;

                if (!hasValidNotes && !hasTest)
                {
                    errors.Add(new AuthenticationError(MedicalRecordErrorCodes.ClinicalNotesRequired, nameof(record.ClinicalNotes)));
                }
                else
                {
                }
                break;
        }

        // Validate medications
        foreach (var med in record.Medications)
        {
            if (string.IsNullOrWhiteSpace(med.MedicationName))
            {
                errors.Add(new AuthenticationError("medical_record.medication_name_required", nameof(med.MedicationName)));
            }
            else
            {
            }

            if (med.DosageAmount <= 0)
            {
                errors.Add(new AuthenticationError("medical_record.invalid_dosage_amount", nameof(med.DosageAmount)));
            }
            else
            {
            }

            if (med.Frequency == Frequency.AsNeeded && string.IsNullOrWhiteSpace(med.Instructions))
            {
                errors.Add(new AuthenticationError(MedicalRecordErrorCodes.AsNeededInstructionsRequired, nameof(med.Instructions)));
            }
            else
            {
            }

            if (!med.MedicationCatalogId.HasValue && !med.CustomMedicationId.HasValue)
            {
                errors.Add(new AuthenticationError(MedicalRecordErrorCodes.InvalidMedicationSource, "Medications"));
            }
            else
            {
            }

            // Custom unlisted medication must have risk acknowledged
            if (!med.MedicationCatalogId.HasValue && med.CustomMedicationId.HasValue && !med.DoctorAcknowledgedRisk)
            {
                errors.Add(new AuthenticationError(MedicalRecordErrorCodes.MedicationRiskUnacknowledged, nameof(med.DoctorAcknowledgedRisk)));
            }
            else
            {
            }
        }

        return errors;
    }

    private static MedicalRecordDetailDto MapToDetailDto(MedicalRecord record, bool isAuthor)
    {
        string patientName = $"{record.Patient.User.FirstName} {record.Patient.User.LastName}".Trim();
        string doctorName = $"{record.Doctor.NameEn ?? record.Doctor.NameAr ?? (record.Doctor.User.FirstName + " " + record.Doctor.User.LastName)}".Trim();
        string displayStatus = record.Status == MedicalRecordStatus.Finalized && record.ChangeLogs.Count > 0
            ? "Finalized with Amendments"
            : record.Status.ToString();

        return new MedicalRecordDetailDto
        {
            Id = record.Id,
            AppointmentId = record.AppointmentId,
            PatientId = record.PatientId,
            PatientName = patientName,
            PID = record.Patient.PID,
            DoctorId = record.DoctorId,
            DoctorName = doctorName,
            ClinicId = record.ClinicId,
            ClinicName = record.Clinic.Name,
            Status = record.Status,
            DisplayStatus = displayStatus,
            VisitDate = record.VisitDate,
            CreatedAtUtc = record.CreatedAt,
            UpdatedAtUtc = record.UpdatedAt,
            FinalizedAtUtc = record.FinalizedAtUtc,
            SignedByName = record.SignedBy != null ? $"{record.SignedBy.FirstName} {record.SignedBy.LastName}".Trim() : null,
            Version = record.Version != null && record.Version.Length > 0 ? Convert.ToBase64String(record.Version) : string.Empty,
            IsEditableByCaller = isAuthor,
            ClinicalOutcome = record.ClinicalOutcome,
            ClinicalNotes = record.ClinicalNotes,
            Diagnoses = record.Diagnoses.Select(d => new MedicalRecordDiagnosisDto
            {
                Id = d.Id,
                DiagnosisCatalogId = d.DiagnosisCatalogId,
                ICD10Code = d.ICD10Code,
                DiagnosisName = d.DiagnosisName,
                Type = d.Type,
                Notes = d.Notes
            }).ToList(),
            Medications = record.Medications.Select(m => new MedicalRecordMedicationDto
            {
                Id = m.Id,
                MedicationCatalogId = m.MedicationCatalogId,
                CustomMedicationId = m.CustomMedicationId,
                MedicationName = m.MedicationName,
                DosageAmount = m.DosageAmount,
                DosageUnit = m.DosageUnit,
                Frequency = m.Frequency,
                Route = m.Route,
                IsOngoing = m.IsOngoing,
                DurationValue = m.DurationValue,
                DurationUnit = m.DurationUnit,
                Instructions = m.Instructions,
                MedicationNote = m.MedicationNote,
                DoctorAcknowledgedRisk = m.DoctorAcknowledgedRisk,
                IsIncomplete = m.IsIncomplete
            }).ToList(),
            TestRequests = record.TestRequests.Select(t => new MedicalRecordTestRequestDto
            {
                Id = t.Id,
                TestCatalogId = t.TestCatalogId,
                TestName = t.TestName,
                Category = t.Category,
                Priority = t.Priority,
                Instructions = t.Instructions,
                ClinicalIndication = t.ClinicalIndication,
                Status = t.Status,
                RequestDateUtc = t.RequestDateUtc,
                IsIncomplete = t.IsIncomplete
            }).ToList(),
            Attachments = record.Attachments.Select(a => new MedicalRecordAttachmentDto
            {
                Id = a.Id,
                FileName = a.FileName,
                FileUrl = a.FileUrl,
                ContentType = a.ContentType,
                FileSizeBytes = a.FileSizeBytes,
                Description = a.Description,
                UploadedAtUtc = a.UploadedAtUtc
            }).ToList(),
            ChangeLogs = record.ChangeLogs.OrderBy(c => c.ChangedAtUtc).Select(c => new MedicalRecordChangeLogDto
            {
                Id = c.Id,
                Field = c.Field,
                OldValue = c.OldValue,
                NewValue = c.NewValue,
                Reason = c.Reason,
                ChangedByName = c.ChangedBy != null ? $"{c.ChangedBy.FirstName} {c.ChangedBy.LastName}".Trim() : "Doctor",
                ChangedAtUtc = c.ChangedAtUtc
            }).ToList()
        };
    }

    private static int? CalculateAge(DateOnly? birthDate, DateTime utcNow)
    {
        if (!birthDate.HasValue)
        {
            return null;
        }
        else
        {
        }

        var today = DateOnly.FromDateTime(utcNow);
        int age = today.Year - birthDate.Value.Year;
        if (birthDate.Value > today.AddYears(-age))
        {
            age--;
        }
        else
        {
        }

        return age >= 0 ? age : null;
    }

    private async Task<Doctor?> ResolveCurrentDoctorAsync(CancellationToken cancellationToken)
    {
        Guid? userId = _currentUserService.UserId;
        if (!userId.HasValue)
        {
            return null;
        }
        else
        {
        }

        return await _dbContext.Doctors
            .AsNoTracking()
            .FirstOrDefaultAsync(d => d.UserId == userId.Value, cancellationToken);
    }

    #endregion
}
