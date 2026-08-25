/**
 * File Name      : GovernorateIntegrationTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : WebApplicationFactory, ApplicationDbContext, Governorate, City
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Integration tests verifying Egyptian governorates and cities lookup endpoints and seeding.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Threading.Tasks;
using Appoynt.Application.Features.Authentication.Login.Contracts;
using Appoynt.Application.Features.Clinics.Contracts;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;
using Xunit;

namespace Appoynt.Tests.IntegrationTests;

/// <summary>
/// Integration tests verifying Governorate and City lookup endpoints.
/// </summary>
[Collection("Integration Tests")]
public sealed class GovernorateIntegrationTests : IClassFixture<WebApplicationFactory<Appoynt.API.Program>>
{
    private readonly WebApplicationFactory<Appoynt.API.Program> _factory;

    /// <summary>
    /// Initializes test fixture with in-memory SQLite database.
    /// </summary>
    /// <param name="factory">The web application factory.</param>
    public GovernorateIntegrationTests(WebApplicationFactory<Appoynt.API.Program> factory)
    {
        _factory = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureAppConfiguration((context, config) =>
            {
                config.AddInMemoryCollection(new Dictionary<string, string?>
                {
                    ["DatabaseProvider"] = "Sqlite",
                    ["ConnectionStrings:DefaultConnection"] = "DataSource=file:appoynt_test_gov.db?mode=memory&cache=shared",
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
        loginResult.Should().NotBeNull();
        return loginResult!.AccessToken;
    }

    [Fact]
    public async Task GetAllGovernorates_ShouldReturnAll27Governorates_WhenSeeded()
    {
        // Arrange
        var client = _factory.CreateClient();
        var token = await AuthenticateAdminAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Act
        var response = await client.GetAsync("/api/governorates");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var governorates = await response.Content.ReadFromJsonAsync<List<GovernorateResponse>>();
        governorates.Should().NotBeNull();
        governorates!.Count.Should().BeGreaterThanOrEqualTo(27);
        governorates.Should().Contain(g => g.NameEn == "Cairo");
        governorates.Should().Contain(g => g.NameEn == "Alexandria");
        governorates.Should().Contain(g => g.NameEn == "Giza");
    }

    [Fact]
    public async Task GetCitiesByGovernorate_ShouldReturnCities_WhenGovernorateExists()
    {
        // Arrange
        var client = _factory.CreateClient();
        var token = await AuthenticateAdminAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var govResponse = await client.GetAsync("/api/governorates");
        var governorates = await govResponse.Content.ReadFromJsonAsync<List<GovernorateResponse>>();
        var cairo = governorates!.First(g => g.NameEn == "Cairo");

        // Act
        var response = await client.GetAsync($"/api/governorates/{cairo.Id}/cities");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var cities = await response.Content.ReadFromJsonAsync<List<CityResponse>>();
        cities.Should().NotBeNull();
        cities!.Count.Should().BeGreaterThan(0);
        cities.Should().Contain(c => c.NameEn == "Nasr City" || c.NameEn == "Maadi" || c.NameEn == "Helwan" || c.NameEn == "Cairo");
    }
}
