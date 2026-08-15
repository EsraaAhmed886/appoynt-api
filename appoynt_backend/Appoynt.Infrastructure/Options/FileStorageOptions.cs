/**
 * File Name      : FileStorageOptions.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Options class for FileStorage config section
 */

using System.ComponentModel.DataAnnotations;

namespace Appoynt.Infrastructure.Options;

/// <summary>
/// Options for configuring file storage.
/// </summary>
public class FileStorageOptions
{
    /// <summary>
    /// Configuration section name.
    /// </summary>
    public const string SectionName = "FileStorage";

    /// <summary>
    /// Gets or sets the root path for file storage.
    /// </summary>
    [Required]
    public string RootPath { get; init; } = "App_Data/uploads";
}
