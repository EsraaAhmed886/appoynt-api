/**
 * File Name      : AdminSeeder.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 22/07/2026
 * Version        : v1.0.0
 * Dependencies   : UserManager<ApplicationUser>, ApplicationDbContext,
 *                  SeedOptions, RoleConstants
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Seeds the default administrator account required
 *                  by the application.
 */

using Appoynt.Application.Common.Interfaces.Seeding;
using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Options;
using Appoynt.Infrastructure.Persistence.Seed.Base;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace Appoynt.Infrastructure.Persistence.Seed;

/// <summary>
/// Seeds the default administrator account.
/// </summary>
public sealed class AdminSeeder
    : SeederBase, IAdminSeeder
{
    #region Fields

    private readonly UserManager<ApplicationUser> _userManager;

    private readonly ApplicationDbContext _dbContext;

    private readonly SeedOptions _seedOptions;

    private readonly ILogger<AdminSeeder> _logger;

    #endregion

    #region Constructors

    /// <summary>
    /// Initializes a new instance of the <see cref="AdminSeeder"/> class.
    /// </summary>
    /// <param name="userManager">
    /// ASP.NET Core Identity user manager.
    /// </param>
    /// <param name="dbContext">
    /// The application database context.
    /// </param>
    /// <param name="seedOptions">
    /// Seed configuration options.
    /// </param>
    /// <param name="logger">
    /// The logger instance.
    /// </param>
    public AdminSeeder(
        UserManager<ApplicationUser> userManager,
        ApplicationDbContext dbContext,
        IOptions<SeedOptions> seedOptions,
        ILogger<AdminSeeder> logger)
    {
        _userManager = userManager;
        _dbContext = dbContext;
        _seedOptions = seedOptions.Value;
        _logger = logger;
    }

    #endregion

    #region Public Methods

    /// <inheritdoc />
    public async Task SeedAsync(
        CancellationToken cancellationToken = default)
    {
        cancellationToken.ThrowIfCancellationRequested();

        ValidateAdminOptions();

        AdminOptions adminOptions = _seedOptions.Admin;

        ApplicationUser? user =
            await GetExistingUserAsync(
                adminOptions.Email,
                cancellationToken)
                .ConfigureAwait(false);

        if (user is null)
        {
            user = await CreateUserAsync(
                adminOptions,
                cancellationToken)
                .ConfigureAwait(false);

            _logger.LogInformation(
                "Created default administrator user '{Email}'.",
                adminOptions.Email);
        }
        else
        {
            _logger.LogInformation(
                "Default administrator user '{Email}' already exists.",
                adminOptions.Email);
        }

        await EnsureAdminRoleAsync(
            user,
            cancellationToken)
            .ConfigureAwait(false);

        await EnsureAdminProfileAsync(
            user,
            cancellationToken)
            .ConfigureAwait(false);
    }

    #endregion

    #region Private Methods

    /// <summary>
    /// Validates that the administrator seed configuration is usable.
    /// </summary>
    /// <exception cref="InvalidOperationException">
    /// Thrown when required administrator configuration is missing.
    /// </exception>
    private void ValidateAdminOptions()
    {
        AdminOptions admin = _seedOptions.Admin;

        if (string.IsNullOrWhiteSpace(admin.FirstName))
        {
            throw new InvalidOperationException(
                "Seed configuration is missing Admin:FirstName.");
        }
        else
        {
        }

        if (string.IsNullOrWhiteSpace(admin.LastName))
        {
            throw new InvalidOperationException(
                "Seed configuration is missing Admin:LastName.");
        }
        else
        {
        }

        if (string.IsNullOrWhiteSpace(admin.Email))
        {
            throw new InvalidOperationException(
                "Seed configuration is missing Admin:Email.");
        }
        else
        {
        }

        if (string.IsNullOrWhiteSpace(admin.PhoneNumber))
        {
            throw new InvalidOperationException(
                "Seed configuration is missing Admin:PhoneNumber.");
        }
        else
        {
        }

        if (string.IsNullOrWhiteSpace(admin.Password))
        {
            throw new InvalidOperationException(
                "Seed configuration is missing Admin:Password.");
        }
        else
        {
        }
    }

    /// <summary>
    /// Finds an existing administrator user by email address.
    /// </summary>
    /// <param name="email">
    /// The administrator email address.
    /// </param>
    /// <param name="cancellationToken">
    /// The cancellation token.
    /// </param>
    /// <returns>
    /// The existing user, or <see langword="null"/> when not found.
    /// </returns>
    private async Task<ApplicationUser?> GetExistingUserAsync(
        string email,
        CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();

        return await _userManager
            .FindByEmailAsync(email)
            .ConfigureAwait(false);
    }

    /// <summary>
    /// Creates the default administrator Identity user.
    /// </summary>
    /// <param name="adminOptions">
    /// The administrator configuration.
    /// </param>
    /// <param name="cancellationToken">
    /// The cancellation token.
    /// </param>
    /// <returns>
    /// The created application user.
    /// </returns>
    private async Task<ApplicationUser> CreateUserAsync(
        AdminOptions adminOptions,
        CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();

        ApplicationUser user = new()
        {
            FirstName = adminOptions.FirstName,
            LastName = adminOptions.LastName,
            Email = adminOptions.Email,
            UserName = adminOptions.Email,
            PhoneNumber = adminOptions.PhoneNumber,
            EmailConfirmed = true,
            PhoneNumberConfirmed = true,
            IsActive = true
        };

        IdentityResult createResult =
            await _userManager
                .CreateAsync(user, adminOptions.Password)
                .ConfigureAwait(false);

        ThrowIfFailed(
            createResult,
            $"Failed to create default administrator user '{adminOptions.Email}'.");

        return user;
    }

    /// <summary>
    /// Ensures the user is assigned to the administrator role.
    /// </summary>
    /// <param name="user">
    /// The application user.
    /// </param>
    /// <param name="cancellationToken">
    /// The cancellation token.
    /// </param>
    private async Task EnsureAdminRoleAsync(
        ApplicationUser user,
        CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();

        bool isInRole =
            await _userManager
                .IsInRoleAsync(user, RoleConstants.Admin)
                .ConfigureAwait(false);

        if (isInRole)
        {
            _logger.LogInformation(
                "Administrator user '{Email}' is already assigned to role '{Role}'.",
                user.Email,
                RoleConstants.Admin);

            return;
        }
        else
        {
        }

        IdentityResult addRoleResult =
            await _userManager
                .AddToRoleAsync(user, RoleConstants.Admin)
                .ConfigureAwait(false);

        ThrowIfFailed(
            addRoleResult,
            $"Failed to assign role '{RoleConstants.Admin}' to administrator user '{user.Email}'.");

        _logger.LogInformation(
            "Assigned role '{Role}' to administrator user '{Email}'.",
            RoleConstants.Admin,
            user.Email);
    }

    /// <summary>
    /// Ensures the administrator profile exists for the given user.
    /// </summary>
    /// <param name="user">
    /// The application user.
    /// </param>
    /// <param name="cancellationToken">
    /// The cancellation token.
    /// </param>
    private async Task EnsureAdminProfileAsync(
        ApplicationUser user,
        CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();

        bool profileExists =
            await _dbContext.Admins
                .AnyAsync(
                    admin => admin.UserId == user.Id,
                    cancellationToken)
                .ConfigureAwait(false);

        if (profileExists)
        {
            _logger.LogInformation(
                "Administrator profile for user '{Email}' already exists.",
                user.Email);

            return;
        }
        else
        {
        }

        Admin adminProfile = new()
        {
            Id = Guid.NewGuid(),
            UserId = user.Id,
            User = user
        };

        _dbContext.Admins.Add(adminProfile);

        await _dbContext
            .SaveChangesAsync(cancellationToken)
            .ConfigureAwait(false);

        _logger.LogInformation(
            "Created administrator profile for user '{Email}'.",
            user.Email);
    }

    #endregion
}
