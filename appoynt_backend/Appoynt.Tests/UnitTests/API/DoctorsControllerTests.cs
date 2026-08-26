/**
 * File Name      : DoctorsControllerTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-24
 * Version        : v1.0.0
 * Dependencies   : DoctorsController, IProfileImageService, IClinicService,
 *                  ICurrentUserService, IDoctorProfileService, ApplicationDbContext,
 *                  Moq, FluentAssertions
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-24
 * Description    : Unit tests for DoctorsController verifying profile and phone
 *                  number delegation via injected services, photo upload guards
 *                  including unauthenticated callers, public photo retrieval
 *                  through the database lookup, and clinic listing pass-through.
 */

using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.API.Controllers;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Clinics.Contracts;
using Appoynt.Application.Features.Doctor;
using Appoynt.Application.Features.Doctor.Contracts;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence;
using FluentAssertions;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Moq;
using Xunit;

namespace Appoynt.Tests.UnitTests.API;

/// <summary>
/// Unit tests for the doctor controller's response contract and service delegation.
/// </summary>
public class DoctorsControllerTests : IDisposable
{
    // Mocked centralized profile image service.
    private readonly Mock<IProfileImageService> _profileImageMock = new();

    // Mocked clinic service used by the clinic listing endpoint.
    private readonly Mock<IClinicService> _clinicServiceMock = new();

    // Mocked current-user accessor simulating authentication state.
    private readonly Mock<ICurrentUserService> _currentUserMock = new();

    // Mocked doctor profile service supplied directly to action invocations.
    private readonly Mock<IDoctorProfileService> _doctorProfileMock = new();

    // In-memory database context backing the photo lookup endpoint.
    private readonly ApplicationDbContext _dbContext;

    /// <summary>
    /// Initializes an isolated in-memory context plus shared mocks for each test.
    /// </summary>
    public DoctorsControllerTests()
    {
        // Build unique in-memory options per test instance.
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;
        var currentUserServiceMock = new Mock<ICurrentUserService>();
        var dateTimeProviderMock = new Mock<IDateTimeProvider>();
        dateTimeProviderMock.Setup(provider => provider.UtcNow).Returns(DateTime.UtcNow);
        _dbContext = new ApplicationDbContext(options, currentUserServiceMock.Object, dateTimeProviderMock.Object);
    }

    /// <summary>
    /// Disposes the in-memory database context after each test.
    /// </summary>
    public void Dispose()
    {
        _dbContext.Dispose();
    }

    /// <summary>
    /// Creates the controller under test wired to all shared mocks.
    /// </summary>
    /// <returns>A <see cref="DoctorsController"/> instance.</returns>
    private DoctorsController CreateController()
    {
        // Assemble the controller with every mocked collaborator.
        return new DoctorsController(
            _profileImageMock.Object,
            _clinicServiceMock.Object,
            _currentUserMock.Object,
            _dbContext);
    }

    /// <summary>
    /// Builds a small in-memory form file simulating a browser upload.
    /// </summary>
    /// <param name="fileName">The simulated client-side file name.</param>
    /// <returns>An <see cref="IFormFile"/> backed by memory.</returns>
    private static IFormFile CreateFormFile(string fileName)
    {
        // Wrap arbitrary bytes in a form file with the supplied name.
        byte[] content = Encoding.UTF8.GetBytes("image-bytes");
        var stream = new MemoryStream(content);
        return new FormFile(stream, 0, content.Length, "file", fileName);
    }

    #region Profile Operations

