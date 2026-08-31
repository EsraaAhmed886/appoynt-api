/**
 * File Name      : CustomMedicationService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : ICustomMedicationService, ApplicationDbContext, ICurrentUserService, IDateTimeProvider
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Implements doctor custom medication creation and transactional admin catalog merge approvals.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Application.Features.MedicalRecords;
using Appoynt.Application.Features.MedicalRecords.Contracts;
using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;

namespace Appoynt.Infrastructure.Services;

/// <summary>
/// Implements custom unlisted medication requests and administrative catalog merge workflows.
/// </summary>
public sealed class CustomMedicationService : ICustomMedicationService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly ICurrentUserService _currentUserService;
    private readonly IDateTimeProvider _dateTimeProvider;

    /// <summary>
    /// Initializes a new instance of the <see cref="CustomMedicationService"/> class.
    /// </summary>
    /// <param name="dbContext">The application database context.</param>
    /// <param name="currentUserService">The current authenticated user accessor.</param>
    /// <param name="dateTimeProvider">The deterministic clock provider.</param>
    public CustomMedicationService(
        ApplicationDbContext dbContext,
        ICurrentUserService currentUserService,
        IDateTimeProvider dateTimeProvider)
    {
        _dbContext = dbContext;
        _currentUserService = currentUserService;
        _dateTimeProvider = dateTimeProvider;
    }

    /// <inheritdoc />
    public async Task<CustomMedicationResponseDto?> CreateCustomMedicationAsync(CreateCustomMedicationRequestDto request, CancellationToken cancellationToken = default)
    {
        Doctor? doctor = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctor == null)
        {
            return null;
        }
        else
        {
            // Doctor resolved successfully.
        }

        string trimmedName = request.Name.Trim();

        // Create the custom medication entity
        var customMed = new CustomMedicationRequest
        {
            Id = Guid.NewGuid(),
            DoctorId = doctor.Id,
            Name = trimmedName,
            DoctorNotes = request.DoctorNotes?.Trim(),
            Status = CustomMedicationStatus.PendingAdminApproval,
            Doctor = doctor
        };

        _dbContext.CustomMedicationRequests.Add(customMed);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return new CustomMedicationResponseDto
        {
            Id = customMed.Id,
            DoctorId = doctor.Id,
            DoctorName = $"{doctor.NameEn ?? doctor.NameAr}".Trim(),
            Name = customMed.Name,
            Status = customMed.Status,
            DoctorNotes = customMed.DoctorNotes,
            CreatedAtUtc = customMed.CreatedAt
        };
    }

    /// <inheritdoc />
    public async Task<IReadOnlyList<CustomMedicationResponseDto>> GetDoctorCustomMedicationsAsync(CancellationToken cancellationToken = default)
    {
        Doctor? doctor = await ResolveCurrentDoctorAsync(cancellationToken);
        if (doctor == null)
        {
            return [];
        }
        else
        {
        }

        return await _dbContext.CustomMedicationRequests
            .AsNoTracking()
            .Where(c => c.DoctorId == doctor.Id)
            .OrderByDescending(c => c.CreatedAt)
            .Select(c => new CustomMedicationResponseDto
            {
                Id = c.Id,
                DoctorId = c.DoctorId,
                DoctorName = $"{c.Doctor.NameEn ?? c.Doctor.NameAr}".Trim(),
                Name = c.Name,
                Status = c.Status,
                LinkedMedicationCatalogId = c.LinkedMedicationCatalogId,
                DoctorNotes = c.DoctorNotes,
                AdminNotes = c.AdminNotes,
                CreatedAtUtc = c.CreatedAt
            })
            .ToListAsync(cancellationToken);
    }

    /// <inheritdoc />
    public async Task<IReadOnlyList<CustomMedicationResponseDto>> GetPendingAdminRequestsAsync(CancellationToken cancellationToken = default)
    {
        return await _dbContext.CustomMedicationRequests
            .AsNoTracking()
            .Include(c => c.Doctor)
            .Where(c => c.Status == CustomMedicationStatus.PendingAdminApproval)
            .OrderBy(c => c.CreatedAt)
            .Select(c => new CustomMedicationResponseDto
            {
                Id = c.Id,
                DoctorId = c.DoctorId,
                DoctorName = $"{c.Doctor.NameEn ?? c.Doctor.NameAr}".Trim(),
                Name = c.Name,
                Status = c.Status,
                LinkedMedicationCatalogId = null,
                DoctorNotes = c.DoctorNotes,
                AdminNotes = c.AdminNotes,
                CreatedAtUtc = c.CreatedAt
            })
            .ToListAsync(cancellationToken);
    }

    /// <inheritdoc />
    public async Task<bool> ApproveCustomMedicationAsync(Guid requestId, ApproveCustomMedicationRequest request, CancellationToken cancellationToken = default)
    {
        CustomMedicationRequest? customMed = await _dbContext.CustomMedicationRequests
            .FirstOrDefaultAsync(c => c.Id == requestId, cancellationToken);

        if (customMed == null || customMed.Status != CustomMedicationStatus.PendingAdminApproval)
        {
            return false;
        }
        else
        {
        }

        // Execute merge inside an explicit database transaction
        await using IDbContextTransaction transaction = await _dbContext.Database.BeginTransactionAsync(cancellationToken);
        try
        {
            // 1. Create the new global catalog medication
            var globalMedication = new Medication
            {
                Id = Guid.NewGuid(),
                NameAr = request.NameAr.Trim(),
                NameEn = request.NameEn.Trim(),
                ActiveIngredient = request.ActiveIngredient.Trim(),
                Form = request.Form?.Trim(),
                Strength = request.Strength?.Trim(),
                IsActive = true
            };

            _dbContext.Medications.Add(globalMedication);

            // 2. Update custom medication request state
            customMed.Status = CustomMedicationStatus.Approved;
            customMed.LinkedMedicationCatalogId = globalMedication.Id;
            customMed.AdminNotes = request.AdminNotes?.Trim();

            // 3. Backfill all existing MedicalRecordMedication rows referencing this CustomMedicationId
            var existingPrescriptions = await _dbContext.MedicalRecordMedications
                .Where(m => m.CustomMedicationId == customMed.Id)
                .ToListAsync(cancellationToken);

            foreach (var prescription in existingPrescriptions)
            {
                prescription.MedicationCatalogId = globalMedication.Id;
            }

            await _dbContext.SaveChangesAsync(cancellationToken);
            await transaction.CommitAsync(cancellationToken);

            return true;
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    /// <inheritdoc />
    public async Task<bool> RejectCustomMedicationAsync(Guid requestId, string? reason, CancellationToken cancellationToken = default)
    {
        CustomMedicationRequest? customMed = await _dbContext.CustomMedicationRequests
            .FirstOrDefaultAsync(c => c.Id == requestId, cancellationToken);

        if (customMed == null || customMed.Status != CustomMedicationStatus.PendingAdminApproval)
        {
            return false;
        }
        else
        {
        }

        customMed.Status = CustomMedicationStatus.Rejected;
        customMed.AdminNotes = reason?.Trim();

        await _dbContext.SaveChangesAsync(cancellationToken);
        return true;
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
}
