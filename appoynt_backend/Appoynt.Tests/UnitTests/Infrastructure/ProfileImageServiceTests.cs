/**
 * File Name      : ProfileImageServiceTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-24
 * Version        : v1.0.0
 * Dependencies   : ProfileImageService, IFileStorageService, IImageProcessingService,
 *                  ApplicationDbContext, Moq, FluentAssertions
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-24
 * Description    : Unit tests for ProfileImageService covering upload validation
 *                  (empty files, oversized uploads, unsupported extensions),
 *                  user resolution, storage delegation, retrieval fallbacks,
 *                  and deletion behavior for all user profile pictures.
 */

using System;
using System.IO;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence;
using Appoynt.Infrastructure.Services;
using FluentAssertions;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace Appoynt.Tests.UnitTests.Infrastructure;

/// <summary>
/// Unit tests for the centralized profile image management service.
/// </summary>
public sealed class ProfileImageServiceTests
{
    // Mocked file storage dependency shared across test cases.
    private readonly Mock<IFileStorageService> _fileStorageMock = new();

    // Mocked image processing dependency shared across test cases.
    private readonly Mock<IImageProcessingService> _imageProcessingMock = new();

    // Mocked logger satisfying the service's logging requirement.
    private readonly Mock<ILogger<ProfileImageService>> _loggerMock = new();

    /// <summary>
    /// Creates an isolated in-memory application database context.
    /// </summary>
    /// <returns>A fresh <see cref="ApplicationDbContext"/>.</returns>
    private static ApplicationDbContext CreateDbContext()
    {
        // Build unique in-memory options per test to avoid state leakage.
        DbContextOptions<ApplicationDbContext> options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        // Provide mocked cross-cutting dependencies required by the context.
        var currentUserServiceMock = new Mock<ICurrentUserService>();
        var dateTimeProviderMock = new Mock<IDateTimeProvider>();
        dateTimeProviderMock.Setup(provider => provider.UtcNow).Returns(DateTime.UtcNow);

        return new ApplicationDbContext(options, currentUserServiceMock.Object, dateTimeProviderMock.Object);
    }

    /// <summary>
    /// Creates the service under test wired with the shared mocks and supplied context.
    /// </summary>
    /// <param name="dbContext">The database context to use.</param>
    /// <returns>A configured <see cref="ProfileImageService"/>.</returns>
    private ProfileImageService CreateService(ApplicationDbContext dbContext)
    {
        // Assemble the service with all mocked collaborators.
        return new ProfileImageService(
            dbContext,
            _fileStorageMock.Object,
            _imageProcessingMock.Object,
            _loggerMock.Object);
    }

