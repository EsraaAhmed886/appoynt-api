/**
 * File Name      : IReferenceDataService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : CatalogDto, TestCategory
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Application service interface for searching and querying global clinical reference catalogs
 *                  (ICD-10 Diagnoses, Medications, Diagnostic Tests).
 */

using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Features.MedicalRecords.Contracts;
using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.MedicalRecords;

/// <summary>
/// Provides search and lookup capabilities over standard clinical catalogs.
/// </summary>
public interface IReferenceDataService
{
    /// <summary>
    /// Searches ICD-10 diagnoses by code or English/Arabic name.
    /// </summary>
    /// <param name="searchTerm">The search text.</param>
    /// <param name="take">Max results to return.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>Matching diagnoses.</returns>
    Task<IReadOnlyList<DiagnosisCatalogDto>> SearchDiagnosesAsync(string? searchTerm, int take = 20, CancellationToken cancellationToken = default);

    /// <summary>
    /// Searches medications by brand name, English/Arabic name, or active ingredient.
    /// Includes the calling doctor's own custom medications.
    /// </summary>
    /// <param name="searchTerm">The search text.</param>
    /// <param name="take">Max results to return.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>Matching medications.</returns>
    Task<IReadOnlyList<MedicationCatalogDto>> SearchMedicationsAsync(string? searchTerm, int take = 20, CancellationToken cancellationToken = default);

    /// <summary>
    /// Searches diagnostic and laboratory tests by category and name.
    /// </summary>
    /// <param name="category">Optional category filter.</param>
    /// <param name="searchTerm">The search text.</param>
    /// <param name="take">Max results to return.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>Matching tests.</returns>
    Task<IReadOnlyList<TestCatalogDto>> SearchTestsAsync(TestCategory? category, string? searchTerm, int take = 20, CancellationToken cancellationToken = default);
}
