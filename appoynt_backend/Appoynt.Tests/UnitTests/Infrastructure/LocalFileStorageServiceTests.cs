/**
 * File Name      : LocalFileStorageServiceTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : LocalFileStorageService, FileStorageOptions, IWebHostEnvironment
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Unit tests for LocalFileStorageService covering file saving,
 *                  reading, deleting, mime type resolution, and path traversal prevention.
 */

using System;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using Appoynt.Infrastructure.FileStorage;
using Appoynt.Infrastructure.Options;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Options;
using Xunit;

namespace Appoynt.Tests.UnitTests.Infrastructure;

public class LocalFileStorageServiceTests : IDisposable
{
    private readonly string _tempFolder;
    private readonly LocalFileStorageService _storageService;

    public LocalFileStorageServiceTests()
    {
        _tempFolder = Path.Combine(Path.GetTempPath(), "AppoyntTests_" + Guid.NewGuid().ToString("N"));
        Directory.CreateDirectory(_tempFolder);

        var options = Options.Create(new FileStorageOptions { RootPath = "uploads" });
        var env = new TestWebHostEnvironment { ContentRootPath = _tempFolder };

        _storageService = new LocalFileStorageService(options, env);
    }

    public void Dispose()
    {
        if (Directory.Exists(_tempFolder))
        {
            try
            {
                Directory.Delete(_tempFolder, true);
            }
            catch
            {
                // Cleanup best effort
            }
        }
    }

    [Fact]
    public async Task SaveFileAsync_ShouldCreateFileAndReturnRelativePath()
    {
        // Arrange
        byte[] content = Encoding.UTF8.GetBytes("Test Image Data");
        using var stream = new MemoryStream(content);

        // Act
        string relativePath = await _storageService.SaveFileAsync(stream, "patients/test-id", ".jpg");

        // Assert
        Assert.False(string.IsNullOrWhiteSpace(relativePath));
        Assert.True(_storageService.FileExists(relativePath));

        using var readStream = await _storageService.ReadFileAsync(relativePath);
        Assert.NotNull(readStream);

        using var reader = new StreamReader(readStream!);
        string text = await reader.ReadToEndAsync();
        Assert.Equal("Test Image Data", text);
    }

    [Fact]
    public async Task SaveFileAsync_PathTraversalAttempt_ShouldThrowArgumentException()
    {
        // Arrange
        byte[] content = Encoding.UTF8.GetBytes("Bad Data");
        using var stream = new MemoryStream(content);

        // Act & Assert
        await Assert.ThrowsAsync<ArgumentException>(() =>
            _storageService.SaveFileAsync(stream, "../../secret", ".jpg"));
    }

    [Fact]
    public async Task DeleteFileAsync_ShouldRemoveFile()
    {
        // Arrange
        byte[] content = Encoding.UTF8.GetBytes("ToDelete");
        using var stream = new MemoryStream(content);
        string relativePath = await _storageService.SaveFileAsync(stream, "patients/test-id", ".png");

        Assert.True(_storageService.FileExists(relativePath));

        // Act
        await _storageService.DeleteFileAsync(relativePath);

        // Assert
        Assert.False(_storageService.FileExists(relativePath));
    }

    [Theory]
    [InlineData(".jpg", "image/jpeg")]
    [InlineData(".jpeg", "image/jpeg")]
    [InlineData(".png", "image/png")]
    [InlineData(".webp", "image/webp")]
    public void GetContentType_ShouldReturnCorrectMimeType(string extension, string expectedMime)
    {
        // Act
        string contentType = _storageService.GetContentType(extension);

        // Assert
        Assert.Equal(expectedMime, contentType);
    }

    private class TestWebHostEnvironment : IWebHostEnvironment
    {
        public string WebRootPath { get; set; } = string.Empty;
        public IFileProvider WebRootFileProvider { get; set; } = null!;
        public string ApplicationName { get; set; } = "Appoynt.Tests";
        public IFileProvider ContentRootFileProvider { get; set; } = null!;
        public string ContentRootPath { get; set; } = string.Empty;
        public string EnvironmentName { get; set; } = "Development";
    }
}
