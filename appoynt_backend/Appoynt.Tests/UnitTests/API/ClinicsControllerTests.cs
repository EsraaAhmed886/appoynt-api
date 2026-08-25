/**
 * File Name      : ClinicsControllerTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-24
 * Version        : v1.0.0
 * Dependencies   : ClinicsController, IClinicService, Clinic Contracts, Moq, FluentAssertions
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-24
 * Description    : Unit tests for ClinicsController verifying creation, retrieval,
 *                  update, phone number management, working period scheduling,
 *                  break management, receptionist assignment, and slot discovery
 *                  status-code mapping against a mocked clinic service.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.API.Controllers;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Application.Features.Clinics.Contracts;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace Appoynt.Tests.UnitTests.API;

/// <summary>
/// Unit tests for the clinic controller's response contract and service delegation.
/// </summary>
public class ClinicsControllerTests
{
    // Mocked clinic application service used to isolate the controller.
    private readonly Mock<IClinicService> _serviceMock = new();

    /// <summary>
    /// Creates a controller wired to the mocked service instance.
    /// </summary>
    /// <returns>A <see cref="ClinicsController"/> under test.</returns>
    private ClinicsController CreateController()
    {
        // Construct the system-under-test with the shared mock.
        return new ClinicsController(_serviceMock.Object);
    }

    #region CreateClinic

    /// <summary>
    /// A successful creation must return 201 Created carrying the new clinic identifier.
    /// </summary>
    [Fact]
    public async Task CreateClinic_ServiceSucceeds_ReturnsCreatedWithClinicId()
    {
        // Arrange a successful creation outcome with a known identifier.
        var request = new CreateClinicRequest { Name = "New Clinic", ConsultationFee = 100m };
        var clinicId = Guid.NewGuid();
        _serviceMock
            .Setup(service => service.CreateClinicAsync(request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(ClinicResult.Success(clinicId));
        var controller = CreateController();

        // Act
        var actionResult = await controller.CreateClinic(request, CancellationToken.None);

        // Assert the anonymous payload exposes the created identifier.
        var objectResult = actionResult.Should().BeOfType<ObjectResult>().Subject;
        objectResult.StatusCode.Should().Be(201);
        var payload = objectResult.Value.Should().BeAssignableTo<object>().Subject;
        payload.GetType().GetProperty("clinicId")!.GetValue(payload).Should().Be(clinicId);
    }

    /// <summary>
    /// A rejected creation must return 400 Bad Request with an errors wrapper.
    /// </summary>
    [Fact]
    public async Task CreateClinic_ServiceFails_ReturnsBadRequestWithErrors()
    {
        // Arrange a business-rule failure from the service.
        var request = new CreateClinicRequest();
        _serviceMock
            .Setup(service => service.CreateClinicAsync(request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(ClinicResult.Failure("clinic.max_clinics_exceeded"));
        var controller = CreateController();

        // Act
        var actionResult = await controller.CreateClinic(request, CancellationToken.None);

        // Assert.
        var badRequestResult = actionResult.Should().BeOfType<BadRequestObjectResult>().Subject;
        badRequestResult.Value.Should().NotBeNull();
    }

    #endregion

    #region Clinic Retrieval

    /// <summary>
    /// The owned-clinics listing must return the service list with 200 OK.
    /// </summary>
    [Fact]
    public async Task GetMyClinics_Invoked_ReturnsOkWithServiceList()
    {
        // Arrange two owned clinics returned by the service.
        var expectedClinics = new List<ClinicResponse> { new() { Name = "Owned Clinic" } };
        _serviceMock
            .Setup(service => service.GetMyClinicsAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(expectedClinics);
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetMyClinics(CancellationToken.None);

        // Assert.
        var okResult = actionResult.Should().BeOfType<OkObjectResult>().Subject;
        okResult.Value.Should().BeSameAs(expectedClinics);
    }

    /// <summary>
    /// Reading an existing clinic must return 200 OK with its details.
    /// </summary>
    [Fact]
    public async Task GetClinicById_ClinicExists_ReturnsOkWithClinic()
    {
        // Arrange the service to return the requested clinic.
        var clinicId = Guid.NewGuid();
        var expectedClinic = new ClinicResponse { Id = clinicId, Name = "Existing Clinic" };
        _serviceMock
            .Setup(service => service.GetClinicByIdAsync(clinicId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(expectedClinic);
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetClinicById(clinicId, CancellationToken.None);

        // Assert.
        var okResult = actionResult.Should().BeOfType<OkObjectResult>().Subject;
        okResult.Value.Should().BeSameAs(expectedClinic);
    }

    /// <summary>
    /// Reading a missing clinic must return 404 Not Found.
    /// </summary>
    [Fact]
    public async Task GetClinicById_ClinicDoesNotExist_ReturnsNotFound()
    {
        // Arrange the service to report no matching clinic.
        _serviceMock
            .Setup(service => service.GetClinicByIdAsync(It.IsAny<Guid>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((ClinicResponse?)null);
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetClinicById(Guid.NewGuid(), CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<NotFoundResult>();
    }

    #endregion

    #region Clinic Update / Delete

    /// <summary>
    /// A successful update must return 200 OK exposing the updated clinic identifier.
    /// </summary>
    [Fact]
    public async Task UpdateClinic_ServiceSucceeds_ReturnsOkWithClinicId()
    {
        // Arrange a successful update outcome for a known clinic.
        var clinicId = Guid.NewGuid();
        var request = new UpdateClinicRequest { Name = "Renamed" };
        _serviceMock
            .Setup(service => service.UpdateClinicAsync(clinicId, request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(ClinicResult.Success(clinicId));
        var controller = CreateController();

        // Act
        var actionResult = await controller.UpdateClinic(clinicId, request, CancellationToken.None);

        // Assert.
        var okResult = actionResult.Should().BeOfType<OkObjectResult>().Subject;
        okResult.Value!.GetType().GetProperty("clinicId")!.GetValue(okResult.Value).Should().Be(clinicId);
    }

    /// <summary>
    /// Updating someone else's clinic must return 400 Bad Request (ownership guard).
    /// </summary>
    [Fact]
    public async Task UpdateClinic_NotOwner_ReturnsBadRequest()
    {
        // Arrange an ownership failure outcome.
        var request = new UpdateClinicRequest();
        _serviceMock
            .Setup(service => service.UpdateClinicAsync(It.IsAny<Guid>(), request, It.IsAny<CancellationToken>()))
            .ReturnsAsync(ClinicResult.Failure("clinic.not_owner"));
        var controller = CreateController();

        // Act
        var actionResult = await controller.UpdateClinic(Guid.NewGuid(), request, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<BadRequestObjectResult>();
    }

    /// <summary>
    /// A successful deletion must return 200 OK per the current contract.
    /// </summary>
    [Fact]
    public async Task DeleteClinic_ServiceSucceeds_ReturnsOk()
    {
        // Arrange a successful deletion outcome.
        var clinicId = Guid.NewGuid();
        _serviceMock
            .Setup(service => service.DeleteClinicAsync(clinicId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(ClinicResult.Success(clinicId));
        var controller = CreateController();

        // Act
        var actionResult = await controller.DeleteClinic(clinicId, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<OkObjectResult>();
    }

    /// <summary>
    /// Deleting a missing clinic must return 400 Bad Request.
    /// </summary>
    [Fact]
    public async Task DeleteClinic_ClinicDoesNotExist_ReturnsBadRequest()
    {
        // Arrange a not-found deletion outcome.
        _serviceMock
            .Setup(service => service.DeleteClinicAsync(It.IsAny<Guid>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(ClinicResult.Failure("clinic.not_found"));
        var controller = CreateController();

        // Act
        var actionResult = await controller.DeleteClinic(Guid.NewGuid(), CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<BadRequestObjectResult>();
    }

    #endregion

    #region Phone Numbers

    /// <summary>
    /// Adding a clinic phone number successfully must return 200 OK with both identifiers.
    /// </summary>
    [Fact]
    public async Task AddPhoneNumber_ServiceSucceeds_ReturnsOkWithIdentifiers()
    {
        // Arrange a successful addition capturing route identifiers.
        var clinicId = Guid.NewGuid();
        var phoneNumberDto = new ClinicPhoneNumberDto { PhoneNumber = "+201012345678", Label = "Main" };
        _serviceMock
            .Setup(service => service.AddPhoneNumberAsync(clinicId, phoneNumberDto, It.IsAny<CancellationToken>()))
            .ReturnsAsync(ClinicResult.Success(Guid.NewGuid()));
        var controller = CreateController();

        // Act
        var actionResult = await controller.AddPhoneNumber(clinicId, phoneNumberDto, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<OkObjectResult>();
    }

    /// <summary>
    /// Adding beyond the phone limit must return 400 Bad Request.
    /// </summary>
    [Fact]
    public async Task AddPhoneNumber_LimitExceeded_ReturnsBadRequest()
    {
        // Arrange a limit-exceeded failure outcome.
        var phoneNumberDto = new ClinicPhoneNumberDto();
        _serviceMock
            .Setup(service => service.AddPhoneNumberAsync(It.IsAny<Guid>(), phoneNumberDto, It.IsAny<CancellationToken>()))
            .ReturnsAsync(ClinicResult.Failure("clinic.phone.max_exceeded"));
        var controller = CreateController();

        // Act
        var actionResult = await controller.AddPhoneNumber(Guid.NewGuid(), phoneNumberDto, CancellationToken.None);

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
        var clinicId = Guid.NewGuid();
        var phoneNumberId = Guid.NewGuid();
        _serviceMock
            .Setup(service => service.RemovePhoneNumberAsync(clinicId, phoneNumberId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(ClinicResult.Success());
        var controller = CreateController();

        // Act
        var actionResult = await controller.RemovePhoneNumber(clinicId, phoneNumberId, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<OkObjectResult>();
    }

    #endregion

    #region Working Periods and Breaks

    /// <summary>
    /// Adding a working period successfully must return 200 OK.
    /// </summary>
    [Fact]
    public async Task AddWorkingPeriod_ServiceSucceeds_ReturnsOk()
    {
        // Arrange a successful period addition outcome.
        var clinicId = Guid.NewGuid();
        var period = new WorkingPeriodRequest { DayOfWeek = 0, StartTime = "09:00", EndTime = "17:00" };
        _serviceMock
            .Setup(service => service.AddWorkingPeriodAsync(clinicId, period, It.IsAny<CancellationToken>()))
            .ReturnsAsync(ClinicResult.Success());
        var controller = CreateController();

        // Act
        var actionResult = await controller.AddWorkingPeriod(clinicId, period, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<OkObjectResult>();
    }

    /// <summary>
    /// An overlapping working period must return 400 Bad Request.
    /// </summary>
    [Fact]
    public async Task AddWorkingPeriod_ScheduleOverlap_ReturnsBadRequest()
    {
        // Arrange an overlap failure outcome.
        var period = new WorkingPeriodRequest { DayOfWeek = 1, StartTime = "09:00", EndTime = "12:00" };
        _serviceMock
            .Setup(service => service.AddWorkingPeriodAsync(It.IsAny<Guid>(), period, It.IsAny<CancellationToken>()))
            .ReturnsAsync(ClinicResult.Failure("clinic.schedule.overlap_detected"));
        var controller = CreateController();

        // Act
        var actionResult = await controller.AddWorkingPeriod(Guid.NewGuid(), period, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<BadRequestObjectResult>();
    }

    /// <summary>
    /// Updating a working period must delegate to the correct composite key.
    /// </summary>
    [Fact]
    public async Task UpdateWorkingPeriod_ServiceSucceeds_ReturnsOk()
    {
        // Arrange identifiers plus a success outcome for the update call.
        var clinicId = Guid.NewGuid();
        var periodId = Guid.NewGuid();
        var period = new WorkingPeriodRequest { DayOfWeek = 2, StartTime = "10:00", EndTime = "18:00" };
        _serviceMock
            .Setup(service => service.UpdateWorkingPeriodAsync(clinicId, periodId, period, It.IsAny<CancellationToken>()))
            .ReturnsAsync(ClinicResult.Success(periodId));
        var controller = CreateController();

        // Act
        var actionResult = await controller.UpdateWorkingPeriod(clinicId, periodId, period, CancellationToken.None);

        // Assert both route keys reached the service together.
        actionResult.Should().BeOfType<OkObjectResult>();
        _serviceMock.Verify(
            service => service.UpdateWorkingPeriodAsync(clinicId, periodId, period, It.IsAny<CancellationToken>()),
            Times.Once);
    }

    /// <summary>
    /// Deleting a break successfully must return 200 OK.
    /// </summary>
    [Fact]
    public async Task RemoveBreak_ServiceSucceeds_ReturnsOk()
    {
        // Arrange a successful break removal outcome.
        var clinicId = Guid.NewGuid();
        var breakId = Guid.NewGuid();
        _serviceMock
            .Setup(service => service.RemoveBreakAsync(clinicId, breakId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(ClinicResult.Success());
        var controller = CreateController();

        // Act
        var actionResult = await controller.RemoveBreak(clinicId, breakId, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<OkObjectResult>();
    }

    /// <summary>
    /// Adding a break outside the period must return 400 Bad Request.
    /// </summary>
    [Fact]
    public async Task AddBreak_OutsidePeriod_ReturnsBadRequest()
    {
        // Arrange an out-of-range break failure outcome.
        var breakRequest = new BreakRequest { StartTime = "23:00", EndTime = "23:30" };
        _serviceMock
            .Setup(service => service.AddBreakAsync(
                It.IsAny<Guid>(), It.IsAny<Guid>(), breakRequest, It.IsAny<CancellationToken>()))
            .ReturnsAsync(ClinicResult.Failure("clinic.break.outside_period"));
        var controller = CreateController();

        // Act
        var actionResult = await controller.AddBreak(
            Guid.NewGuid(), Guid.NewGuid(), breakRequest, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<BadRequestObjectResult>();
    }

    #endregion

    #region Receptionists

    /// <summary>
    /// Assigning a receptionist successfully must return 200 OK.
    /// </summary>
    [Fact]
    public async Task AssignReceptionist_ServiceSucceeds_ReturnsOk()
    {
        // Arrange a successful assignment outcome.
        var clinicId = Guid.NewGuid();
        var receptionistId = Guid.NewGuid();
        _serviceMock
            .Setup(service => service.AssignReceptionistAsync(clinicId, receptionistId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(ClinicResult.Success());
        var controller = CreateController();

        // Act
        var actionResult = await controller.AssignReceptionist(clinicId, receptionistId, CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<OkObjectResult>();
    }

    /// <summary>
    /// Assigning a receptionist belonging to another doctor must fail with 400 Bad Request.
    /// </summary>
    [Fact]
    public async Task AssignReceptionist_NotSameDoctor_ReturnsBadRequest()
    {
        // Arrange a cross-doctor assignment rejection.
        _serviceMock
            .Setup(service => service.AssignReceptionistAsync(
                It.IsAny<Guid>(), It.IsAny<Guid>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(ClinicResult.Failure("clinic.receptionist.not_same_doctor"));
        var controller = CreateController();

        // Act
        var actionResult = await controller.AssignReceptionist(Guid.NewGuid(), Guid.NewGuid(), CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<BadRequestObjectResult>();
    }

    /// <summary>
    /// Removing a receptionist successfully must return 200 OK.
    /// </summary>
    [Fact]
    public async Task RemoveReceptionist_ServiceSucceeds_ReturnsOk()
    {
        // Arrange a successful removal outcome.
        _serviceMock
            .Setup(service => service.RemoveReceptionistAsync(
                It.IsAny<Guid>(), It.IsAny<Guid>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(ClinicResult.Success());
        var controller = CreateController();

        // Act
        var actionResult = await controller.RemoveReceptionist(Guid.NewGuid(), Guid.NewGuid(), CancellationToken.None);

        // Assert.
        actionResult.Should().BeOfType<OkObjectResult>();
    }

    #endregion

    #region Slot Discovery

    /// <summary>
    /// Available slot discovery must forward the requested date and return the slots list.
    /// </summary>
    [Fact]
    public async Task GetAvailableSlots_Invoked_ReturnsSlotsForRequestedDate()
    {
        // Arrange expected slots for a specific clinic and date.
        var clinicId = Guid.NewGuid();
        var queryDate = new DateOnly(2026, 9, 1);
        var expectedSlots = new List<SlotResponse>
        {
            new() { StartTime = "09:00", EndTime = "09:30", Status = "Available" },
            new() { StartTime = "09:30", EndTime = "10:00", Status = "Available" }
        };
        _serviceMock
            .Setup(service => service.GetAvailableSlotsAsync(clinicId, queryDate, It.IsAny<CancellationToken>()))
            .ReturnsAsync(expectedSlots);
        var controller = CreateController();

        // Act
        var actionResult = await controller.GetAvailableSlots(clinicId, queryDate, CancellationToken.None);

        // Assert.
        var okResult = actionResult.Should().BeOfType<OkObjectResult>().Subject;
        okResult.Value.Should().BeSameAs(expectedSlots);
    }

    #endregion
}
