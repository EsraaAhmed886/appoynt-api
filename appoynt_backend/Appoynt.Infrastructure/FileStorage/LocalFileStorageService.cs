/**
 * File Name      : LocalFileStorageService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : IFileStorageService, IOptions<FileStorageOptions>, IWebHostEnvironment
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Local file storage implementation.
 */

using System;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Infrastructure.Options;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Options;

namespace Appoynt.Infrastructure.FileStorage;

/// <summary>
/// Implementation of IFileStorageService using local file system.
/// </summary>
public class LocalFileStorageService : IFileStorageService
{
    // Holds the options
    private readonly FileStorageOptions _options;
    
    // Holds the env
    private readonly IWebHostEnvironment _env;

    /// <summary>
    /// Initializes a new instance of LocalFileStorageService.
    /// </summary>
    public LocalFileStorageService(IOptions<FileStorageOptions> options, IWebHostEnvironment env)
    {
        // Set options
        _options = options.Value;
        // Set env
        _env = env;
    }

    /// <summary>
    /// Saves a file asynchronously.
    /// </summary>
    public async Task<string> SaveFileAsync(Stream stream, string directory, string extension, CancellationToken cancellationToken = default)
    {
        // Generate a new random file name
        string fileName = $"{Guid.NewGuid()}{extension}";
        
        // Ensure the directory path does not contain path traversal characters
        if (directory.Contains(".."))
        {
            // Throw exception for invalid path
            throw new ArgumentException("Invalid directory path.", nameof(directory));
        }
        else
        {
            // No action required.
        }

        // Combine paths to create relative path
        string relativePath = Path.Combine(directory, fileName).Replace("\\", "/");
        
        // Combine with root to get full path
        string physicalPath = Path.Combine(_env.ContentRootPath, _options.RootPath, relativePath);
        
        // Get the directory of the physical path
        string physicalDirectory = Path.GetDirectoryName(physicalPath)!;
        
        // Check if directory exists
        if (!Directory.Exists(physicalDirectory))
        {
            // Create directory if it does not exist
            Directory.CreateDirectory(physicalDirectory);
        }
        else
        {
            // No action required.
        }

        // Create the file stream
        await using FileStream fileStream = new FileStream(physicalPath, FileMode.Create, FileAccess.Write);
        
        // Copy the stream to the file
        await stream.CopyToAsync(fileStream, cancellationToken);
        
        // Return the relative path
        return relativePath;
    }

    /// <summary>
    /// Reads a file asynchronously.
    /// </summary>
    public Task<Stream?> ReadFileAsync(string relativePath, CancellationToken cancellationToken = default)
    {
        // Validate path against traversal
        if (relativePath.Contains(".."))
        {
            // Throw exception
            throw new ArgumentException("Invalid file path.", nameof(relativePath));
        }
        else
        {
            // No action required.
        }

        // Resolve the physical path
        string physicalPath = Path.Combine(_env.ContentRootPath, _options.RootPath, relativePath);
        
        // Check if file exists
        if (!File.Exists(physicalPath))
        {
            // Return null if file not found
            return Task.FromResult<Stream?>(null);
        }
        else
        {
            // No action required.
        }

        // Open the file for reading
        Stream stream = new FileStream(physicalPath, FileMode.Open, FileAccess.Read, FileShare.Read);
        
        // Return the stream
        return Task.FromResult<Stream?>(stream);
    }

    /// <summary>
    /// Deletes a file asynchronously.
    /// </summary>
    public Task DeleteFileAsync(string relativePath, CancellationToken cancellationToken = default)
    {
        // Validate path against traversal
        if (relativePath.Contains(".."))
        {
            // Throw exception
            throw new ArgumentException("Invalid file path.", nameof(relativePath));
        }
        else
        {
            // No action required.
        }

        // Resolve the physical path
        string physicalPath = Path.Combine(_env.ContentRootPath, _options.RootPath, relativePath);
        
        // Check if file exists
        if (File.Exists(physicalPath))
        {
            // Delete the file
            File.Delete(physicalPath);
        }
        else
        {
            // No action required.
        }

        // Return completed task
        return Task.CompletedTask;
    }

    /// <summary>
    /// Checks if a file exists.
    /// </summary>
    public bool FileExists(string relativePath)
    {
        // Validate path against traversal
        if (relativePath.Contains(".."))
        {
            // Throw exception
            throw new ArgumentException("Invalid file path.", nameof(relativePath));
        }
        else
        {
            // No action required.
        }

        // Resolve the physical path
        string physicalPath = Path.Combine(_env.ContentRootPath, _options.RootPath, relativePath);
        
        // Check and return existence
        return File.Exists(physicalPath);
    }

    /// <summary>
    /// Gets the MIME content type from an extension.
    /// </summary>
    public string GetContentType(string extension)
    {
        // Convert to lowercase
        string lowerExtension = extension.ToLowerInvariant();
        
        // Map extension to mime type
        switch (lowerExtension)
        {
            case ".jpg":
            case ".jpeg":
                // Return jpeg type
                return "image/jpeg";
            case ".png":
                // Return png type
                return "image/png";
            case ".webp":
                // Return webp type
                return "image/webp";
            default:
                // Return generic binary type
                return "application/octet-stream";
        }
    }
}
