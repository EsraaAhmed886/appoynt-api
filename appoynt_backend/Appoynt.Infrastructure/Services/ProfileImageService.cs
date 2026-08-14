/**
 * File Name      : ProfileImageService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : IProfileImageService, IFileStorageService, IImageProcessingService, ApplicationDbContext
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Implements centralized profile picture upload, retrieval, and deletion for all user roles.
 */

using System;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Application.Common.Models;
using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace Appoynt.Infrastructure.Services;

/// <summary>
/// Implements centralized profile picture management for all application users.
/// </summary>
public sealed class ProfileImageService : IProfileImageService
{
    private readonly ApplicationDbContext _dbContext;
    private readonly IFileStorageService _fileStorageService;
    private readonly IImageProcessingService _imageProcessingService;
    private readonly ILogger<ProfileImageService> _logger;

    /// <summary>
    /// Initializes a new instance of the <see cref="ProfileImageService"/> class.
    /// </summary>
    /// <param name="dbContext">The application database context.</param>
    /// <param name="fileStorageService">The local file storage service.</param>
    /// <param name="imageProcessingService">The image processing and compression service.</param>
    /// <param name="logger">The service logger instance.</param>
    public ProfileImageService(
        ApplicationDbContext dbContext,
        IFileStorageService fileStorageService,
        IImageProcessingService imageProcessingService,
        ILogger<ProfileImageService> logger)
    {
        _dbContext = dbContext;
        _fileStorageService = fileStorageService;
        _imageProcessingService = imageProcessingService;
        _logger = logger;
    }

    /// <inheritdoc />
    public async Task<ProfileImageResult> UploadProfileImageAsync(
        Guid userId,
        Stream fileStream,
        string fileName,
        long fileSize,
        CancellationToken cancellationToken = default)
    {
        // Validate that the stream and file size are non-empty.
        if (fileStream == null || fileSize <= 0)
        {
            return ProfileImageResult.Failure(ProfileImageErrorCodes.Empty, "file");
        }
        else
        {
            // No action required.
        }

        // Validate maximum raw upload size limit.
        if (fileSize > ProfilePictureConstants.MaxSizeBytes)
        {
            return ProfileImageResult.Failure(ProfileImageErrorCodes.FileTooLarge, "file");
        }
        else
        {
            // No action required.
        }

        // Extract and normalize file extension.
        string extension = Path.GetExtension(fileName).ToLowerInvariant();

        // Validate supported file extensions.
        if (!ProfilePictureConstants.AllowedExtensions.Contains(extension))
        {
            return ProfileImageResult.Failure(ProfileImageErrorCodes.UnsupportedFileType, "file");
        }
        else
        {
            // No action required.
        }

        // Locate the target application user in the database.
        ApplicationUser? user = await _dbContext.Users
            .FirstOrDefaultAsync(u => u.Id == userId, cancellationToken);

        if (user == null)
        {
            return ProfileImageResult.Failure(ProfileImageErrorCodes.UserNotFound, nameof(userId));
        }
        else
        {
            // No action required.
        }

        // Preserve previous photo path to clean up disk storage on successful upload.
        string? previousPhotoPath = user.ProfilePicturePath;

        try
        {
            // Process the image: downscale to max dimensions and compress to JPEG format.
            await using Stream processedStream = await _imageProcessingService.ProcessProfileImageAsync(
                fileStream,
                ProfilePictureConstants.MaxDimensionPixels,
                ProfilePictureConstants.JpegQuality,
                cancellationToken);

            // Calculate and log compression performance metrics.
            long processedSize = processedStream.Length;
            double reductionPercent = fileSize > 0
                ? (1.0 - ((double)processedSize / fileSize)) * 100.0
                : 0.0;

            _logger.LogInformation(
                "Profile image processed for user {UserId}: input={InputSize} bytes, output={OutputSize} bytes, reduction={Reduction:F1}%",
                userId,
                fileSize,
                processedSize,
                reductionPercent);

            // Define target directory scoped by user identifier.
            string targetDirectory = $"{ProfilePictureConstants.StorageDirectory}/{userId}";

            // Persist the processed JPEG stream to disk storage.
            string newRelativePath = await _fileStorageService.SaveFileAsync(
                processedStream,
                targetDirectory,
                ProfilePictureConstants.OutputExtension,
                cancellationToken);

            // Update user record with the new profile picture path.
            user.ProfilePicturePath = newRelativePath;
            user.UpdatedAt = DateTime.UtcNow;

            // Commit database changes.
            await _dbContext.SaveChangesAsync(cancellationToken);

            // Delete the old photo file from disk if it existed.
            if (!string.IsNullOrEmpty(previousPhotoPath) && previousPhotoPath != newRelativePath)
            {
                await _fileStorageService.DeleteFileAsync(previousPhotoPath, cancellationToken);
            }
            else
            {
                // No previous file cleanup required.
            }

            // Return success with the stored relative path.
            return ProfileImageResult.Success(newRelativePath);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to process or save profile image for user {UserId}", userId);
            return ProfileImageResult.Failure(ProfileImageErrorCodes.ProcessingFailed, "file");
        }
    }

    /// <inheritdoc />
    public async Task<(Stream? Stream, string ContentType)?> GetProfileImageAsync(
        Guid userId,
        CancellationToken cancellationToken = default)
    {
        // Query the user's stored profile picture path without tracking.
        var user = await _dbContext.Users
            .AsNoTracking()
            .Where(u => u.Id == userId)
            .Select(u => new { u.ProfilePicturePath })
            .FirstOrDefaultAsync(cancellationToken);

        if (user == null || string.IsNullOrEmpty(user.ProfilePicturePath))
        {
            return null;
        }
        else
        {
            // No action required.
        }

        // Verify that the physical file exists on disk.
        if (!_fileStorageService.FileExists(user.ProfilePicturePath))
        {
            _logger.LogWarning("Profile picture path {Path} referenced by user {UserId} not found on disk", user.ProfilePicturePath, userId);
            return null;
        }
        else
        {
            // No action required.
        }

        // Open read stream for the stored image file.
        Stream? fileStream = await _fileStorageService.ReadFileAsync(user.ProfilePicturePath, cancellationToken);

        if (fileStream == null)
        {
            return null;
        }
        else
        {
            // Return stream with standardized JPEG content type.
            return (fileStream, ProfilePictureConstants.ContentType);
        }
    }

    /// <inheritdoc />
    public async Task<ProfileImageResult> DeleteProfileImageAsync(
        Guid userId,
        CancellationToken cancellationToken = default)
    {
        // Locate the target application user.
        ApplicationUser? user = await _dbContext.Users
            .FirstOrDefaultAsync(u => u.Id == userId, cancellationToken);

        if (user == null)
        {
            return ProfileImageResult.Failure(ProfileImageErrorCodes.UserNotFound, nameof(userId));
        }
        else
        {
            // No action required.
        }

        if (string.IsNullOrEmpty(user.ProfilePicturePath))
        {
            return ProfileImageResult.Failure(ProfileImageErrorCodes.NotFound, "ProfilePicture");
        }
        else
        {
            // No action required.
        }

        string currentPath = user.ProfilePicturePath;

        // Delete physical file from storage.
        await _fileStorageService.DeleteFileAsync(currentPath, cancellationToken);

        // Clear database property.
        user.ProfilePicturePath = null;
        user.UpdatedAt = DateTime.UtcNow;

        // Commit database changes.
        await _dbContext.SaveChangesAsync(cancellationToken);

        _logger.LogInformation("Deleted profile image for user {UserId} at path {Path}", userId, currentPath);

        return ProfileImageResult.Success();
    }
}
