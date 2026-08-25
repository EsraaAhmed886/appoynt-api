using System.Net;
using System.Net.Http.Json;
using Appoynt.Application.Features.Authentication.Login.Contracts;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;

namespace Appoynt.Tests.IntegrationTests;

/// <summary>
/// API integration tests for Rate Limiting middleware.
/// </summary>
[Collection("Integration Tests")]
public sealed class RateLimitingIntegrationTests : IClassFixture<WebApplicationFactory<Appoynt.API.Program>>
{
    private readonly WebApplicationFactory<Appoynt.API.Program> _factory;

    public RateLimitingIntegrationTests(WebApplicationFactory<Appoynt.API.Program> factory)
    {
        _factory = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureAppConfiguration((context, config) =>
            {
                config.AddInMemoryCollection(new Dictionary<string, string?>
                {
                    ["DatabaseProvider"] = "Sqlite",
                    ["ConnectionStrings:DefaultConnection"] = "DataSource=file:appoynt_test_ratelimit.db?mode=memory&cache=shared",
                    ["Jwt:SecretKey"] = "SuperSecretKeyWithMinimum32CharactersLength!",
                    ["RateLimiting:Enabled"] = "true",
                    ["RateLimiting:Login:PermitLimit"] = "5", // Set permit limit to 5 for testing
                    ["RateLimiting:Login:WindowInMinutes"] = "1"
                });
            });
        });
    }

    [Fact]
    public async Task Login_ShouldReturnTooManyRequests_WhenRateLimitExceeded()
    {
        HttpClient client = _factory.CreateClient();

        var request = new LoginRequest
        {
            Identifier = "test@example.com",
            Password = "P@ssword123"
        };

        for (int i = 0; i < 5; i++)
        {
            HttpResponseMessage res = await client.PostAsJsonAsync("/api/auth/login", request);
            res.StatusCode.Should().NotBe(HttpStatusCode.TooManyRequests);
        }

        // 6th request should be blocked by rate limiter
        HttpResponseMessage responseBlocked = await client.PostAsJsonAsync("/api/auth/login", request);
        responseBlocked.StatusCode.Should().Be(HttpStatusCode.TooManyRequests);
    }
}
