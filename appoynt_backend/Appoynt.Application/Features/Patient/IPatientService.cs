/**
 * File Name      : IPatientService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : Appoynt.Application.Features.Patient.Contracts
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Defines the contract for the patient service.
 */

using System;
using System.Collections.Generic;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Features.Patient.Contracts;

namespace Appoynt.Application.Features.Patient;

/// <summary>
/// Service interface for managing patient profiles and family members.
/// </summary>
public interface IPatientService
{
    /// <summary>
    /// Gets the profile of the current patient.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A patient result containing the profile response.</returns>
    Task<PatientProfileResponse?> GetProfileAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Updates the profile of the current patient.
    /// </summary>
    /// <param name="request">The update profile request.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A patient result indicating success or failure.</returns>
    Task<PatientResult> UpdateProfileAsync(UpdatePatientProfileRequest request, CancellationToken cancellationToken = default);

    /// <summary>
    /// Uploads a profile photo for the current patient.
    /// </summary>
    /// <param name="fileStream">The stream containing the photo data.</param>
    /// <param name="fileName">The original file name.</param>
    /// <param name="fileSize">The file size in bytes.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A patient result indicating success or failure.</returns>
    Task<PatientResult> UploadProfilePhotoAsync(Stream fileStream, string fileName, long fileSize, CancellationToken cancellationToken = default);

    /// <summary>
    /// Gets the profile photo of a patient.
    /// </summary>
    /// <param name="patientId">The patient identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A tuple containing the photo stream and content type, or null if not found.</returns>
    Task<(Stream? Stream, string ContentType)?> GetProfilePhotoAsync(Guid patientId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Deletes the profile photo of the current patient.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A patient result indicating success or failure.</returns>
    Task<PatientResult> DeleteProfilePhotoAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Adds a family member to the current patient's profile.
    /// </summary>
    /// <param name="request">The add family member request.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A patient result indicating success or failure.</returns>
    Task<PatientResult> AddFamilyMemberAsync(AddFamilyMemberRequest request, CancellationToken cancellationToken = default);

    /// <summary>
    /// Gets all family members of the current patient.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A collection of family member responses.</returns>
    Task<IEnumerable<FamilyMemberResponse>> GetFamilyMembersAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Gets a specific family member by identifier.
    /// </summary>
    /// <param name="id">The family member identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The family member response, or null if not found.</returns>
    Task<FamilyMemberResponse?> GetFamilyMemberByIdAsync(Guid id, CancellationToken cancellationToken = default);

    /// <summary>
    /// Updates a specific family member.
    /// </summary>
    /// <param name="id">The family member identifier.</param>
    /// <param name="request">The update family member request.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A patient result indicating success or failure.</returns>
    Task<PatientResult> UpdateFamilyMemberAsync(Guid id, UpdateFamilyMemberRequest request, CancellationToken cancellationToken = default);

    /// <summary>
    /// Deletes a specific family member.
    /// </summary>
    /// <param name="id">The family member identifier.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A patient result indicating success or failure.</returns>
    Task<PatientResult> DeleteFamilyMemberAsync(Guid id, CancellationToken cancellationToken = default);
}
