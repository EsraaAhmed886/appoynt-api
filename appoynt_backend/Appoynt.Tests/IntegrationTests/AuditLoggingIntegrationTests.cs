/**
 * File Name      : AuditLoggingIntegrationTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-16
 * Version        : v1.0.0
 * Dependencies   : WebApplicationFactory, ApplicationDbContext, FluentAssertions
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-30
 * Description    : Integration tests verifying the generic Audit Logging engine behavior.
 */

using System.Text.Json;
using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Persistence;
using FluentAssertions;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Appoynt.Tests.IntegrationTests;

/// <summary>
/// Integration tests verifying the generic Audit Logging engine behavior.
/// </summary>
[Collection("Integration Tests")]
public sealed class AuditLoggingIntegrationTests : IClassFixture<WebApplicationFactory<Appoynt.API.Program>>
{
    private readonly WebApplicationFactory<Appoynt.API.Program> _factory;

    public AuditLoggingIntegrationTests(WebApplicationFactory<Appoynt.API.Program> factory)
    {
        _factory = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureAppConfiguration((context, config) =>
            {
                config.AddInMemoryCollection(new Dictionary<string, string?>
                {
                    ["DatabaseProvider"] = "Sqlite",
                    ["ConnectionStrings:DefaultConnection"] = "DataSource=file:appoynt_test_audit.db?mode=memory&cache=shared",
                    ["Jwt:SecretKey"] = "SuperSecretKeyWithMinimum32CharactersLength!",
                    ["Seed:Enabled"] = "false"
                });
            });
        });
    }

    [Fact]
    public async Task SaveChanges_ShouldGenerateCreateAuditLog_WhenEntityIsAdded()
    {
        // Arrange
        using var scope = _factory.Services.CreateScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
        await dbContext.Database.EnsureCreatedAsync();

        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Test",
            LastName = "User",
            UserName = "testcreate",
            Email = "testcreate@example.com",
            PhoneNumber = Guid.NewGuid().ToString()
        };

        var patient = new Patient
        {
            Id = Guid.NewGuid(),
            UserId = user.Id,
            User = user
        };

        // Act
        dbContext.Patients.Add(patient);
        await dbContext.SaveChangesAsync();

        // Assert
        var auditLogs = await dbContext.AuditLogs
            .Where(a => a.TableName == "Patients" && a.Type == AuditType.Create)
            .ToListAsync();

        auditLogs.Should().HaveCount(1);
        var auditLog = auditLogs.First();
        
        auditLog.OldValues.Should().BeNull();
        auditLog.NewValues.Should().NotBeNull();
        auditLog.NewValues.Should().Contain(patient.UserId.ToString());
        auditLog.PrimaryKey.Should().Contain(patient.Id.ToString());
    }

    [Fact]
    public async Task SaveChanges_ShouldGenerateUpdateAuditLog_WhenEntityIsModified()
    {
        // Arrange
        using var scope = _factory.Services.CreateScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
        await dbContext.Database.EnsureCreatedAsync();

        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Initial First",
            LastName = "Update",
            UserName = "testupdate",
            Email = "testupdate@example.com",
            PhoneNumber = Guid.NewGuid().ToString()
        };

        dbContext.Users.Add(user);
        await dbContext.SaveChangesAsync();

        // Act
        user.FirstName = "Updated First";
        await dbContext.SaveChangesAsync();

        // Assert
        var updateLogs = await dbContext.AuditLogs
            .Where(a => a.TableName == "AspNetUsers" && a.Type == AuditType.Update)
            .ToListAsync();
        var updateLog = updateLogs
            .OrderByDescending(a => a.DateTimeOffset)
            .FirstOrDefault();

        updateLog.Should().NotBeNull();
        updateLog!.OldValues.Should().Contain("Initial First");
        updateLog.NewValues.Should().Contain("Updated First");
        updateLog.AffectedColumns.Should().Contain("FirstName");
    }

    [Fact]
    public async Task SaveChanges_ShouldGenerateDeleteAuditLog_WhenEntityIsSoftDeleted()
    {
        // Arrange
        using var scope = _factory.Services.CreateScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
        await dbContext.Database.EnsureCreatedAsync();

        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Test",
            LastName = "Delete",
            UserName = "testdelete",
            Email = "testdelete@example.com",
            PhoneNumber = Guid.NewGuid().ToString()
        };

        dbContext.Users.Add(user);
        await dbContext.SaveChangesAsync();

        // Act
        dbContext.Users.Remove(user);
        await dbContext.SaveChangesAsync();

        // Assert
        // Soft delete transforms Delete into Modified
        var updateLogs = await dbContext.AuditLogs
            .Where(a => a.TableName == "AspNetUsers" && a.Type == AuditType.Update)
            .ToListAsync();
        var updateLog = updateLogs
            .OrderByDescending(a => a.DateTimeOffset)
            .FirstOrDefault();

        updateLog.Should().NotBeNull();
        updateLog!.NewValues.Should().Contain("DeletedAt");
    }

    [Fact]
    public async Task SaveChanges_ShouldNotAuditExcludedEntities()
    {
        // Arrange
        using var scope = _factory.Services.CreateScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
        await dbContext.Database.EnsureCreatedAsync();

        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Test",
            LastName = "Otp",
            UserName = "testotp",
            Email = "testotp@example.com",
            PhoneNumber = Guid.NewGuid().ToString()
        };

        var otp = new OtpChallenge
        {
            Id = Guid.NewGuid(),
            UserId = user.Id,
            User = user,
            CodeHash = "hash",
            Purpose = OtpPurpose.PhoneConfirmation,
            ExpiresAt = DateTime.UtcNow.AddMinutes(5),
            SentAt = DateTime.UtcNow
        };

        // Act
        dbContext.OtpChallenges.Add(otp);
        await dbContext.SaveChangesAsync();

        // Assert
        var auditLogs = await dbContext.AuditLogs
            .Where(a => a.TableName == "OtpChallenges")
            .ToListAsync();

        auditLogs.Should().BeEmpty();
    }

    [Fact]
    public async Task SaveChanges_ShouldMaskSensitiveProperties()
    {
        // Arrange
        using var scope = _factory.Services.CreateScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
        await dbContext.Database.EnsureCreatedAsync();

        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            FirstName = "Test",
            LastName = "Mask",
            UserName = "testmask",
            Email = "testmask@example.com",
            PhoneNumber = Guid.NewGuid().ToString(),
            PasswordHash = "SuperSecretHashValue123!"
        };

        // Act
        dbContext.Users.Add(user);
        await dbContext.SaveChangesAsync();

        // Assert
        var auditLogs = await dbContext.AuditLogs
            .Where(a => a.TableName == "AspNetUsers" && a.Type == AuditType.Create)
            .ToListAsync();
            
        var auditLog = auditLogs
            .OrderByDescending(a => a.DateTimeOffset)
            .FirstOrDefault();

        auditLog.Should().NotBeNull();
        auditLog!.NewValues.Should().NotContain("SuperSecretHashValue123!");
        auditLog.NewValues.Should().NotContain("PasswordHash");
    }
}
