using System.Net;
using System.Net.Http.Json;
using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Application.Features.Authentication.PasswordRecovery.Contracts;
using Appoynt.Application.Features.Authentication.Registration.Contracts;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;

namespace Appoynt.Tests.IntegrationTests;

/// <summary>
/// API integration tests for Password Recovery endpoints.
/// </summary>
[Collection("Integration Tests")]
public sealed class PasswordRecoveryIntegrationTests : IClassFixture<WebApplicationFactory<Appoynt.API.Program>>
{
    private readonly WebApplicationFactory<Appoynt.API.Program> _factory;

    public PasswordRecoveryIntegrationTests(WebApplicationFactory<Appoynt.API.Program> factory)
    {
        _factory = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureAppConfiguration((context, config) =>
            {
                config.AddInMemoryCollection(new Dictionary<string, string?>
                {
                    ["DatabaseProvider"] = "Sqlite",
                    ["ConnectionStrings:DefaultConnection"] = "DataSource=file:appoynt_test_pwdrecovery.db?mode=memory&cache=shared",
                    ["Jwt:SecretKey"] = "SuperSecretKeyWithMinimum32CharactersLength!",
                    ["Seed:Enabled"] = "true",
                    ["Seed:Admin:Password"] = "P@ssword123!"
                });
            });
        });
    }

    [Fact]
    public async Task ForgotPassword_ShouldReturnChallenge_WhenUserExists()
    {
        HttpClient client = _factory.CreateClient();

        // 1. Register a user
        var regRequest = new RegisterRequest
        {
            FirstName = "Recovery",
            LastName = "User",
            Email = "recovery.user@example.com",
            PhoneNumber = "01099998888",
            Password = "P@ssword123",
            ConfirmPassword = "P@ssword123"
        };

        await client.PostAsJsonAsync("/api/auth/register", regRequest);

        // 2. Request Forgot Password
        var forgotReq = new ForgotPasswordRequest
        {
            Identifier = "recovery.user@example.com"
        };

        HttpResponseMessage forgotRes = await client.PostAsJsonAsync("/api/auth/forgot-password", forgotReq);
        if (!forgotRes.IsSuccessStatusCode)
        {
            string err = await forgotRes.Content.ReadAsStringAsync();
            throw new Exception($"Forgot password failed with status {forgotRes.StatusCode} and body {err}");
        }
        else
        {
        }
        forgotRes.StatusCode.Should().Be(HttpStatusCode.OK);

        var challenge = await forgotRes.Content.ReadFromJsonAsync<OtpChallengeResponse>();
        challenge.Should().NotBeNull();
        challenge!.ChallengeId.Should().NotBeEmpty();
    }

    [Fact]
    public async Task ForgotPassword_ShouldReturnBadRequest_WhenUserDoesNotExist()
    {
        HttpClient client = _factory.CreateClient();

        var forgotReq = new ForgotPasswordRequest
        {
            Identifier = "nonexistent.user@example.com"
        };

        HttpResponseMessage forgotRes = await client.PostAsJsonAsync("/api/auth/forgot-password", forgotReq);
        forgotRes.StatusCode.Should().Be(HttpStatusCode.BadRequest);
    }
}
