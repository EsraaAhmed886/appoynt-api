/**
 * File Name      : CacheKeys.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : System
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-25
 * Description    : Central registry of cache key formats so producers and
 *                  invalidators never drift apart on key composition.
 */

using System;

namespace Appoynt.Application.Common.Constants;

/// <summary>
/// Builds the canonical cache keys used across booking read paths.
/// </summary>
public static class CacheKeys
{
    /// <summary>
    /// The key prefix for the per-clinic available-dates calendar entries.
    /// </summary>
    private const string AvailableDatesPrefix = "booking:available-dates:";

    /// <summary>
    /// The key prefix for the doctor booking-summary entries.
    /// </summary>
    private const string DoctorBookingSummaryPrefix = "booking:doctor-summary:";

    /// <summary>
    /// Builds the cache key for a clinic's available-dates window.
    /// </summary>
    /// <param name="clinicId">The clinic identifier.</param>
    /// <returns>The composed cache key.</returns>
    public static string AvailableDates(Guid clinicId)
    {
        // Compose the deterministic per-clinic key.
        return $"{AvailableDatesPrefix}{clinicId}";
    }

    /// <summary>
    /// Builds the cache key for a doctor's booking summary payload.
    /// </summary>
    /// <param name="doctorId">The doctor identifier.</param>
    /// <returns>The composed cache key.</returns>
    public static string DoctorBookingSummary(Guid doctorId)
    {
        // Compose the deterministic per-doctor key.
        return $"{DoctorBookingSummaryPrefix}{doctorId}";
    }
}
