/**
 * File Name      : AuthenticationFullQATests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 06/08/2026
 * Version        : v1.0.0
 * Dependencies   : WebApplicationFactory, ApplicationDbContext, Identity
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 06/08/2026
 * Description    : Comprehensive QA integration tests verifying all authentication scenarios,
 *                  database persistence, password hashing, JWT claims, validation rules,
 *                  duplicate rejection, and role-based authorization.
 */

using System.IdentityModel.Tokens.Jwt;
using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Security.Claims;
using System.Text;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Authentication.Login.Contracts;
using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Application.Features.Authentication.PasswordRecovery.Contracts;
using Appoynt.Application.Features.Authentication.Registration.Contracts;
using Appoynt.Application.Features.UserManagement.Contracts;
using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence;
using FluentAssertions;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using Xunit;

namespace Appoynt.Tests.IntegrationTests;

[Collection("Sequential")]
public class AuthenticationFullQATests : IClassFixture<WebApplicationFactory<Appoynt.API.Program>>
{
    private readonly WebApplicationFactory<Appoynt.API.Program> _factory;
    private readonly HttpClient _client;
    private const string SecretKey = "SuperSecretKeyWithMinimum32CharactersLength!";

    public AuthenticationFullQATests(WebApplicationFactory<Appoynt.API.Program> factory)
    {
        _factory = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureAppConfiguration((context, config) =>
            {
                config.AddInMemoryCollection(new Dictionary<string, string?>
                {
                    ["DatabaseProvider"] = "Sqlite",
                    ["ConnectionStrings:DefaultConnection"] = "DataSource=file:appoynt_qa_test.db?mode=memory&cache=shared",
                    ["Jwt:Issuer"] = "Appoynt.API",
                    ["Jwt:Audience"] = "Appoynt.Client",
                    ["Jwt:SecretKey"] = SecretKey,
                    ["RateLimiting:Register:PermitLimit"] = "100",
                    ["RateLimiting:Register:WindowInMinutes"] = "60",
                    ["RateLimiting:Login:PermitLimit"] = "100",
                    ["RateLimiting:Login:WindowInMinutes"] = "60",
                    ["RateLimiting:OtpVerify:PermitLimit"] = "100",
                    ["RateLimiting:OtpVerify:WindowInMinutes"] = "60",
                    ["RateLimiting:OtpResend:PermitLimit"] = "100",
                    ["RateLimiting:OtpResend:WindowInMinutes"] = "60",
                    ["RateLimiting:ForgotPassword:PermitLimit"] = "100",
                    ["RateLimiting:ForgotPassword:WindowInMinutes"] = "60",
                    ["RateLimiting:ResetPassword:PermitLimit"] = "100",
                    ["RateLimiting:ResetPassword:WindowInMinutes"] = "60",
                    ["Seed:Enabled"] = "true",
                    ["Seed:Admin:FirstName"] = "System",
                    ["Seed:Admin:LastName"] = "Admin",
                    ["Seed:Admin:Email"] = "admin.qa@appoynt.com",
                    ["Seed:Admin:PhoneNumber"] = "01099998888",
                    ["Seed:Admin:Password"] = "Password123!"
                });
            });
        });
        _client = _factory.CreateClient();
    }

    [Fact]
    public async Task Task06_Task07_Task08_RegisterUser_ShouldStoreInDb_WithHashedPassword()
    {
        // 1. Arrange: Create unique patient request
        string uniqueId = Guid.NewGuid().ToString("N")[..8];
        string email = $"qa.user.{uniqueId}@example.com";
        string phone = "010" + Random.Shared.Next(10000000, 99999999).ToString();
        string rawPassword = "P@ssword123!";

        var registerRequest = new RegisterRequest
        {
            FirstName = "QA",
            LastName = "Patient",
            Email = email,
            PhoneNumber = phone,
            Password = rawPassword,
            ConfirmPassword = rawPassword
        };

        // 2. Act: Send HTTP POST to Register endpoint
        HttpResponseMessage response = await _client.PostAsJsonAsync("/api/auth/register", registerRequest);

        // 3. Assert HTTP response status
        response.StatusCode.Should().Be(HttpStatusCode.Created);
        var responseBody = await response.Content.ReadFromJsonAsync<RegisterResponse>();
        responseBody.Should().NotBeNull();
        responseBody!.UserId.Should().NotBeEmpty();

        // 4. Verify Database state directly via DbContext
        using var scope = _factory.Services.CreateScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
        var userManager = scope.ServiceProvider.GetRequiredService<UserManager<ApplicationUser>>();

        var dbUser = await dbContext.Users
            .Include(u => u.Patient)
            .FirstOrDefaultAsync(u => u.Id == responseBody.UserId);

        dbUser.Should().NotBeNull();
        dbUser!.Email.Should().Be(email);
        dbUser.PhoneNumber.Should().Be(phone);
        dbUser.Patient.Should().NotBeNull();
        dbUser.Patient!.UserId.Should().Be(dbUser.Id);

        // 5. Verify Password is properly hashed and NOT stored in plaintext
        dbUser.PasswordHash.Should().NotBeNullOrWhiteSpace();
        dbUser.PasswordHash.Should().NotBe(rawPassword);

        var passwordHasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher<ApplicationUser>>();
        var verifyResult = passwordHasher.VerifyHashedPassword(dbUser, dbUser.PasswordHash!, rawPassword);
        verifyResult.Should().Be(PasswordVerificationResult.Success);
    }

    [Fact]
    public async Task DevelopmentEnvironment_FixedOtp_Registration_Verify_And_Login()
    {
        // 1. Register a new patient in Development environment
        string uniqueId = Guid.NewGuid().ToString("N")[..8];
        string email = $"dev.otp.{uniqueId}@example.com";
        string phone = "010" + Random.Shared.Next(10000000, 99999999).ToString();
        string password = "P@ssword123!";

        var regReq = new RegisterRequest
        {
            FirstName = "DevOTP",
            LastName = "Patient",
            Email = email,
            PhoneNumber = phone,
            Password = password,
            ConfirmPassword = password
        };

        HttpResponseMessage regResp = await _client.PostAsJsonAsync("/api/auth/register", regReq);
        regResp.StatusCode.Should().Be(HttpStatusCode.Created);
        var regBody = await regResp.Content.ReadFromJsonAsync<RegisterResponse>();
        regBody.Should().NotBeNull();

        // 2. Verify OTP using the Development fixed code "123456"
        var verifyOtpReq = new VerifyOtpRequest
        {
            ChallengeId = regBody!.ChallengeId,
            Code = "123456"
        };

        HttpResponseMessage verifyResp = await _client.PostAsJsonAsync("/api/auth/otp/verify", verifyOtpReq);
        verifyResp.StatusCode.Should().Be(HttpStatusCode.OK);

        // 3. Verify user's phone number is confirmed in DB
        using (var scope = _factory.Services.CreateScope())
        {
            var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
            var dbUser = await dbContext.Users.FirstAsync(u => u.Id == regBody.UserId);
            dbUser.PhoneNumberConfirmed.Should().BeTrue();
        }

        // 4. Perform Login with confirmed phone number
        var loginReq = new LoginRequest
        {
            Identifier = email,
            Password = password
        };

        HttpResponseMessage loginResp = await _client.PostAsJsonAsync("/api/auth/login", loginReq);
        loginResp.StatusCode.Should().Be(HttpStatusCode.OK);
        var loginBody = await loginResp.Content.ReadFromJsonAsync<LoginResponse>();
        loginBody.Should().NotBeNull();
        loginBody!.AccessToken.Should().NotBeNullOrWhiteSpace();
    }

    [Fact]
    public async Task Validation_ShouldReturnBadRequest_WhenRequestIsInvalid()
    {
        // Validation rule check: Password mismatch
        var invalidReq = new RegisterRequest
        {
            FirstName = "Invalid",
            LastName = "User",
            Email = "invalid.user@example.com",
            PhoneNumber = "01012345678",
            Password = "P@ssword123!",
            ConfirmPassword = "DifferentPassword!"
        };

        HttpResponseMessage valResp = await _client.PostAsJsonAsync("/api/auth/register", invalidReq);
        valResp.StatusCode.Should().Be(HttpStatusCode.BadRequest);
    }

    [Fact]
    public async Task DuplicateRegistration_ShouldReturnConflict_WhenEmailAlreadyExists()
    {
        string email = $"dup.email.{Guid.NewGuid().ToString("N")[..6]}@example.com";
        string phone = "010" + Random.Shared.Next(10000000, 99999999).ToString();

        var firstReq = new RegisterRequest
        {
            FirstName = "First",
            LastName = "User",
            Email = email,
            PhoneNumber = phone,
            Password = "P@ssword123!",
            ConfirmPassword = "P@ssword123!"
        };

        HttpResponseMessage firstResp = await _client.PostAsJsonAsync("/api/auth/register", firstReq);
        firstResp.StatusCode.Should().Be(HttpStatusCode.Created);

        // Duplicate Email check
        var dupEmailReq = new RegisterRequest
        {
            FirstName = "Second",
            LastName = "User",
            Email = email,
            PhoneNumber = "010" + Random.Shared.Next(10000000, 99999999).ToString(),
            Password = "P@ssword123!",
            ConfirmPassword = "P@ssword123!"
        };

        HttpResponseMessage dupEmailResp = await _client.PostAsJsonAsync("/api/auth/register", dupEmailReq);
        dupEmailResp.StatusCode.Should().Be(HttpStatusCode.Conflict);
    }

    [Fact]
    public async Task DuplicateRegistration_ShouldReturnConflict_WhenPhoneAlreadyExists()
    {
        string email1 = $"phone.email1.{Guid.NewGuid().ToString("N")[..6]}@example.com";
        string email2 = $"phone.email2.{Guid.NewGuid().ToString("N")[..6]}@example.com";
        string phone = "010" + Random.Shared.Next(10000000, 99999999).ToString();

        var firstReq = new RegisterRequest
        {
            FirstName = "First",
            LastName = "User",
            Email = email1,
            PhoneNumber = phone,
            Password = "P@ssword123!",
            ConfirmPassword = "P@ssword123!"
        };

        HttpResponseMessage firstResp = await _client.PostAsJsonAsync("/api/auth/register", firstReq);
        firstResp.StatusCode.Should().Be(HttpStatusCode.Created);

        // Duplicate Phone check
        var dupPhoneReq = new RegisterRequest
        {
            FirstName = "Third",
            LastName = "User",
            Email = email2,
            PhoneNumber = phone,
            Password = "P@ssword123!",
            ConfirmPassword = "P@ssword123!"
        };

        HttpResponseMessage dupPhoneResp = await _client.PostAsJsonAsync("/api/auth/register", dupPhoneReq);
        dupPhoneResp.StatusCode.Should().Be(HttpStatusCode.Conflict);
    }

    [Fact]
    public async Task Task09_Task10_Task13_Login_InvalidPassword_And_SuccessfulLogin_JWTClaims()
    {
        // 1. Register a new user
        string uniqueId = Guid.NewGuid().ToString("N")[..8];
        string email = $"jwt.user.{uniqueId}@example.com";
        string phone = "010" + Random.Shared.Next(10000000, 99999999).ToString();
        string password = "P@ssword123!";

        var regReq = new RegisterRequest
        {
            FirstName = "JWT",
            LastName = "Tester",
            Email = email,
            PhoneNumber = phone,
            Password = password,
            ConfirmPassword = password
        };

        HttpResponseMessage regResp = await _client.PostAsJsonAsync("/api/auth/register", regReq);
        regResp.StatusCode.Should().Be(HttpStatusCode.Created);
        var regBody = await regResp.Content.ReadFromJsonAsync<RegisterResponse>();

        // 2. Test Invalid Password Login -> 401 Unauthorized
        var invalidLoginReq = new LoginRequest
        {
            Identifier = email,
            Password = "WrongPassword123!"
        };
        HttpResponseMessage invalidLoginResp = await _client.PostAsJsonAsync("/api/auth/login", invalidLoginReq);
        invalidLoginResp.StatusCode.Should().Be(HttpStatusCode.Unauthorized);

        // 3. Manually confirm user's phone in Db (or verify via OTP) to enable login
        using (var scope = _factory.Services.CreateScope())
        {
            var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
            var user = await dbContext.Users.FirstAsync(u => u.Id == regBody!.UserId);
            user.PhoneNumberConfirmed = true;
            await dbContext.SaveChangesAsync();
        }

        // 4. Perform Successful Login
        var validLoginReq = new LoginRequest
        {
            Identifier = email,
            Password = password
        };
        HttpResponseMessage loginResp = await _client.PostAsJsonAsync("/api/auth/login", validLoginReq);
        loginResp.StatusCode.Should().Be(HttpStatusCode.OK);

        var loginBody = await loginResp.Content.ReadFromJsonAsync<LoginResponse>();
        loginBody.Should().NotBeNull();
        loginBody!.AccessToken.Should().NotBeNullOrWhiteSpace();

        // 5. Verify JWT Structure and Claims using JwtSecurityTokenHandler
        var tokenHandler = new JwtSecurityTokenHandler();
        tokenHandler.CanReadToken(loginBody.AccessToken).Should().BeTrue();
        var jwtToken = tokenHandler.ReadJwtToken(loginBody.AccessToken);

        jwtToken.Issuer.Should().Be("Appoynt.API");
        jwtToken.Audiences.Should().Contain("Appoynt.Client");

        var userIdClaim = jwtToken.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier || c.Type == "sub");
        userIdClaim.Should().NotBeNull();
        userIdClaim!.Value.Should().Be(regBody!.UserId.ToString());

        var roleClaim = jwtToken.Claims.FirstOrDefault(c => c.Type == ClaimTypes.Role || c.Type == "role");
        roleClaim.Should().NotBeNull();
        roleClaim!.Value.Should().Be(RoleConstants.Patient);
    }

    [Fact]
    public async Task Task14_ProtectedEndpoints_ValidToken_InvalidToken_ExpiredToken_NoToken()
    {
        // 1. No JWT Token -> 401 Unauthorized
        HttpResponseMessage noTokenResp = await _client.GetAsync("/api/users");
        noTokenResp.StatusCode.Should().Be(HttpStatusCode.Unauthorized);

        // 2. Invalid/Malformed JWT Token -> 401 Unauthorized
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", "Invalid.JWT.TokenString");
        HttpResponseMessage invalidTokenResp = await _client.GetAsync("/api/users");
        invalidTokenResp.StatusCode.Should().Be(HttpStatusCode.Unauthorized);

        // 3. Expired JWT Token -> 401 Unauthorized
        string expiredToken = GenerateExpiredJwtToken();
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", expiredToken);
        HttpResponseMessage expiredTokenResp = await _client.GetAsync("/api/users");
        expiredTokenResp.StatusCode.Should().Be(HttpStatusCode.Unauthorized);

        // 4. Valid Admin JWT Token -> 200 OK
        string adminToken = await GetAdminJwtTokenAsync();
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", adminToken);
        HttpResponseMessage validTokenResp = await _client.GetAsync("/api/users");
        validTokenResp.StatusCode.Should().Be(HttpStatusCode.OK);
    }

    [Fact]
    public async Task Task10_Authorization_RoleBased_Forbidden()
    {
        // 1. Login as Patient
        string patientToken = await RegisterAndLoginPatientAsync();

        // 2. Patient attempts to create an Admin -> 403 Forbidden
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", patientToken);

        var createAdminReq = new CreateStaffRequest
        {
            FirstName = "Hacker",
            LastName = "Admin",
            Email = "hacker.admin@example.com",
            PhoneNumber = "01033334444",
            Password = "P@ssword123!"
        };

        HttpResponseMessage forbiddenResp = await _client.PostAsJsonAsync("/api/users/admins", createAdminReq);
        forbiddenResp.StatusCode.Should().Be(HttpStatusCode.Forbidden);
    }

    private string GenerateExpiredJwtToken()
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.UTF8.GetBytes(SecretKey);

        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(new[]
            {
                new Claim(ClaimTypes.NameIdentifier, Guid.NewGuid().ToString()),
                new Claim(ClaimTypes.Role, RoleConstants.Admin)
            }),
            IssuedAt = DateTime.UtcNow.AddMinutes(-60),
            NotBefore = DateTime.UtcNow.AddMinutes(-60),
            Expires = DateTime.UtcNow.AddMinutes(-30), // Expired 30 minutes ago
            Issuer = "Appoynt.API",
            Audience = "Appoynt.Client",
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
        };

        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }

    private async Task<string> GetAdminJwtTokenAsync()
    {
        var loginReq = new LoginRequest
        {
            Identifier = "admin.qa@appoynt.com",
            Password = "Password123!"
        };

        HttpResponseMessage response = await _client.PostAsJsonAsync("/api/auth/login", loginReq);
        var body = await response.Content.ReadFromJsonAsync<LoginResponse>();
        return body!.AccessToken;
    }

    private async Task<string> RegisterAndLoginPatientAsync()
    {
        string uniqueId = Guid.NewGuid().ToString("N")[..8];
        string email = $"patient.role.{uniqueId}@example.com";
        string phone = "010" + Random.Shared.Next(10000000, 99999999).ToString();
        string password = "P@ssword123!";

        var regReq = new RegisterRequest
        {
            FirstName = "Role",
            LastName = "Patient",
            Email = email,
            PhoneNumber = phone,
            Password = password,
            ConfirmPassword = password
        };

        HttpResponseMessage regResp = await _client.PostAsJsonAsync("/api/auth/register", regReq);
        var regBody = await regResp.Content.ReadFromJsonAsync<RegisterResponse>();

        using (var scope = _factory.Services.CreateScope())
        {
            var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
            var user = await dbContext.Users.FirstAsync(u => u.Id == regBody!.UserId);
            user.PhoneNumberConfirmed = true;
            await dbContext.SaveChangesAsync();
        }

        var loginReq = new LoginRequest
        {
            Identifier = email,
            Password = password
        };

        HttpResponseMessage loginResp = await _client.PostAsJsonAsync("/api/auth/login", loginReq);
        var loginBody = await loginResp.Content.ReadFromJsonAsync<LoginResponse>();
        return loginBody!.AccessToken;
    }
}
