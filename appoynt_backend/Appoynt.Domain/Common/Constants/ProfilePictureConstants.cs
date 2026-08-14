/**
 * File Name      : ProfilePictureConstants.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Defines constant values used for user profile picture
 *                  upload, validation, processing, and storage rules.
 */

using System.Collections.Generic;

namespace Appoynt.Domain.Common.Constants;

/// <summary>
/// Provides constant values used for user profile picture validation, processing, and storage.
/// </summary>
public static class ProfilePictureConstants
{
    #region Upload and Validation Constants

    /// <summary>
    /// The maximum allowed profile picture upload file size in bytes (10 MB raw upload limit).
    /// </summary>
    public const long MaxSizeBytes = 10 * 1024 * 1024;

    /// <summary>
    /// The allowed file extensions for incoming profile picture uploads.
    /// </summary>
    public static readonly IReadOnlyList<string> AllowedExtensions =
    [
        ".jpg",
        ".jpeg",
        ".png",
        ".webp"
    ];

    /// <summary>
    /// The maximum length for the stored profile picture path in the database.
    /// </summary>
    public const int PathMaxLength = 500;

    /// <summary>
    /// The base storage subdirectory name for user profile pictures.
    /// </summary>
    public const string StorageDirectory = "profiles";

    #endregion

    #region Processing Constants

    /// <summary>
    /// The maximum dimension (width or height) in pixels for processed profile pictures.
    /// </summary>
    public const int MaxDimensionPixels = 800;

    /// <summary>
    /// The JPEG encoding quality percentage (0-100) applied during image processing.
    /// </summary>
    public const int JpegQuality = 75;

    /// <summary>
    /// The standardized output file extension for all processed profile pictures.
    /// </summary>
    public const string OutputExtension = ".jpg";

    /// <summary>
    /// The standardized MIME content type for processed profile pictures.
    /// </summary>
    public const string ContentType = "image/jpeg";

    #endregion
}