    /// <summary>
    /// Seeds a user row and returns its identifier for later assertions.
    /// </summary>
    /// <param name="dbContext">The database context to seed.</param>
    /// <returns>The persisted user identifier.</returns>
    private static async Task<Guid> SeedUserAsync(ApplicationDbContext dbContext)
    {
        // Add a minimal valid user record.
        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Photo",
            LastName = "Tester",
            Email = "photo.tester@example.com",
            UserName = "photo.tester@example.com",
            PhoneNumber = "01012340001"
        };
        dbContext.Users.Add(user);
        await dbContext.SaveChangesAsync();
        return user.Id;
    }

    #region Upload Validation

    /// <summary>
    /// An empty upload (zero bytes) must be rejected with the empty-file error.
    /// </summary>
    [Fact]
    public async Task UploadProfileImageAsync_EmptyFileSize_ReturnsEmptyError()
    {
        // Arrange a zero-length upload stream and context.
        using var dbContext = CreateDbContext();
        var service = CreateService(dbContext);
        using var emptyStream = new MemoryStream();

        // Act
        var result = await service.UploadProfileImageAsync(
            Guid.NewGuid(), emptyStream, "avatar.png", fileSize: 0);

        // Assert no storage interaction took place.
        result.Succeeded.Should().BeFalse();
        result.Errors.Single().Code.Should().Be(ProfileImageErrorCodes.Empty);
        result.Errors.Single().Field.Should().Be("file");
        _fileStorageMock.Verify(storage => storage.SaveFileAsync(
            It.IsAny<Stream>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<CancellationToken>()),
            Times.Never);
    }

    /// <summary>
    /// Uploads beyond ten megabytes must be rejected before any processing occurs.
    /// </summary>
    [Fact]
    public async Task UploadProfileImageAsync_FileExceedsMaxSize_ReturnsFileTooLargeError()
    {
        // Arrange an oversized declared size above the configured limit.
        using var dbContext = CreateDbContext();
        var service = CreateService(dbContext);
        using var stream = new MemoryStream(Encoding.UTF8.GetBytes("dummy"));
        long oversized = ProfilePictureConstants.MaxSizeBytes + 1;

        // Act
        var result = await service.UploadProfileImageAsync(
            Guid.NewGuid(), stream, "huge.png", oversized);

        // Assert the size guard fired without touching storage or processing.
        result.Succeeded.Should().BeFalse();
        result.Errors.Single().Code.Should().Be(ProfileImageErrorCodes.FileTooLarge);
        _imageProcessingMock.Verify(processing => processing.ProcessProfileImageAsync(
            It.IsAny<Stream>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<CancellationToken>()),
            Times.Never);
    }

    /// <summary>
    /// Disallowed file extensions such as executables must be rejected.
    /// </summary>
    [Theory]
    [InlineData("malicious.exe")]
    [InlineData("script.bat")]
    [InlineData("archive.zip")]
    [InlineData("no-extension")]
    public async Task UploadProfileImageAsync_UnsupportedExtension_ReturnsUnsupportedFileTypeError(string fileName)
    {
        // Arrange a well-sized but wrongly typed upload.
        using var dbContext = CreateDbContext();
        var service = CreateService(dbContext);
        using var stream = new MemoryStream(Encoding.UTF8.GetBytes("dummy"));

        // Act
        var result = await service.UploadProfileImageAsync(
            Guid.NewGuid(), stream, fileName, fileSize: 1024);

        // Assert the extension allow-list blocked the upload.
        result.Succeeded.Should().BeFalse();
        result.Errors.Single().Code.Should().Be(ProfileImageErrorCodes.UnsupportedFileType);
    }

    /// <summary>
    /// A missing target user must abort the upload with the user-not-found error.
    /// </summary>
    [Fact]
    public async Task UploadProfileImageAsync_UserDoesNotExist_ReturnsUserNotFoundError()
    {
        // Arrange an upload targeting a user absent from the database.
        using var dbContext = CreateDbContext();
        var service = CreateService(dbContext);
        using var stream = new MemoryStream(Encoding.UTF8.GetBytes("dummy"));

        // Act
        var result = await service.UploadProfileImageAsync(
            Guid.NewGuid(), stream, "avatar.png", fileSize: 1024);

        // Assert no image was processed or stored.
        result.Succeeded.Should().BeFalse();
        result.Errors.Single().Code.Should().Be(ProfileImageErrorCodes.UserNotFound);
        _imageProcessingMock.Verify(processing => processing.ProcessProfileImageAsync(
            It.IsAny<Stream>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<CancellationToken>()),
            Times.Never);
    }

    #endregion

    #region Upload Success Path

    /// <summary>
    /// A valid first upload must process, store, persist, and return the new path.
    /// </summary>
    [Fact]
    public async Task UploadProfileImageAsync_ValidUpload_SavesProcessedImageAndReturnsPath()
    {
        // Arrange a seeded user and a processed output stream from the mock pipeline.
        using var dbContext = CreateDbContext();
        Guid userId = await SeedUserAsync(dbContext);
        var service = CreateService(dbContext);
        using var inputStream = new MemoryStream(Encoding.UTF8.GetBytes("raw-image-bytes"));
        using var processedStream = new MemoryStream(Encoding.UTF8.GetBytes("processed-jpeg"));
        _imageProcessingMock
            .Setup(processing => processing.ProcessProfileImageAsync(
                inputStream,
                ProfilePictureConstants.MaxDimensionPixels,
                ProfilePictureConstants.JpegQuality,
                It.IsAny<CancellationToken>()))
            .ReturnsAsync(processedStream);
        string expectedRelativePath = $"profiles/{userId}/stored-image.jpg";
        _fileStorageMock
            .Setup(storage => storage.SaveFileAsync(
                processedStream,
                $"{ProfilePictureConstants.StorageDirectory}/{userId}",
                ProfilePictureConstants.OutputExtension,
                It.IsAny<CancellationToken>()))
            .ReturnsAsync(expectedRelativePath);

        // Act
        var result = await service.UploadProfileImageAsync(userId, inputStream, "avatar.png", fileSize: 1024);

        // Assert success plus persistence of the new path on the user record.
        result.Succeeded.Should().BeTrue();
        result.StoredPath.Should().Be(expectedRelativePath);
        var updatedUser = await dbContext.Users.AsNoTracking().SingleAsync(user => user.Id == userId);
        updatedUser.ProfilePicturePath.Should().Be(expectedRelativePath);
    }

    /// <summary>
    /// Replacing an existing photo must delete the previous file after storing the new one.
    /// </summary>
    [Fact]
    public async Task UploadProfileImageAsync_ReplacingExistingPhoto_DeletesPreviousFile()
    {
        // Arrange a user that already owns a stored photo path.
        string previousPath = "profiles/old-photo.jpg";
        using var dbContext = CreateDbContext();
        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Existing",
            LastName = "Owner",
            Email = "existing.owner@example.com",
            UserName = "existing.owner@example.com",
            PhoneNumber = "01012340002",
            ProfilePicturePath = previousPath
        };
        dbContext.Users.Add(user);
        await dbContext.SaveChangesAsync();

        var service = CreateService(dbContext);
        using var inputStream = new MemoryStream(Encoding.UTF8.GetBytes("new-bytes"));
        using var processedStream = new MemoryStream(Encoding.UTF8.GetBytes("processed-new"));
        _imageProcessingMock
            .Setup(processing => processing.ProcessProfileImageAsync(
                It.IsAny<Stream>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(processedStream);
        string newPath = $"profiles/{user.Id}/new-image.jpg";
        _fileStorageMock
            .Setup(storage => storage.SaveFileAsync(
                It.IsAny<Stream>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(newPath);

        // Act
        var result = await service.UploadProfileImageAsync(user.Id, inputStream, "avatar.jpeg", fileSize: 2048);

        // Assert the stale file cleanup ran exactly once against the old path only.
        result.Succeeded.Should().BeTrue();
        _fileStorageMock.Verify(
            storage => storage.DeleteFileAsync(previousPath, It.IsAny<CancellationToken>()),
            Times.Once);
        _fileStorageMock.Verify(
            storage => storage.DeleteFileAsync(newPath, It.IsAny<CancellationToken>()),
            Times.Never);
    }

    /// <summary>
    /// A processing failure must be converted into the ProcessingFailed error code.
    /// </summary>
    [Fact]
    public async Task UploadProfileImageAsync_ProcessingThrows_ReturnsProcessingFailedError()
    {
        // Arrange the image processor to explode mid-pipeline.
        using var dbContext = CreateDbContext();
        Guid userId = await SeedUserAsync(dbContext);
        var service = CreateService(dbContext);
        using var inputStream = new MemoryStream(Encoding.UTF8.GetBytes("corrupt-data"));
        _imageProcessingMock
            .Setup(processing => processing.ProcessProfileImageAsync(
                It.IsAny<Stream>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<CancellationToken>()))
            .ThrowsAsync(new InvalidOperationException("Corrupt image data"));

        // Act
        var result = await service.UploadProfileImageAsync(userId, inputStream, "avatar.png", fileSize: 512);

        // Assert the failure is contained and nothing reached persistent storage.
        result.Succeeded.Should().BeFalse();
        result.Errors.Single().Code.Should().Be(ProfileImageErrorCodes.ProcessingFailed);
        _fileStorageMock.Verify(storage => storage.SaveFileAsync(
            It.IsAny<Stream>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<CancellationToken>()),
            Times.Never);
    }

    #endregion

    #region Retrieval

    /// <summary>
    /// Retrieval for a user without a photo must return null instead of throwing.
    /// </summary>
    [Fact]
    public async Task GetProfileImageAsync_UserHasNoPhoto_ReturnsNull()
    {
        // Arrange a user lacking any stored picture reference.
        using var dbContext = CreateDbContext();
        Guid userId = await SeedUserAsync(dbContext);
        var service = CreateService(dbContext);

        // Act
        var retrieved = await service.GetProfileImageAsync(userId);

        // Assert.
        retrieved.Should().BeNull();
    }

    /// <summary>
    /// A dangling path pointing at a missing disk file must return null gracefully.
    /// </summary>
    [Fact]
    public async Task GetProfileImageAsync_FileMissingOnDisk_ReturnsNull()
    {
        // Arrange a user whose recorded path no longer exists on storage.
        using var dbContext = CreateDbContext();
        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Ghost",
            LastName = "Photo",
            Email = "ghost.photo@example.com",
            UserName = "ghost.photo@example.com",
            PhoneNumber = "01012340003",
            ProfilePicturePath = "profiles/ghost/deleted.jpg"
        };
        dbContext.Users.Add(user);
        await dbContext.SaveChangesAsync();

        _fileStorageMock
            .Setup(storage => storage.FileExists(user.ProfilePicturePath))
            .Returns(false);

        var service = CreateService(dbContext);

        // Act
        var retrieved = await service.GetProfileImageAsync(user.Id);

        // Assert.
        retrieved.Should().BeNull();
    }

    /// <summary>
    /// A healthy photo reference must return the stream paired with the JPEG content type.
    /// </summary>
    [Fact]
    public async Task GetProfileImageAsync_ExistingPhoto_ReturnsStreamWithJpegContentType()
    {
        // Arrange a user with a valid on-disk picture.
        using var dbContext = CreateDbContext();
        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Happy",
            LastName = "Path",
            Email = "happy.path@example.com",
            UserName = "happy.path@example.com",
            PhoneNumber = "01012340004",
            ProfilePicturePath = "profiles/happy/photo.jpg"
        };
        dbContext.Users.Add(user);
        await dbContext.SaveChangesAsync();

        using var storedStream = new MemoryStream(Encoding.UTF8.GetBytes("jpeg-bytes"));
        _fileStorageMock
            .Setup(storage => storage.FileExists(user.ProfilePicturePath))
            .Returns(true);
        _fileStorageMock
            .Setup(storage => storage.ReadFileAsync(user.ProfilePicturePath, It.IsAny<CancellationToken>()))
            .ReturnsAsync(storedStream);

        var service = CreateService(dbContext);

        // Act
        var retrieved = await service.GetProfileImageAsync(user.Id);

        // Assert content type matches the standardized processed format.
        retrieved.Should().NotBeNull();
        retrieved!.Value.Stream.Should().BeSameAs(storedStream);
        retrieved.Value.ContentType.Should().Be(ProfilePictureConstants.ContentType);
    }

    #endregion

    #region Deletion

    /// <summary>
    /// Deleting the photo of a nonexistent user must fail with UserNotFound.
    /// </summary>
    [Fact]
    public async Task DeleteProfileImageAsync_UserDoesNotExist_ReturnsUserNotFoundError()
    {
        // Arrange a deletion attempt against an unknown identifier.
        using var dbContext = CreateDbContext();
        var service = CreateService(dbContext);

        // Act
        var result = await service.DeleteProfileImageAsync(Guid.NewGuid());

        // Assert.
        result.Succeeded.Should().BeFalse();
        result.Errors.Single().Code.Should().Be(ProfileImageErrorCodes.UserNotFound);
    }

    /// <summary>
    /// Deleting when no photo exists must fail with the NotFound error code.
    /// </summary>
    [Fact]
    public async Task DeleteProfileImageAsync_NoPhotoStored_ReturnsNotFoundError()
    {
        // Arrange a user that never uploaded a picture.
        using var dbContext = CreateDbContext();
        Guid userId = await SeedUserAsync(dbContext);
        var service = CreateService(dbContext);

        // Act
        var result = await service.DeleteProfileImageAsync(userId);

        // Assert.
        result.Succeeded.Should().BeFalse();
        result.Errors.Single().Code.Should().Be(ProfileImageErrorCodes.NotFound);
    }

    /// <summary>
    /// A successful deletion must remove the file and clear the stored path.
    /// </summary>
    [Fact]
    public async Task DeleteProfileImageAsync_ExistingPhoto_RemovesFileAndClearsPath()
    {
        // Arrange a user owning an existing picture.
        string storedPath = "profiles/user/to-delete.jpg";
        using var dbContext = CreateDbContext();
        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Delete",
            LastName = "Me",
            Email = "delete.me@example.com",
            UserName = "delete.me@example.com",
            PhoneNumber = "01012340005",
            ProfilePicturePath = storedPath
        };
        dbContext.Users.Add(user);
        await dbContext.SaveChangesAsync();

        var service = CreateService(dbContext);

        // Act
        var result = await service.DeleteProfileImageAsync(user.Id);

        // Assert both physical removal and database clearing occurred.
        result.Succeeded.Should().BeTrue();
        _fileStorageMock.Verify(
            storage => storage.DeleteFileAsync(storedPath, It.IsAny<CancellationToken>()),
            Times.Once);
        var refreshedUser = await dbContext.Users.AsNoTracking().SingleAsync(record => record.Id == user.Id);
        refreshedUser.ProfilePicturePath.Should().BeNull();
    }

    #endregion
}


