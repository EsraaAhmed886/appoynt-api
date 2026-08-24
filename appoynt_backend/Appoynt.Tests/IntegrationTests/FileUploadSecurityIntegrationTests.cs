/**
 * File Name      : FileUploadSecurityIntegrationTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-24
 * Version        : v1.0.0
 * Dependencies   : WebApplicationFactory, HttpClient, FluentAssertions,
 *                  ProfileImageErrorCodes, PatientResult
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-24
 * Description    : API integration tests simulating hostile multipart uploads:
 *                  executable payloads renamed to image extensions must be
 *                  rejected by content decoding, disallowed extensions must be
 *                  blocked by the allow-list, and genuine images must upload
 *                  successfully end to end.
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
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Authentication.Login.Contracts;
using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Application.Features.Authentication.Registration.Contracts;
using Appoynt.Application.Features.Patient.Contracts;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;
using Xunit;

namespace Appoynt.Tests.IntegrationTests;

/// <summary>
/// Integration tests defending the profile photo pipeline against malicious uploads.
/// </summary>
[Collection("Sequential")]
public sealed class FileUploadSecurityIntegrationTests : IClassFixture<WebApplicationFactory<Appoynt.API.Program>>
{
    // Fixed development OTP accepted by the OTP service in test environments.
    private const string DevelopmentOtpCode = "123456";

    // A minimal valid 1x1 PNG used for positive-path uploads.
    private const string TinyPngBase64 = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==";

    // Factory hosting the API under test with an isolated database.
    private readonly WebApplicationFactory<Appoynt.API.Program> _factory;

    /// <summary>
    /// Initializes the test factory with isolated storage and relaxed rate limits.
    /// </summary>
    /// <param name="factory">The shared host factory provided by xUnit.</param>
    public FileUploadSecurityIntegrationTests(WebApplicationFactory<Appoynt.API.Program> factory)
    {
        _factory = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureAppConfiguration((context, config) =>
            {
                config.AddInMemoryCollection(new Dictionary<string, string?>
                {
                    ["DatabaseProvider"] = "Sqlite",
                    ["ConnectionStrings:DefaultConnection"] = "DataSource=file:appoynt_upload_security_test.db?mode=memory&cache=shared",
                    ["Jwt:SecretKey"] = "SuperSecretKeyWithMinimum32CharactersLength!",
                    ["FileStorage:RootPath"] = "App_Data/uploads_security_scan_test",
                    ["RateLimiting:Register:PermitLimit"] = "100",
                    ["RateLimiting:Register:WindowInMinutes"] = "60",
                    ["RateLimiting:Login:PermitLimit"] = "100",
                    ["RateLimiting:Login:WindowInMinutes"] = "60",
                    ["RateLimiting:OtpVerify:PermitLimit"] = "100",
                    ["RateLimiting:OtpVerify:WindowInMinutes"] = "60",
                    ["Seed:Enabled"] = "true",
                    ["Seed:Admin:Password"] = "P@ssword123!"
                });
            });
        });
    }

    /// <summary>
    /// Creates a fully verified patient account and returns its authenticated client.
    /// </summary>
    /// <returns>An authenticated patient HTTP client.</returns>
    private async Task<HttpClient> CreateAuthenticatedPatientAsync()
    {
        // Build unique registration credentials for this test run.
        var client = _factory.CreateClient();
        string email = $"upload.tester.{Guid.NewGuid():N}@appoynt.com";
        var registerResponse = await client.PostAsJsonAsync("/api/auth/register", new RegisterRequest
        {
            FirstName = "Upload",
            LastName = "Tester",
            Email = email,
            PhoneNumber = "010" + Random.Shared.Next(10000000, 99999999).ToString(),
            Password = "P@ssword123!",
            ConfirmPassword = "P@ssword123!"
        });
        registerResponse.StatusCode.Should().Be(HttpStatusCode.Created);

        // Confirm the phone via the development OTP then log in.
        var registerBody = await registerResponse.Content.ReadFromJsonAsync<RegisterResponse>();
        await client.PostAsJsonAsync("/api/auth/otp/verify", new VerifyOtpRequest
        {
            ChallengeId = registerBody!.ChallengeId,
            Code = DevelopmentOtpCode
        });
        var loginResponse = await client.PostAsJsonAsync("/api/auth/login", new LoginRequest
        {
            Identifier = email,
            Password = "P@ssword123!"
        });
        loginResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        var loginBody = await loginResponse.Content.ReadFromJsonAsync<LoginResponse>();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loginBody!.AccessToken);
        return client;
    }

    /// <summary>
    /// Posts a multipart payload to the patient profile photo endpoint.
    /// </summary>
    /// <param name="client">The authenticated patient client.</param>
    /// <param name="fileName">The simulated file name including extension.</param>
    /// <param name="bytes">The raw payload bytes to send.</param>
    /// <returns>The endpoint's HTTP response.</returns>
    private static async Task<HttpResponseMessage> UploadPhotoAsync(HttpClient client, string fileName, byte[] bytes)
    {
        // Assemble a standard multipart form with a single typed file part.
        using var content = new MultipartFormDataContent();
        using var streamContent = new ByteArrayContent(bytes);
        streamContent.Headers.ContentType = MediaTypeHeaderValue.Parse("application/octet-stream");
        content.Add(streamContent, "file", fileName);
        return await client.PostAsync("/api/patients/profile-photo", content);
    }

    /// <summary>
    /// An executable payload disguised with a .png extension must be rejected by content decoding.
    /// </summary>
    [Fact]
    public async Task UploadProfilePhoto_ExecutableRenamedToPng_ReturnsBadRequest()
    {
        // Arrange an authenticated patient and classic PE executable bytes ("MZ").
        var client = await CreateAuthenticatedPatientAsync();
        byte[] exePayload = [0x4D, 0x5A, 0x90, 0x00, 0x03, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00];

        // Act uploading the hostile bytes under an innocent image name.
        var response = await UploadPhotoAsync(client, "avatar.png", exePayload);

        // Assert the pipeline refuses non-image content regardless of extension.
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
        var errors = await response.Content.ReadFromJsonAsync<List<AuthenticationError>>();
        errors.Should().Contain(error => error.Code == ProfileImageErrorCodes.ProcessingFailed);
    }

    /// <summary>
    /// A text file renamed to .jpg must likewise fail image decoding.
    /// </summary>
    [Fact]
    public async Task UploadProfilePhoto_TextRenamedToJpg_ReturnsBadRequest()
    {
        // Arrange plain-text bytes masquerading as a JPEG.
        var client = await CreateAuthenticatedPatientAsync();
        byte[] textPayload = "<script>alert('xss')</script>"u8.ToArray();

        // Act
        var response = await UploadPhotoAsync(client, "innocent.jpg", textPayload);

        // Assert.
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
        var errors = await response.Content.ReadFromJsonAsync<List<AuthenticationError>>();
        errors.Should().Contain(error => error.Code == ProfileImageErrorCodes.ProcessingFailed);
    }

    /// <summary>
    /// Disallowed extensions such as .exe must be blocked by the extension allow-list.
    /// </summary>
    [Fact]
    public async Task UploadProfilePhoto_ExecutableExtension_ReturnsUnsupportedFileType()
    {
        // Arrange even valid-looking bytes carrying a forbidden extension.
        var client = await CreateAuthenticatedPatientAsync();
        byte[] anyBytes = Convert.FromBase64String(TinyPngBase64);

        // Act uploading under an executable extension.
        var response = await UploadPhotoAsync(client, "payload.exe", anyBytes);

        // Assert the allow-list rejection surfaces before processing.
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
        var errors = await response.Content.ReadFromJsonAsync<List<AuthenticationError>>();
        errors.Should().Contain(error => error.Code == ProfileImageErrorCodes.UnsupportedFileType);
    }

    /// <summary>
    /// Double extensions must be treated by their final effective extension only.
    /// </summary>
    [Fact]
    public async Task UploadProfilePhoto_DoubleExtension_IsJudgedByFinalExtension()
    {
        // Arrange a text payload wearing both a fake and a real image extension.
        var client = await CreateAuthenticatedPatientAsync();
        byte[] textPayload = "not-an-image"u8.ToArray();

        // Act uploading "photo.png.exe"-style naming reversed: image first, exe last is blocked;
        // here we verify that ".png" trailing after junk still requires decodable content.
        var response = await UploadPhotoAsync(client, "photo.exe.png", textPayload);

        // Assert the .png suffix passes the allow-list but content decoding rejects the body.
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
        var errors = await response.Content.ReadFromJsonAsync<List<AuthenticationError>>();
        errors.Should().Contain(error => error.Code == ProfileImageErrorCodes.ProcessingFailed);
    }

    /// <summary>
    /// A genuine tiny PNG must upload successfully through the full processing pipeline.
    /// </summary>
    [Fact]
    public async Task UploadProfilePhoto_ValidPng_ReturnsSuccessWithStoredPath()
    {
        // Arrange an authenticated patient and real PNG bytes.
        var client = await CreateAuthenticatedPatientAsync();
        byte[] validPng = Convert.FromBase64String(TinyPngBase64);

        // Act
        var response = await UploadPhotoAsync(client, "avatar.png", validPng);

        // Assert the happy path persists a processed artifact.
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var result = await response.Content.ReadFromJsonAsync<PatientResult>();
        result!.Succeeded.Should().BeTrue();

        // The stored photo must now be retrievable through the public endpoint.
        var photoResponse = await client.GetAsync($"/api/patients/{result.PatientId}/profile-photo");
        photoResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        photoResponse.Content.Headers.ContentType!.MediaType.Should().Be("image/jpeg");
    }
}
