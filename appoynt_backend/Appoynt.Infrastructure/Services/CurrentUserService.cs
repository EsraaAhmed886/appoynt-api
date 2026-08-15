/**
 * File Name      : CurrentUserService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : IHttpContextAccessor, ICurrentUserService, ClaimsPrincipal
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Provides access to the currently authenticated user's
 *                  identifier from the HTTP context.
 */

using System;
using System.Security.Claims;
using Appoynt.Application.Common.Interfaces;
using Microsoft.AspNetCore.Http;

namespace Appoynt.Infrastructure.Services;

/// <summary>
/// Provides information about the currently authenticated user.
/// </summary>
public sealed class CurrentUserService : ICurrentUserService
{
    #region Dependencies

    /// <summary>
    /// Provides access to the current HTTP context.
    /// </summary>
    private readonly IHttpContextAccessor _httpContextAccessor;

    #endregion

    #region Constructors

    /// <summary>
    /// Initializes a new instance of the <see cref="CurrentUserService"/> class.
    /// </summary>
    /// <param name="httpContextAccessor">
    /// Provides access to the current HTTP context.
    /// </param>
    public CurrentUserService(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    #endregion

    #region Properties

    /// <summary>
    /// Gets the identifier of the currently authenticated user.
    /// Returns <see langword="null"/> when no authenticated user exists
    /// or the identifier is not a valid <see cref="Guid"/>.
    /// </summary>
    public Guid? UserId
    {
        get
        {
            // Retrieve the user identifier claim from the current HTTP context.
            var userId = _httpContextAccessor.HttpContext?
                .User?
                .FindFirstValue(ClaimTypes.NameIdentifier);

            // Convert the claim value to a Guid when possible.
            return Guid.TryParse(userId, out var id)
                ? id
                : null;
        }
    }

    /// <summary>
    /// Gets the role of the currently authenticated user.
    /// </summary>
    public string? Role
    {
        get
        {
            return _httpContextAccessor.HttpContext?
                .User?
                .FindFirstValue(ClaimTypes.Role);
        }
    }

    #endregion
}