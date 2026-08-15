/**
 * File Name      : ProfileImageErrorCodes.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Contains constant error codes for profile image operations.
 */

namespace Appoynt.Application.Common.Constants;

/// <summary>
/// Provides constant error codes for profile image operations across all roles.
/// </summary>
public static class ProfileImageErrorCodes
{
    /// <summary>
    /// Indicates that the uploaded file exceeds the maximum allowed size limit.
    /// </summary>
    public const string FileTooLarge = "profile_image.file_too_large";

    /// <summary>
    /// Indicates that the uploaded file extension or MIME type is unsupported.
    /// </summary>
    public const string UnsupportedFileType = "profile_image.unsupported_file_type";

    /// <summary>
    /// Indicates that the uploaded file stream is empty or contains zero bytes.
    /// </summary>
    public const string Empty = "profile_image.empty";

    /// <summary>
    /// Indicates that the targeted user does not exist.
    /// </summary>
    public const string UserNotFound = "profile_image.user_not_found";

    /// <summary>
    /// Indicates that the user has no existing profile picture to retrieve or delete.
    /// </summary>
    public const string NotFound = "profile_image.not_found";

    /// <summary>
    /// Indicates that image processing (resize, re-encoding) failed.
    /// </summary>
    public const string ProcessingFailed = "profile_image.processing_failed";
}
