/**
 * File Name      : RoleSeeder.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 22/07/2026
 * Version        : v1.1.0
 * Dependencies   : ASP.NET Core Identity, RoleConstants
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 22/07/2026
 * Description    : Seeds the default ASP.NET Core Identity roles required
 *                  by the application.
 */

using Appoynt.Application.Common.Interfaces.Seeding;
using Appoynt.Domain.Common.Constants;
using Appoynt.Infrastructure.Persistence.Seed.Base;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;

namespace Appoynt.Infrastructure.Persistence.Seed;

/// <summary>
/// Seeds the default application roles.
/// </summary>
public sealed class RoleSeeder
    : SeederBase, IRoleSeeder
{
    #region Fields

    private readonly RoleManager<IdentityRole<Guid>> _roleManager;

    private readonly ILogger<RoleSeeder> _logger;

    #endregion

    #region Constructors

    /// <summary>
    /// Initializes a new instance of the <see cref="RoleSeeder"/> class.
    /// </summary>
    /// <param name="roleManager">
    /// ASP.NET Core Identity role manager.
    /// </param>
    /// <param name="logger">
    /// The logger instance.
    /// </param>
    public RoleSeeder(
        RoleManager<IdentityRole<Guid>> roleManager,
        ILogger<RoleSeeder> logger)
    {
        _roleManager = roleManager;
        _logger = logger;
    }

    #endregion

    #region Public Methods

    /// <inheritdoc />
    public async Task SeedAsync(
        CancellationToken cancellationToken = default)
    {
        cancellationToken.ThrowIfCancellationRequested();

        foreach (string roleName in RoleConstants.All)
        {
            await EnsureRoleExistsAsync(
                roleName,
                cancellationToken)
                .ConfigureAwait(false);
        }
    }

    #endregion

    #region Private Methods

    /// <summary>
    /// Ensures that the specified role exists.
    /// </summary>
    /// <param name="roleName">
    /// The role name.
    /// </param>
    /// <param name="cancellationToken">
    /// The cancellation token.
    /// </param>
    private async Task EnsureRoleExistsAsync(
        string roleName,
        CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();

        bool roleExists =
            await _roleManager
                .RoleExistsAsync(roleName)
                .ConfigureAwait(false);

        if (roleExists)
        {
            _logger.LogInformation(
                "Application role '{RoleName}' already exists.",
                roleName);

            return;
        }
        else
        {
        }

        IdentityRole<Guid> role = new()
        {
            Name = roleName
        };

        IdentityResult result =
            await _roleManager
                .CreateAsync(role)
                .ConfigureAwait(false);

        ThrowIfFailed(
            result,
            $"Failed to create application role '{roleName}'.");

        _logger.LogInformation(
            "Created application role '{RoleName}'.",
            roleName);
    }

    #endregion
}