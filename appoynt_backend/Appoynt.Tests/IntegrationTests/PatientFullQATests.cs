/**
 * File Name      : PatientFullQATests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : WebApplicationFactory, HttpClient, System.Net.Http.Json
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Comprehensive API Integration tests for PatientsController endpoints
 *                  (Get/Update Profile, Upload/Stream/Delete Profile Photo,
 *                  Add/List/Get/Update/Delete Family Members) and UsersController.DeleteAllUsers.
 */

using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Threading.Tasks;
using Appoynt.Application.Features.Authentication.Login.Contracts;
using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Application.Features.Authentication.Registration.Contracts;
using Appoynt.Application.Features.Patient.Contracts;
using Appoynt.Domain.Enums;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;
using Xunit;

namespace Appoynt.Tests.IntegrationTests;

[Collection("Sequential")]
public class PatientFullQATests : IClassFixture<WebApplicationFactory<Appoynt.API.Program>>
{
    private readonly WebApplicationFactory<Appoynt.API.Program> _factory;
    private const string SecretKey = "SuperSecretKeyWithMinimum32CharactersLength!";

    public PatientFullQATests(WebApplicationFactory<Appoynt.API.Program> factory)
    {
        _factory = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureAppConfiguration((context, config) =>
            {
                config.AddInMemoryCollection(new Dictionary<string, string?>
                {
                    ["DatabaseProvider"] = "Sqlite",
                    ["ConnectionStrings:DefaultConnection"] = "DataSource=file:appoynt_patient_qa_test.db?mode=memory&cache=shared",
                    ["Jwt:Issuer"] = "Appoynt.API",
                    ["Jwt:Audience"] = "Appoynt.Client",
                    ["Jwt:SecretKey"] = SecretKey,
                    ["FileStorage:RootPath"] = "App_Data/uploads_test",
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
                    ["Seed:Admin:Email"] = "admin.patientqa@appoynt.com",
                    ["Seed:Admin:PhoneNumber"] = "01099998877",
                    ["Seed:Admin:Password"] = "Password123!@#"
                });
            });
        });
    }

    [Fact]
    public async Task CompletePatientWorkflow_IntegrationTest()
    {
        var client = _factory.CreateClient();

        // 1. Register Patient
        string email = $"patient.qa.{Guid.NewGuid():N}@appoynt.com";
        string phone = "010" + Random.Shared.Next(10000000, 99999999).ToString();
        string password = "P@ssword123!";

        var regResponse = await client.PostAsJsonAsync("/api/auth/register", new RegisterRequest
        {
            FirstName = "Test",
            LastName = "Patient",
            Email = email,
            PhoneNumber = phone,
            Password = password,
            ConfirmPassword = password
        });
        regResponse.StatusCode.Should().Be(HttpStatusCode.Created);
        var regBody = await regResponse.Content.ReadFromJsonAsync<RegisterResponse>();
        regBody.Should().NotBeNull();

        // 2. Verify OTP
        var verifyResponse = await client.PostAsJsonAsync("/api/auth/otp/verify", new VerifyOtpRequest
        {
            ChallengeId = regBody!.ChallengeId,
            Code = "123456"
        });
        verifyResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        // 3. Login as Patient
        var loginResponse = await client.PostAsJsonAsync("/api/auth/login", new LoginRequest
        {
            Identifier = email,
            Password = password
        });
        loginResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var loginBody = await loginResponse.Content.ReadFromJsonAsync<LoginResponse>();
        loginBody.Should().NotBeNull();
        string token = loginBody!.AccessToken;

        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // 4. Get Patient Profile (Initial)
        var getProfileResp = await client.GetAsync("/api/patients/profile");
        getProfileResp.StatusCode.Should().Be(HttpStatusCode.OK);
        var profile = await getProfileResp.Content.ReadFromJsonAsync<PatientProfileResponse>();
        profile.Should().NotBeNull();
        profile!.PID.Should().HaveLength(9);
        profile.FamilyNumber.Should().HaveLength(7);
        profile.PID.Should().EndWith("U0");

        // 5. Update Patient Profile
        var updateProfileResp = await client.PutAsJsonAsync("/api/patients/profile", new UpdatePatientProfileRequest
        {
            NationalId = "29810150101234",
            WeightKg = 78.5m,
            HeightCm = 180.0m,
            BloodGroup = BloodGroup.OPositive,
            SmokingStatus = SmokingStatus.NonSmoker
        });
        updateProfileResp.StatusCode.Should().Be(HttpStatusCode.OK);

        // Verify updated profile
        getProfileResp = await client.GetAsync("/api/patients/profile");
        profile = await getProfileResp.Content.ReadFromJsonAsync<PatientProfileResponse>();
        profile!.NationalId.Should().Be("29810150101234");
        profile.BirthDate.Should().Be(new DateOnly(1998, 10, 15));
        profile.WeightKg.Should().Be(78.5m);
        profile.BloodGroup.Should().Be(BloodGroup.OPositive);

        // 6. Upload Profile Photo
        byte[] validPhoto = Convert.FromBase64String("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==");
        using var content = new MultipartFormDataContent();
        using var streamContent = new ByteArrayContent(validPhoto);
        streamContent.Headers.ContentType = MediaTypeHeaderValue.Parse("image/png");
        content.Add(streamContent, "file", "avatar.png");

        var uploadPhotoResp = await client.PostAsync("/api/patients/profile-photo", content);
        uploadPhotoResp.StatusCode.Should().Be(HttpStatusCode.OK);

        // Verify profile photo exists
        getProfileResp = await client.GetAsync("/api/patients/profile");
        profile = await getProfileResp.Content.ReadFromJsonAsync<PatientProfileResponse>();
        profile!.HasProfilePhoto.Should().BeTrue();

        // 7. Get Profile Photo Stream
        var getPhotoResp = await client.GetAsync($"/api/patients/{profile.Id}/profile-photo");
        getPhotoResp.StatusCode.Should().Be(HttpStatusCode.OK);
        getPhotoResp.Content.Headers.ContentType?.MediaType.Should().Be("image/jpeg");

        // 8. Delete Profile Photo
        var deletePhotoResp = await client.DeleteAsync("/api/patients/profile-photo");
        deletePhotoResp.StatusCode.Should().Be(HttpStatusCode.OK);

        getProfileResp = await client.GetAsync("/api/patients/profile");
        profile = await getProfileResp.Content.ReadFromJsonAsync<PatientProfileResponse>();
        profile!.HasProfilePhoto.Should().BeFalse();

        // 9. Add Family Member (Wife)
        var addFamilyResp = await client.PostAsJsonAsync("/api/patients/family-members", new AddFamilyMemberRequest
        {
            FullName = "Fatima Mahmoud",
            Gender = Gender.Female,
            Relationship = FamilyRelationship.Wife,
            BirthDate = new DateOnly(1999, 4, 20)
        });
        addFamilyResp.StatusCode.Should().Be(HttpStatusCode.OK);
        var familyResult = await addFamilyResp.Content.ReadFromJsonAsync<PatientResult>();
        familyResult.Should().NotBeNull();
        Guid familyMemberId = familyResult!.PatientId!.Value;

        // 10. List Family Members
        var getFamilyResp = await client.GetAsync("/api/patients/family-members");
        getFamilyResp.StatusCode.Should().Be(HttpStatusCode.OK);
        var familyList = await getFamilyResp.Content.ReadFromJsonAsync<List<FamilyMemberResponse>>();
        familyList.Should().NotBeNull();
        familyList.Should().HaveCount(1);
        familyList![0].FullName.Should().Be("Fatima Mahmoud");
        familyList[0].PID.Should().Be(profile.FamilyNumber + "W1");

        // 11. Get Family Member By ID
        var getMemberByIdResp = await client.GetAsync($"/api/patients/family-members/{familyMemberId}");
        getMemberByIdResp.StatusCode.Should().Be(HttpStatusCode.OK);
        var member = await getMemberByIdResp.Content.ReadFromJsonAsync<FamilyMemberResponse>();
        member.Should().NotBeNull();
        member!.Id.Should().Be(familyMemberId);

        // 12. Update Family Member
        var updateFamilyResp = await client.PutAsJsonAsync($"/api/patients/family-members/{familyMemberId}", new UpdateFamilyMemberRequest
        {
            FullName = "Fatima M. Ali"
        });
        updateFamilyResp.StatusCode.Should().Be(HttpStatusCode.OK);

        getMemberByIdResp = await client.GetAsync($"/api/patients/family-members/{familyMemberId}");
        member = await getMemberByIdResp.Content.ReadFromJsonAsync<FamilyMemberResponse>();
        member!.FullName.Should().Be("Fatima M. Ali");

        // 13. Delete Family Member
        var deleteFamilyResp = await client.DeleteAsync($"/api/patients/family-members/{familyMemberId}");
        deleteFamilyResp.StatusCode.Should().Be(HttpStatusCode.OK);

        getFamilyResp = await client.GetAsync("/api/patients/family-members");
        familyList = await getFamilyResp.Content.ReadFromJsonAsync<List<FamilyMemberResponse>>();
        familyList.Should().BeEmpty();
    }
}
