/**
 * File Name      : IMedicalCatalogSeeder.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : ISeeder
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Defines the contract for seeding standard medical reference catalogs
 *                  (ICD-10 Diagnoses, Medications, and Diagnostic Tests).
 */

namespace Appoynt.Application.Common.Interfaces.Seeding;

/// <summary>
/// Seeds standard medical reference catalogs into the database.
/// </summary>
public interface IMedicalCatalogSeeder : ISeeder
{
}
