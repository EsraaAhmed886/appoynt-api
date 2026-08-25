/**
 * File Name      : SecurityIntegrationTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-24
 * Version        : v1.0.0
 * Dependencies   : WebApplicationFactory, HttpClient, FluentAssertions,
 *                  Authentication and Patient Contracts
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-24
 * Description    : API integration tests focused on Insecure Direct Object Reference
 *                  (IDOR) protection: verifying that patients cannot read or mutate
 *                  other patients' family members, that listings remain isolated per
 *                  account, that role-restricted endpoints reject foreign roles, and
 *                  that anonymous callers receive 401 responses.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Threading.Tasks;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Features.Authentication.Login.Contracts;
using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Application.Features.Authentication.Registration.Contracts;
using Appoynt.Application.Features.Patient.Contracts;
using Appoynt.Application.Common.Models;
using Appoynt.Domain.Enums;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;
using Xunit;

namespace Appoynt.Tests.IntegrationTests;

/// <summary>
/// Security-focused integration tests guarding against cross-patient data access.
/// </summary>
[Collection("Sequential")]
public sealed class SecurityIntegrationTests : IClassFixture<WebApplicationFactory<Appoynt.API.Program>>
{
    // Fixed development OTP accepted by the OTP service in test environments.
    private const string DevelopmentOtpCode = "123456";

    // Factory hosting the API under test with an isolated database.
    private readonly WebApplicationFactory<Appoynt.API.Program> _factory;

    /// <summary>
    /// Initializes the test factory with isolated storage, relaxed rate limits, and seeding.
    /// </summary>
    /// <param name="factory">The shared host factory provided by xUnit.</param>
    public SecurityIntegrationTests(WebApplicationFactory<Appoynt.API.Program> factory)
    {
        _factory = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureAppConfiguration((context, config) =>
            {
                config.AddInMemoryCollection(new Dictionary<string, string?>
                {
                    ["DatabaseProvider"] = "Sqlite",
                    ["ConnectionStrings:DefaultConnection"] = "DataSource=file:appoynt_security_test.db?mode=memory&cache=shared",
                    ["Jwt:SecretKey"] = "SuperSecretKeyWithMinimum32CharactersLength!",
                    ["FileStorage:RootPath"] = "App_Data/uploads_security_test",
                    ["RateLimiting:Register:PermitLimit"] = "100",
                    ["RateLimiting:Register:WindowInMinutes"] = "60",
                    ["RateLimiting:Login:PermitLimit"] = "100",
                    ["RateLimiting:Login:WindowInMinutes"] = "60",
                    ["RateLimiting:OtpVerify:PermitLimit"] = "100",
                    ["RateLimiting:OtpVerify:WindowInMinutes"] = "60",
                    ["RateLimiting:OtpResend:PermitLimit"] = "100",
                    ["RateLimiting:OtpResend:WindowInMinutes"] = "60",
                    ["Seed:Enabled"] = "true",
                    ["Seed:Admin:Password"] = "P@ssword123!"
                });
            });
        });
    }

    /// <summary>
    /// Registers a fresh patient account, confirms the phone via development OTP, logs in,
    /// and returns an authenticated HTTP client plus the patient's user identifier.
    /// </summary>
    /// <param name="label">A unique label used to build distinct credentials.</param>
    /// <returns>The authenticated client and registered user identifier.</returns>
    private async Task<(HttpClient Client, Guid UserId)> CreateAuthenticatedPatientAsync(string label)
    {
        // Build unique registration values from the supplied label.
        var client = _factory.CreateClient();
        string email = $"security.{label}.{Guid.NewGuid():N}@appoynt.com";
        string phone = "010" + Random.Shared.Next(10000000, 99999999).ToString();
        const string password = "P@ssword123!";

        // Register the patient account.
        var registerResponse = await client.PostAsJsonAsync("/api/auth/register", new RegisterRequest
        {
            FirstName = "Security",
            LastName = label,
            Email = email,
            PhoneNumber = phone,
            Password = password,
            ConfirmPassword = password
        });
        registerResponse.StatusCode.Should().Be(HttpStatusCode.Created);
        var registerBody = await registerResponse.Content.ReadFromJsonAsync<RegisterResponse>();
        registerBody.Should().NotBeNull();

        // Confirm the phone number using the fixed development OTP.
        var verifyResponse = await client.PostAsJsonAsync("/api/auth/otp/verify", new VerifyOtpRequest
        {
            ChallengeId = registerBody!.ChallengeId,
            Code = DevelopmentOtpCode
        });
        verifyResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        // Log in and attach the bearer token to the returned client.
        var loginResponse = await client.PostAsJsonAsync("/api/auth/login", new LoginRequest
        {
            Identifier = email,
            Password = password
        });
        loginResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var loginBody = await loginResponse.Content.ReadFromJsonAsync<LoginResponse>();
        loginBody!.AccessToken.Should().NotBeNullOrWhiteSpace();

        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loginBody.AccessToken);
        return (client, registerBody.UserId);
    }

    /// <summary>
    /// Adds one family member to the given patient and returns its identifier.
    /// </summary>
    /// <param name="client">An authenticated patient client.</param>
    /// <returns>The newly created family member identifier.</returns>
    private static async Task<Guid> AddFamilyMemberAndCaptureIdAsync(HttpClient client)
    {
        // Add a valid son entry for the calling patient.
        var addResponse = await client.PostAsJsonAsync("/api/patients/family-members", new AddFamilyMemberRequest
        {
            FullName = "Karim Security",
            Gender = Gender.Male,
            Relationship = FamilyRelationship.Son,
            BirthDate = new DateOnly(2016, 3, 8)
        });
        addResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        // Read back the listing to capture the generated member identifier.
        var listResponse = await client.GetAsync("/api/patients/family-members");
        listResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var members = await listResponse.Content.ReadFromJsonAsync<List<FamilyMemberResponse>>();
        members.Should().NotBeNull();
        members.Should().HaveCount(1);
        return members![0].Id;
    }

    #region Cross-Patient Family Member Access (IDOR)

    /// <summary>
    /// Patient B must receive 404 when reading a family member owned by patient A.
    /// </summary>
    [Fact]
    public async Task GetFamilyMemberById_OtherPatientsMember_ReturnsNotFound()
    {
        // Arrange two independent patients where A owns one family member.
        var (patientAClient, _) = await CreateAuthenticatedPatientAsync("idorGetOwner");
        Guid memberAId = await AddFamilyMemberAndCaptureIdAsync(patientAClient);
        var (patientBClient, _) = await CreateAuthenticatedPatientAsync("idorGetAttacker");

        // Act as patient B requesting A's family member directly by identifier.
        var response = await patientBClient.GetAsync($"/api/patients/family-members/{memberAId}");

        // Assert the foreign record is invisible.
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);
    }

    /// <summary>
    /// Patient B must not be able to update a family member owned by patient A.
    /// </summary>
    [Fact]
    public async Task UpdateFamilyMember_OtherPatientsMember_ReturnsBadRequestWithNotFoundError()
    {
        // Arrange two patients where A owns the targeted family member.
        var (patientAClient, _) = await CreateAuthenticatedPatientAsync("idorPutOwner");
        Guid memberAId = await AddFamilyMemberAndCaptureIdAsync(patientAClient);
        var (patientBClient, _) = await CreateAuthenticatedPatientAsync("idorPutAttacker");

        // Act as patient B attempting to rename A's family member.
        var response = await patientBClient.PutAsJsonAsync(
            $"/api/patients/family-members/{memberAId}",
            new UpdateFamilyMemberRequest { FullName = "Hacked Name" });

        // Assert mutation was refused with ownership-scoped not-found semantics.
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
        var errors = await response.Content.ReadFromJsonAsync<List<AuthenticationError>>();
        errors.Should().ContainSingle(error => error.Code == PatientErrorCodes.FamilyMemberNotFound);
    }

    /// <summary>
    /// Patient B must not be able to delete a family member owned by patient A.
    /// </summary>
    [Fact]
    public async Task DeleteFamilyMember_OtherPatientsMember_ReturnsBadRequestAndKeepsRecord()
    {
        // Arrange two patients where A owns the targeted family member.
        var (patientAClient, _) = await CreateAuthenticatedPatientAsync("idorDeleteOwner");
        Guid memberAId = await AddFamilyMemberAndCaptureIdAsync(patientAClient);
        var (patientBClient, _) = await CreateAuthenticatedPatientAsync("idorDeleteAttacker");

        // Act as patient B attempting to delete A's family member.
        var deleteResponse = await patientBClient.DeleteAsync($"/api/patients/family-members/{memberAId}");

        // Assert the deletion was refused.
        deleteResponse.StatusCode.Should().Be(HttpStatusCode.BadRequest);
        var errors = await deleteResponse.Content.ReadFromJsonAsync<List<AuthenticationError>>();
        errors.Should().ContainSingle(error => error.Code == PatientErrorCodes.FamilyMemberNotFound);

        // Verify A still sees the intact family member afterwards.
        var ownerViewResponse = await patientAClient.GetAsync($"/api/patients/family-members/{memberAId}");
        ownerViewResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var member = await ownerViewResponse.Content.ReadFromJsonAsync<FamilyMemberResponse>();
        member!.FullName.Should().Be("Karim Security");
    }

    /// <summary>
    /// Family member listings must only contain records belonging to the caller.
    /// </summary>
    [Fact]
    public async Task GetFamilyMembers_ListRemainsIsolatedPerPatient()
    {
        // Arrange two patients each owning exactly one distinct family member.
        var (patientAClient, _) = await CreateAuthenticatedPatientAsync("isolatedListA");
        Guid memberAId = await AddFamilyMemberAndCaptureIdAsync(patientAClient);
        var (patientBClient, _) = await CreateAuthenticatedPatientAsync("isolatedListB");
        Guid memberBId = await AddFamilyMemberAndCaptureIdAsync(patientBClient);

        // Act reading both listings.
        var listAResponse = await patientAClient.GetAsync("/api/patients/family-members");
        var listBResponse = await patientBClient.GetAsync("/api/patients/family-members");

        // Assert each listing contains only the owner's own record.
        var listA = await listAResponse.Content.ReadFromJsonAsync<List<FamilyMemberResponse>>();
        var listB = await listBResponse.Content.ReadFromJsonAsync<List<FamilyMemberResponse>>();
        listA!.Select(member => member.Id).Should().BeEquivalentTo(new[] { memberAId });
        listB!.Select(member => member.Id).Should().BeEquivalentTo(new[] { memberBId });
    }

    #endregion

    #region Role Boundary Enforcement

    /// <summary>
    /// The seeded administrator must be rejected by patient-only endpoints.
    /// </summary>
    [Fact]
    public async Task PatientProfile_AdminToken_ReturnsForbidden()
    {
        // Arrange an admin session against the seeded admin credentials.
        var client = _factory.CreateClient();
        var loginResponse = await client.PostAsJsonAsync("/api/auth/login", new LoginRequest
        {
            Identifier = "admin@appoynt.com",
            Password = "P@ssword123!"
        });
        loginResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        var loginBody = await loginResponse.Content.ReadFromJsonAsync<LoginResponse>();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loginBody!.AccessToken);

        // Act calling a patient-role endpoint as an administrator.
        var profileResponse = await client.GetAsync("/api/patients/profile");

        // Assert role enforcement denies access.
        profileResponse.StatusCode.Should().Be(HttpStatusCode.Forbidden);
    }

    /// <summary>
    /// Unauthenticated callers must receive 401 on protected patient endpoints.
    /// </summary>
    [Fact]
    public async Task FamilyMemberEndpoints_NoAuthentication_ReturnsUnauthorized()
    {
        // Arrange a client without any bearer token.
        var client = _factory.CreateClient();

        // Act hitting both listing and creation endpoints anonymously.
        var listResponse = await client.GetAsync("/api/patients/family-members");
        var createResponse = await client.PostAsJsonAsync("/api/patients/family-members", new AddFamilyMemberRequest
        {
            FullName = "Anonymous Entry",
            Gender = Gender.Male,
            Relationship = FamilyRelationship.Son,
            BirthDate = new DateOnly(2020, 1, 1)
        });

        // Assert both calls are rejected before reaching business logic.
        listResponse.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
        createResponse.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion
}
