/**
 * File Name      : DoctorAppointmentsIntegrationTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : WebApplicationFactory, ApplicationDbContext, FluentAssertions,
 *                  DoctorAppointments Contracts, Clinic Contracts
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-26
 * Description    : Integration tests for the doctor appointments screen covering
 *                  the current-patient board, paginated queue ordering, computed
 *                  slot display statuses, the per-doctor single-consultation
 *                  guard, invalid lifecycle transitions, ownership-based hiding
 *                  of foreign clinics/appointments, and calendar horizons.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Threading.Tasks;
using Appoynt.Application.Features.Authentication.Login.Contracts;
using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Application.Features.Authentication.Registration.Contracts;
using Appoynt.Application.Features.Clinics.Contracts;
using Appoynt.Application.Features.DoctorAppointments.Contracts;
using Appoynt.Application.Features.UserManagement.Contracts;
using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Persistence;
using FluentAssertions;
using FluentAssertions.Execution;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Xunit;

namespace Appoynt.Tests.IntegrationTests;

/// <summary>
/// Integration tests for the doctor appointments screen endpoints.
/// </summary>
[Collection("Sequential")]
public sealed class DoctorAppointmentsIntegrationTests : IClassFixture<WebApplicationFactory<Appoynt.API.Program>>
{
    // Fixed development OTP accepted by the OTP service in test environments.
    private const string DevelopmentOtpCode = "123456";

    // Factory hosting the API under test with an isolated database.
    private readonly WebApplicationFactory<Appoynt.API.Program> _factory;

    /// <summary>
    /// Initializes the test factory with isolated storage and relaxed limits.
    /// </summary>
    /// <param name="factory">The shared host factory provided by xUnit.</param>
    public DoctorAppointmentsIntegrationTests(WebApplicationFactory<Appoynt.API.Program> factory)
    {
        _factory = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureAppConfiguration((context, config) =>
            {
                config.AddInMemoryCollection(new Dictionary<string, string?>
                {
                    ["DatabaseProvider"] = "Sqlite",
                    ["ConnectionStrings:DefaultConnection"] = "DataSource=file:appoynt_doctor_appointments_test.db?mode=memory&cache=shared",
                    ["Jwt:SecretKey"] = "SuperSecretKeyWithMinimum32CharactersLength!",
                    ["RateLimiting:Register:PermitLimit"] = "200",
                    ["RateLimiting:Register:WindowInMinutes"] = "60",
                    ["RateLimiting:Login:PermitLimit"] = "200",
                    ["RateLimiting:Login:WindowInMinutes"] = "60",
                    ["RateLimiting:OtpVerify:PermitLimit"] = "200",
                    ["RateLimiting:OtpVerify:WindowInMinutes"] = "60",
                    ["Seed:Enabled"] = "true",
                    ["Seed:Admin:Password"] = "Password123!"
                });
            });
        });
    }

    #region Test Setup Helpers

    /// <summary>
    /// Logs in as the seeded administrator and returns the bearer token.
    /// </summary>
    /// <param name="client">An unauthenticated HTTP client.</param>
    /// <returns>The admin access token.</returns>
    private async Task<string> AuthenticateAdminAsync(HttpClient client)
    {
        // Log in with the seeded administrator credentials.
        var loginResponse = await client.PostAsJsonAsync("/api/auth/login", new LoginRequest
        {
            Identifier = "admin@appoynt.com",
            Password = "Password123!"
        });
        loginResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var loginResult = await loginResponse.Content.ReadFromJsonAsync<LoginResponse>();
        return loginResult!.AccessToken;
    }

    /// <summary>
    /// Creates a doctor account through the admin endpoint and logs in as them.
    /// </summary>
    /// <param name="suffix">A unique label for the doctor identity.</param>
    /// <returns>The authenticated doctor client plus the identity-user identifier.</returns>
    private async Task<(HttpClient Client, Guid UserId)> CreateAndLoginDoctorAsync(string suffix)
    {
        // Bootstrap an admin session to provision the doctor account.
        var bootstrapClient = _factory.CreateClient();
        var adminToken = await AuthenticateAdminAsync(bootstrapClient);
        bootstrapClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminToken);

        // Build the doctor creation payload with unique credentials.
        string email = $"appts_doctor_{suffix}_{Guid.NewGuid():N}@appoynt.com";
        var createResponse = await bootstrapClient.PostAsJsonAsync("/api/users/doctors", new CreateDoctorRequest
        {
            FirstName = "Appts",
            LastName = $"Doc{suffix}",
            NameAr = $"د. مواعيد {suffix}",
            NameEn = $"Dr. Appts {suffix}",
            Email = email,
            PhoneNumber = "+2011" + Random.Shared.Next(10000000, 99999999).ToString(),
            Password = "Password123!",
            SpecializationIds = []
        });
        createResponse.StatusCode.Should().Be(HttpStatusCode.Created);
        var createBody = await createResponse.Content.ReadFromJsonAsync<UserManagementResult>();

        // Log in as the newly created doctor (staff accounts are pre-confirmed).
        var doctorClient = _factory.CreateClient();
        var loginResponse = await doctorClient.PostAsJsonAsync("/api/auth/login", new LoginRequest
        {
            Identifier = email,
            Password = "Password123!"
        });
        loginResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var loginBody = await loginResponse.Content.ReadFromJsonAsync<LoginResponse>();
        doctorClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loginBody!.AccessToken);
        return (doctorClient, createBody!.UserId!.Value);
    }

    /// <summary>
    /// Resolves the Doctor ENTITY identifier for an identity-user identifier.
    /// </summary>
    /// <param name="userId">The identity-user identifier.</param>
    /// <returns>The matching doctor entity identifier.</returns>
    private async Task<Guid> ResolveDoctorEntityIdAsync(Guid userId)
    {
        // Read the mapping row through a scoped context on the shared database.
        Guid doctorEntityId = Guid.Empty;
        await ExecuteWithDbContextAsync(async dbContext =>
        {
            doctorEntityId = await dbContext.Doctors
                .AsNoTracking()
                .Where(d => d.UserId == userId)
                .Select(d => d.Id)
                .FirstAsync();
        });
        return doctorEntityId;
    }

    /// <summary>
    /// Creates a verified patient account plus its profile row, returning both ids.
    /// </summary>
    /// <param name="label">A unique label used to build distinct credentials.</param>
    /// <returns>A tuple of the authenticated client, user id, and patient entity id.</returns>
    private async Task<(HttpClient Client, Guid UserId, Guid PatientId)> CreateAndLoginPatientAsync(string label)
    {
        // Register a fresh patient account with unique contact details.
        var client = _factory.CreateClient();
        string email = $"appts_patient_{label}_{Guid.NewGuid():N}@appoynt.com";
        var registerResponse = await client.PostAsJsonAsync("/api/auth/register", new RegisterRequest
        {
            FirstName = "Queue",
            LastName = label,
            Email = email,
            PhoneNumber = "010" + Random.Shared.Next(10000000, 99999999).ToString(),
            Password = "P@ssword123!",
            ConfirmPassword = "P@ssword123!"
        });
        registerResponse.StatusCode.Should().Be(HttpStatusCode.Created);
        var registerBody = await registerResponse.Content.ReadFromJsonAsync<RegisterResponse>();

        // Confirm the phone through the fixed development OTP, then log in.
        await client.PostAsJsonAsync("/api/auth/otp/verify", new VerifyOtpRequest
        {
            ChallengeId = registerBody!.ChallengeId,
            Code = DevelopmentOtpCode
        });
        var loginResponse = await client.PostAsJsonAsync("/api/auth/login", new LoginRequest
        {
            Identifier = email,
            Password = "P@ssword123!"
        });
        loginResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var loginBody = await loginResponse.Content.ReadFromJsonAsync<LoginResponse>();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loginBody!.AccessToken);

        // Resolve the patient profile row bound to this user account.
        Guid patientEntityId = Guid.Empty;
        await ExecuteWithDbContextAsync(async dbContext =>
        {
            patientEntityId = await dbContext.Patients
                .AsNoTracking()
                .Where(p => p.UserId == registerBody.UserId)
                .Select(p => p.Id)
                .FirstAsync();
        });

        return (client, registerBody.UserId, patientEntityId);
    }

    /// <summary>
    /// Creates an active clinic for the doctor with one weekly period so slot
    /// generation produces bookable inventory.
    /// </summary>
    /// <param name="doctorClient">A client authenticated as the owning doctor.</param>
    /// <param name="suffix">A unique label for the clinic name.</param>
    /// <param name="startTime">Period start override to avoid cross-clinic overlap.</param>
    /// <param name="endTime">Period end override to avoid cross-clinic overlap.</param>
    /// <returns>The created clinic identifier.</returns>
    private async Task<Guid> CreateClinicWithSlotsAsync(
        HttpClient doctorClient,
        string suffix,
        string startTime = "09:00",
        string endTime = "12:00")
    {
        // Resolve seeded location identifiers.
        var govResponse = await doctorClient.GetAsync("/api/governorates");
        var governorates = await govResponse.Content.ReadFromJsonAsync<List<GovernorateResponse>>();
        var cairo = governorates!.First(g => g.NameEn == "Cairo");
        var citiesResponse = await doctorClient.GetAsync($"/api/governorates/{cairo.Id}/cities");
        var cities = await citiesResponse.Content.ReadFromJsonAsync<List<CityResponse>>();

        // Create the clinic with a Monday period so slots land on known dates.
        var createResponse = await doctorClient.PostAsJsonAsync("/api/clinics", new CreateClinicRequest
        {
            Name = $"Appointments Clinic {suffix}",
            GovernorateId = cairo.Id,
            CityId = cities!.First().Id,
            ConsultationFee = 200m,
            AppointmentDurationMinutes = 30,
            MaxAdvanceBookingDays = 14,
            WorkingPeriods =
            [
                new WorkingPeriodRequest { DayOfWeek = (int)DayOfWeek.Monday, StartTime = startTime, EndTime = endTime }
            ]
        });
        createResponse.StatusCode.Should().Be(HttpStatusCode.Created);
        var json = await createResponse.Content.ReadFromJsonAsync<System.Text.Json.JsonElement>();
        return json.GetProperty("clinicId").GetGuid();
    }

    /// <summary>
    /// Creates an active clinic whose weekly period falls on TODAY so generated
    /// slots exist on the current date, matching the /current board's day scope.
    /// </summary>
    /// <param name="doctorClient">A client authenticated as the owning doctor.</param>
    /// <param name="suffix">A unique label for the clinic name.</param>
    /// <param name="startTime">Period start override for multi-clinic overlap safety.</param>
    /// <param name="endTime">Period end override for multi-clinic overlap safety.</param>
    /// <returns>The created clinic identifier plus today's date.</returns>
    private async Task<(Guid ClinicId, DateOnly Today)> CreateTodayClinicWithSlotsAsync(
        HttpClient doctorClient,
        string suffix,
        string startTime = "09:00",
        string endTime = "12:00")
    {
        // Anchor the recurring period on today's weekday.
        var today = DateOnly.FromDateTime(DateTime.UtcNow);

        // Resolve seeded location identifiers.
        var govResponse = await doctorClient.GetAsync("/api/governorates");
        var governorates = await govResponse.Content.ReadFromJsonAsync<List<GovernorateResponse>>();
        var cairo = governorates!.First(g => g.NameEn == "Cairo");
        var citiesResponse = await doctorClient.GetAsync($"/api/governorates/{cairo.Id}/cities");
        var cities = await citiesResponse.Content.ReadFromJsonAsync<List<CityResponse>>();

        // Create the clinic bound to today's weekday.
        var createResponse = await doctorClient.PostAsJsonAsync("/api/clinics", new CreateClinicRequest
        {
            Name = $"Today Clinic {suffix}",
            GovernorateId = cairo.Id,
            CityId = cities!.First().Id,
            ConsultationFee = 200m,
            AppointmentDurationMinutes = 30,
            MaxAdvanceBookingDays = 14,
            WorkingPeriods =
            [
                new WorkingPeriodRequest { DayOfWeek = (int)today.DayOfWeek, StartTime = startTime, EndTime = endTime }
            ]
        });
        createResponse.StatusCode.Should().Be(HttpStatusCode.Created);
        var json = await createResponse.Content.ReadFromJsonAsync<System.Text.Json.JsonElement>();
        return (json.GetProperty("clinicId").GetGuid(), today);
    }

    /// <summary>
    /// Computes the next Monday strictly after today, matching generated slots.
    /// </summary>
    /// <returns>The next upcoming Monday date.</returns>
    private static DateOnly NextMonday()
    {
        // Walk forward until the weekday becomes Monday.
        var date = DateOnly.FromDateTime(DateTime.UtcNow);
        while (date.DayOfWeek != DayOfWeek.Monday)
        {
            date = date.AddDays(1);
        }
        return date;
    }

    /// <summary>
    /// Seeds an appointment directly against an existing generated slot.
    /// Direct seeding stands in for the deferred ConfirmBooking write path.
    /// </summary>
    /// <param name="clinicId">The owning clinic.</param>
    /// <param name="patientId">The patient profile identifier.</param>
    /// <param name="date">The target Monday date holding generated slots.</param>
    /// <param name="slotIndex">Zero-based index into the day's time-ordered slots.</param>
    /// <param name="status">The lifecycle status to seed.</param>
    /// <param name="type">The booking type to seed.</param>
    /// <returns>The seeded appointment identifier.</returns>
    private async Task<Guid> SeedAppointmentAsync(
        Guid clinicId,
        Guid patientId,
        DateOnly date,
        int slotIndex,
        AppointmentStatus status,
        BookingType type = BookingType.New)
    {
        // Persist through a scoped context sharing the host database.
        Guid appointmentId = Guid.Empty;
        await ExecuteWithDbContextAsync(async dbContext =>
        {
            // Load the day's ordered slots and bind to the requested position.
            var slot = await dbContext.AppointmentSlots
                .Include(s => s.Clinic)
                .Where(s => s.ClinicId == clinicId && s.Date == date)
                .OrderBy(s => s.StartTime)
                .Skip(slotIndex)
                .FirstAsync();

            // Reserve it as booked so the panel joins reflect reality.
            slot.Status = SlotStatus.Booked;

            // Load the patient profile with its user for required navigation.
            var patient = await dbContext.Patients
                .Include(p => p.User)
                .FirstAsync(p => p.Id == patientId);

            // Compose the appointment copying denormalized fields from the slot.
            var appointment = new Appointment
            {
                Id = Guid.NewGuid(),
                PatientId = patientId,
                Patient = patient,
                AppointmentSlotId = slot.Id,
                AppointmentSlot = slot,
                ClinicId = clinicId,
                Clinic = slot.Clinic,
                Date = slot.Date,
                Type = type,
                Status = status
            };
            dbContext.Appointments.Add(appointment);
            await dbContext.SaveChangesAsync();
            appointmentId = appointment.Id;
        });
        return appointmentId;
    }

    /// <summary>
    /// Runs an action against the application's own database context.
    /// </summary>
    /// <param name="action">The database operation to execute.</param>
    private async Task ExecuteWithDbContextAsync(Func<ApplicationDbContext, Task> action)
    {
        // Open a DI scope sharing the same SQLite database as the host.
        using var scope = _factory.Services.CreateScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
        await action(dbContext);
    }

    #endregion

    #region Current Board & Queue

    /// <summary>
    /// An empty day renders no current patient and an empty queue.
    /// </summary>
    [Fact]
    public async Task GetCurrent_NoSeededAppointments_ReturnsEmptyBoard()
    {
        // Arrange a doctor with a clinic and no appointments today.
        var (doctorClient, userId) = await CreateAndLoginDoctorAsync("EmptyBoard");
        var doctorId = await ResolveDoctorEntityIdAsync(userId);
        var clinicId = await CreateClinicWithSlotsAsync(doctorClient, "EmptyBoard");

        // Act reading the board.
        var response = await doctorClient.GetAsync($"/api/doctor/appointments/current?clinicId={clinicId}");

        // Assert the empty shape.
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var board = await response.Content.ReadFromJsonAsync<CurrentAppointmentsDto>();
        board!.CurrentPatient.Should().BeNull();
        board.Queue.Should().BeEmpty();
        board.QueueHasMore.Should().BeFalse();
        board.QueueTotalCount.Should().Be(0);
    }

    /// <summary>
    /// The full lifecycle moves a patient from queue to current card to completion.
    /// </summary>
    [Fact]
    public async Task Lifecycle_StartThenEnd_UpdatesStateAndBoard()
    {
        // Arrange a doctor, clinic, patient, and one upcoming appointment.
        var (doctorClient, userId) = await CreateAndLoginDoctorAsync("Lifecycle");
        var doctorId = await ResolveDoctorEntityIdAsync(userId);
        var (clinicId, today) = await CreateTodayClinicWithSlotsAsync(doctorClient, "Lifecycle");
        var (_, _, patientId) = await CreateAndLoginPatientAsync("LifecycleP");
        Guid appointmentId = await SeedAppointmentAsync(clinicId, patientId, today, 0, AppointmentStatus.Upcoming);

        // Pre-state: the patient waits inside the queue.
        var preResponse = await doctorClient.GetAsync($"/api/doctor/appointments/current?clinicId={clinicId}");
        var preBoard = await preResponse.Content.ReadFromJsonAsync<CurrentAppointmentsDto>();
        preBoard!.QueueTotalCount.Should().Be(1,
            because: "seeded visit must appear; http={0} body={1} today={2}",
            (int)preResponse.StatusCode,
            await preResponse.Content.ReadAsStringAsync(),
            today);

        // Act starting the consultation.
        var startResponse = await doctorClient.PutAsJsonAsync($"/api/doctor/appointments/{appointmentId}/start", new { });

        // Assert the transition stamps the start time and promotes the card.
        startResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var started = await startResponse.Content.ReadFromJsonAsync<AppointmentStateDto>();
        started!.Status.Should().Be(AppointmentStatus.InConsultation);
        started.ActualStartTimeUtc.Should().NotBeNull();

        var duringBoard = await (await doctorClient.GetAsync($"/api/doctor/appointments/current?clinicId={clinicId}"))
            .Content.ReadFromJsonAsync<CurrentAppointmentsDto>();
        using (new AssertionScope())
        {
            duringBoard!.CurrentPatient.Should().NotBeNull();
            duringBoard.CurrentPatient!.AppointmentId.Should().Be(appointmentId);
            duringBoard.CurrentPatient.PhoneNumber.Should().NotBeNullOrEmpty();
            duringBoard.CurrentPatient.ExpectedTime.Should().EndWith(":00");
            duringBoard.Queue.Should().BeEmpty();
        }

        // Act ending the consultation.
        var endResponse = await doctorClient.PutAsJsonAsync($"/api/doctor/appointments/{appointmentId}/end", new { });

        // Assert completion stamps the end time and empties the card again.
        endResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var ended = await endResponse.Content.ReadFromJsonAsync<AppointmentStateDto>();
        ended!.Status.Should().Be(AppointmentStatus.Completed);
        ended.ActualEndTimeUtc.Should().NotBeNull();

        var postBoard = await (await doctorClient.GetAsync($"/api/doctor/appointments/current?clinicId={clinicId}"))
            .Content.ReadFromJsonAsync<CurrentAppointmentsDto>();
        postBoard!.CurrentPatient.Should().BeNull();
        postBoard.QueueTotalCount.Should().Be(0);
    }

    /// <summary>
    /// The queue is backend-paginated, ordered by slot time, with truthful paging flags.
    /// </summary>
    [Fact]
    public async Task GetCurrent_SevenUpcoming_PaginatesAndOrdersBySlotTime()
    {
        // Arrange seven upcoming appointments across consecutive morning slots.
        var (doctorClient, userId) = await CreateAndLoginDoctorAsync("Pagination");
        var doctorId = await ResolveDoctorEntityIdAsync(userId);
        var (clinicId, today) = await CreateTodayClinicWithSlotsAsync(doctorClient, "Pagination", startTime: "09:00", endTime: "13:00");
        var (_, _, patientId) = await CreateAndLoginPatientAsync("Pager");

        for (int index = 0; index < 7; index++)
        {
            await SeedAppointmentAsync(clinicId, patientId, today, index, AppointmentStatus.Upcoming);
        }

        // Act requesting a five-item page.
        var pageOne = await (await doctorClient.GetAsync($"/api/doctor/appointments/current?clinicId={clinicId}&take=5"))
            .Content.ReadFromJsonAsync<CurrentAppointmentsDto>();

        // Assert page metadata, size, and strict time ordering hold.
        pageOne!.Queue.Should().HaveCount(5);
        pageOne.QueueHasMore.Should().BeTrue();
        pageOne.QueueTotalCount.Should().Be(7);
        pageOne.Queue.Select(q => q.ExpectedTime).Should().BeInAscendingOrder();

        // A page beyond capacity returns everything without the more-flag.
        var pageFull = await (await doctorClient.GetAsync($"/api/doctor/appointments/current?clinicId={clinicId}&take=50"))
            .Content.ReadFromJsonAsync<CurrentAppointmentsDto>();
        pageFull!.Queue.Should().HaveCount(7);
        pageFull.QueueHasMore.Should().BeFalse();
    }

    /// <summary>
    /// The follow-up booking type flag surfaces through the queue payload.
    /// </summary>
    [Fact]
    public async Task GetCurrent_FollowUpType_SurfacesInQueuePayload()
    {
        // Arrange one follow-up appointment.
        var (doctorClient, userId) = await CreateAndLoginDoctorAsync("FollowUpFlag");
        var doctorId = await ResolveDoctorEntityIdAsync(userId);
        var (clinicId, today) = await CreateTodayClinicWithSlotsAsync(doctorClient, "FollowUpFlag");
        var (_, _, patientId) = await CreateAndLoginPatientAsync("Follower");
        await SeedAppointmentAsync(clinicId, patientId, today, 0, AppointmentStatus.Upcoming, BookingType.FollowUp);

        // Act reading the board.
        var board = await (await doctorClient.GetAsync($"/api/doctor/appointments/current?clinicId={clinicId}"))
            .Content.ReadFromJsonAsync<CurrentAppointmentsDto>();

        // Assert the badge value flowed through untouched.
        board!.Queue.Single().BookingType.Should().Be(BookingType.FollowUp);
    }

    #endregion

    #region Lifecycle Guards

    /// <summary>
    /// Starting while another appointment of the SAME DOCTOR is already in
    /// consultation - even at a different owned clinic - is rejected.
    /// </summary>
    [Fact]
    public async Task StartConsultation_ConcurrentAcrossOwnedClinics_ReturnsAlreadyInConsultation()
    {
        // Arrange two clinics (non-overlapping windows) each holding one upcoming visit.
        var (doctorClient, userId) = await CreateAndLoginDoctorAsync("DoubleStart");
        var doctorId = await ResolveDoctorEntityIdAsync(userId);
        var (clinicA, today) = await CreateTodayClinicWithSlotsAsync(doctorClient, "DoubleStartA", "09:00", "12:00");
        var clinicB = (await CreateTodayClinicWithSlotsAsync(doctorClient, "DoubleStartB", "13:00", "16:00")).ClinicId;
        var (_, _, patientId) = await CreateAndLoginPatientAsync("DualVisitor");
        Guid appointmentA = await SeedAppointmentAsync(clinicA, patientId, today, 0, AppointmentStatus.Upcoming);
        Guid appointmentB = await SeedAppointmentAsync(clinicB, patientId, today, 0, AppointmentStatus.Upcoming);

        // Begin the first consultation successfully.
        var firstStart = await doctorClient.PutAsJsonAsync($"/api/doctor/appointments/{appointmentA}/start", new { });
        firstStart.StatusCode.Should().Be(HttpStatusCode.OK);

        // Act attempting the simultaneous second consultation.
        var secondStart = await doctorClient.PutAsJsonAsync($"/api/doctor/appointments/{appointmentB}/start", new { });
        var body = await secondStart.Content.ReadFromJsonAsync<ErrorEnvelope>();

        // Assert the per-doctor guard fires with the stable code.
        secondStart.StatusCode.Should().Be(HttpStatusCode.Conflict);
        body!.Errors.Should().Contain(error => error.Code == "appointment.already_in_consultation");
    }

    /// <summary>
    /// Re-starting an appointment that is already InConsultation is rejected.
    /// </summary>
    [Fact]
    public async Task StartConsultation_AlreadyStarted_ReturnsInvalidTransition()
    {
        // Arrange a live consultation.
        var (doctorClient, userId) = await CreateAndLoginDoctorAsync("RestartGuard");
        var doctorId = await ResolveDoctorEntityIdAsync(userId);
        var (clinicId, today) = await CreateTodayClinicWithSlotsAsync(doctorClient, "RestartGuard");
        var (_, _, patientId) = await CreateAndLoginPatientAsync("Restarter");
        Guid appointmentId = await SeedAppointmentAsync(clinicId, patientId, today, 0, AppointmentStatus.Upcoming);
        await doctorClient.PutAsJsonAsync($"/api/doctor/appointments/{appointmentId}/start", new { });

        // Act starting the same consultation again.
        var restartResponse = await doctorClient.PutAsJsonAsync($"/api/doctor/appointments/{appointmentId}/start", new { });
        var body = await restartResponse.Content.ReadFromJsonAsync<ErrorEnvelope>();

        // Assert the state machine refuses the redundant transition.
        restartResponse.StatusCode.Should().Be(HttpStatusCode.Conflict);
        body!.Errors.Should().Contain(error => error.Code == "appointment.invalid_transition");
    }

    /// <summary>
    /// Ending an appointment that never entered consultation is rejected.
    /// </summary>
    [Fact]
    public async Task EndConsultation_NotStarted_ReturnsInvalidTransition()
    {
        // Arrange an appointment still waiting in the queue.
        var (doctorClient, userId) = await CreateAndLoginDoctorAsync("EarlyEnd");
        var doctorId = await ResolveDoctorEntityIdAsync(userId);
        var (clinicId, today) = await CreateTodayClinicWithSlotsAsync(doctorClient, "EarlyEnd");
        var (_, _, patientId) = await CreateAndLoginPatientAsync("EarlyEnder");
        Guid appointmentId = await SeedAppointmentAsync(clinicId, patientId, today, 0, AppointmentStatus.Upcoming);

        // Act ending before any start.
        var endResponse = await doctorClient.PutAsJsonAsync($"/api/doctor/appointments/{appointmentId}/end", new { });
        var body = await endResponse.Content.ReadFromJsonAsync<ErrorEnvelope>();

        // Assert the premature transition is refused.
        endResponse.StatusCode.Should().Be(HttpStatusCode.Conflict);
        body!.Errors.Should().Contain(error => error.Code == "appointment.invalid_transition");
    }

    #endregion

    #region Ownership Hiding (IDOR)

    /// <summary>
    /// Another doctor's clinic reads as not-found across every scoped endpoint.
    /// </summary>
    [Fact]
    public async Task ForeignClinic_Reads_ReturnsNotFoundEverywhere()
    {
        // Arrange doctor A owning a clinic and doctor B probing it.
        var (doctorAClient, doctorAUserId) = await CreateAndLoginDoctorAsync("OwnerDoc");
        var doctorAId = await ResolveDoctorEntityIdAsync(doctorAUserId);
        var clinicA = await CreateClinicWithSlotsAsync(doctorAClient, "Owned");
        var (doctorBClient, _) = await CreateAndLoginDoctorAsync("ProbeDoc");
        var monday = NextMonday();

        // Act probing all three scoped reads as doctor B.
        var currentResponse = await doctorBClient.GetAsync($"/api/doctor/appointments/current?clinicId={clinicA}");
        var slotsResponse = await doctorBClient.GetAsync($"/api/doctor/appointments/slots?clinicId={clinicA}&date={monday:yyyy-MM-dd}");
        var datesResponse = await doctorBClient.GetAsync($"/api/doctor/appointments/slots/available-dates?clinicId={clinicA}");

        // Assert existence stays hidden behind uniform 404 responses.
        currentResponse.StatusCode.Should().Be(HttpStatusCode.NotFound);
        slotsResponse.StatusCode.Should().Be(HttpStatusCode.NotFound);
        datesResponse.StatusCode.Should().Be(HttpStatusCode.NotFound);
    }

    /// <summary>
    /// Starting another doctor's appointment reports not-found, never conflict,
    /// so foreign resources stay indistinguishable from missing ones.
    /// </summary>
    [Fact]
    public async Task StartConsultation_ForeignAppointment_ReturnsNotFound()
    {
        // Arrange doctor A with a queued appointment and doctor B targeting it.
        var (doctorAClient, doctorAUserId) = await CreateAndLoginDoctorAsync("ApptOwner");
        var doctorAId = await ResolveDoctorEntityIdAsync(doctorAUserId);
        var clinicA = await CreateClinicWithSlotsAsync(doctorAClient, "ApptOwner");
        var monday = NextMonday();
        var (_, _, patientId) = await CreateAndLoginPatientAsync("HiddenVisit");
        Guid hiddenAppointment = await SeedAppointmentAsync(clinicA, patientId, monday, 0, AppointmentStatus.Upcoming);

        var (doctorBClient, _) = await CreateAndLoginDoctorAsync("ApptAttacker");

        // Act starting the foreign appointment.
        var response = await doctorBClient.PutAsJsonAsync($"/api/doctor/appointments/{hiddenAppointment}/start", new { });

        // Assert the ownership guard hides the record entirely.
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);
    }

    #endregion

    #region Slots Panel & Calendar

    /// <summary>
    /// Display statuses join SlotStatus inventory with appointment lifecycle,
    /// including effective expiry for stale pending locks.
    /// </summary>
    [Fact]
    public async Task GetSlots_MixedSlotStates_MapsDisplayStatusesCorrectly()
    {
        // Arrange a clinic whose Monday carries six slots in varied states.
        var (doctorClient, userId) = await CreateAndLoginDoctorAsync("Panel");
        var doctorId = await ResolveDoctorEntityIdAsync(userId);
        var clinicId = await CreateClinicWithSlotsAsync(doctorClient, "Panel");
        var monday = NextMonday();
        var (_, _, patientId) = await CreateAndLoginPatientAsync("PanelPatient");

        Guid freeSlot = Guid.Empty, liveLockSlot = Guid.Empty, staleLockSlot = Guid.Empty,
             bookedSlot = Guid.Empty, consultSlot = Guid.Empty, breakSlot = Guid.Empty;

        await ExecuteWithDbContextAsync(async dbContext =>
        {
            // Pull the day's ordered slots once for deterministic assignment.
            var slots = await dbContext.AppointmentSlots
                .Include(s => s.Clinic)
                .Where(s => s.ClinicId == clinicId && s.Date == monday)
                .OrderBy(s => s.StartTime)
                .ToListAsync();
            slots.Count.Should().BeGreaterThanOrEqualTo(6);

            // Load the patient profile once for the seeded visits' navigation.
            var panelPatient = await dbContext.Patients
                .Include(p => p.User)
                .FirstAsync(p => p.Id == patientId);

            // Slot 0 stays Available.
            freeSlot = slots[0].Id;

            // Slot 1 holds a LIVE pending lock.
            slots[1].Status = SlotStatus.Pending;
            slots[1].HeldByUserId = null;
            slots[1].ExpiresAtUtc = DateTime.UtcNow.AddMinutes(10);
            liveLockSlot = slots[1].Id;

            // Slot 2 holds an EXPIRED pending lock presented as free.
            slots[2].Status = SlotStatus.Pending;
            slots[2].ExpiresAtUtc = DateTime.UtcNow.AddMinutes(-5);
            staleLockSlot = slots[2].Id;

            // Slot 3 is booked by an upcoming visit.
            slots[3].Status = SlotStatus.Booked;
            var bookedVisit = new Appointment
            {
                Id = Guid.NewGuid(),
                PatientId = patientId,
                Patient = panelPatient,
                AppointmentSlotId = slots[3].Id,
                AppointmentSlot = slots[3],
                ClinicId = clinicId,
                Clinic = slots[3].Clinic,
                Date = monday,
                Type = BookingType.New,
                Status = AppointmentStatus.Upcoming
            };
            dbContext.Appointments.Add(bookedVisit);
            bookedSlot = slots[3].Id;

            // Slot 4 is booked by a visit currently in consultation.
            slots[4].Status = SlotStatus.Booked;
            var activeVisit = new Appointment
            {
                Id = Guid.NewGuid(),
                PatientId = patientId,
                Patient = panelPatient,
                AppointmentSlotId = slots[4].Id,
                AppointmentSlot = slots[4],
                ClinicId = clinicId,
                Clinic = slots[4].Clinic,
                Date = monday,
                Type = BookingType.New,
                Status = AppointmentStatus.InConsultation,
                ActualStartTimeUtc = DateTime.UtcNow.AddMinutes(-10)
            };
            dbContext.Appointments.Add(activeVisit);
            consultSlot = slots[4].Id;

            // Slot 5 sits inside a baked break window.
            slots[5].Status = SlotStatus.Unavailable;
            breakSlot = slots[5].Id;

            await dbContext.SaveChangesAsync();
        });

        // Act reading the doctor's day panel.
        var response = await doctorClient.GetAsync($"/api/doctor/appointments/slots?clinicId={clinicId}&date={monday:yyyy-MM-dd}");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var panel = await response.Content.ReadFromJsonAsync<List<DoctorDashboardSlotDto>>();

        // Assert every computed label lands exactly where expected.
        using (new AssertionScope())
        {
            panel!.Single(s => s.SlotId == freeSlot).DisplayStatus.Should().Be("Available");
            panel.Single(s => s.SlotId == liveLockSlot).DisplayStatus.Should().Be("Pending");
            panel.Single(s => s.SlotId == staleLockSlot).DisplayStatus.Should().Be("Available");
            panel.Single(s => s.SlotId == bookedSlot).DisplayStatus.Should().Be("Booked");
            panel.Single(s => s.SlotId == consultSlot).DisplayStatus.Should().Be("InConsultation");
            panel.Single(s => s.SlotId == breakSlot).DisplayStatus.Should().Be("Break");
            panel.Should().OnlyContain(s => s.StartTime.Length == 5 && s.EndTime.Length == 5);
        }
    }

    /// <summary>
    /// The doctor calendar lists working weekdays bounded by the clinic horizon.
    /// </summary>
    [Fact]
    public async Task GetAvailableDates_ListsWorkingMondaysWithinClinicHorizon()
    {
        // Arrange a Monday-only clinic with a fourteen-day horizon.
        var (doctorClient, userId) = await CreateAndLoginDoctorAsync("Calendar");
        var doctorId = await ResolveDoctorEntityIdAsync(userId);
        var clinicId = await CreateClinicWithSlotsAsync(doctorClient, "Calendar");
        var monday = NextMonday();

        // Act reading the picker dates.
        var response = await doctorClient.GetAsync($"/api/doctor/appointments/slots/available-dates?clinicId={clinicId}");

        // Assert only working weekdays appear inside the window bounds.
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var dates = (await response.Content.ReadFromJsonAsync<Appoynt.Application.Features.Booking.Contracts.AvailableDatesResponseDto>())!;
        dates.AvailableDates.Should().NotBeEmpty();
        dates.AvailableDates.Should().OnlyContain(date => date.DayOfWeek == DayOfWeek.Monday);
        dates.AvailableDates.Should().BeInAscendingOrder();
        dates.AvailableDates.First().Should().BeOnOrAfter(DateOnly.FromDateTime(DateTime.UtcNow));
        dates.AvailableDates.Last().Should().BeOnOrBefore(monday.AddDays(13));
    }

    #endregion

    /// <summary>
    /// Local shape mirroring the unified error envelope used across the API.
    /// </summary>
    private sealed class ErrorEnvelope
    {
        /// <summary>
        /// Gets the structured error list carried by failed operations.
        /// </summary>
        public List<Appoynt.Application.Common.Models.AuthenticationError> Errors { get; init; } = [];
    }
}

