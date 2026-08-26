/**
 * File Name      : PatientsControllerTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-24
 * Version        : v1.0.0
 * Dependencies   : PatientsController, IPatientService, Moq, FluentAssertions
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-24
 * Description    : Unit tests for PatientsController verifying HTTP status code
 *                  mapping, file upload guards, photo streaming, family member
 *                  CRUD delegation, and favorites pagination without hosting the
 *                  ASP.NET pipeline.
 */

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.API.Controllers;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Patient;
using Appoynt.Application.Features.Patient.Contracts;
using FluentAssertions;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace Appoynt.Tests.UnitTests.API;

/// <summary>
/// Unit tests for the patient controller's response contract and service delegation.
/// </summary>
public class PatientsControllerTests
{
    // Mocked patient application service used to isolate the controller.
    private readonly Mock<IPatientService> _serviceMock = new();

    /// <summary>
    /// Creates a controller wired to the mocked service instance.
    /// </summary>
    /// <returns>A <see cref="PatientsController"/> under test.</returns>
    private PatientsController CreateController()
    {
        // Construct the system-under-test with the shared mock.
        return new PatientsController(_serviceMock.Object);
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

    #region GetProfile

    /// <summary>
    /// An existing profile must return 200 OK with the profile payload.
    /// </summary>
    [Fact]
    public async Task GetProfile_ProfileExists_ReturnsOkWithProfile()
    {
        // Arrange the service to return an existing patient profile.
        var expectedProfile = new PatientProfileResponse { PID = "1234567U0" };
        _serviceMock
            .Setup(service => service.GetProfileAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(expectedProfile);
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetProfile(CancellationToken.None);

        // Assert.
        var okResult = actionResult.Should().BeOfType<OkObjectResult>().Subject;
        okResult.Value.Should().BeSameAs(expectedProfile);
    }

    /// <summary>
    /// A missing patient profile must return 404 Not Found.
    /// </summary>
    [Fact]
    public async Task GetProfile_ProfileMissing_ReturnsNotFound()
    {
        // Arrange the service to report no profile for the caller.
        _serviceMock
            .Setup(service => service.GetProfileAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync((PatientProfileResponse?)null);
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetProfile(CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<NotFoundResult>();
    }

    #endregion

    #region UpdateProfile / UpdatePhoneNumber

    /// <summary>
    /// A successful profile update must return 200 OK with the result.
    /// </summary>
    [Fact]
    public async Task UpdateProfile_ServiceSucceeds_ReturnsOkWithResult()
    {
        // Arrange a successful update outcome.
        var request = new UpdatePatientProfileRequest { WeightKg = 80m };
        var successResult = PatientResult.Success(Guid.NewGuid());
        _serviceMock
            .Setup(service => service.UpdateProfileAsync(request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(successResult);
        var controller = CreateController();

        // Act
        var actionResult = await controller.UpdateProfile(request, CancellationToken.None);

        // Assert.
        var okResult = actionResult.Should().BeOfType<OkObjectResult>().Subject;
        okResult.Value.Should().BeSameAs(successResult);
    }

    /// <summary>
    /// A failed profile update must return 400 Bad Request carrying the errors list.
    /// </summary>
    [Fact]
    public async Task UpdateProfile_ServiceFails_ReturnsBadRequestWithErrors()
    {
        // Arrange a validation failure outcome from the service.
        var request = new UpdatePatientProfileRequest();
        var failureErrors = new List<AuthenticationError> { new("weight.out_of_range", "WeightKg") };
        _serviceMock
            .Setup(service => service.UpdateProfileAsync(request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(PatientResult.Failure(failureErrors));
        var controller = CreateController();

        // Act
        var actionResult = await controller.UpdateProfile(request, CancellationToken.None);

        // Assert the raw errors collection is returned in the body.
        var badRequestResult = actionResult.Should().BeOfType<BadRequestObjectResult>().Subject;
        badRequestResult.Value.Should().BeSameAs(failureErrors);
    }

    /// <summary>
    /// A successful phone number change must return 200 OK.
    /// </summary>
    [Fact]
    public async Task UpdatePhoneNumber_ServiceSucceeds_ReturnsOk()
    {
        // Arrange a successful phone change outcome.
        var request = new UpdatePatientPhoneNumberRequest { PhoneNumber = "01099998888" };
        _serviceMock
            .Setup(service => service.UpdatePhoneNumberAsync(request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(PatientResult.Success(Guid.NewGuid()));
        var controller = CreateController();

        // Act
        var actionResult = await controller.UpdatePhoneNumber(request, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<OkObjectResult>();
    }

    /// <summary>
    /// A rejected phone number change must return 400 Bad Request.
    /// </summary>
    [Fact]
    public async Task UpdatePhoneNumber_ServiceFails_ReturnsBadRequest()
    {
        // Arrange a failure outcome for the phone change.
        var request = new UpdatePatientPhoneNumberRequest();
        _serviceMock
            .Setup(service => service.UpdatePhoneNumberAsync(request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(PatientResult.Failure(AuthenticationErrorCodes.PhoneFormatInvalid));
        var controller = CreateController();

        // Act
        var actionResult = await controller.UpdatePhoneNumber(request, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<BadRequestObjectResult>();
    }

    #endregion

    #region Profile Photo

    /// <summary>
    /// Uploading without a file must return 400 with the empty-file error before any service call.
    /// </summary>
    [Fact]
    public async Task UploadProfilePhoto_NoFileProvided_ReturnsBadRequestWithEmptyError()
    {
        // Arrange a controller without any uploaded payload.
        var controller = CreateController();

        // Act passing a null file reference.
        var actionResult = await controller.UploadProfilePhoto(null!, CancellationToken.None);

        // Assert no service interaction occurred and the empty code is returned.
        var badRequestResult = actionResult.Should().BeOfType<BadRequestObjectResult>().Subject;
        var errors = badRequestResult.Value.Should().BeAssignableTo<IEnumerable<AuthenticationError>>().Subject.ToList();
        errors.Should().ContainSingle(error => error.Code == ProfileImageErrorCodes.Empty);
        _serviceMock.Verify(service => service.UploadProfilePhotoAsync(
            It.IsAny<Stream>(), It.IsAny<string>(), It.IsAny<long>(), It.IsAny<CancellationToken>()),
            Times.Never);
    }

    /// <summary>
    /// A zero-length upload must be treated identically to a missing file.
    /// </summary>
    [Fact]
    public async Task UploadProfilePhoto_EmptyFile_ReturnsBadRequestWithoutServiceCall()
    {
        // Arrange a zero-byte form file.
        var emptyFile = new FormFile(new MemoryStream(), 0, 0, "file", "empty.png");
        var controller = CreateController();

        // Act
        var actionResult = await controller.UploadProfilePhoto(emptyFile, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<BadRequestObjectResult>();
        _serviceMock.Verify(service => service.UploadProfilePhotoAsync(
            It.IsAny<Stream>(), It.IsAny<string>(), It.IsAny<long>(), It.IsAny<CancellationToken>()),
            Times.Never);
    }

    /// <summary>
    /// A valid upload must forward stream metadata to the service and return 200 OK on success.
    /// </summary>
    [Fact]
    public async Task UploadProfilePhoto_ValidFile_DelegatesToServiceAndReturnsOk()
    {
        // Arrange a valid form file plus a matching success outcome capturing inputs.
        IFormFile file = CreateFormFile("avatar.png");
        string? capturedFileName = null;
        long capturedLength = 0;
        _serviceMock
            .Setup(service => service.UploadProfilePhotoAsync(
                It.IsAny<Stream>(),
                It.IsAny<string>(),
                It.IsAny<long>(),
                It.IsAny<CancellationToken>()))
            .Callback((Stream _, string fileName, long length, CancellationToken _) =>
            {
                // Capture forwarded metadata for verification below.
                capturedFileName = fileName;
                capturedLength = length;
            })
            .ReturnsAsync(PatientResult.Success(Guid.NewGuid()));
        var controller = CreateController();

        // Act
        var actionResult = await controller.UploadProfilePhoto(file, CancellationToken.None);

        // Assert the original file name and size reached the service unchanged.
        actionResult.Should().BeOfType<OkObjectResult>();
        capturedFileName.Should().Be("avatar.png");
        capturedLength.Should().Be(file.Length);
    }

    /// <summary>
    /// A service-side rejection of the upload must surface as 400 Bad Request.
    /// </summary>
    [Fact]
    public async Task UploadProfilePhoto_ServiceRejects_ReturnsBadRequest()
    {
        // Arrange the service to reject the image as unsupported.
        IFormFile file = CreateFormFile("avatar.exe");
        _serviceMock
            .Setup(service => service.UploadProfilePhotoAsync(
                It.IsAny<Stream>(), It.IsAny<string>(), It.IsAny<long>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(PatientResult.Failure(ProfileImageErrorCodes.UnsupportedFileType));
        var controller = CreateController();

        // Act
        var actionResult = await controller.UploadProfilePhoto(file, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<BadRequestObjectResult>();
    }

    /// <summary>
    /// Retrieving an existing photo must produce a file result with the service content type.
    /// </summary>
    [Fact]
    public async Task GetProfilePhoto_PhotoExists_ReturnsFileStreamResult()
    {
        // Arrange the service to return a readable stream with a JPEG type.
        using var photoStream = new MemoryStream(Encoding.UTF8.GetBytes("jpeg"));
        _serviceMock
            .Setup(service => service.GetProfilePhotoAsync(It.IsAny<Guid>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((photoStream, "image/jpeg"));
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetProfilePhoto(Guid.NewGuid(), CancellationToken.None);

        // Assert the streamed response carries the correct MIME type.
        var fileResult = actionResult.Should().BeOfType<FileStreamResult>().Subject;
        fileResult.ContentType.Should().Be("image/jpeg");
    }

    /// <summary>
    /// Retrieving when no photo exists must return 404 Not Found.
    /// </summary>
    [Fact]
    public async Task GetProfilePhoto_PhotoMissing_ReturnsNotFound()
    {
        // Arrange the service to report no stored photo.
        _serviceMock
            .Setup(service => service.GetProfilePhotoAsync(It.IsAny<Guid>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(((Stream?, string)?)null);
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetProfilePhoto(Guid.NewGuid(), CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<NotFoundResult>();
    }

    /// <summary>
    /// Successful photo deletion must return 200 OK with the result.
    /// </summary>
    [Fact]
    public async Task DeleteProfilePhoto_ServiceSucceeds_ReturnsOk()
    {
        // Arrange a successful deletion outcome.
        _serviceMock
            .Setup(service => service.DeleteProfilePhotoAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(PatientResult.Success(Guid.NewGuid()));
        var controller = CreateController();

        // Act
        var actionResult = await controller.DeleteProfilePhoto(CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<OkObjectResult>();
    }

    /// <summary>
    /// Failed photo deletion must return 400 Bad Request with errors.
    /// </summary>
    [Fact]
    public async Task DeleteProfilePhoto_ServiceFails_ReturnsBadRequest()
    {
        // Arrange a not-found deletion outcome.
        _serviceMock
            .Setup(service => service.DeleteProfilePhotoAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(PatientResult.Failure(ProfileImageErrorCodes.NotFound));
        var controller = CreateController();

        // Act
        var actionResult = await controller.DeleteProfilePhoto(CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<BadRequestObjectResult>();
    }

    #endregion

    #region Family Members

    /// <summary>
    /// Adding a family member successfully must return 200 OK.
    /// </summary>
    [Fact]
    public async Task AddFamilyMember_ServiceSucceeds_ReturnsOk()
    {
        // Arrange a successful addition outcome.
        var request = new AddFamilyMemberRequest
        {
            FullName = "New Member",
            Gender = Domain.Enums.Gender.Female,
            Relationship = Domain.Enums.FamilyRelationship.Daughter,
            BirthDate = new System.DateOnly(2018, 5, 1)
        };
        _serviceMock
            .Setup(service => service.AddFamilyMemberAsync(request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(PatientResult.Success(Guid.NewGuid()));
        var controller = CreateController();

        // Act
        var actionResult = await controller.AddFamilyMember(request, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<OkObjectResult>();
    }

    /// <summary>
    /// A rejected family member addition must return 400 Bad Request.
    /// </summary>
    [Fact]
    public async Task AddFamilyMember_ServiceFails_ReturnsBadRequest()
    {
        // Arrange a validation failure for the addition.
        var request = new AddFamilyMemberRequest();
        _serviceMock
            .Setup(service => service.AddFamilyMemberAsync(request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(PatientResult.Failure("family_member.full_name.required"));
        var controller = CreateController();

        // Act
        var actionResult = await controller.AddFamilyMember(request, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<BadRequestObjectResult>();
    }

    /// <summary>
    /// Reading an existing family member must return 200 OK with its details.
    /// </summary>
    [Fact]
    public async Task GetFamilyMemberById_MemberExists_ReturnsOkWithMember()
    {
        // Arrange the service to return the requested member.
        var memberId = Guid.NewGuid();
        var expectedMember = new FamilyMemberResponse { Id = memberId, FullName = "Existing Member" };
        _serviceMock
            .Setup(service => service.GetFamilyMemberByIdAsync(memberId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(expectedMember);
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetFamilyMemberById(memberId, CancellationToken.None);

        // Assert.
        var okResult = actionResult.Should().BeOfType<OkObjectResult>().Subject;
        okResult.Value.Should().BeSameAs(expectedMember);
    }

    /// <summary>
    /// Reading a missing or foreign family member must return 404 Not Found (IDOR guard).
    /// </summary>
    [Fact]
    public async Task GetFamilyMemberById_MemberDoesNotExist_ReturnsNotFound()
    {
        // Arrange the service to report nothing for the requested identifier.
        _serviceMock
            .Setup(service => service.GetFamilyMemberByIdAsync(It.IsAny<Guid>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((FamilyMemberResponse?)null);
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetFamilyMemberById(Guid.NewGuid(), CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<NotFoundResult>();
    }

    /// <summary>
    /// Updating a family member successfully must return 200 OK.
    /// </summary>
    [Fact]
    public async Task UpdateFamilyMember_ServiceSucceeds_ReturnsOk()
    {
        // Arrange a successful member rename outcome.
        var memberId = Guid.NewGuid();
        var request = new UpdateFamilyMemberRequest { FullName = "Renamed Member" };
        _serviceMock
            .Setup(service => service.UpdateFamilyMemberAsync(memberId, request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(PatientResult.Success(Guid.NewGuid()));
        var controller = CreateController();

        // Act
        var actionResult = await controller.UpdateFamilyMember(memberId, request, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<OkObjectResult>();
    }

    /// <summary>
    /// A failed family member update must return 400 Bad Request with errors.
    /// </summary>
    [Fact]
    public async Task UpdateFamilyMember_ServiceFails_ReturnsBadRequest()
    {
        // Arrange a not-found outcome for the member update.
        var memberId = Guid.NewGuid();
        var request = new UpdateFamilyMemberRequest();
        _serviceMock
            .Setup(service => service.UpdateFamilyMemberAsync(memberId, request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(PatientResult.Failure("family_member.not_found"));
        var controller = CreateController();

        // Act
        var actionResult = await controller.UpdateFamilyMember(memberId, request, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<BadRequestObjectResult>();
    }

    /// <summary>
    /// Deleting a family member successfully must return 200 OK.
    /// </summary>
    [Fact]
    public async Task DeleteFamilyMember_ServiceSucceeds_ReturnsOk()
    {
        // Arrange a successful deletion outcome.
        var memberId = Guid.NewGuid();
        _serviceMock
            .Setup(service => service.DeleteFamilyMemberAsync(memberId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(PatientResult.Success(Guid.NewGuid()));
        var controller = CreateController();

        // Act
        var actionResult = await controller.DeleteFamilyMember(memberId, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<OkObjectResult>();
    }

    #endregion

    #region Favorites

    /// <summary>
    /// Adding a favorite doctor must delegate the exact identifier and return 200 OK.
    /// </summary>
    [Fact]
    public async Task AddDoctorToFavorites_ServiceSucceeds_ReturnsOkAndPassesDoctorId()
    {
        // Arrange a successful favorite addition capturing the identifier argument.
        var doctorId = Guid.NewGuid();
        _serviceMock
            .Setup(service => service.AddDoctorToFavoritesAsync(doctorId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(PatientResult.Success(Guid.NewGuid()));
        var controller = CreateController();

        // Act
        var actionResult = await controller.AddDoctorToFavorites(doctorId, CancellationToken.None);

        // Assert the route identifier reached the service verbatim.
        actionResult.Should().BeOfType<OkObjectResult>();
        _serviceMock.Verify(
            service => service.AddDoctorToFavoritesAsync(doctorId, It.IsAny<CancellationToken>()),
            Times.Once);
    }

    /// <summary>
    /// Favoriting an unknown doctor must return 400 Bad Request.
    /// </summary>
    [Fact]
    public async Task AddDoctorToFavorites_DoctorDoesNotExist_ReturnsBadRequest()
    {
        // Arrange a not-found outcome for the doctor reference.
        _serviceMock
            .Setup(service => service.AddDoctorToFavoritesAsync(It.IsAny<Guid>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(PatientResult.Failure("favorite_doctor.not_found"));
        var controller = CreateController();

        // Act
        var actionResult = await controller.AddDoctorToFavorites(Guid.NewGuid(), CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<BadRequestObjectResult>();
    }

    /// <summary>
    /// Removing all favorite clinics must return 200 OK on success.
    /// </summary>
    [Fact]
    public async Task RemoveAllFavoriteClinics_ServiceSucceeds_ReturnsOk()
    {
        // Arrange a bulk removal success outcome.
        _serviceMock
            .Setup(service => service.RemoveAllFavoriteClinicsAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(PatientResult.Success(Guid.NewGuid()));
        var controller = CreateController();

        // Act
        var actionResult = await controller.RemoveAllFavoriteClinics(CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<OkObjectResult>();
    }

    /// <summary>
    /// The paginated favorites listing must forward paging parameters untouched and return 200 OK.
    /// </summary>
    [Theory]
    [InlineData(1, 15)]
    [InlineData(2, 50)]
    public async Task GetFavoriteDoctors_Invoked_PassesPagingParametersToService(int pageNumber, int pageSize)
    {
        // Arrange an expected paged payload returned by the service.
        var expectedResponse = new PagedResponse<FavoriteDoctorResponse>
        {
            Items = new List<FavoriteDoctorResponse>(),
            TotalCount = 0,
            PageNumber = pageNumber,
            PageSize = pageSize
        };
        _serviceMock
            .Setup(service => service.GetFavoriteDoctorsAsync(pageNumber, pageSize, null, It.IsAny<CancellationToken>()))
            .ReturnsAsync(expectedResponse);
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetFavoriteDoctors(pageNumber, pageSize, null, CancellationToken.None);

        // Assert both status and parameter propagation hold.
        var okResult = actionResult.Should().BeOfType<OkObjectResult>().Subject;
        okResult.Value.Should().BeSameAs(expectedResponse);
        _serviceMock.Verify(
            service => service.GetFavoriteDoctorsAsync(pageNumber, pageSize, null, It.IsAny<CancellationToken>()),
            Times.Once);
    }

    /// <summary>
    /// The clinic favorites listing must include the search term when provided.
    /// </summary>
    [Fact]
    public async Task GetFavoriteClinics_WithSearchTerm_PassesSearchToService()
    {
        // Arrange an empty page result for the search term under test.
        const string searchTerm = "dental";
        _serviceMock
            .Setup(service => service.GetFavoriteClinicsAsync(1, 15, searchTerm, It.IsAny<CancellationToken>()))
            .ReturnsAsync(new PagedResponse<FavoriteClinicResponse>());
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetFavoriteClinics(1, 15, searchTerm, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<OkObjectResult>();
        _serviceMock.Verify(
            service => service.GetFavoriteClinicsAsync(1, 15, searchTerm, It.IsAny<CancellationToken>()),
            Times.Once);
    }

    #endregion
}
