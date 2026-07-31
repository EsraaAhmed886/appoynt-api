/**
 * File Name      : UserManagementIntegrationTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 28/07/2026
 * Version        : v1.0.0
 * Dependencies   : CustomWebApplicationFactory
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 28/07/2026
 * Description    : Integration tests for staff user management endpoints.
 */

using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using Appoynt.Application.Features.Authentication.Login.Contracts;
using Appoynt.Application.Features.UserManagement.Contracts;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Xunit;

namespace Appoynt.Tests.IntegrationTests;

[Collection("Sequential")]
public class UserManagementIntegrationTests : IClassFixture<WebApplicationFactory<Appoynt.API.Program>>
{
    private readonly WebApplicationFactory<Appoynt.API.Program> _factory;
    private readonly HttpClient _client;

    public UserManagementIntegrationTests(WebApplicationFactory<Appoynt.API.Program> factory)
    {
        _factory = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureAppConfiguration((context, config) =>
            {
                config.AddInMemoryCollection(new Dictionary<string, string?>
                {
                    ["DatabaseProvider"] = "Sqlite",
                    ["ConnectionStrings:DefaultConnection"] = "DataSource=file:appoynt_test_usermgmt.db?mode=memory&cache=shared",
                    ["Jwt:SecretKey"] = "SuperSecretKeyWithMinimum32CharactersLength!",
                    ["Seed:Enabled"] = "true",
                    ["Seed:Admin:Password"] = "Password123!"
                });
            });
        });
        _client = _factory.CreateClient();
    }

    private async Task<string> GetAdminTokenAsync()
    {
        var loginRequest = new LoginRequest
        {
            Identifier = "admin@appoynt.com",
            Password = "Password123!"
        };

        var response = await _client.PostAsJsonAsync("/api/auth/login", loginRequest);
        var result = await response.Content.ReadFromJsonAsync<LoginResponse>();
        return result!.AccessToken;
    }

    private async Task<string> GetTokenAsync(string email, string password)
    {
        var loginRequest = new LoginRequest
        {
            Identifier = email,
            Password = password
        };

        var response = await _client.PostAsJsonAsync("/api/auth/login", loginRequest);
        var result = await response.Content.ReadFromJsonAsync<LoginResponse>();
        return result!.AccessToken;
    }

    [Fact]
    public async Task CreateDoctor_ShouldSucceed_WhenUserIsAdmin()
    {
        // Arrange
        string token = await GetAdminTokenAsync();
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var request = new CreateStaffRequest
        {
            FirstName = "Gregory",
            LastName = "House",
            Email = "house@appoynt.com",
            PhoneNumber = "15558889999",
            Password = "Password123!"
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/users/doctors", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Created);

        using var scope = _factory.Services.CreateScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
        
        var doctor = await dbContext.Doctors
            .Include(d => d.User)
            .FirstOrDefaultAsync(d => d.User.Email == "house@appoynt.com");

        doctor.Should().NotBeNull();
        doctor!.User.FirstName.Should().Be("Gregory");
    }

    [Fact]
    public async Task CreateDoctor_ShouldReturnForbidden_WhenUserIsNotAdmin()
    {
        // Arrange: Try without any token
        _client.DefaultRequestHeaders.Authorization = null;

        var request = new CreateStaffRequest
        {
            FirstName = "Gregory",
            LastName = "House",
            Email = "house2@appoynt.com",
            PhoneNumber = "15558889998",
            Password = "Password123!"
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/users/doctors", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    [Fact]
    public async Task CreateReceptionist_ShouldSucceed_WhenUserIsDoctor()
    {
        // Arrange: Admin creates a doctor first
        string adminToken = await GetAdminTokenAsync();
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminToken);

        var doctorRequest = new CreateStaffRequest
        {
            FirstName = "Doctor",
            LastName = "Strange",
            Email = "strange@appoynt.com",
            PhoneNumber = "15558887777",
            Password = "Password123!"
        };
        await _client.PostAsJsonAsync("/api/users/doctors", doctorRequest);

        // Authenticate as the new doctor
        string doctorToken = await GetTokenAsync("strange@appoynt.com", "Password123!");
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", doctorToken);

        var receptionistRequest = new CreateStaffRequest
        {
            FirstName = "Wong",
            LastName = "Sorcerer",
            Email = "wong@appoynt.com",
            PhoneNumber = "15558886666",
            Password = "Password123!"
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/users/receptionists", receptionistRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Created);

        using var scope = _factory.Services.CreateScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
        
        var receptionist = await dbContext.Receptionists
            .Include(r => r.User)
            .FirstOrDefaultAsync(r => r.User.Email == "wong@appoynt.com");

        receptionist.Should().NotBeNull();
        
        // Ensure the Receptionist is linked to Doctor Strange
        var doctor = await dbContext.Doctors
            .Include(d => d.User)
            .FirstOrDefaultAsync(d => d.User.Email == "strange@appoynt.com");
            
        receptionist!.DoctorId.Should().Be(doctor!.Id);
    }

    [Fact]
    public async Task CreateAdmin_ShouldReturnForbidden_WhenUserIsDoctor()
    {
        // Arrange
        string adminToken = await GetAdminTokenAsync();
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminToken);

        var doctorRequest = new CreateStaffRequest
        {
            FirstName = "Doctor",
            LastName = "Who",
            Email = "who@appoynt.com",
            PhoneNumber = "15551112222",
            Password = "Password123!"
        };
        await _client.PostAsJsonAsync("/api/users/doctors", doctorRequest);

        // Authenticate as Doctor
        string doctorToken = await GetTokenAsync("who@appoynt.com", "Password123!");
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", doctorToken);

        var adminRequest = new CreateStaffRequest
        {
            FirstName = "Hacker",
            LastName = "Man",
            Email = "hacker@appoynt.com",
            PhoneNumber = "15559998888",
            Password = "Password123!"
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/users/admins", adminRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Forbidden);
    }

    [Fact]
    public async Task CreateDoctor_ShouldReturnBadRequest_WhenEmailAlreadyExists()
    {
        // Arrange
        string adminToken = await GetAdminTokenAsync();
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminToken);

        var firstDoctor = new CreateStaffRequest
        {
            FirstName = "John",
            LastName = "Doe",
            Email = "duplicate@appoynt.com",
            PhoneNumber = "15553334444",
            Password = "Password123!"
        };
        await _client.PostAsJsonAsync("/api/users/doctors", firstDoctor);

        var secondDoctor = new CreateStaffRequest
        {
            FirstName = "Jane",
            LastName = "Doe",
            Email = "duplicate@appoynt.com",
            PhoneNumber = "15553335555",
            Password = "Password123!"
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/users/doctors", secondDoctor);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
        var content = await response.Content.ReadAsStringAsync();
        content.Should().Contain("auth.registration.email.already_registered");
    }

    [Fact]
    public async Task CreateDoctor_ShouldReturnBadRequest_WhenPhoneAlreadyExists()
    {
        // Arrange
        string adminToken = await GetAdminTokenAsync();
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminToken);

        var firstDoctor = new CreateStaffRequest
        {
            FirstName = "Mark",
            LastName = "Smith",
            Email = "mark@appoynt.com",
            PhoneNumber = "15556667777",
            Password = "Password123!"
        };
        await _client.PostAsJsonAsync("/api/users/doctors", firstDoctor);

        var secondDoctor = new CreateStaffRequest
        {
            FirstName = "Sarah",
            LastName = "Smith",
            Email = "sarah@appoynt.com",
            PhoneNumber = "15556667777",
            Password = "Password123!"
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/users/doctors", secondDoctor);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
        var content = await response.Content.ReadAsStringAsync();
        content.Should().Contain("auth.registration.phone.already_registered");
    }
}
