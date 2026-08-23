/**
 * File Name      : PatientFavoritesIntegrationTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : WebApplicationFactory, HttpClient, System.Net.Http.Json, FluentAssertions, Xunit
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-23
 * Description    : Integration tests for Patient Favorites feature covering doctors and clinics endpoints.
 */

using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Threading.Tasks;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Authentication.Login.Contracts;
using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Application.Features.Authentication.Registration.Contracts;
using Appoynt.Application.Features.Patient.Contracts;
using Appoynt.Application.Features.UserManagement.Contracts;
using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Persistence;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Xunit;

namespace Appoynt.Tests.IntegrationTests;

/// <summary>
/// Integration test suite verifying the behavior of patient favorites endpoints for doctors and clinics.
/// </summary>
[Collection("Sequential")]
public class PatientFavoritesIntegrationTests : IClassFixture<WebApplicationFactory<Appoynt.API.Program>>
{
    private readonly WebApplicationFactory<Appoynt.API.Program> _factory;
    private const string SecretKey = "SuperSecretKeyWithMinimum32CharactersLength!";

    /// <summary>
    /// Initializes a new instance of the test class with custom in-memory configuration.
    /// </summary>
    public PatientFavoritesIntegrationTests(WebApplicationFactory<Appoynt.API.Program> factory)
    {
        // Configure test web application host with sqlite in-memory database
        _factory = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureAppConfiguration((context, config) =>
            {
                config.AddInMemoryCollection(new Dictionary<string, string?>
                {
                    ["DatabaseProvider"] = "Sqlite",
                    ["ConnectionStrings:DefaultConnection"] = "DataSource=file:appoynt_patient_fav_test.db?mode=memory&cache=shared",
                    ["Jwt:Issuer"] = "Appoynt.API",
                    ["Jwt:Audience"] = "Appoynt.Client",
                    ["Jwt:SecretKey"] = SecretKey,
                    ["FileStorage:RootPath"] = "App_Data/uploads_fav_test",
                    ["RateLimiting:Register:PermitLimit"] = "100",
                    ["RateLimiting:Register:WindowInMinutes"] = "60",
                    ["RateLimiting:Login:PermitLimit"] = "100",
                    ["RateLimiting:Login:WindowInMinutes"] = "60",
                    ["RateLimiting:OtpVerify:PermitLimit"] = "100",
                    ["RateLimiting:OtpVerify:WindowInMinutes"] = "60",
                    ["RateLimiting:OtpResend:PermitLimit"] = "100",
                    ["RateLimiting:OtpResend:WindowInMinutes"] = "60",
                    ["Seed:Enabled"] = "true",
                    ["Seed:Admin:FirstName"] = "System",
                    ["Seed:Admin:LastName"] = "Admin",
                    ["Seed:Admin:Email"] = "admin.fav@appoynt.com",
                    ["Seed:Admin:PhoneNumber"] = "01088887766",
                    ["Seed:Admin:Password"] = "Password123!@#"
                });
            });
        });
    }

    /// <summary>
    /// Helper method to create, verify, and authenticate a new patient user.
    /// </summary>
    private async Task<(HttpClient Client, string Token)> CreateAuthenticatedPatientAsync()
    {
        // Create HTTP client instance
        var client = _factory.CreateClient();

        // Generate unique registration credentials
        string email = $"patient.fav.{Guid.NewGuid():N}@appoynt.com";
        string phone = "010" + Random.Shared.Next(10000000, 99999999).ToString();
        string password = "P@ssword123!";

        // Register patient
        var regResponse = await client.PostAsJsonAsync("/api/auth/register", new RegisterRequest
        {
            FirstName = "FavPatient",
            LastName = "User",
            Email = email,
            PhoneNumber = phone,
            Password = password,
            ConfirmPassword = password
        });
        regResponse.StatusCode.Should().Be(HttpStatusCode.Created);
        var regBody = await regResponse.Content.ReadFromJsonAsync<RegisterResponse>();

        // Verify OTP challenge
        var verifyResponse = await client.PostAsJsonAsync("/api/auth/otp/verify", new VerifyOtpRequest
        {
            ChallengeId = regBody!.ChallengeId,
            Code = "123456"
        });
        verifyResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        // Login to acquire JWT access token
        var loginResponse = await client.PostAsJsonAsync("/api/auth/login", new LoginRequest
        {
            Identifier = email,
            Password = password
        });
        loginResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var loginBody = await loginResponse.Content.ReadFromJsonAsync<LoginResponse>();

        // Set authorization header
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loginBody!.AccessToken);

        // Return client and token tuple
        return (client, loginBody.AccessToken);
    }

    /// <summary>
    /// Helper method to log in as Admin and create a new Doctor for testing.
    /// </summary>
    private async Task<Guid> CreateDoctorAsync()
    {
        // Create unauthenticated client
        var client = _factory.CreateClient();

        // Login as System Admin
        var adminLoginResponse = await client.PostAsJsonAsync("/api/auth/login", new LoginRequest
        {
            Identifier = "admin.fav@appoynt.com",
            Password = "Password123!@#"
        });
        adminLoginResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var adminLogin = await adminLoginResponse.Content.ReadFromJsonAsync<LoginResponse>();

        // Set Admin authorization header
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminLogin!.AccessToken);

        // Generate doctor credentials
        string email = $"doc.fav.{Guid.NewGuid():N}@appoynt.com";
        string phone = "+2010" + Random.Shared.Next(10000000, 99999999).ToString();

        // Create doctor user
        var docResponse = await client.PostAsJsonAsync("/api/users/doctors", new CreateDoctorRequest
        {
            FirstName = "Doctor",
            LastName = "FavoriteTest",
            Email = email,
            PhoneNumber = phone,
            Password = "Password123!",
            NameAr = "دكتور تجريبي",
            NameEn = "Dr. Test Favorite",
            Bio = "Specialist in test favorites",
            Education = "MD"
        });

        docResponse.StatusCode.Should().Be(HttpStatusCode.Created);

        // Retrieve Doctor ID directly from database context
        using var scope = _factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
        var doctor = await db.Doctors
            .Include(d => d.User)
            .FirstAsync(d => d.User.Email == email);

        return doctor.Id;
    }

    [Fact]
    public async Task FavoriteDoctorWorkflow_FullLifecycle_ShouldSucceed()
    {
        // 1. Setup: Create Patient and Doctor
        var (patientClient, _) = await CreateAuthenticatedPatientAsync();
        Guid doctorId = await CreateDoctorAsync();

        // 2. Add doctor to favorites
        var addResponse = await patientClient.PostAsync($"/api/patients/me/favorites/doctors/{doctorId}", null);
        addResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var addResult = await addResponse.Content.ReadFromJsonAsync<PatientResult>();
        addResult!.Succeeded.Should().BeTrue();

        // 3. Adding again should return 400 Bad Request (duplicate prevention)
        var duplicateResponse = await patientClient.PostAsync($"/api/patients/me/favorites/doctors/{doctorId}", null);
        duplicateResponse.StatusCode.Should().Be(HttpStatusCode.BadRequest);

        // 4. Get favorite doctors (should contain 1 item)
        var getResponse = await patientClient.GetAsync("/api/patients/me/favorites/doctors?pageNumber=1&pageSize=15");
        string responseText = await getResponse.Content.ReadAsStringAsync();
        getResponse.StatusCode.Should().Be(HttpStatusCode.OK, because: responseText);
        var pagedResult = await getResponse.Content.ReadFromJsonAsync<PagedResponse<FavoriteDoctorResponse>>();
        pagedResult.Should().NotBeNull();
        pagedResult!.TotalCount.Should().Be(1);
        pagedResult.Items.Should().ContainSingle(d => d.Id == doctorId);

        // 5. Search favorite doctors by name
        var searchMatchResponse = await patientClient.GetAsync("/api/patients/me/favorites/doctors?search=FavoriteTest");
        searchMatchResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var searchMatchResult = await searchMatchResponse.Content.ReadFromJsonAsync<PagedResponse<FavoriteDoctorResponse>>();
        searchMatchResult!.TotalCount.Should().Be(1);

        var searchNoMatchResponse = await patientClient.GetAsync("/api/patients/me/favorites/doctors?search=NonExistentName123");
        searchNoMatchResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var searchNoMatchResult = await searchNoMatchResponse.Content.ReadFromJsonAsync<PagedResponse<FavoriteDoctorResponse>>();
        searchNoMatchResult!.TotalCount.Should().Be(0);

        // 6. Remove doctor from favorites
        var removeResponse = await patientClient.DeleteAsync($"/api/patients/me/favorites/doctors/{doctorId}");
        removeResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        // 7. Removing again should return 400 Bad Request (not in favorites)
        var removeAgainResponse = await patientClient.DeleteAsync($"/api/patients/me/favorites/doctors/{doctorId}");
        removeAgainResponse.StatusCode.Should().Be(HttpStatusCode.BadRequest);

        // 8. Verify list is now empty
        var getEmptyResponse = await patientClient.GetAsync("/api/patients/me/favorites/doctors");
        getEmptyResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var emptyPagedResult = await getEmptyResponse.Content.ReadFromJsonAsync<PagedResponse<FavoriteDoctorResponse>>();
        emptyPagedResult!.TotalCount.Should().Be(0);
    }

    [Fact]
    public async Task RemoveAllFavoriteDoctors_ShouldClearFavorites()
    {
        // 1. Setup Patient and Doctor
        var (patientClient, _) = await CreateAuthenticatedPatientAsync();
        Guid doctorId = await CreateDoctorAsync();

        // 2. Add to favorites
        await patientClient.PostAsync($"/api/patients/me/favorites/doctors/{doctorId}", null);

        // 3. Clear all favorites
        var clearResponse = await patientClient.DeleteAsync("/api/patients/me/favorites/doctors");
        clearResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        // 4. Verify favorites list is empty
        var getResponse = await patientClient.GetAsync("/api/patients/me/favorites/doctors");
        var pagedResult = await getResponse.Content.ReadFromJsonAsync<PagedResponse<FavoriteDoctorResponse>>();
        pagedResult!.TotalCount.Should().Be(0);
    }

    /// <summary>
    /// Helper method to create a clinic for a doctor and return the clinic identifier.
    /// </summary>
    private async Task<Guid> CreateClinicAsync(Guid doctorId)
    {
        using var scope = _factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();

        // Find or seed a governorate and city
        var gov = await db.Governorates.Include(g => g.Cities).FirstOrDefaultAsync();
        if (gov == null)
        {
            gov = new Governorate
            {
                Id = Guid.NewGuid(),
                NameAr = "القاهرة",
                NameEn = "Cairo"
            };
            db.Governorates.Add(gov);
            await db.SaveChangesAsync();
        }

        var city = await db.Cities.FirstOrDefaultAsync(c => c.GovernorateId == gov.Id);
        if (city == null)
        {
            city = new City
            {
                Id = Guid.NewGuid(),
                GovernorateId = gov.Id,
                Governorate = gov,
                NameAr = "مدينة نصر",
                NameEn = "Nasr City"
            };
            db.Cities.Add(city);
            await db.SaveChangesAsync();
        }

        var clinic = new Clinic
        {
            Id = Guid.NewGuid(),
            Name = "Alpha Care Clinic",
            DoctorId = doctorId,
            Doctor = null!,
            GovernorateId = gov.Id,
            Governorate = gov,
            CityId = city.Id,
            City = city,
            DetailedAddress = "45 Abbas El-Akkad St",
            ConsultationFee = 400.00m,
            Status = ClinicStatus.Active,
            AppointmentDurationMinutes = 30,
            MaxAdvanceBookingDays = 14
        };

        db.Clinics.Add(clinic);
        await db.SaveChangesAsync();

        return clinic.Id;
    }

    [Fact]
    public async Task FavoriteClinicWorkflow_FullLifecycle_ShouldSucceed()
    {
        // 1. Setup Patient, Doctor, and Clinic
        var (patientClient, _) = await CreateAuthenticatedPatientAsync();
        Guid doctorId = await CreateDoctorAsync();
        Guid clinicId = await CreateClinicAsync(doctorId);

        // 2. Add clinic to favorites
        var addResponse = await patientClient.PostAsync($"/api/patients/me/favorites/clinics/{clinicId}", null);
        addResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var addResult = await addResponse.Content.ReadFromJsonAsync<PatientResult>();
        addResult!.Succeeded.Should().BeTrue();

        // 3. Adding again should return 400 Bad Request
        var duplicateResponse = await patientClient.PostAsync($"/api/patients/me/favorites/clinics/{clinicId}", null);
        duplicateResponse.StatusCode.Should().Be(HttpStatusCode.BadRequest);

        // 4. Get favorite clinics
        var getResponse = await patientClient.GetAsync("/api/patients/me/favorites/clinics?pageNumber=1&pageSize=15");
        getResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var pagedResult = await getResponse.Content.ReadFromJsonAsync<PagedResponse<FavoriteClinicResponse>>();
        pagedResult.Should().NotBeNull();
        pagedResult!.TotalCount.Should().Be(1);
        pagedResult.Items.Should().ContainSingle(c => c.Id == clinicId);

        // 5. Search favorite clinics
        var searchMatchResponse = await patientClient.GetAsync("/api/patients/me/favorites/clinics?search=Alpha");
        searchMatchResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var searchResult = await searchMatchResponse.Content.ReadFromJsonAsync<PagedResponse<FavoriteClinicResponse>>();
        searchResult!.TotalCount.Should().Be(1);

        // 6. Remove clinic from favorites
        var removeResponse = await patientClient.DeleteAsync($"/api/patients/me/favorites/clinics/{clinicId}");
        removeResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        // 7. Verify empty
        var getEmptyResponse = await patientClient.GetAsync("/api/patients/me/favorites/clinics");
        getEmptyResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var emptyPagedResult = await getEmptyResponse.Content.ReadFromJsonAsync<PagedResponse<FavoriteClinicResponse>>();
        emptyPagedResult!.TotalCount.Should().Be(0);
    }

    [Fact]
    public async Task RemoveAllFavoriteClinics_ShouldClearFavorites()
    {
        // 1. Setup Patient, Doctor, and Clinic
        var (patientClient, _) = await CreateAuthenticatedPatientAsync();
        Guid doctorId = await CreateDoctorAsync();
        Guid clinicId = await CreateClinicAsync(doctorId);

        // 2. Add clinic to favorites
        await patientClient.PostAsync($"/api/patients/me/favorites/clinics/{clinicId}", null);

        // 3. Clear all clinic favorites
        var clearResponse = await patientClient.DeleteAsync("/api/patients/me/favorites/clinics");
        clearResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        // 4. Verify list is empty
        var getResponse = await patientClient.GetAsync("/api/patients/me/favorites/clinics");
        var pagedResult = await getResponse.Content.ReadFromJsonAsync<PagedResponse<FavoriteClinicResponse>>();
        pagedResult!.TotalCount.Should().Be(0);
    }
}
