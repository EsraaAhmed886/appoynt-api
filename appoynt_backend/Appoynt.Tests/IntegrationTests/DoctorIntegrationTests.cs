/**
 * File Name      : DoctorIntegrationTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : WebApplicationFactory, ApplicationDbContext, Doctor, Specialization, DoctorPhoneNumber
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Comprehensive integration tests for Doctor entity extension,
 *                  creation flow, validations, and profile photo management.
 */

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Threading.Tasks;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Authentication.Login.Contracts;
using Appoynt.Application.Features.UserManagement.Contracts;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;
using Xunit;

namespace Appoynt.Tests.IntegrationTests;

/// <summary>
/// Integration tests verifying Doctor account creation, relationships, and profile picture workflows.
/// </summary>
[Collection("Sequential")]
public class DoctorIntegrationTests : IClassFixture<WebApplicationFactory<Appoynt.API.Program>>
{
    private readonly WebApplicationFactory<Appoynt.API.Program> _factory;
    private readonly HttpClient _client;

    /// <summary>
    /// Initializes test fixture with SQLite in-memory database.
    /// </summary>
    public DoctorIntegrationTests(WebApplicationFactory<Appoynt.API.Program> factory)
    {
        _factory = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureAppConfiguration((context, config) =>
            {
                config.AddInMemoryCollection(new Dictionary<string, string?>
                {
                    ["DatabaseProvider"] = "Sqlite",
                    ["ConnectionStrings:DefaultConnection"] = "DataSource=file:appoynt_test_doctor.db?mode=memory&cache=shared",
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

    private static byte[] GenerateTestImageBytes(int width, int height)
    {
        using var image = new Image<Rgba32>(width, height);
        using var ms = new MemoryStream();
        image.SaveAsPng(ms);
        return ms.ToArray();
    }

    #region Doctor Creation Tests

    [Fact]
    public async Task CreateDoctor_WithFullAttributes_ShouldPersistAllFieldsAndRelationships()
    {
        // Arrange
        string adminToken = await GetAdminTokenAsync();
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminToken);

        // Seed a specialization directly in database
        Guid specId1 = Guid.NewGuid();
        Guid specId2 = Guid.NewGuid();
        using (var scope = _factory.Services.CreateScope())
        {
            var db = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
            db.Specializations.Add(new Specialization
            {
                Id = specId1,
                NameEn = "Cardiology " + Guid.NewGuid().ToString("N")[..6],
                NameAr = "أمراض القلب " + Guid.NewGuid().ToString("N")[..6]
            });
            db.Specializations.Add(new Specialization
            {
                Id = specId2,
                NameEn = "Neurology " + Guid.NewGuid().ToString("N")[..6],
                NameAr = "أمراض الأعصاب " + Guid.NewGuid().ToString("N")[..6]
            });
            await db.SaveChangesAsync();
        }

        var request = new CreateDoctorRequest
        {
            FirstName = "Ahmed",
            LastName = "Zewail",
            NameAr = "د. أحمد زويل",
            NameEn = "Dr. Ahmed Zewail",
            Bio = "Nobel Laureate in Chemistry and Pioneer in Femtochemistry.",
            Education = "PhD University of Pennsylvania, BS Alexandria University.",
            Email = "zewail@appoynt.com",
            PhoneNumber = "+201012345678",
            Password = "Password123!",
            SpecializationIds = [specId1, specId2],
            PhoneNumbers =
            [
                new DoctorPhoneNumberDto { PhoneNumber = "+201099998888", Label = "Private Clinic" },
                new DoctorPhoneNumberDto { PhoneNumber = "+201122223333", Label = "Hospital Office" }
            ]
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/users/doctors", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Created);

        using (var scope = _factory.Services.CreateScope())
        {
            var db = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
            var doctor = await db.Doctors
                .Include(d => d.User)
                .Include(d => d.PhoneNumbers)
                .Include(d => d.DoctorSpecializations)
                    .ThenInclude(ds => ds.Specialization)
                .FirstOrDefaultAsync(d => d.User.Email == "zewail@appoynt.com");

            doctor.Should().NotBeNull();
            doctor!.NameAr.Should().Be("د. أحمد زويل");
            doctor.NameEn.Should().Be("Dr. Ahmed Zewail");
            doctor.Bio.Should().Be("Nobel Laureate in Chemistry and Pioneer in Femtochemistry.");
            doctor.Education.Should().Be("PhD University of Pennsylvania, BS Alexandria University.");
            doctor.PhoneNumbers.Should().HaveCount(2);
            doctor.PhoneNumbers.Select(p => p.PhoneNumber).Should().Contain(["+201099998888", "+201122223333"]);
            doctor.DoctorSpecializations.Should().HaveCount(2);
            doctor.DoctorSpecializations.Select(ds => ds.SpecializationId).Should().Contain([specId1, specId2]);
        }
    }

    [Fact]
    public async Task CreateDoctor_WithMinimalAttributes_ShouldAutoComposeNameEn()
    {
        // Arrange
        string adminToken = await GetAdminTokenAsync();
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminToken);

        var request = new CreateDoctorRequest
        {
            FirstName = "Magdi",
            LastName = "Yacoub",
            NameAr = "د. مجدي يعقوب",
            Email = "yacoub@appoynt.com",
            PhoneNumber = "+201055554444",
            Password = "Password123!"
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/users/doctors", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Created);

        using (var scope = _factory.Services.CreateScope())
        {
            var db = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
            var doctor = await db.Doctors
                .Include(d => d.User)
                .Include(d => d.PhoneNumbers)
                .Include(d => d.DoctorSpecializations)
                .FirstOrDefaultAsync(d => d.User.Email == "yacoub@appoynt.com");

            doctor.Should().NotBeNull();
            doctor!.NameAr.Should().Be("د. مجدي يعقوب");
            doctor.NameEn.Should().Be("Magdi Yacoub");
            doctor.Bio.Should().BeNull();
            doctor.Education.Should().BeNull();
            doctor.PhoneNumbers.Should().BeEmpty();
            doctor.DoctorSpecializations.Should().BeEmpty();
        }
    }

    [Fact]
    public async Task CreateDoctor_WithMissingNameAr_ShouldReturnBadRequest()
    {
        // Arrange
        string adminToken = await GetAdminTokenAsync();
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminToken);

        var request = new CreateDoctorRequest
        {
            FirstName = "Test",
            LastName = "Doctor",
            NameAr = null,
            NameEn = "Dr. Test",
            Email = "missingnamear@appoynt.com",
            PhoneNumber = "+201033332222",
            Password = "Password123!"
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/users/doctors", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
    }

    [Fact]
    public async Task CreateDoctor_WithInvalidSpecializationId_ShouldReturnBadRequest_AndRollback()
    {
        // Arrange
        string adminToken = await GetAdminTokenAsync();
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminToken);

        Guid nonExistentSpecId = Guid.NewGuid();

        var request = new CreateDoctorRequest
        {
            FirstName = "Failed",
            LastName = "Doctor",
            NameAr = "د. فاشل",
            NameEn = "Dr. Failed",
            Email = "failed@appoynt.com",
            PhoneNumber = "+201077778888",
            Password = "Password123!",
            SpecializationIds = [nonExistentSpecId]
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/users/doctors", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);

        // Verify transaction was rolled back and no ApplicationUser or Doctor was created
        using (var scope = _factory.Services.CreateScope())
        {
            var db = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
            var user = await db.Users.FirstOrDefaultAsync(u => u.Email == "failed@appoynt.com");
            user.Should().BeNull();
        }
    }

    [Fact]
    public async Task CreateDoctor_WithMoreThan5PhoneNumbers_ShouldReturnBadRequest()
    {
        // Arrange
        string adminToken = await GetAdminTokenAsync();
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminToken);

        var request = new CreateDoctorRequest
        {
            FirstName = "Busy",
            LastName = "Doctor",
            NameAr = "د. مشغول",
            NameEn = "Dr. Busy",
            Email = "busy@appoynt.com",
            PhoneNumber = "+201011119999",
            Password = "Password123!",
            PhoneNumbers =
            [
                new DoctorPhoneNumberDto { PhoneNumber = "+201011110001", Label = "P1" },
                new DoctorPhoneNumberDto { PhoneNumber = "+201011110002", Label = "P2" },
                new DoctorPhoneNumberDto { PhoneNumber = "+201011110003", Label = "P3" },
                new DoctorPhoneNumberDto { PhoneNumber = "+201011110004", Label = "P4" },
                new DoctorPhoneNumberDto { PhoneNumber = "+201011110005", Label = "P5" },
                new DoctorPhoneNumberDto { PhoneNumber = "+201011110006", Label = "P6" }
            ]
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/users/doctors", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
    }

    [Fact]
    public async Task CreateDoctor_WithDuplicatePhoneNumbers_ShouldReturnBadRequest()
    {
        // Arrange
        string adminToken = await GetAdminTokenAsync();
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminToken);

        var request = new CreateDoctorRequest
        {
            FirstName = "Dupe",
            LastName = "Doctor",
            NameAr = "د. مكرر",
            NameEn = "Dr. Dupe",
            Email = "dupe@appoynt.com",
            PhoneNumber = "+201011118888",
            Password = "Password123!",
            PhoneNumbers =
            [
                new DoctorPhoneNumberDto { PhoneNumber = "+201099991111", Label = "Clinic 1" },
                new DoctorPhoneNumberDto { PhoneNumber = "+201099991111", Label = "Clinic 2" }
            ]
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/users/doctors", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
    }

    #endregion

    #region Doctor Profile Photo Workflow Tests

    [Fact]
    public async Task DoctorProfilePhoto_UploadGetDeleteWorkflow_ShouldSucceed()
    {
        // Arrange: Admin creates a doctor
        string adminToken = await GetAdminTokenAsync();
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminToken);

        var doctorRequest = new CreateDoctorRequest
        {
            FirstName = "Photo",
            LastName = "Doc",
            NameAr = "د. فوتو",
            NameEn = "Dr. Photo",
            Email = "photodoc@appoynt.com",
            PhoneNumber = "+201044443333",
            Password = "Password123!"
        };
        var createResp = await _client.PostAsJsonAsync("/api/users/doctors", doctorRequest);
        createResp.StatusCode.Should().Be(HttpStatusCode.Created);

        // Authenticate as the newly created Doctor
        string doctorToken = await GetTokenAsync("photodoc@appoynt.com", "Password123!");
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", doctorToken);

        // Generate a 1200x900 test image (exceeds 800px to test resizing)
        byte[] testImageBytes = GenerateTestImageBytes(1200, 900);

        using var formContent = new MultipartFormDataContent();
        using var streamContent = new ByteArrayContent(testImageBytes);
        streamContent.Headers.ContentType = MediaTypeHeaderValue.Parse("image/png");
        formContent.Add(streamContent, "file", "doctor_avatar.png");

        // Act 1: Upload Photo as Doctor
        var uploadResp = await _client.PostAsync("/api/doctors/profile-photo", formContent);

        // Assert 1: Upload succeeds and returns .jpg stored path
        uploadResp.StatusCode.Should().Be(HttpStatusCode.OK);
        var uploadResult = await uploadResp.Content.ReadFromJsonAsync<ProfileImageResult>();
        uploadResult.Should().NotBeNull();
        uploadResult!.Succeeded.Should().BeTrue();
        uploadResult.StoredPath.Should().EndWith(".jpg");

        // Resolve Doctor ID from DB
        Guid doctorId;
        using (var scope = _factory.Services.CreateScope())
        {
            var db = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
            var doc = await db.Doctors.Include(d => d.User).FirstAsync(d => d.User.Email == "photodoc@appoynt.com");
            doctorId = doc.Id;
            doc.User.ProfilePicturePath.Should().NotBeNullOrEmpty();
            doc.User.ProfilePicturePath.Should().EndWith(".jpg");
        }

        // Act 2: GET Doctor Photo (as authenticated doctor)
        var getPhotoResp = await _client.GetAsync($"/api/doctors/{doctorId}/profile-photo");
        getPhotoResp.StatusCode.Should().Be(HttpStatusCode.OK);
        getPhotoResp.Content.Headers.ContentType?.MediaType.Should().Be("image/jpeg");

        // Act 3: GET Doctor Photo (as Admin — verifying open visibility to any authenticated user)
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminToken);
        var getPhotoAsAdminResp = await _client.GetAsync($"/api/doctors/{doctorId}/profile-photo");
        getPhotoAsAdminResp.StatusCode.Should().Be(HttpStatusCode.OK);
        getPhotoAsAdminResp.Content.Headers.ContentType?.MediaType.Should().Be("image/jpeg");

        // Act 4: Delete Doctor Photo (as Doctor)
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", doctorToken);
        var deleteResp = await _client.DeleteAsync("/api/doctors/profile-photo");
        deleteResp.StatusCode.Should().Be(HttpStatusCode.OK);

        // Act 5: GET Doctor Photo after deletion -> 404
        var getPhotoAfterDeleteResp = await _client.GetAsync($"/api/doctors/{doctorId}/profile-photo");
        getPhotoAfterDeleteResp.StatusCode.Should().Be(HttpStatusCode.NotFound);
    }

    [Fact]
    public async Task DoctorProfilePhoto_Upload_WhenNotDoctor_ShouldReturnForbidden()
    {
        // Arrange: Try to upload photo using Admin credentials
        string adminToken = await GetAdminTokenAsync();
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminToken);

        byte[] testImageBytes = GenerateTestImageBytes(100, 100);
        using var formContent = new MultipartFormDataContent();
        using var streamContent = new ByteArrayContent(testImageBytes);
        streamContent.Headers.ContentType = MediaTypeHeaderValue.Parse("image/png");
        formContent.Add(streamContent, "file", "avatar.png");

        // Act: Admin tries to POST to /api/doctors/profile-photo
        var response = await _client.PostAsync("/api/doctors/profile-photo", formContent);

        // Assert: 403 Forbidden because only Doctor role is authorized to upload own photo
        response.StatusCode.Should().Be(HttpStatusCode.Forbidden);
    }

    [Fact]
    public async Task DefaultSeededDoctor_ShouldBeAbleToLogin_WithDefaultCredentials()
    {
        // Act: Login with default seeded doctor credentials
        var loginRequest = new LoginRequest
        {
            Identifier = "doctor@appoynt.com",
            Password = "Password123!"
        };

        var response = await _client.PostAsJsonAsync("/api/auth/login", loginRequest);

        // Assert: Login should succeed and return access token
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var result = await response.Content.ReadFromJsonAsync<LoginResponse>();
        result.Should().NotBeNull();
        result!.AccessToken.Should().NotBeNullOrWhiteSpace();

        // Verify that the token allows accessing Doctor-authorized endpoints
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", result.AccessToken);
        var myClinicsResponse = await _client.GetAsync("/api/clinics/my");
        myClinicsResponse.StatusCode.Should().Be(HttpStatusCode.OK);
    }

    #endregion

    #region Doctor Profile & IDOR Tests

    [Fact]
    public async Task UpdateDoctorProfile_ShouldUpdateDomainAndBaseUser_InTransaction()
    {
        // Arrange
        string adminToken = await GetAdminTokenAsync();
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminToken);

        Guid specId = Guid.NewGuid();
        using (var scope = _factory.Services.CreateScope())
        {
            var db = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
            db.Specializations.Add(new Specialization
            {
                Id = specId,
                NameEn = "Derma " + Guid.NewGuid().ToString("N")[..6],
                NameAr = "جلدية " + Guid.NewGuid().ToString("N")[..6]
            });
            await db.SaveChangesAsync();
        }

        var createReq = new CreateDoctorRequest
        {
            FirstName = "Skin",
            LastName = "Doc",
            NameAr = "دكتور سكين",
            NameEn = "Dr. Skin",
            Email = "skin@appoynt.com",
            PhoneNumber = "+201099995555",
            Password = "Password123!"
        };
        await _client.PostAsJsonAsync("/api/users/doctors", createReq);

        string doctorToken = await GetTokenAsync("skin@appoynt.com", "Password123!");
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", doctorToken);

        var updateReq = new Appoynt.Application.Features.Doctor.Contracts.UpdateDoctorProfileRequest
        {
            FirstName = "Super",
            LastName = "Skin",
            NameEn = "Dr. Super Skin",
            Bio = "Best skin doctor",
            SpecializationIds = [specId]
        };

        // Act
        var response = await _client.PutAsJsonAsync("/api/doctors/profile", updateReq);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var getResp = await _client.GetAsync("/api/doctors/profile");
        var profile = await getResp.Content.ReadFromJsonAsync<Appoynt.Application.Features.Doctor.Contracts.DoctorProfileResponse>();
        
        profile.Should().NotBeNull();
        profile!.FirstName.Should().Be("Super");
        profile.NameEn.Should().Be("Dr. Super Skin");
        profile.Bio.Should().Be("Best skin doctor");
        profile.Specializations.Should().ContainSingle(s => s.Id == specId);
    }

    [Fact]
    public async Task UpdateDoctorProfile_IDOR_ShouldNotAllowEditingOtherDoctor()
    {
        // 1. Arrange: Seed Doctor A and Doctor B
        string adminToken = await GetAdminTokenAsync();
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminToken);

        Guid specId = Guid.NewGuid();
        using (var scope = _factory.Services.CreateScope())
        {
            var db = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
            db.Specializations.Add(new Specialization
            {
                Id = specId,
                NameEn = "Derma IDOR " + Guid.NewGuid().ToString("N")[..6],
                NameAr = "جلدية " + Guid.NewGuid().ToString("N")[..6]
            });
            await db.SaveChangesAsync();
        }

        // Create Doctor A
        var doctorAReq = new CreateDoctorRequest
        {
            FirstName = "Doctor",
            LastName = "A",
            NameAr = "دكتور أ",
            NameEn = "Dr. A",
            Email = "doctorA@appoynt.com",
            PhoneNumber = "+201010001000",
            Password = "Password123!"
        };
        await _client.PostAsJsonAsync("/api/users/doctors", doctorAReq);

        // Create Doctor B
        var doctorBReq = new CreateDoctorRequest
        {
            FirstName = "Doctor",
            LastName = "B",
            NameAr = "دكتور ب",
            NameEn = "Dr. B",
            Email = "doctorB@appoynt.com",
            PhoneNumber = "+201020002000",
            Password = "Password123!"
        };
        await _client.PostAsJsonAsync("/api/users/doctors", doctorBReq);

        // 2. Act: Login as Doctor A and try to update profile
        string doctorAToken = await GetTokenAsync("doctorA@appoynt.com", "Password123!");
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", doctorAToken);

        // Note: UpdateDoctorProfileRequest structurally lacks an 'Id' or 'DoctorId' field.
        // The service resolves identity solely from the token. We update the data to "Hacked".
        var updateReq = new Appoynt.Application.Features.Doctor.Contracts.UpdateDoctorProfileRequest
        {
            FirstName = "Hacked",
            LastName = "Attempt",
            NameEn = "Dr. Hacked",
            SpecializationIds = [specId]
        };

        var response = await _client.PutAsJsonAsync("/api/doctors/profile", updateReq);
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        // 3. Assert: Ensure ONLY Doctor A was updated, and Doctor B remained completely untouched.
        using (var scope = _factory.Services.CreateScope())
        {
            var db = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
            
            var targetDoctorA = await db.Doctors.Include(d => d.User).FirstAsync(d => d.User.Email == "doctorA@appoynt.com");
            targetDoctorA.User.FirstName.Should().Be("Hacked");
            targetDoctorA.User.LastName.Should().Be("Attempt");
            targetDoctorA.NameEn.Should().Be("Dr. Hacked");

            var untouchedDoctorB = await db.Doctors.Include(d => d.User).FirstAsync(d => d.User.Email == "doctorB@appoynt.com");
            untouchedDoctorB.User.FirstName.Should().Be("Doctor");
            untouchedDoctorB.User.LastName.Should().Be("B");
            untouchedDoctorB.NameEn.Should().Be("Dr. B");
        }
    }

    #endregion
}
