/**
 * File Name      : ReferenceDataService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : IReferenceDataService, ApplicationDbContext, ICurrentUserService
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Implements clinical catalog search queries for ICD-10 diagnoses, medications, and diagnostic tests.
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

namespace Appoynt.Infrastructure.Services;

/// <summary>
/// Implements clinical catalog search operations.
/// </summary>
public sealed class ReferenceDataService : IReferenceDataService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly ICurrentUserService _currentUserService;

    /// <summary>
    /// Initializes a new instance of the <see cref="ReferenceDataService"/> class.
    /// </summary>
    /// <param name="dbContext">The application database context.</param>
    /// <param name="currentUserService">The current authenticated user accessor.</param>
    public ReferenceDataService(ApplicationDbContext dbContext, ICurrentUserService currentUserService)
    {
        _dbContext = dbContext;
        _currentUserService = currentUserService;
    }

    /// <inheritdoc />
    public async Task<IReadOnlyList<DiagnosisCatalogDto>> SearchDiagnosesAsync(string? searchTerm, int take = 20, CancellationToken cancellationToken = default)
    {
        // Clamp result count between 1 and 50
        int clampedTake = Math.Clamp(take, 1, 50);

        // Prepare query on active diagnoses
        IQueryable<Diagnosis> query = _dbContext.Diagnoses
            .AsNoTracking()
            .Where(d => d.IsActive);

        // Apply search filter if provided
        if (!string.IsNullOrWhiteSpace(searchTerm))
        {
            string trimmed = searchTerm.Trim();
            query = query.Where(d =>
                d.ICD10Code.Contains(trimmed) ||
                d.NameEn.Contains(trimmed) ||
                d.NameAr.Contains(trimmed));
        }
        else
        {
            // Return default initial list
        }

        // Project to DTO
        return await query
            .OrderBy(d => d.ICD10Code)
            .Take(clampedTake)
            .Select(d => new DiagnosisCatalogDto
            {
                Id = d.Id,
                ICD10Code = d.ICD10Code,
                NameAr = d.NameAr,
                NameEn = d.NameEn
            })
            .ToListAsync(cancellationToken);
    }

    /// <inheritdoc />
    public async Task<IReadOnlyList<MedicationCatalogDto>> SearchMedicationsAsync(string? searchTerm, int take = 20, CancellationToken cancellationToken = default)
    {
        // Clamp result count between 1 and 50
        int clampedTake = Math.Clamp(take, 1, 50);
        string trimmed = (searchTerm ?? string.Empty).Trim();

        // Retrieve calling doctor's ID if authenticated
        Guid? doctorId = await ResolveCurrentDoctorIdAsync(cancellationToken);

        // Global medications query
        IQueryable<Medication> globalQuery = _dbContext.Medications
            .AsNoTracking()
            .Where(m => m.IsActive);

        if (!string.IsNullOrWhiteSpace(trimmed))
        {
            globalQuery = globalQuery.Where(m =>
                m.NameEn.Contains(trimmed) ||
                m.NameAr.Contains(trimmed) ||
                m.ActiveIngredient.Contains(trimmed));
        }
        else
        {
        }

        // Fetch global results
        var globalList = await globalQuery
            .OrderBy(m => m.NameEn)
            .Take(clampedTake)
            .Select(m => new MedicationCatalogDto
            {
                Id = m.Id,
                NameAr = m.NameAr,
                NameEn = m.NameEn,
                ActiveIngredient = m.ActiveIngredient,
                Form = m.Form,
                Strength = m.Strength,
                IsCustom = false,
                CustomMedicationId = null
            })
            .ToListAsync(cancellationToken);

        // If a doctor is authenticated, also search their unapproved custom medications
        if (doctorId.HasValue)
        {
            IQueryable<CustomMedicationRequest> customQuery = _dbContext.CustomMedicationRequests
                .AsNoTracking()
                .Where(c => c.DoctorId == doctorId.Value && c.Status == CustomMedicationStatus.PendingAdminApproval);

            if (!string.IsNullOrWhiteSpace(trimmed))
            {
                customQuery = customQuery.Where(c => c.Name.Contains(trimmed));
            }
            else
            {
            }

            var customList = await customQuery
                .OrderByDescending(c => c.CreatedAt)
                .Take(clampedTake)
                .Select(c => new MedicationCatalogDto
                {
                    Id = c.Id,
                    NameAr = c.Name,
                    NameEn = c.Name,
                    ActiveIngredient = "Custom / Unverified",
                    Form = null,
                    Strength = null,
                    IsCustom = true,
                    CustomMedicationId = c.Id
                })
                .ToListAsync(cancellationToken);

            // Merge doctor's custom list on top
            return customList.Concat(globalList).Take(clampedTake).ToList();
        }
        else
        {
            return globalList;
        }
    }

    /// <inheritdoc />
    public async Task<IReadOnlyList<TestCatalogDto>> SearchTestsAsync(TestCategory? category, string? searchTerm, int take = 20, CancellationToken cancellationToken = default)
    {
        // Clamp result count between 1 and 50
        int clampedTake = Math.Clamp(take, 1, 50);

        IQueryable<TestCatalog> query = _dbContext.TestCatalogs
            .AsNoTracking()
            .Where(t => t.IsActive);

        if (category.HasValue)
        {
            query = query.Where(t => t.Category == category.Value);
        }
        else
        {
        }

        if (!string.IsNullOrWhiteSpace(searchTerm))
        {
            string trimmed = searchTerm.Trim();
            query = query.Where(t =>
                t.NameEn.Contains(trimmed) ||
                t.NameAr.Contains(trimmed));
        }
        else
        {
        }

        return await query
            .OrderBy(t => t.NameEn)
            .Take(clampedTake)
            .Select(t => new TestCatalogDto
            {
                Id = t.Id,
                NameAr = t.NameAr,
                NameEn = t.NameEn,
                Category = t.Category,
                Description = t.Description
            })
            .ToListAsync(cancellationToken);
    }

    private async Task<Guid?> ResolveCurrentDoctorIdAsync(CancellationToken cancellationToken)
    {
        Guid? userId = _currentUserService.UserId;
        if (!userId.HasValue)
        {
            return null;
        }
        else
        {
        }

        Doctor? doctor = await _dbContext.Doctors
            .AsNoTracking()
            .FirstOrDefaultAsync(d => d.UserId == userId.Value, cancellationToken);

        return doctor?.Id;
    }
}
