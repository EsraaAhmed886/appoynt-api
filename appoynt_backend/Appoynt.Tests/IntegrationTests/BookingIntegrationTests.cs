/**
 * File Name      : BookingIntegrationTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-25
 * Version        : v1.0.0
 * Dependencies   : WebApplicationFactory, ApplicationDbContext, FluentAssertions,
 *                  Booking Contracts, Clinic Contracts
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-25
 * Description    : Integration tests for the patient booking screen covering the
 *                  atomic slot lock workflow (idempotency, auto-switching, failure
 *                  preservation), time and clinic-state guards, effective-status
 *                  projection for expired locks, default-clinic promotion rules,
 *                  database-level default uniqueness, and concurrent lock races.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Authentication.Login.Contracts;
using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Application.Features.Authentication.Registration.Contracts;
using Appoynt.Application.Features.Booking.Contracts;
using Appoynt.Application.Features.Clinics.Contracts;
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
/// Integration tests for the patient booking endpoints and slot locking workflow.
/// </summary>
[Collection("Sequential")]
public sealed class BookingIntegrationTests : IClassFixture<WebApplicationFactory<Appoynt.API.Program>>
{
    // Fixed development OTP accepted by the OTP service in test environments.
    private const string DevelopmentOtpCode = "123456";

    // Factory hosting the API under test with an isolated database.
    private readonly WebApplicationFactory<Appoynt.API.Program> _factory;

    /// <summary>
    /// Initializes the test factory with isolated storage and relaxed limits.
    /// </summary>
    /// <param name="factory">The shared host factory provided by xUnit.</param>
    public BookingIntegrationTests(WebApplicationFactory<Appoynt.API.Program> factory)
    {
        _factory = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureAppConfiguration((context, config) =>
            {
                config.AddInMemoryCollection(new Dictionary<string, string?>
                {
                    ["DatabaseProvider"] = "Sqlite",
                    ["ConnectionStrings:DefaultConnection"] = "DataSource=file:appoynt_booking_test.db?mode=memory&cache=shared",
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
    /// Creates a verified patient account and returns an authenticated client.
    /// </summary>
    /// <param name="label">A unique label used to build distinct credentials.</param>
    /// <returns>A client authenticated as the new patient.</returns>
    private async Task<HttpClient> CreateAndLoginPatientAsync(string label)
    {
        // Register a fresh patient account with unique contact details.
        var client = _factory.CreateClient();
        string email = $"booker.{label}.{Guid.NewGuid():N}@appoynt.com";
        var registerResponse = await client.PostAsJsonAsync("/api/auth/register", new RegisterRequest
        {
            FirstName = "Booker",
            LastName = label,
            Email = email,
            PhoneNumber = "010" + Random.Shared.Next(10000000, 99999999).ToString(),
            Password = "P@ssword123!",
            ConfirmPassword = "P@ssword123!"
        });
        registerResponse.StatusCode.Should().Be(HttpStatusCode.Created);

        // Confirm the phone through the fixed development OTP, then log in.
        var registerBody = await registerResponse.Content.ReadFromJsonAsync<RegisterResponse>();
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
        return client;
    }

    /// <summary>
    /// Creates a doctor account through the admin endpoint and logs in as them.
    /// </summary>
    /// <param name="suffix">A unique label for the doctor identity.</param>
    /// <returns>A tuple of the doctor's client and identifier.</returns>
    private async Task<(HttpClient Client, Guid DoctorId)> CreateAndLoginDoctorAsync(string suffix)
    {
        // Bootstrap an admin session to provision the doctor account.
        var bootstrapClient = _factory.CreateClient();
        var adminToken = await AuthenticateAdminAsync(bootstrapClient);
        bootstrapClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminToken);

        // Build the doctor creation payload with unique credentials.
        string email = $"booking_doctor_{suffix}_{Guid.NewGuid():N}@appoynt.com";
        var createResponse = await bootstrapClient.PostAsJsonAsync("/api/users/doctors", new CreateDoctorRequest
        {
            FirstName = "Booking",
            LastName = $"Doc{suffix}",
            NameAr = $"د. حجز {suffix}",
            NameEn = $"Dr. Booking {suffix}",
            Email = email,
            PhoneNumber = "+2010" + Random.Shared.Next(10000000, 99999999).ToString(),
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
    /// Resolves the Doctor ENTITY identifier for a user account identifier,
    /// since staff creation endpoints return the identity-user identifier.
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
    /// Creates an active clinic for the doctor with one weekly morning period so
    /// slot generation produces bookable inventory.
    /// </summary>
    /// <param name="doctorClient">A client authenticated as the owning doctor.</param>
    /// <param name="suffix">A unique label for the clinic name.</param>
    /// <param name="startTime">Period start; override to avoid cross-clinic overlap.</param>
    /// <param name="endTime">Period end; override to avoid cross-clinic overlap.</param>
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
            Name = $"Booking Clinic {suffix}",
            GovernorateId = cairo.Id,
            CityId = cities!.First().Id,
            ConsultationFee = 250m,
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
    /// Fetches the public day view for a clinic anonymously.
    /// </summary>
    /// <param name="clinicId">The clinic identifier.</param>
    /// <param name="date">The requested date.</param>
    /// <returns>The mapped slot DTO list.</returns>
    private async Task<List<ClinicSlotDto>> GetDaySlotsAsync(Guid clinicId, DateOnly date)
    {
        // Anonymous client mirrors real guest browsing.
        var guestClient = _factory.CreateClient();
        return await GetDaySlotsAsync(guestClient, clinicId, date);
    }

    /// <summary>
    /// Fetches the public day view using a specific client so own-lock
    /// indicators resolve for the calling patient.
    /// </summary>
    /// <param name="client">The HTTP client whose identity applies.</param>
    /// <param name="clinicId">The clinic identifier.</param>
    /// <param name="date">The requested date.</param>
    /// <returns>The mapped slot DTO list.</returns>
    private async Task<List<ClinicSlotDto>> GetDaySlotsAsync(HttpClient client, Guid clinicId, DateOnly date)
    {
        // Execute the real-time read with the supplied identity context.
        var response = await client.GetAsync($"/api/booking/clinics/{clinicId}/slots?date={date:yyyy-MM-dd}");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        return await response.Content.ReadFromJsonAsync<List<ClinicSlotDto>>() ?? [];
    }

    /// <summary>
    /// Locks the first available slot of a day and returns its identifier.
    /// </summary>
    /// <param name="patientClient">An authenticated patient client.</param>
    /// <param name="clinicId">The clinic identifier.</param>
    /// <param name="date">The target date.</param>
    /// <returns>The locked slot's identifier.</returns>
    private async Task<Guid> LockFirstAvailableAsync(HttpClient patientClient, Guid clinicId, DateOnly date)
    {
        // Read the day view to find open capacity.
        var slots = await GetDaySlotsAsync(clinicId, date);
        var target = slots.First(slot => slot.Status == "Available");

        // Acquire the lock through the mutation endpoint.
        var lockResponse = await patientClient.PostAsync($"/api/booking/slots/{target.SlotId}/lock", null);
        lockResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        return target.SlotId;
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

    #region Slot Lock Workflow

    /// <summary>
    /// A successful lock marks the slot pending and reports a full countdown window.
    /// </summary>
    [Fact]
    public async Task LockSlot_AvailableSlot_ReturnsPendingLockWithCountdown()
    {
        // Arrange a doctor clinic plus an authenticated patient.
        var (doctorClient, _) = await CreateAndLoginDoctorAsync("LockSuccess");
        var clinicId = await CreateClinicWithSlotsAsync(doctorClient, "LockSuccess");
        var monday = NextMonday();
        var patient = await CreateAndLoginPatientAsync("LockWinner");

        // Act locking the first open slot of the next Monday.
        var slots = await GetDaySlotsAsync(clinicId, monday);
        slots.Should().NotBeEmpty();
        var target = slots.First(slot => slot.Status == "Available");
        var lockResponse = await patient.PostAsync($"/api/booking/slots/{target.SlotId}/lock", null);

        // Assert the lock payload carries a fresh fifteen-minute countdown.
        lockResponse.StatusCode.Should().Be(HttpStatusCode.OK,
            because: "lock must succeed; body: {0}",
            await lockResponse.Content.ReadAsStringAsync());
        var lockBody = await lockResponse.Content.ReadFromJsonAsync<SlotLockResponseDto>();
        lockBody!.SlotId.Should().Be(target.SlotId);
        lockBody.RemainingSeconds.Should().BeInRange(880, 900);
        lockBody.ExpiresAt.Should().BeWithin(TimeSpan.FromSeconds(905)).After(DateTime.UtcNow);

        // The public day view now reflects the pending state.
        var refreshed = await GetDaySlotsAsync(clinicId, monday);
        refreshed.First(slot => slot.SlotId == target.SlotId).Status.Should().Be("Pending");
    }

    /// <summary>
    /// A slot locked by one patient yields a conflict when another patient tries it.
    /// </summary>
    [Fact]
    public async Task LockSlot_HeldByOtherPatient_ReturnsConflict()
    {
        // Arrange two independent patients competing over the same inventory.
        var (doctorClient, _) = await CreateAndLoginDoctorAsync("LockConflict");
        var clinicId = await CreateClinicWithSlotsAsync(doctorClient, "LockConflict");
        var monday = NextMonday();
        var firstPatient = await CreateAndLoginPatientAsync("ConflictA");
        var secondPatient = await CreateAndLoginPatientAsync("ConflictB");
        Guid slotId = await LockFirstAvailableAsync(firstPatient, clinicId, monday);

        // Act as the second patient targeting the already-pending slot.
        var conflictResponse = await secondPatient.PostAsync($"/api/booking/slots/{slotId}/lock", null);

        // Assert the unified error envelope carries the stable code.
        conflictResponse.StatusCode.Should().Be(HttpStatusCode.Conflict);
        var body = await conflictResponse.Content.ReadFromJsonAsync<ErrorEnvelope>();
        body!.Errors.Should().Contain(error => error.Code == "clinic.slot.not_available");
    }

    /// <summary>
    /// A slot that has already started or passed cannot be locked (time guard).
    /// </summary>
    [Fact]
    public async Task LockSlot_PastSlot_ReturnsConflict()
    {
        // Arrange inventory plus a hand-inserted slot dated yesterday.
        var (doctorClient, _) = await CreateAndLoginDoctorAsync("PastGuard");
        var clinicId = await CreateClinicWithSlotsAsync(doctorClient, "PastGuard");
        var patient = await CreateAndLoginPatientAsync("PastLocker");
        var yesterday = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(-1));
        Guid pastSlotId = Guid.Empty;

        await ExecuteWithDbContextAsync(async dbContext =>
        {
            // Clone an existing generated slot but shift it into the past.
            var template = await dbContext.AppointmentSlots
                .AsNoTracking()
                .FirstAsync(s => s.ClinicId == clinicId);
            var pastSlot = new AppointmentSlot
            {
                Id = Guid.NewGuid(),
                ClinicId = clinicId,
                Clinic = null!,
                Date = yesterday,
                StartTime = template.StartTime,
                EndTime = template.EndTime,
                Status = SlotStatus.Available
            };
            dbContext.AppointmentSlots.Add(pastSlot);
            await dbContext.SaveChangesAsync();
            pastSlotId = pastSlot.Id;
        });

        // Act attempting to lock the historical slot.
        var response = await patient.PostAsync($"/api/booking/slots/{pastSlotId}/lock", null);

        // Assert the time guard refuses the lock.
        response.StatusCode.Should().Be(HttpStatusCode.Conflict);
    }

    /// <summary>
    /// Re-locking the same slot keeps the ORIGINAL expiry - the countdown never resets.
    /// </summary>
    [Fact]
    public async Task LockSlot_ReLockSameSlot_PreservesOriginalExpiry()
    {
        // Arrange a patient holding a live lock.
        var (doctorClient, _) = await CreateAndLoginDoctorAsync("ReLock");
        var clinicId = await CreateClinicWithSlotsAsync(doctorClient, "ReLock");
        var monday = NextMonday();
        var patient = await CreateAndLoginPatientAsync("Relocker");
        Guid slotId = await LockFirstAvailableAsync(patient, clinicId, monday);

        // Capture the original expiry before reopening the same slot.
        var firstLock = await (await patient.PostAsync($"/api/booking/slots/{slotId}/lock", null))
            .Content.ReadFromJsonAsync<SlotLockResponseDto>();

        // Act re-locking the identical slot.
        var secondResponse = await patient.PostAsync($"/api/booking/slots/{slotId}/lock", null);

        // Assert the expiry is byte-identical - idempotent continuation.
        secondResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var secondLock = await secondResponse.Content.ReadFromJsonAsync<SlotLockResponseDto>();
        secondLock!.ExpiresAt.Should().Be(firstLock!.ExpiresAt);
    }

    /// <summary>
    /// Locking a different slot automatically frees the previously held one.
    /// </summary>
    [Fact]
    public async Task LockSlot_DifferentSlot_ReleasesPreviousLock()
    {
        // Arrange a patient holding one lock among several open slots.
        var (doctorClient, _) = await CreateAndLoginDoctorAsync("AutoSwitch");
        var clinicId = await CreateClinicWithSlotsAsync(doctorClient, "AutoSwitch");
        var monday = NextMonday();
        var patient = await CreateAndLoginPatientAsync("Switcher");
        var slots = await GetDaySlotsAsync(clinicId, monday);
        var firstTarget = slots.First(slot => slot.Status == "Available");
        var secondTarget = slots.First(slot => slot.Status == "Available" && slot.SlotId != firstTarget.SlotId);

        // Hold the first slot, then acquire the second.
        await patient.PostAsync($"/api/booking/slots/{firstTarget.SlotId}/lock", null);
        var switchResponse = await patient.PostAsJsonAsync($"/api/booking/slots/{secondTarget.SlotId}/lock", new { });

        // Assert the old slot returned to the public pool.
        switchResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var refreshed = await GetDaySlotsAsync(clinicId, monday);
        refreshed.First(slot => slot.SlotId == firstTarget.SlotId).Status.Should().Be("Available");
        refreshed.First(slot => slot.SlotId == secondTarget.SlotId).Status.Should().Be("Pending");
    }

    /// <summary>
    /// Regression test for the lock-ordering bug: a FAILED acquisition must leave
    /// the caller's existing lock completely untouched.
    /// </summary>
    [Fact]
    public async Task LockSlot_FailedAcquisition_KeepsPreviousLockUntouched()
    {
        // Arrange patient A holding slot X and patient B having taken slot Y.
        var (doctorClient, _) = await CreateAndLoginDoctorAsync("KeepOld");
        var clinicId = await CreateClinicWithSlotsAsync(doctorClient, "KeepOld");
        var monday = NextMonday();
        var patientA = await CreateAndLoginPatientAsync("Keeper");
        var patientB = await CreateAndLoginPatientAsync("Taker");
        var slots = await GetDaySlotsAsync(clinicId, monday);
        var slotX = slots.First(slot => slot.Status == "Available");
        var slotY = slots.First(slot => slot.Status == "Available" && slot.SlotId != slotX.SlotId);

        await patientA.PostAsync($"/api/booking/slots/{slotX.SlotId}/lock", null);
        await patientB.PostAsync($"/api/booking/slots/{slotY.SlotId}/lock", null);

        // Act as patient A chasing B's slot and losing the race.
        var failedAttempt = await patientA.PostAsync($"/api/booking/slots/{slotY.SlotId}/lock", null);

        // Assert the failure occurred AND A's original slot is still held.
        failedAttempt.StatusCode.Should().Be(HttpStatusCode.Conflict);
        var refreshed = await GetDaySlotsAsync(patientA, clinicId, monday);
        var xAfterFailure = refreshed.First(slot => slot.SlotId == slotX.SlotId);
        using (new AssertionScope())
        {
            xAfterFailure.Status.Should().Be("Pending");
            xAfterFailure.IsLockedByMe.Should().BeTrue();
            xAfterFailure.ExpiresAt.Should().NotBeNull();
        }
    }

    /// <summary>
    /// Releasing frees the slot and the operation stays idempotent afterwards.
    /// </summary>
    [Fact]
    public async Task ReleaseSlot_HeldSlot_FreesItAndRemainsIdempotent()
    {
        // Arrange a patient holding a live lock.
        var (doctorClient, _) = await CreateAndLoginDoctorAsync("Release");
        var clinicId = await CreateClinicWithSlotsAsync(doctorClient, "Release");
        var monday = NextMonday();
        var patient = await CreateAndLoginPatientAsync("Releaser");
        Guid slotId = await LockFirstAvailableAsync(patient, clinicId, monday);

        // Act releasing the slot twice.
        var firstRelease = await patient.PostAsync($"/api/booking/slots/{slotId}/release", null);
        var secondRelease = await patient.PostAsync($"/api/booking/slots/{slotId}/release", null);

        // Assert both calls succeed and the slot is publicly free again.
        firstRelease.StatusCode.Should().Be(HttpStatusCode.NoContent);
        secondRelease.StatusCode.Should().Be(HttpStatusCode.NoContent);
        var refreshed = await GetDaySlotsAsync(clinicId, monday);
        refreshed.First(slot => slot.SlotId == slotId).Status.Should().Be("Available");
    }

    /// <summary>
    /// An expired pending lock surfaces as Available immediately on read,
    /// without waiting for the background maintenance job.
    /// </summary>
    [Fact]
    public async Task GetSlots_ExpiredPendingLock_ShowsAvailableImmediately()
    {
        // Arrange a slot forced into an expired pending state directly in storage.
        var (doctorClient, _) = await CreateAndLoginDoctorAsync("ExpiredView");
        var clinicId = await CreateClinicWithSlotsAsync(doctorClient, "ExpiredView");
        var monday = NextMonday();
        Guid expiredSlotId = Guid.Empty;

        await ExecuteWithDbContextAsync(async dbContext =>
        {
            // Take a generated slot and age its lock beyond the countdown.
            var slot = await dbContext.AppointmentSlots
                .FirstAsync(s => s.ClinicId == clinicId && s.Date == monday && s.Status == SlotStatus.Available);
            slot.Status = SlotStatus.Pending;
            slot.HeldByUserId = null;
            slot.ExpiresAtUtc = DateTime.UtcNow.AddMinutes(-5);
            await dbContext.SaveChangesAsync();
            expiredSlotId = slot.Id;
        });

        // Act reading the day view anonymously.
        var refreshed = await GetDaySlotsAsync(clinicId, monday);

        // Assert the effective-status projection presents the slot as free.
        var projected = refreshed.First(slot => slot.SlotId == expiredSlotId);
        projected.Status.Should().Be("Available");
        projected.ExpiresAt.Should().BeNull();
    }

    /// <summary>
    /// Slots belonging to an inactive clinic cannot be locked.
    /// </summary>
    [Fact]
    public async Task LockSlot_InactiveClinicSlot_ReturnsConflict()
    {
        // Arrange a clinic whose status is flipped to Inactive through its owner.
        var (doctorClient, _) = await CreateAndLoginDoctorAsync("InactiveClinic");
        var clinicId = await CreateClinicWithSlotsAsync(doctorClient, "InactiveClinic");
        var monday = NextMonday();
        var patient = await CreateAndLoginPatientAsync("InactiveLocker");
        var slotsBefore = await GetDaySlotsAsync(clinicId, monday);
        slotsBefore.Should().Contain(slot => slot.Status == "Available");

        var deactivateResponse = await doctorClient.PutAsJsonAsync($"/api/clinics/{clinicId}", new UpdateClinicRequest { Status = 1 });
        deactivateResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        // Act attempting to lock one of the inactive clinic's slots.
        var target = slotsBefore.First(slot => slot.Status == "Available");
        var lockResponse = await patient.PostAsync($"/api/booking/slots/{target.SlotId}/lock", null);

        // Assert the clinic-state guard blocks the lock.
        lockResponse.StatusCode.Should().Be(HttpStatusCode.Conflict);
    }

    #endregion

    #region Concurrent Access

    /// <summary>
    /// Two patients racing on the same instant produce exactly one winner.
    /// NOTE: SQLite serializes writes, so a losing writer may surface either as
    /// a clean 409 or as a provider concurrency exception mapped to 500; both
    /// count as losses because exactly one 200 is asserted.
    /// </summary>
    [Fact]
    public async Task LockSlot_ConcurrentRacers_ExactlyOneWins()
    {
        // Arrange two patients and one contested slot behind a start gate.
        var (doctorClient, _) = await CreateAndLoginDoctorAsync("Race");
        var clinicId = await CreateClinicWithSlotsAsync(doctorClient, "Race");
        var monday = NextMonday();
        var patientA = await CreateAndLoginPatientAsync("RacerA");
        var patientB = await CreateAndLoginPatientAsync("RacerB");
        Guid contestedSlot = await LockFirstAvailableAsync(patientA, clinicId, monday);
        await patientA.PostAsync($"/api/booking/slots/{contestedSlot}/release", null);

        var startSignal = new TaskCompletionSource();
        var racerTaskA = Task.Run(async () =>
        {
            await startSignal.Task;
            return await patientA.PostAsync($"/api/booking/slots/{contestedSlot}/lock", null);
        });
        var racerTaskB = Task.Run(async () =>
        {
            await startSignal.Task;
            return await patientB.PostAsync($"/api/booking/slots/{contestedSlot}/lock", null);
        });

        // Act releasing both racers simultaneously.
        startSignal.SetResult();
        var responses = await Task.WhenAll(racerTaskA, racerTaskB);

        // Assert exactly one winner and a defeated-but-safe runner-up.
        responses.Count(response => response.StatusCode == HttpStatusCode.OK).Should().Be(1);
        responses.Should().OnlyContain(response =>
            response.StatusCode == HttpStatusCode.OK ||
            response.StatusCode == HttpStatusCode.Conflict ||
            response.StatusCode == HttpStatusCode.InternalServerError);

        // Final state must show a single pending holder on the contested slot.
        var finalState = await GetDaySlotsAsync(clinicId, monday);
        finalState.Count(slot => slot.SlotId == contestedSlot && slot.Status == "Pending").Should().Be(1);
    }

    #endregion

    #region Booking Summary & Default Clinic

    /// <summary>
    /// The anonymous booking summary lists clinics default-first and reflects
    /// default switching performed through the clinic update endpoint.
    /// </summary>
    [Fact]
    public async Task BookingSummary_AnonymousAccess_ListsDefaultClinicFirst()
    {
        // Arrange a doctor with two clinics; creation auto-defaults the first.
        var (doctorClient, createdUserId) = await CreateAndLoginDoctorAsync("Summary");
        var doctorId = await ResolveDoctorEntityIdAsync(createdUserId);
        var firstClinicId = await CreateClinicWithSlotsAsync(doctorClient, "SummaryA");
        var secondClinicId = await CreateClinicWithSlotsAsync(doctorClient, "SummaryB", startTime: "13:00", endTime: "16:00");

        // Promote the second clinic to default through the public contract.
        var promoteResponse = await doctorClient.PutAsJsonAsync(
            $"/api/clinics/{secondClinicId}",
            new UpdateClinicRequest { IsDefault = true });
        promoteResponse.StatusCode.Should().Be(HttpStatusCode.OK,
            because: "promotion must succeed; body: {0}",
            await promoteResponse.Content.ReadAsStringAsync());

        // Act reading the summary without any authentication header.
        var guestClient = _factory.CreateClient();
        var summaryResponse = await guestClient.GetAsync($"/api/doctors/{doctorId}/clinics/booking-summary");

        // Assert ordering and flag correctness on the anonymous payload.
        summaryResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var summary = await summaryResponse.Content.ReadFromJsonAsync<DoctorBookingSummaryDto>();
        summary.Should().NotBeNull();
        summary!.Clinics.Should().HaveCount(2);
        summary.Clinics[0].ClinicId.Should().Be(secondClinicId);
        summary.Clinics[0].IsDefault.Should().BeTrue();
        summary.Clinics[1].ClinicId.Should().Be(firstClinicId);
        summary.Clinics[1].IsDefault.Should().BeFalse();
        summary.Clinics.Should().OnlyContain(clinic => clinic.WorkingDays.Count > 0);
    }

    /// <summary>
    /// Soft-deleting the default clinic promotes the oldest remaining sibling,
    /// keeping the booking surface anchored on a primary clinic.
    /// </summary>
    [Fact]
    public async Task DeleteClinic_DefaultClinic_PromotesOldestSibling()
    {
        // Arrange two clinics where the FIRST is the current default.
        var (doctorClient, createdUserId) = await CreateAndLoginDoctorAsync("Promote");
        var doctorId = await ResolveDoctorEntityIdAsync(createdUserId);
        var firstClinicId = await CreateClinicWithSlotsAsync(doctorClient, "PromoteOld");
        var secondClinicId = await CreateClinicWithSlotsAsync(doctorClient, "PromoteNew", startTime: "13:00", endTime: "16:00");

        // Act soft-deleting the current default.
        var deleteResponse = await doctorClient.DeleteAsync($"/api/clinics/{firstClinicId}");
        deleteResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        // Assert the survivor inherited the default flag.
        var guestClient = _factory.CreateClient();
        var summaryResponse = await guestClient.GetAsync($"/api/doctors/{doctorId}/clinics/booking-summary");
        summaryResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var summary = await summaryResponse.Content.ReadFromJsonAsync<DoctorBookingSummaryDto>();
        summary!.Clinics.Should().ContainSingle(clinic => clinic.ClinicId == secondClinicId);
        summary.Clinics.Single().IsDefault.Should().BeTrue();
    }

    /// <summary>
    /// The filtered unique index rejects two simultaneous default clinics at the
    /// database level even when application-level demotion is bypassed.
    /// </summary>
    [Fact]
    public async Task Database_TwoDefaultsForSameDoctor_RejectedByUniqueIndex()
    {
        // Arrange a doctor with one auto-defaulted clinic.
        var (doctorClient, _) = await CreateAndLoginDoctorAsync("UniqueIndex");
        var clinicId = await CreateClinicWithSlotsAsync(doctorClient, "UniqueIndex");

        await ExecuteWithDbContextAsync(async dbContext =>
        {
            // Load the existing default with all required navigation owners.
            var existing = await dbContext.Clinics
                .Include(c => c.Governorate)
                .Include(c => c.City)
                .Include(c => c.Doctor)
                .FirstAsync(c => c.Id == clinicId);

            // Forge a second default for the same doctor, bypassing demotion.
            var forged = new Clinic
            {
                Id = Guid.NewGuid(),
                DoctorId = existing.DoctorId,
                Doctor = existing.Doctor,
                Name = "Forged Default Clinic",
                GovernorateId = existing.GovernorateId,
                Governorate = existing.Governorate,
                CityId = existing.CityId,
                City = existing.City,
                ConsultationFee = existing.ConsultationFee,
                Status = ClinicStatus.Active,
                AppointmentDurationMinutes = existing.AppointmentDurationMinutes,
                MaxAdvanceBookingDays = existing.MaxAdvanceBookingDays,
                IsDefault = true
            };

            // Act persisting the duplicate default.
            dbContext.Clinics.Add(forged);

            // Assert the filtered unique index rejects the write.
            await Assert.ThrowsAnyAsync<DbUpdateException>(() => dbContext.SaveChangesAsync());
        });
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
        public List<AuthenticationError> Errors { get; init; } = [];
    }
}



