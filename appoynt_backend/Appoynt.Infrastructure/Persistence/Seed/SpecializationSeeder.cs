/**
 * File Name      : SpecializationSeeder.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : ApplicationDbContext, ISpecializationSeeder, Specialization
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Seeds essential medical specializations (e.g. Cardiology, Dermatology, Pediatrics) into the database.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Interfaces.Seeding;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Seed.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace Appoynt.Infrastructure.Persistence.Seed;

/// <summary>
/// Seeds essential medical specializations if they do not already exist in the database.
/// </summary>
public sealed class SpecializationSeeder : SeederBase, ISpecializationSeeder
{
    #region Dependencies

    private readonly ApplicationDbContext _dbContext;
    private readonly ILogger<SpecializationSeeder> _logger;

    #endregion

    #region Default Data

    private static readonly (string NameEn, string NameAr)[] DefaultSpecializations =
    [
        ("Cardiology", "طب وجراحة القلب والأوعية الدموية"),
        ("Dermatology", "الجلدية والتناسلية"),
        ("Dentistry", "طب وجراحة الفم والأسنان"),
        ("Pediatrics", "طب الأطفال وحديثي الولادة"),
        ("Orthopedics", "جراحة العظام والمفاصل"),
        ("Ophthalmology", "طب وجراحة العيون"),
        ("Neurology", "المخ والأعصاب والطب النفسي"),
        ("Internal Medicine", "الأمراض الباطنية والجهاز الهضمي"),
        ("General Surgery", "الجراحة العامة والمناظير"),
        ("Ear, Nose and Throat (ENT)", "الأنف والأذن والحنجرة"),
        ("Obstetrics and Gynecology", "النساء والتوليد وعلاج العقم")
    ];

    #endregion

    #region Constructor

    /// <summary>
    /// Initializes a new instance of the <see cref="SpecializationSeeder"/> class.
    /// </summary>
    /// <param name="dbContext">The application database context.</param>
    /// <param name="logger">The logger instance.</param>
    public SpecializationSeeder(
        ApplicationDbContext dbContext,
        ILogger<SpecializationSeeder> logger)
    {
        // Store the database context dependency.
        _dbContext = dbContext;

        // Store the logger dependency.
        _logger = logger;
    }

    #endregion

    #region Public Methods

    /// <inheritdoc />
    public async Task SeedAsync(CancellationToken cancellationToken = default)
    {
        // Ensure operation has not been cancelled.
        cancellationToken.ThrowIfCancellationRequested();

        // Load existing specialization English names from database.
        var existingNames = await _dbContext.Specializations
            .Select(s => s.NameEn)
            .ToListAsync(cancellationToken);

        // Filter specializations that do not exist yet.
        var toAdd = new List<Specialization>();
        foreach (var (nameEn, nameAr) in DefaultSpecializations)
        {
            // Check if specialization exists.
            bool exists = existingNames.Any(en => en.Equals(nameEn, StringComparison.OrdinalIgnoreCase));
            if (!exists)
            {
                // Create new specialization entity.
                toAdd.Add(new Specialization
                {
                    Id = Guid.NewGuid(),
                    NameEn = nameEn,
                    NameAr = nameAr
                });
            }
            else
            {
                // Specialization already exists.
            }
        }

        // Add missing specializations to the database if any found.
        if (toAdd.Count > 0)
        {
            // Add range to DbContext.
            _dbContext.Specializations.AddRange(toAdd);

            // Save changes to database.
            await _dbContext.SaveChangesAsync(cancellationToken);

            _logger.LogInformation("Seeded {Count} new medical specializations into the database.", toAdd.Count);
        }
        else
        {
            _logger.LogInformation("Medical specializations are already seeded.");
        }
    }

    #endregion
}
