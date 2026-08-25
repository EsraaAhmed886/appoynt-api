using System.Net;
using System.Net.Http.Json;
using Appoynt.Application.Features.Authentication.Login.Contracts;
using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Application.Features.Authentication.Registration.Contracts;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;

namespace Appoynt.Tests.IntegrationTests;

/// <summary>
/// API integration tests for AuthenticationController endpoints.
/// </summary>
[Collection("Integration Tests")]
public sealed class AuthenticationControllerTests : IClassFixture<WebApplicationFactory<Appoynt.API.Program>>
{
    private readonly WebApplicationFactory<Appoynt.API.Program> _factory;

    public AuthenticationControllerTests(WebApplicationFactory<Appoynt.API.Program> factory)
    {
        _factory = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureAppConfiguration((context, config) =>
            {
                config.AddInMemoryCollection(new Dictionary<string, string?>
                {
                    ["DatabaseProvider"] = "Sqlite",
                    ["ConnectionStrings:DefaultConnection"] = "DataSource=file:appoynt_test.db?mode=memory&cache=shared",
                    ["Jwt:SecretKey"] = "SuperSecretKeyWithMinimum32CharactersLength!",
                    ["Seed:Enabled"] = "true",
                    ["Seed:Admin:Password"] = "P@ssword123!"
                });
            });
        });
    }

    [Fact]
    public async Task Register_ShouldReturnCreatedWithIds_WhenRequestIsValid()
    {
        HttpClient client = _factory.CreateClient();

        var request = new RegisterRequest
        {
            FirstName = "Integration",
            LastName = "Patient",
            Email = "integration.patient@example.com",
            PhoneNumber = "01011112222",
            Password = "P@ssword123",
            ConfirmPassword = "P@ssword123"
        };

        HttpResponseMessage response = await client.PostAsJsonAsync("/api/auth/register", request);

        response.StatusCode.Should().Be(HttpStatusCode.Created);

        var body = await response.Content.ReadFromJsonAsync<RegisterResponse>();
        body.Should().NotBeNull();
        body!.UserId.Should().NotBeEmpty();
        body.ChallengeId.Should().NotBeEmpty();
    }

    [Fact]
    public async Task Register_ShouldReturnBadRequest_WhenEmailIsInvalid()
    {
        HttpClient client = _factory.CreateClient();

        var request = new RegisterRequest
        {
            FirstName = "Integration",
            LastName = "Patient",
            Email = "invalid-email-address",
            PhoneNumber = "01011112222",
            Password = "P@ssword123",
            ConfirmPassword = "P@ssword123"
        };

        HttpResponseMessage response = await client.PostAsJsonAsync("/api/auth/register", request);

        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
    }

    [Fact]
    public async Task Login_ShouldReturnUnauthorized_WhenPhoneIsNotConfirmed()
    {
        HttpClient client = _factory.CreateClient();

        // 1. Register user
        var regRequest = new RegisterRequest
        {
            FirstName = "Unconfirmed",
            LastName = "User",
            Email = "unconfirmed.patient@example.com",
            PhoneNumber = "01022223333",
            Password = "P@ssword123",
            ConfirmPassword = "P@ssword123"
        };

        await client.PostAsJsonAsync("/api/auth/register", regRequest);

        // 2. Attempt login before OTP verification
        var loginRequest = new LoginRequest
        {
            Identifier = "unconfirmed.patient@example.com",
            Password = "P@ssword123"
        };

        HttpResponseMessage response = await client.PostAsJsonAsync("/api/auth/login", loginRequest);

        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    [Fact]
    public async Task OtpVerify_ShouldReturnBadRequest_WhenChallengeIdIsInvalid()
    {
        HttpClient client = _factory.CreateClient();

        var verifyRequest = new VerifyOtpRequest
        {
            ChallengeId = Guid.NewGuid(),
            Code = "123456"
        };

        HttpResponseMessage response = await client.PostAsJsonAsync("/api/auth/otp/verify", verifyRequest);

        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
    }

    [Fact]
    public async Task OtpResend_ShouldReturnBadRequest_WhenChallengeNotExpired()
    {
        HttpClient client = _factory.CreateClient();

        var regRequest = new RegisterRequest
        {
            FirstName = "Resend",
            LastName = "Test",
            Email = "resend.test@example.com",
            PhoneNumber = "01033334444",
            Password = "P@ssword123",
            ConfirmPassword = "P@ssword123"
        };

        HttpResponseMessage regResponse = await client.PostAsJsonAsync("/api/auth/register", regRequest);
        var regBody = await regResponse.Content.ReadFromJsonAsync<RegisterResponse>();

        var resendRequest = new ResendOtpRequest
        {
            ChallengeId = regBody!.ChallengeId
        };

        HttpResponseMessage response = await client.PostAsJsonAsync("/api/auth/otp/resend", resendRequest);

        // Should return BadRequest because OTP is active (cooldown not expired)
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
    }

    [Fact]
    public async Task Register_ShouldSucceed_WhenEmailAndPhoneReusedAfterSoftDelete()
    {
        HttpClient client = _factory.CreateClient();

        // 1. Register a patient
        var regRequest = new RegisterRequest
        {
            FirstName = "Deleted",
            LastName = "Patient",
            Email = "reusable.patient@example.com",
            PhoneNumber = "01088887777",
            Password = "P@ssword123",
            ConfirmPassword = "P@ssword123"
        };

        HttpResponseMessage regResponse = await client.PostAsJsonAsync("/api/auth/register", regRequest);
        regResponse.StatusCode.Should().Be(HttpStatusCode.Created);
        var regBody = await regResponse.Content.ReadFromJsonAsync<RegisterResponse>();
        regBody.Should().NotBeNull();
        regBody!.UserId.Should().NotBeEmpty();

        // 2. Admin logs in
        var loginAdmin = new LoginRequest
        {
            Identifier = "admin@appoynt.com",
            Password = "P@ssword123!"
        };
        var loginResponse = await client.PostAsJsonAsync("/api/auth/login", loginAdmin);
        var loginBody = await loginResponse.Content.ReadFromJsonAsync<LoginResponse>();

        // 3. Admin soft-deletes the patient
        var deleteRequest = new HttpRequestMessage(HttpMethod.Delete, $"/api/users/{regBody.UserId}");
        deleteRequest.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", loginBody!.AccessToken);
        var deleteResponse = await client.SendAsync(deleteRequest);
        deleteResponse.StatusCode.Should().Be(HttpStatusCode.NoContent);

        // 4. Re-register with the EXACT SAME email and phone number
        var secondRegRequest = new RegisterRequest
        {
            FirstName = "Recreated",
            LastName = "Patient",
            Email = "reusable.patient@example.com",
            PhoneNumber = "01088887777",
            Password = "P@ssword123",
            ConfirmPassword = "P@ssword123"
        };

        HttpResponseMessage secondRegResponse = await client.PostAsJsonAsync("/api/auth/register", secondRegRequest);

        // Assert
        secondRegResponse.StatusCode.Should().Be(HttpStatusCode.Created);
        var secondRegBody = await secondRegResponse.Content.ReadFromJsonAsync<RegisterResponse>();
        secondRegBody.Should().NotBeNull();
        secondRegBody!.UserId.Should().NotBe(regBody.UserId);
        secondRegBody.ChallengeId.Should().NotBeEmpty();
    }
}
