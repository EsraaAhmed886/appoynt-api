/**
 * File Name      : UserPaginationIntegrationTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-24
 * Version        : v1.0.0
 * Dependencies   : WebApplicationFactory, HttpClient, FluentAssertions,
 *                  UserManagement Contracts
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-24
 * Description    : API integration tests validating paginated user listing
 *                  behavior: SKIP/TAKE page slicing, total counts, out-of-range
 *                  page rejection through model validation, role filtering,
 *                  and name search against a populated isolated database.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Threading.Tasks;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Authentication.Login.Contracts;
using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Application.Features.Authentication.Registration.Contracts;
using Appoynt.Application.Features.UserManagement.Contracts;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;
using Xunit;

namespace Appoynt.Tests.IntegrationTests;

/// <summary>
/// Integration tests for pagination and search semantics of the users listing endpoint.
/// </summary>
[Collection("Sequential")]
public sealed class UserPaginationIntegrationTests : IClassFixture<WebApplicationFactory<Appoynt.API.Program>>
{
    // Fixed development OTP accepted by the OTP service in test environments.
    private const string DevelopmentOtpCode = "123456";

    // Factory hosting the API under test with an isolated database.
    private readonly WebApplicationFactory<Appoynt.API.Program> _factory;

    /// <summary>
    /// Initializes the test factory with isolated storage and relaxed rate limits.
    /// </summary>
    /// <param name="factory">The shared host factory provided by xUnit.</param>
    public UserPaginationIntegrationTests(WebApplicationFactory<Appoynt.API.Program> factory)
    {
        _factory = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureAppConfiguration((context, config) =>
            {
                config.AddInMemoryCollection(new Dictionary<string, string?>
                {
                    ["DatabaseProvider"] = "Sqlite",
                    ["ConnectionStrings:DefaultConnection"] = "DataSource=file:appoynt_pagination_test.db?mode=memory&cache=shared",
                    ["Jwt:SecretKey"] = "SuperSecretKeyWithMinimum32CharactersLength!",
                    ["RateLimiting:Register:PermitLimit"] = "200",
                    ["RateLimiting:Register:WindowInMinutes"] = "60",
                    ["RateLimiting:Login:PermitLimit"] = "100",
                    ["RateLimiting:Login:WindowInMinutes"] = "60",
                    ["RateLimiting:OtpVerify:PermitLimit"] = "200",
                    ["RateLimiting:OtpVerify:WindowInMinutes"] = "60",
                    ["Seed:Enabled"] = "true",
                    ["Seed:Admin:Password"] = "P@ssword123!"
                });
            });
        });
    }

    /// <summary>
    /// Logs in as the seeded administrator and returns an authenticated client.
    /// </summary>
    /// <returns>An admin-authenticated HTTP client.</returns>
    private async Task<HttpClient> LoginAsAdminAsync()
    {
        // Log in using the seeded administrator credentials.
        var client = _factory.CreateClient();
        var loginResponse = await client.PostAsJsonAsync("/api/auth/login", new LoginRequest
        {
            Identifier = "admin@appoynt.com",
            Password = "P@ssword123!"
        });
        loginResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var loginBody = await loginResponse.Content.ReadFromJsonAsync<LoginResponse>();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loginBody!.AccessToken);
        return client;
    }

    /// <summary>
    /// Registers a patient account with a distinctive first name for search scenarios.
    /// </summary>
    /// <param name="firstName">A unique first name embedded in the account.</param>
    private async Task RegisterPatientAsync(string firstName)
    {
        // Register without completing OTP since only the user row is needed for listings.
        var client = _factory.CreateClient();
        var registerResponse = await client.PostAsJsonAsync("/api/auth/register", new RegisterRequest
        {
            FirstName = firstName,
            LastName = "PaginationTester",
            Email = $"{firstName.ToLowerInvariant()}.{Guid.NewGuid():N}@appoynt.com",
            PhoneNumber = "010" + Random.Shared.Next(10000000, 99999999).ToString(),
            Password = "P@ssword123!",
            ConfirmPassword = "P@ssword123!"
        });
        registerResponse.StatusCode.Should().Be(HttpStatusCode.Created);

        // Confirm the phone so the account stays active for admin-scoped listings.
        var registerBody = await registerResponse.Content.ReadFromJsonAsync<RegisterResponse>();
        var verifyResponse = await client.PostAsJsonAsync("/api/auth/otp/verify", new VerifyOtpRequest
        {
            ChallengeId = registerBody!.ChallengeId,
            Code = DevelopmentOtpCode
        });
        verifyResponse.StatusCode.Should().Be(HttpStatusCode.OK);
    }

    /// <summary>
    /// Seeds a deterministic population of seven patients plus the admin (eight users).
    /// </summary>
    /// <param name="adminClient">An authenticated admin client.</param>
    private async Task SeedPopulationAsync(HttpClient adminClient)
    {
        // Read the current total once to avoid double-seeding across ordered test runs.
        var initialPage = await adminClient.GetFromJsonAsync<PagedResponse<UserResponse>>("/api/users?pageNumber=1&pageSize=1");
        if (initialPage!.TotalCount >= 8)
        {
            return;
        }

        // Alphabetic-only names: the first three share a searchable prefix.
        string[] firstNames =
        [
            "AlphaSearch",
            "BetaSearch",
            "GammaSearch",
            "DeltaFiller",
            "EchoFiller",
            "FoxtrotFiller",
            "GolfFiller"
        ];

        // Create exactly enough patients to reach eight total accounts.
        for (int index = initialPage.TotalCount - 1; index < 7; index++)
        {
            await RegisterPatientAsync(firstNames[index]);
        }
    }

    #region Page Slicing

    /// <summary>
    /// A middle page must return exactly one page worth of items with correct metadata.
    /// </summary>
    [Fact]
    public async Task GetUsers_MiddlePage_ReturnsExactSliceWithMetadata()
    {
        // Arrange an authenticated admin and a known population size.
        var adminClient = await LoginAsAdminAsync();
        await SeedPopulationAsync(adminClient);

        // Act requesting the second page of three.
        var page = await adminClient.GetFromJsonAsync<PagedResponse<UserResponse>>(
            "/api/users?pageNumber=2&pageSize=3");

        // Assert slice boundaries and paging metadata hold.
        page.Should().NotBeNull();
        page!.Items.Should().HaveCount(3);
        page.PageNumber.Should().Be(2);
        page.PageSize.Should().Be(3);
        page.TotalCount.Should().BeGreaterThanOrEqualTo(8);
        page.TotalPages.Should().BeGreaterThanOrEqualTo(3);

        // Verify no identifier repeats across pages (correct SKIP behavior).
        var firstPageIds = (await adminClient.GetFromJsonAsync<PagedResponse<UserResponse>>(
                "/api/users?pageNumber=1&pageSize=3"))!
            .Items.Select(user => user.Id).ToList();
        page.Items.Select(user => user.Id).Should().NotIntersectWith(firstPageIds);
    }

    /// <summary>
    /// A page beyond the final record must return an empty item collection.
    /// </summary>
    [Fact]
    public async Task GetUsers_PageBeyondEnd_ReturnsEmptyItems()
    {
        // Arrange the seeded population and admin authentication.
        var adminClient = await LoginAsAdminAsync();
        await SeedPopulationAsync(adminClient);

        // Act requesting a far-out page.
        var page = await adminClient.GetFromJsonAsync<PagedResponse<UserResponse>>(
            "/api/users?pageNumber=50&pageSize=10");

        // Assert the empty tail page carries full metadata still.
        page!.Items.Should().BeEmpty();
        page.TotalCount.Should().BeGreaterThanOrEqualTo(8);
    }

    /// <summary>
    /// Invalid page numbers must be rejected by model validation before execution.
    /// </summary>
    [Theory]
    [InlineData("pageNumber=0&pageSize=3")]
    [InlineData("pageNumber=-1&pageSize=3")]
    [InlineData("pageNumber=1&pageSize=0")]
    [InlineData("pageNumber=1&pageSize=101")]
    public async Task GetUsers_InvalidPagingParameters_ReturnsBadRequest(string queryString)
    {
        // Arrange an authenticated admin client.
        var adminClient = await LoginAsAdminAsync();

        // Act with each out-of-range combination.
        var response = await adminClient.GetAsync($"/api/users?{queryString}");

        // Assert automatic model validation blocks the request.
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
    }

    #endregion

    #region Filtering

    /// <summary>
    /// Filtering by role must restrict results to members of that role only.
    /// </summary>
    [Fact]
    public async Task GetUsers_FilterByAdminRole_ReturnsOnlyAdministrators()
    {
        // Arrange population plus admin authentication.
        var adminClient = await LoginAsAdminAsync();
        await SeedPopulationAsync(adminClient);

        // Act filtering to the Admin role.
        var page = await adminClient.GetFromJsonAsync<PagedResponse<UserResponse>>(
            "/api/users?pageNumber=1&pageSize=50&role=Admin");

        // Assert only the seeded administrator matches.
        page!.TotalCount.Should().Be(1);
        page.Items.Single().Roles.Should().Contain("Admin");
    }

    /// <summary>
    /// Name search must match only accounts containing the supplied term.
    /// </summary>
    [Fact]
    public async Task GetUsers_SearchByName_ReturnsMatchingAccountsOnly()
    {
        // Arrange population including distinctly named patients.
        var adminClient = await LoginAsAdminAsync();
        await SeedPopulationAsync(adminClient);

        // Act searching for the shared prefix of the searchable cohort.
        var page = await adminClient.GetFromJsonAsync<PagedResponse<UserResponse>>(
            "/api/users?pageNumber=1&pageSize=50&name=Search");

        // Assert every returned row embeds the search term; none lack it.
        page!.Items.Should().NotBeEmpty();
        page.Items.Should().OnlyContain(user => user.FirstName.Contains("Search"));
    }

    /// <summary>
    /// A search term matching nobody must yield an empty result rather than all users.
    /// </summary>
    [Fact]
    public async Task GetUsers_SearchWithoutMatches_ReturnsEmptyResult()
    {
        // Arrange population plus admin authentication.
        var adminClient = await LoginAsAdminAsync();
        await SeedPopulationAsync(adminClient);

        // Act searching for a guaranteed-absent name.
        var page = await adminClient.GetFromJsonAsync<PagedResponse<UserResponse>>(
            "/api/users?pageNumber=1&pageSize=50&name=NoSuchPersonExists");

        // Assert.
        page!.Items.Should().BeEmpty();
        page.TotalCount.Should().Be(0);
    }

    #endregion
}
