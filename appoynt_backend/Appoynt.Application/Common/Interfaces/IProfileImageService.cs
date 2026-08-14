/**
 * File Name      : IProfileImageService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : ProfileImageResult
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Defines the contract for centralized profile picture management across all application users.
 */

using System;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Models;

namespace Appoynt.Application.Common.Interfaces;

/// <summary>
/// Service interface for centralized profile picture upload, retrieval, and deletion operations across all user roles.
/// </summary>
public interface IProfileImageService
{
    /// <summary>
    /// Uploads, compresses, and saves a new profile picture for the specified user, deleting any previously stored picture.
    /// </summary>
    /// <param name="userId">The unique identifier of the user.</param>
    /// <param name="fileStream">The raw incoming file data stream.</param>
    /// <param name="fileName">The original file name containing the extension.</param>
    /// <param name="fileSize">The raw file size in bytes.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A result object indicating success or failure errors.</returns>
    Task<ProfileImageResult> UploadProfileImageAsync(
        Guid userId,
        Stream fileStream,
        string fileName,
        long fileSize,
        CancellationToken cancellationToken = default);

    /// <summary>
    /// Retrieves the profile picture image stream and MIME content type for the specified user.
    /// </summary>
    /// <param name="userId">The unique identifier of the user.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A tuple containing the readable stream and MIME content type, or null if no picture exists.</returns>
    Task<(Stream? Stream, string ContentType)?> GetProfileImageAsync(
        Guid userId,
        CancellationToken cancellationToken = default);

    /// <summary>
    /// Deletes the stored profile picture file and clears the profile picture reference for the specified user.
    /// </summary>
    /// <param name="userId">The unique identifier of the user.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A result object indicating success or failure errors.</returns>
    Task<ProfileImageResult> DeleteProfileImageAsync(
        Guid userId,
        CancellationToken cancellationToken = default);
}