    /// <summary>
    /// Reading an existing doctor profile must return 200 OK with the payload.
    /// </summary>
    [Fact]
    public async Task GetProfile_ProfileExists_ReturnsOkWithProfile()
    {
        // Arrange the injected profile service to return a profile.
        var expectedProfile = new DoctorProfileResponse();
        _doctorProfileMock
            .Setup(service => service.GetProfileAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(expectedProfile);
        var controller = CreateController();

        // Act invoking the action with the mock passed as the [FromServices] argument.
        var actionResult = await controller.GetProfile(_doctorProfileMock.Object, CancellationToken.None);

        // Assert.
        var okResult = actionResult.Should().BeOfType<OkObjectResult>().Subject;
        okResult.Value.Should().BeSameAs(expectedProfile);
    }

    /// <summary>
    /// Reading when no doctor record exists must return 404 Not Found.
    /// </summary>
    [Fact]
    public async Task GetProfile_ProfileMissing_ReturnsNotFound()
    {
        // Arrange the profile service to report no record.
        _doctorProfileMock
            .Setup(service => service.GetProfileAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync((DoctorProfileResponse?)null);
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetProfile(_doctorProfileMock.Object, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<NotFoundResult>();
    }

    /// <summary>
    /// A successful profile update must return 200 OK with the result payload.
    /// </summary>
    [Fact]
    public async Task UpdateProfile_ServiceSucceeds_ReturnsOkWithResult()
    {
        // Arrange a successful update outcome from the profile service.
        var request = new UpdateDoctorProfileRequest { FirstName = "Updated", LastName = "Doctor" };
        _doctorProfileMock
            .Setup(service => service.UpdateProfileAsync(request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(DoctorResult.Success(Guid.NewGuid()));
        var controller = CreateController();

        // Act
        var actionResult = await controller.UpdateProfile(_doctorProfileMock.Object, request, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<OkObjectResult>();
    }

    /// <summary>
    /// A rejected profile update must return 400 Bad Request carrying errors.
    /// </summary>
    [Fact]
    public async Task UpdateProfile_ServiceFails_ReturnsBadRequestWithErrors()
    {
        // Arrange a validation failure outcome.
        var request = new UpdateDoctorProfileRequest();
        var failureErrors = new List<AuthenticationError> { new(DoctorErrorCodes.NameArRequired, "NameAr") };
        _doctorProfileMock
            .Setup(service => service.UpdateProfileAsync(request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(DoctorResult.Failure(failureErrors));
        var controller = CreateController();

        // Act
        var actionResult = await controller.UpdateProfile(_doctorProfileMock.Object, request, CancellationToken.None);

        // Assert.
        var badRequestResult = actionResult.Should().BeOfType<BadRequestObjectResult>().Subject;
        badRequestResult.Value.Should().BeSameAs(failureErrors);
    }

    /// <summary>
    /// Adding a phone number successfully must return 200 OK.
    /// </summary>
    [Fact]
    public async Task AddPhoneNumber_ServiceSucceeds_ReturnsOk()
    {
        // Arrange a successful phone addition outcome.
        var request = new AddDoctorPhoneNumberRequest { PhoneNumber = "01012345678", Label = "Clinic" };
        _doctorProfileMock
            .Setup(service => service.AddPhoneNumberAsync(request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(DoctorResult.Success(Guid.NewGuid()));
        var controller = CreateController();

        // Act
        var actionResult = await controller.AddPhoneNumber(_doctorProfileMock.Object, request, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<OkObjectResult>();
    }

    /// <summary>
    /// A failed phone addition must return 400 Bad Request.
    /// </summary>
    [Fact]
    public async Task AddPhoneNumber_ServiceFails_ReturnsBadRequest()
    {
        // Arrange a failure outcome exceeding the phone limit.
        var request = new AddDoctorPhoneNumberRequest();
        _doctorProfileMock
            .Setup(service => service.AddPhoneNumberAsync(request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(DoctorResult.Failure(DoctorErrorCodes.MaxPhoneNumbersExceeded));
        var controller = CreateController();

        // Act
        var actionResult = await controller.AddPhoneNumber(_doctorProfileMock.Object, request, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<BadRequestObjectResult>();
    }

    /// <summary>
    /// Removing a phone number successfully must return 200 OK.
    /// </summary>
    [Fact]
    public async Task RemovePhoneNumber_ServiceSucceeds_ReturnsOk()
    {
        // Arrange a successful removal outcome.
        var phoneId = Guid.NewGuid();
        _doctorProfileMock
            .Setup(service => service.RemovePhoneNumberAsync(phoneId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(DoctorResult.Success(Guid.NewGuid()));
        var controller = CreateController();

        // Act
        var actionResult = await controller.RemovePhoneNumber(_doctorProfileMock.Object, phoneId, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<OkObjectResult>();
    }

    /// <summary>
    /// Removing a missing phone number must return 400 Bad Request.
    /// </summary>
    [Fact]
    public async Task RemovePhoneNumber_PhoneDoesNotExist_ReturnsBadRequest()
    {
        // Arrange a not-found removal outcome.
        _doctorProfileMock
            .Setup(service => service.RemovePhoneNumberAsync(It.IsAny<Guid>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(DoctorResult.Failure("phone_number.not_found"));
        var controller = CreateController();

        // Act
        var actionResult = await controller.RemovePhoneNumber(_doctorProfileMock.Object, Guid.NewGuid(), CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<BadRequestObjectResult>();
    }

    #endregion

    #region Profile Photo Upload / Delete

    /// <summary>
    /// Uploading without any file must return 400 with the empty-file error code.
    /// </summary>
    [Fact]
    public async Task UploadProfilePhoto_NoFile_ReturnsBadRequestWithEmptyError()
    {
        // Arrange a controller without an uploaded payload.
        var controller = CreateController();

        // Act
        var actionResult = await controller.UploadProfilePhoto(null!, CancellationToken.None);

        // Assert.
        var badRequestResult = actionResult.Should().BeOfType<BadRequestObjectResult>().Subject;
        var errors = badRequestResult.Value.Should().BeAssignableTo<IEnumerable<AuthenticationError>>().Subject;
        errors.Should().ContainSingle(error => error.Code == ProfileImageErrorCodes.Empty);
    }

    /// <summary>
    /// An authenticated upload must delegate to the image service using the caller's identifier.
    /// </summary>
    [Fact]
    public async Task UploadProfilePhoto_AuthenticatedUser_DelegatesWithUserIdAndReturnsOk()
    {
        // Arrange an authenticated caller identity and a valid file.
        var userId = Guid.NewGuid();
        _currentUserMock.Setup(currentUser => currentUser.UserId).Returns(userId);
        IFormFile file = CreateFormFile("doctor.png");
        _profileImageMock
            .Setup(service => service.UploadProfileImageAsync(
                userId, It.IsAny<Stream>(), "doctor.png", It.IsAny<long>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(ProfileImageResult.Success("profiles/doctor/photo.jpg"));
        var controller = CreateController();

        // Act
        var actionResult = await controller.UploadProfilePhoto(file, CancellationToken.None);

        // Assert delegation happened exactly once for this user.
        actionResult.Should().BeOfType<OkObjectResult>();
        _profileImageMock.Verify(
            service => service.UploadProfileImageAsync(
                userId, It.IsAny<Stream>(), "doctor.png", It.IsAny<long>(), It.IsAny<CancellationToken>()),
            Times.Once);
    }

    /// <summary>
    /// An upload whose processing fails must return 400 Bad Request with errors.
    /// </summary>
    [Fact]
    public async Task UploadProfilePhoto_ServiceRejects_ReturnsBadRequest()
    {
        // Arrange an authenticated caller and an oversized-file rejection.
        _currentUserMock.Setup(currentUser => currentUser.UserId).Returns(Guid.NewGuid());
        IFormFile file = CreateFormFile("huge.png");
        _profileImageMock
            .Setup(service => service.UploadProfileImageAsync(
                It.IsAny<Guid>(), It.IsAny<Stream>(), It.IsAny<string>(), It.IsAny<long>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(ProfileImageResult.Failure(ProfileImageErrorCodes.FileTooLarge));
        var controller = CreateController();

        // Act
        var actionResult = await controller.UploadProfilePhoto(file, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<BadRequestObjectResult>();
    }

    /// <summary>
    /// Deleting a photo without an authenticated identifier must yield Unauthorized.
    /// </summary>
    [Fact]
    public async Task DeleteProfilePhoto_NoAuthenticatedUserId_ReturnsUnauthorized()
    {
        // Arrange an unauthenticated current-user accessor.
        _currentUserMock.Setup(currentUser => currentUser.UserId).Returns((Guid?)null);
        var controller = CreateController();

        // Act
        var actionResult = await controller.DeleteProfilePhoto(CancellationToken.None);

        // Assert no deletion reached the service layer.
        actionResult.Should().BeOfType<UnauthorizedResult>();
        _profileImageMock.Verify(
            service => service.DeleteProfileImageAsync(It.IsAny<Guid>(), It.IsAny<CancellationToken>()),
            Times.Never);
    }

    /// <summary>
    /// A successful photo deletion must delegate and return 200 OK.
    /// </summary>
    [Fact]
    public async Task DeleteProfilePhoto_AuthenticatedUser_ReturnsOkOnSuccess()
    {
        // Arrange an authenticated caller and success outcome.
        var userId = Guid.NewGuid();
        _currentUserMock.Setup(currentUser => currentUser.UserId).Returns(userId);
        _profileImageMock
            .Setup(service => service.DeleteProfileImageAsync(userId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(ProfileImageResult.Success());
        var controller = CreateController();

        // Act
        var actionResult = await controller.DeleteProfilePhoto(CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<OkObjectResult>();
    }

    #endregion

    #region Public Photo Retrieval

    /// <summary>
    /// Requesting the photo of an unknown doctor must return 404 Not Found.
    /// </summary>
    [Fact]
    public async Task GetProfilePhoto_DoctorDoesNotExist_ReturnsNotFound()
    {
        // Arrange an empty database with no matching doctor row.
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetProfilePhoto(Guid.NewGuid(), CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<NotFoundResult>();
    }

    /// <summary>
    /// A doctor without a stored picture must produce a 404 response.
    /// </summary>
    [Fact]
    public async Task GetProfilePhoto_DoctorHasNoPicture_ReturnsNotFound()
    {
        // Arrange a doctor entity linked to a user lacking a photo.
        var userId = Guid.NewGuid();
        var user = new ApplicationUser
        {
            Id = userId,
            FirstName = "Doctor",
            LastName = "Nobody",
            PhoneNumber = "01012345999",
            Email = "doctor.nobody@example.com",
            UserName = "doctor.nobody@example.com"
        };
        var doctor = new Doctor { Id = Guid.NewGuid(), UserId = userId, User = user };
        _dbContext.Users.Add(user);
        _dbContext.Doctors.Add(doctor);
        await _dbContext.SaveChangesAsync();

        _profileImageMock
            .Setup(service => service.GetProfileImageAsync(userId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(((Stream?, string)?)null);
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetProfilePhoto(doctor.Id, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<NotFoundResult>();
    }

    /// <summary>
    /// A doctor with a stored picture must stream it back with the JPEG content type.
    /// </summary>
    [Fact]
    public async Task GetProfilePhoto_DoctorHasPicture_ReturnsFileStreamResult()
    {
        // Arrange a doctor entity linked to a user owning a stored picture.
        var userId = Guid.NewGuid();
        var user = new ApplicationUser
        {
            Id = userId,
            FirstName = "Doctor",
            LastName = "Somebody",
            PhoneNumber = "01012345888",
            Email = "doctor.somebody@example.com",
            UserName = "doctor.somebody@example.com"
        };
        var doctor = new Doctor { Id = Guid.NewGuid(), UserId = userId, User = user };
        _dbContext.Users.Add(user);
        _dbContext.Doctors.Add(doctor);
        await _dbContext.SaveChangesAsync();

        using var photoStream = new MemoryStream(Encoding.UTF8.GetBytes("jpeg-data"));
        _profileImageMock
            .Setup(service => service.GetProfileImageAsync(userId, It.IsAny<CancellationToken>()))
            .ReturnsAsync((photoStream, "image/jpeg"));
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetProfilePhoto(doctor.Id, CancellationToken.None);

        // Assert the stream result carries the standardized MIME type.
        var fileResult = actionResult.Should().BeOfType<FileStreamResult>().Subject;
        fileResult.ContentType.Should().Be("image/jpeg");
    }

    #endregion

    #region Clinic Listing

    /// <summary>
    /// The doctor clinics listing must pass through the service list untouched.
    /// </summary>
    [Fact]
    public async Task GetDoctorClinics_Invoked_ReturnsServiceList()
    {
        // Arrange two clinic summaries returned by the clinic service.
        var doctorId = Guid.NewGuid();
        var expectedClinics = new List<ClinicResponse>
        {
            new() { Id = Guid.NewGuid(), DoctorId = doctorId, Name = "Clinic One" },
            new() { Id = Guid.NewGuid(), DoctorId = doctorId, Name = "Clinic Two" }
        };
        _clinicServiceMock
            .Setup(service => service.GetDoctorClinicsAsync(doctorId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(expectedClinics);
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetDoctorClinics(doctorId, CancellationToken.None);

        // Assert.
        var okResult = actionResult.Should().BeOfType<OkObjectResult>().Subject;
        okResult.Value.Should().BeSameAs(expectedClinics);
    }

    #endregion
}

