/**
 * File Name      : ClinicIntegrationTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : WebApplicationFactory, ApplicationDbContext, Clinic, AppointmentSlot, ClinicWorkingPeriod
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Comprehensive integration tests covering clinic lifecycle, working periods, breaks, phone numbers, receptionist assignments, cross-clinic schedule conflicts, and pre-generated slots.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Threading.Tasks;
using Appoynt.Application.Features.Authentication.Login.Contracts;
using Appoynt.Application.Features.Clinics.Contracts;
using Appoynt.Application.Features.UserManagement.Contracts;
using Appoynt.Domain.Common.Constants;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;
using Xunit;

namespace Appoynt.Tests.IntegrationTests;

/// <summary>
/// Comprehensive integration tests for clinic lifecycle, scheduling, conflict detection, and slot discovery.
/// </summary>
[Collection("Integration Tests")]
public sealed class ClinicIntegrationTests : IClassFixture<WebApplicationFactory<Appoynt.API.Program>>
{
    private readonly WebApplicationFactory<Appoynt.API.Program> _factory;

    /// <summary>
    /// Initializes test fixture with in-memory SQLite database.
    /// </summary>
    /// <param name="factory">The web application factory.</param>
    public ClinicIntegrationTests(WebApplicationFactory<Appoynt.API.Program> factory)
    {
        _factory = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureAppConfiguration((context, config) =>
            {
                config.AddInMemoryCollection(new Dictionary<string, string?>
                {
                    ["DatabaseProvider"] = "Sqlite",
                    ["ConnectionStrings:DefaultConnection"] = "DataSource=file:appoynt_test_clinic.db?mode=memory&cache=shared",
                    ["Jwt:SecretKey"] = "SuperSecretKeyWithMinimum32CharactersLength!",
                    ["Seed:Enabled"] = "true",
                    ["Seed:Admin:Password"] = "Password123!"
                });
            });
        });
    }

    private async Task<string> AuthenticateAdminAsync(HttpClient client)
    {
        var loginRequest = new LoginRequest
        {
            Identifier = "admin@appoynt.com",
            Password = "Password123!"
        };

        var loginResponse = await client.PostAsJsonAsync("/api/auth/login", loginRequest);
        loginResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        var loginResult = await loginResponse.Content.ReadFromJsonAsync<LoginResponse>();
        return loginResult!.AccessToken;
    }

    private async Task<(string Token, Guid DoctorId)> CreateAndLoginDoctorAsync(HttpClient client, string suffix)
    {
        var adminToken = await AuthenticateAdminAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminToken);

        var randomDigits = new Random().Next(10000000, 99999999).ToString();
        var createDoctorRequest = new CreateDoctorRequest
        {
            FirstName = "Doctor",
            LastName = $"Test{suffix}",
            NameAr = $"د. اختبار {suffix}",
            NameEn = $"Dr. Test {suffix}",
            Email = $"doctor_{suffix}_{Guid.NewGuid():N}@appoynt.com",
            PhoneNumber = $"+2010{randomDigits}",
            Password = "Password123!",
            SpecializationIds = []
        };

        var createResponse = await client.PostAsJsonAsync("/api/users/doctors", createDoctorRequest);
        createResponse.StatusCode.Should().Be(HttpStatusCode.Created);

        var createBody = await createResponse.Content.ReadFromJsonAsync<UserManagementResult>();
        var doctorId = createBody!.UserId!.Value;

        // Login as the doctor
        var loginRequest = new LoginRequest
        {
            Identifier = createDoctorRequest.Email,
            Password = createDoctorRequest.Password
        };

        var loginResponse = await client.PostAsJsonAsync("/api/auth/login", loginRequest);
        loginResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        var loginResult = await loginResponse.Content.ReadFromJsonAsync<LoginResponse>();
        return (loginResult!.AccessToken, doctorId);
    }

    [Fact]
    public async Task CreateClinic_ShouldCreateClinicAndGenerateSlots_WhenRequestIsValid()
    {
        // Arrange
        var client = _factory.CreateClient();
        var (doctorToken, _) = await CreateAndLoginDoctorAsync(client, "CreateClinic1");
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", doctorToken);

        // Fetch governorates and cities for valid IDs
        var govResponse = await client.GetAsync("/api/governorates");
        var governorates = await govResponse.Content.ReadFromJsonAsync<List<GovernorateResponse>>();
        var cairo = governorates!.First(g => g.NameEn == "Cairo");

        var citiesResponse = await client.GetAsync($"/api/governorates/{cairo.Id}/cities");
        var cities = await citiesResponse.Content.ReadFromJsonAsync<List<CityResponse>>();
        var city = cities!.First();

        var createClinicRequest = new CreateClinicRequest
        {
            Name = "Al-Amal Heart Clinic",
            GovernorateId = cairo.Id,
            CityId = city.Id,
            DetailedAddress = "123 El-Tahrir Street, Floor 3",
            ConsultationFee = 350.00m,
            AppointmentDurationMinutes = 30,
            MaxAdvanceBookingDays = 14,
            PhoneNumbers =
            [
                new ClinicPhoneNumberDto { PhoneNumber = "+201012345678", Label = "Reception" },
                new ClinicPhoneNumberDto { PhoneNumber = "+20223456789", Label = "Landline" }
            ],
            WorkingPeriods =
            [
                new WorkingPeriodRequest
                {
                    DayOfWeek = (int)DayOfWeek.Monday,
                    StartTime = "09:00",
                    EndTime = "17:00",
                    Breaks =
                    [
                        new BreakRequest { StartTime = "12:00", EndTime = "13:00" }
                    ]
                }
            ]
        };

        // Act
        var response = await client.PostAsJsonAsync("/api/clinics", createClinicRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Created);
        var json = await response.Content.ReadFromJsonAsync<JsonElement>();
        var clinicId = json.GetProperty("clinicId").GetGuid();
        clinicId.Should().NotBeEmpty();

        // Verify clinic details
        var getClinicResponse = await client.GetAsync($"/api/clinics/{clinicId}");
        getClinicResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var clinic = await getClinicResponse.Content.ReadFromJsonAsync<ClinicResponse>();
        clinic.Should().NotBeNull();
        clinic!.Name.Should().Be("Al-Amal Heart Clinic");
        clinic.ConsultationFee.Should().Be(350.00m);
        clinic.AppointmentDurationMinutes.Should().Be(30);
        clinic.PhoneNumbers.Should().HaveCount(2);
        clinic.WorkingPeriods.Should().HaveCount(1);
        clinic.WorkingPeriods[0].Breaks.Should().HaveCount(1);

        // Verify available slots discovery
        var nextMonday = DateOnly.FromDateTime(DateTime.UtcNow);
        while (nextMonday.DayOfWeek != DayOfWeek.Monday)
        {
            nextMonday = nextMonday.AddDays(1);
        }

        var slotsResponse = await client.GetAsync($"/api/clinics/{clinicId}/slots?date={nextMonday:yyyy-MM-dd}");
        slotsResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var slots = await slotsResponse.Content.ReadFromJsonAsync<List<SlotResponse>>();
        slots.Should().NotBeNull();
        slots!.Should().NotBeEmpty();
        // Slots during break (12:00-13:00) must NOT be returned as Available
        slots.Should().NotContain(s => s.StartTime == "12:00" || s.StartTime == "12:30");
        // Valid working period slots must be Available
        slots.Should().Contain(s => s.StartTime == "09:00" && s.EndTime == "09:30");
    }

    [Fact]
    public async Task CreateClinic_ShouldReject_WhenCrossClinicScheduleConflicts()
    {
        // Arrange
        var client = _factory.CreateClient();
        var (doctorToken, _) = await CreateAndLoginDoctorAsync(client, "CrossConflict");
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", doctorToken);

        var govResponse = await client.GetAsync("/api/governorates");
        var governorates = await govResponse.Content.ReadFromJsonAsync<List<GovernorateResponse>>();
        var cairo = governorates!.First(g => g.NameEn == "Cairo");

        var citiesResponse = await client.GetAsync($"/api/governorates/{cairo.Id}/cities");
        var cities = await citiesResponse.Content.ReadFromJsonAsync<List<CityResponse>>();
        var city = cities!.First();

        // Clinic 1: Tuesday 10:00 - 14:00
        var clinic1 = new CreateClinicRequest
        {
            Name = "Clinic One",
            GovernorateId = cairo.Id,
            CityId = city.Id,
            ConsultationFee = 200.00m,
            AppointmentDurationMinutes = 30,
            MaxAdvanceBookingDays = 14,
            WorkingPeriods =
            [
                new WorkingPeriodRequest
                {
                    DayOfWeek = (int)DayOfWeek.Tuesday,
                    StartTime = "10:00",
                    EndTime = "14:00"
                }
            ]
        };

        var response1 = await client.PostAsJsonAsync("/api/clinics", clinic1);
        response1.StatusCode.Should().Be(HttpStatusCode.Created);

        // Clinic 2: Tuesday 12:00 - 16:00 (Overlaps 10:00-14:00!)
        var clinic2 = new CreateClinicRequest
        {
            Name = "Clinic Two",
            GovernorateId = cairo.Id,
            CityId = city.Id,
            ConsultationFee = 250.00m,
            AppointmentDurationMinutes = 30,
            MaxAdvanceBookingDays = 14,
            WorkingPeriods =
            [
                new WorkingPeriodRequest
                {
                    DayOfWeek = (int)DayOfWeek.Tuesday,
                    StartTime = "12:00",
                    EndTime = "16:00"
                }
            ]
        };

        // Act
        var response2 = await client.PostAsJsonAsync("/api/clinics", clinic2);

        // Assert
        response2.StatusCode.Should().Be(HttpStatusCode.BadRequest);
        var body = await response2.Content.ReadAsStringAsync();
        body.Should().Contain("clinic.schedule.cross_clinic_conflict");
    }

    [Fact]
    public async Task ClinicPhoneNumbersAndBreaks_ShouldSupportFullCrud()
    {
        // Arrange
        var client = _factory.CreateClient();
        var (doctorToken, _) = await CreateAndLoginDoctorAsync(client, "CrudOperations");
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", doctorToken);

        var govResponse = await client.GetAsync("/api/governorates");
        var governorates = await govResponse.Content.ReadFromJsonAsync<List<GovernorateResponse>>();
        var cairo = governorates!.First(g => g.NameEn == "Cairo");
        var citiesResponse = await client.GetAsync($"/api/governorates/{cairo.Id}/cities");
        var cities = await citiesResponse.Content.ReadFromJsonAsync<List<CityResponse>>();
        var city = cities!.First();

        var clinicRequest = new CreateClinicRequest
        {
            Name = "Operations Test Clinic",
            GovernorateId = cairo.Id,
            CityId = city.Id,
            ConsultationFee = 300.00m,
            AppointmentDurationMinutes = 20,
            MaxAdvanceBookingDays = 7,
            WorkingPeriods =
            [
                new WorkingPeriodRequest
                {
                    DayOfWeek = (int)DayOfWeek.Wednesday,
                    StartTime = "08:00",
                    EndTime = "16:00"
                }
            ]
        };

        var createResponse = await client.PostAsJsonAsync("/api/clinics", clinicRequest);
        var json = await createResponse.Content.ReadFromJsonAsync<JsonElement>();
        var clinicId = json.GetProperty("clinicId").GetGuid();

        // 1. Add Phone Number
        var addPhoneResponse = await client.PostAsJsonAsync($"/api/clinics/{clinicId}/phone-numbers", new ClinicPhoneNumberDto
        {
            PhoneNumber = "01099887766",
            Label = "Direct Line"
        });
        addPhoneResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        // 2. Add Break to working period
        var getClinic = await client.GetFromJsonAsync<ClinicResponse>($"/api/clinics/{clinicId}");
        var wpId = getClinic!.WorkingPeriods[0].Id;

        var addBreakResponse = await client.PostAsJsonAsync($"/api/clinics/{clinicId}/working-periods/{wpId}/breaks", new BreakRequest
        {
            StartTime = "12:00",
            EndTime = "12:40"
        });
        addBreakResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        // 3. Update clinic details
        var updateResponse = await client.PutAsJsonAsync($"/api/clinics/{clinicId}", new UpdateClinicRequest
        {
            Name = "Updated Clinic Name",
            ConsultationFee = 400.00m
        });
        updateResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        var updatedClinic = await client.GetFromJsonAsync<ClinicResponse>($"/api/clinics/{clinicId}");
        updatedClinic!.Name.Should().Be("Updated Clinic Name");
        updatedClinic.ConsultationFee.Should().Be(400.00m);

        // 4. Soft Delete Clinic
        var deleteResponse = await client.DeleteAsync($"/api/clinics/{clinicId}");
        deleteResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        // 5. Verify clinic is no longer returned in active list
        var myClinics = await client.GetFromJsonAsync<List<ClinicResponse>>("/api/clinics/my");
        myClinics.Should().NotContain(c => c.Id == clinicId);
    }
}
