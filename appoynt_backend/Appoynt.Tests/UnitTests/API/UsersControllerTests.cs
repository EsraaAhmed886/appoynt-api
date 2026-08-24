/**
 * File Name      : UsersControllerTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-24
 * Version        : v1.0.0
 * Dependencies   : UsersController, IUserManagementService, Moq, FluentAssertions
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-24
 * Description    : Unit tests for UsersController verifying HTTP status code mapping
 *                  and service delegation for staff creation, retrieval, updates,
 *                  and deletions without hosting the ASP.NET pipeline.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.API.Controllers;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.UserManagement;
using Appoynt.Application.Features.UserManagement.Contracts;
using FluentAssertions;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace Appoynt.Tests.UnitTests.API;

/// <summary>
/// Unit tests for the user management controller's response contract.
/// </summary>
public class UsersControllerTests
{
    // Mocked application service used to isolate the controller.
    private readonly Mock<IUserManagementService> _serviceMock = new();

    /// <summary>
    /// Creates a controller wired to the mocked service instance.
    /// </summary>
    /// <returns>A <see cref="UsersController"/> under test.</returns>
    private UsersController CreateController()
    {
        // Construct the system-under-test with the shared mock.
        return new UsersController(_serviceMock.Object);
    }

    #region CreateAdmin

    /// <summary>
    /// Successful admin creation must return 201 Created with the result payload.
    /// </summary>
    [Fact]
    public async Task CreateAdmin_ServiceSucceeds_ReturnsCreatedWithResult()
    {
        // Arrange a successful service outcome carrying the new identifier.
        var request = new CreateStaffRequest { FirstName = "New", LastName = "Admin" };
        var expectedResult = UserManagementResult.Success(Guid.NewGuid());
        _serviceMock
            .Setup(service => service.CreateAdminAsync(request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(expectedResult);
        var controller = CreateController();

        // Act
        var actionResult = await controller.CreateAdmin(request, CancellationToken.None);

        // Assert status and payload match the successful creation.
        var objectResult = actionResult.Should().BeOfType<ObjectResult>().Subject;
        objectResult.StatusCode.Should().Be(StatusCodes.Status201Created);
        objectResult.Value.Should().BeSameAs(expectedResult);
    }

    /// <summary>
    /// Failed admin creation must return 400 Bad Request with error details.
    /// </summary>
    [Fact]
    public async Task CreateAdmin_ServiceFails_ReturnsBadRequestWithErrors()
    {
        // Arrange a failing service outcome describing the validation problem.
        var request = new CreateStaffRequest();
        var failureResult = UserManagementResult.Failure(AuthenticationErrorCodes.EmailAlreadyRegistered, "Email");
        _serviceMock
            .Setup(service => service.CreateAdminAsync(request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(failureResult);
        var controller = CreateController();

        // Act
        var actionResult = await controller.CreateAdmin(request, CancellationToken.None);

        // Assert the failure is surfaced as a bad request.
        var badRequestResult = actionResult.Should().BeOfType<BadRequestObjectResult>().Subject;
        badRequestResult.StatusCode.Should().Be(StatusCodes.Status400BadRequest);
        badRequestResult.Value.Should().BeSameAs(failureResult);
    }

    /// <summary>
    /// The controller must forward the caller's cancellation token into the service call.
    /// </summary>
    [Fact]
    public async Task CreateAdmin_Invoked_PassesCancellationTokenToService()
    {
        // Arrange with an explicit cancellation token to observe propagation.
        var cancellationToken = new CancellationToken(canceled: false);
        _serviceMock
            .Setup(service => service.CreateAdminAsync(It.IsAny<CreateStaffRequest>(), cancellationToken))
            .ReturnsAsync(UserManagementResult.Success(Guid.NewGuid()));
        var controller = CreateController();

        // Act
        await controller.CreateAdmin(new CreateStaffRequest(), cancellationToken);

        // Assert the exact token reached the mocked dependency.
        _serviceMock.Verify(
            service => service.CreateAdminAsync(It.IsAny<CreateStaffRequest>(), cancellationToken),
            Times.Once);
    }

    #endregion

    #region CreateDoctor

    /// <summary>
    /// Successful doctor creation must return 201 Created.
    /// </summary>
    [Fact]
    public async Task CreateDoctor_ServiceSucceeds_ReturnsCreated()
    {
        // Arrange a successful doctor creation outcome.
        var request = new CreateDoctorRequest { FirstName = "New", LastName = "Doctor", NameAr = "د. جديد" };
        var expectedResult = UserManagementResult.Success(Guid.NewGuid());
        _serviceMock
            .Setup(service => service.CreateDoctorAsync(request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(expectedResult);
        var controller = CreateController();

        // Act
        var actionResult = await controller.CreateDoctor(request, CancellationToken.None);

        // Assert.
        var objectResult = actionResult.Should().BeOfType<ObjectResult>().Subject;
        objectResult.StatusCode.Should().Be(StatusCodes.Status201Created);
        objectResult.Value.Should().BeSameAs(expectedResult);
    }

    /// <summary>
    /// Duplicate doctor email must surface as 400 Bad Request.
    /// </summary>
    [Fact]
    public async Task CreateDoctor_ServiceFails_ReturnsBadRequest()
    {
        // Arrange a duplicate-email failure from the service layer.
        var request = new CreateDoctorRequest();
        var failureResult = UserManagementResult.Failure(AuthenticationErrorCodes.EmailAlreadyRegistered, "Email");
        _serviceMock
            .Setup(service => service.CreateDoctorAsync(request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(failureResult);
        var controller = CreateController();

        // Act
        var actionResult = await controller.CreateDoctor(request, CancellationToken.None);

        // Assert.
        var badRequestResult = actionResult.Should().BeOfType<BadRequestObjectResult>().Subject;
        badRequestResult.StatusCode.Should().Be(StatusCodes.Status400BadRequest);
    }

    #endregion

    #region CreateReceptionist

    /// <summary>
    /// Successful receptionist creation must return 201 Created.
    /// </summary>
    [Fact]
    public async Task CreateReceptionist_ServiceSucceeds_ReturnsCreated()
    {
        // Arrange a successful receptionist creation outcome.
        var request = new CreateStaffRequest { FirstName = "New", LastName = "Receptionist" };
        var expectedResult = UserManagementResult.Success(Guid.NewGuid());
        _serviceMock
            .Setup(service => service.CreateReceptionistAsync(request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(expectedResult);
        var controller = CreateController();

        // Act
        var actionResult = await controller.CreateReceptionist(request, CancellationToken.None);

        // Assert.
        var objectResult = actionResult.Should().BeOfType<ObjectResult>().Subject;
        objectResult.StatusCode.Should().Be(StatusCodes.Status201Created);
        objectResult.Value.Should().BeSameAs(expectedResult);
    }

    /// <summary>
    /// Failed receptionist creation must return 400 Bad Request.
    /// </summary>
    [Fact]
    public async Task CreateReceptionist_ServiceFails_ReturnsBadRequest()
    {
        // Arrange a weak-password failure outcome.
        var request = new CreateStaffRequest();
        var failureResult = UserManagementResult.Failure(AuthenticationErrorCodes.PasswordComplexityInvalid);
        _serviceMock
            .Setup(service => service.CreateReceptionistAsync(request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(failureResult);
        var controller = CreateController();

        // Act
        var actionResult = await controller.CreateReceptionist(request, CancellationToken.None);

        // Assert.
        var badRequestResult = actionResult.Should().BeOfType<BadRequestObjectResult>().Subject;
        badRequestResult.StatusCode.Should().Be(StatusCodes.Status400BadRequest);
    }

    #endregion

    #region GetUsers

    /// <summary>
    /// Listing users must always return 200 OK with the paged payload.
    /// </summary>
    [Fact]
    public async Task GetUsers_Invoked_ReturnsOkWithPagedResponse()
    {
        // Arrange an empty first page of users returned by the service.
        var queryParameters = new UserQueryParameters { PageNumber = 2, PageSize = 5 };
        var expectedResponse = new PagedResponse<UserResponse>
        {
            Items = new List<UserResponse>(),
            TotalCount = 0,
            PageNumber = 2,
            PageSize = 5
        };
        _serviceMock
            .Setup(service => service.GetUsersAsync(queryParameters, It.IsAny<CancellationToken>()))
            .ReturnsAsync(expectedResponse);
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetUsers(queryParameters, CancellationToken.None);

        // Assert pagination parameters flowed through unchanged.
        var okResult = actionResult.Should().BeOfType<OkObjectResult>().Subject;
        okResult.StatusCode.Should().Be(StatusCodes.Status200OK);
        okResult.Value.Should().BeSameAs(expectedResponse);
    }

    #endregion

    #region GetUserById

    /// <summary>
    /// An existing user identifier must produce 200 OK with the user details.
    /// </summary>
    [Fact]
    public async Task GetUserById_UserExists_ReturnsOkWithUser()
    {
        // Arrange an existing user record returned by the service.
        var userId = Guid.NewGuid();
        var expectedUser = new UserResponse
        {
            Id = userId,
            FirstName = "Existing",
            LastName = "User",
            Email = "existing.user@appoynt.com"
        };
        _serviceMock
            .Setup(service => service.GetUserByIdAsync(userId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(expectedUser);
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetUserById(userId, CancellationToken.None);

        // Assert.
        var okResult = actionResult.Should().BeOfType<OkObjectResult>().Subject;
        okResult.Value.Should().BeSameAs(expectedUser);
    }

    /// <summary>
    /// A missing user identifier must produce 404 Not Found.
    /// </summary>
    [Fact]
    public async Task GetUserById_UserDoesNotExist_ReturnsNotFound()
    {
        // Arrange the service to report no matching user.
        var userId = Guid.NewGuid();
        _serviceMock
            .Setup(service => service.GetUserByIdAsync(userId, It.IsAny<CancellationToken>()))
            .ReturnsAsync((UserResponse?)null);
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetUserById(userId, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<NotFoundResult>();
    }

    #endregion

    #region UpdateUser

    /// <summary>
    /// A successful update must return 200 OK with the update result.
    /// </summary>
    [Fact]
    public async Task UpdateUser_ServiceSucceeds_ReturnsOkWithResult()
    {
        // Arrange a successful update outcome for an arbitrary target user.
        var userId = Guid.NewGuid();
        var request = new UpdateUserRequest { FirstName = "Renamed" };
        var successResult = UserManagementResult.Success(userId);
        _serviceMock
            .Setup(service => service.UpdateUserAsync(userId, request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(successResult);
        var controller = CreateController();

        // Act
        var actionResult = await controller.UpdateUser(userId, request, CancellationToken.None);

        // Assert.
        var okResult = actionResult.Should().BeOfType<OkObjectResult>().Subject;
        okResult.Value.Should().BeSameAs(successResult);
    }

    /// <summary>
    /// An update rejected due to permissions must translate into 403 Forbidden.
    /// </summary>
    [Fact]
    public async Task UpdateUser_ForbiddenErrorCode_ReturnsForbid()
    {
        // Arrange a permission-denied outcome from the service.
        var userId = Guid.NewGuid();
        var request = new UpdateUserRequest();
        var forbiddenResult = UserManagementResult.Failure(AuthenticationErrorCodes.Forbidden);
        _serviceMock
            .Setup(service => service.UpdateUserAsync(userId, request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(forbiddenResult);
        var controller = CreateController();

        // Act
        var actionResult = await controller.UpdateUser(userId, request, CancellationToken.None);

        // Assert the authorization failure maps to Forbid (403 in the pipeline).
        actionResult.Should().BeOfType<ForbidResult>();
    }

    /// <summary>
    /// Any other update failure must fall back to 400 Bad Request.
    /// </summary>
    [Fact]
    public async Task UpdateUser_NonForbiddenFailure_ReturnsBadRequest()
    {
        // Arrange a validation-only failure without the forbidden marker.
        var userId = Guid.NewGuid();
        var request = new UpdateUserRequest();
        var failureResult = UserManagementResult.Failure(AuthenticationErrorCodes.UserNotFound);
        _serviceMock
            .Setup(service => service.UpdateUserAsync(userId, request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(failureResult);
        var controller = CreateController();

        // Act
        var actionResult = await controller.UpdateUser(userId, request, CancellationToken.None);

        // Assert.
        var badRequestResult = actionResult.Should().BeOfType<BadRequestObjectResult>().Subject;
        badRequestResult.StatusCode.Should().Be(StatusCodes.Status400BadRequest);
    }

    #endregion

    #region DeleteUser

    /// <summary>
    /// A successful soft delete must return 204 No Content.
    /// </summary>
    [Fact]
    public async Task DeleteUser_ServiceSucceeds_ReturnsNoContent()
    {
        // Arrange a successful deletion outcome.
        var userId = Guid.NewGuid();
        _serviceMock
            .Setup(service => service.DeleteUserAsync(userId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(UserManagementResult.Success(userId));
        var controller = CreateController();

        // Act
        var actionResult = await controller.DeleteUser(userId, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<NoContentResult>();
    }

    /// <summary>
    /// Deleting a user the caller may not remove must yield 403 Forbidden.
    /// </summary>
    [Fact]
    public async Task DeleteUser_ForbiddenErrorCode_ReturnsForbid()
    {
        // Arrange a permission-denied deletion outcome.
        var userId = Guid.NewGuid();
        _serviceMock
            .Setup(service => service.DeleteUserAsync(userId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(UserManagementResult.Failure(AuthenticationErrorCodes.Forbidden));
        var controller = CreateController();

        // Act
        var actionResult = await controller.DeleteUser(userId, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<ForbidResult>();
    }

    /// <summary>
    /// A deletion failing for non-permission reasons must return 400 Bad Request.
    /// </summary>
    [Fact]
    public async Task DeleteUser_OtherFailure_ReturnsBadRequest()
    {
        // Arrange a not-found style failure outcome.
        var userId = Guid.NewGuid();
        _serviceMock
            .Setup(service => service.DeleteUserAsync(userId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(UserManagementResult.Failure(AuthenticationErrorCodes.UserNotFound));
        var controller = CreateController();

        // Act
        var actionResult = await controller.DeleteUser(userId, CancellationToken.None);

        // Assert.
        var badRequestResult = actionResult.Should().BeOfType<BadRequestObjectResult>().Subject;
        badRequestResult.StatusCode.Should().Be(StatusCodes.Status400BadRequest);
    }

    #endregion

    #region DeleteAllUsers

    /// <summary>
    /// A successful batch deletion must return 204 No Content.
    /// </summary>
    [Fact]
    public async Task DeleteAllUsers_ServiceSucceeds_ReturnsNoContent()
    {
        // Arrange a successful batch deletion outcome.
        _serviceMock
            .Setup(service => service.DeleteAllUsersAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(UserManagementResult.Success(Guid.NewGuid()));
        var controller = CreateController();

        // Act
        var actionResult = await controller.DeleteAllUsers(CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<NoContentResult>();
    }

    /// <summary>
    /// A batch deletion denied by policy must yield 403 Forbidden.
    /// </summary>
    [Fact]
    public async Task DeleteAllUsers_ForbiddenErrorCode_ReturnsForbid()
    {
        // Arrange a permission-denied batch outcome.
        _serviceMock
            .Setup(service => service.DeleteAllUsersAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(UserManagementResult.Failure(AuthenticationErrorCodes.Forbidden));
        var controller = CreateController();

        // Act
        var actionResult = await controller.DeleteAllUsers(CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<ForbidResult>();
    }

    #endregion
}


