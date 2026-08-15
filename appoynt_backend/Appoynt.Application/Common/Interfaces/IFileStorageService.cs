/**
 * File Name      : IFileStorageService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Defines the contract for file storage operations.
 */

using System.IO;
using System.Threading;
using System.Threading.Tasks;

namespace Appoynt.Application.Common.Interfaces;

/// <summary>
/// Provides an interface for storing and retrieving files.
/// </summary>
public interface IFileStorageService
{
    /// <summary>
    /// Saves a file to the storage medium.
    /// </summary>
    /// <param name="content">The file content stream.</param>
    /// <param name="directory">The target directory.</param>
    /// <param name="fileExtension">The file extension.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The relative storage path of the saved file.</returns>
    Task<string> SaveFileAsync(Stream content, string directory, string fileExtension, CancellationToken cancellationToken = default);

    /// <summary>
    /// Reads a file from the storage medium.
    /// </summary>
    /// <param name="relativePath">The relative path of the file.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A stream containing the file content, or null if the file does not exist.</returns>
    Task<Stream?> ReadFileAsync(string relativePath, CancellationToken cancellationToken = default);

    /// <summary>
    /// Deletes a file from the storage medium.
    /// </summary>
    /// <param name="relativePath">The relative path of the file.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    Task DeleteFileAsync(string relativePath, CancellationToken cancellationToken = default);

    /// <summary>
    /// Checks if a file exists.
    /// </summary>
    /// <param name="relativePath">The relative path of the file.</param>
    /// <returns>True if the file exists, false otherwise.</returns>
    bool FileExists(string relativePath);

    /// <summary>
    /// Gets the content (MIME) type of a file based on its path.
    /// </summary>
    /// <param name="relativePath">The relative path of the file.</param>
    /// <returns>The content type string.</returns>
    string GetContentType(string relativePath);
}
