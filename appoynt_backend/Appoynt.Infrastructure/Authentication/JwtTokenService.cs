/**
 * File Name      : JwtTokenService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : ITokenService, JwtOptions, ApplicationUser, UserManager,
 *                  JWT Security Token Handler
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Generates signed JSON Web Token access tokens for
 *                  authenticated application users.
 */

using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Options;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace Appoynt.Infrastructure.Authentication;

/// <summary>
/// Generates signed JSON Web Token access tokens for application users.
/// </summary>
public sealed class JwtTokenService : ITokenService
{
    #region Fields

    private readonly UserManager<ApplicationUser> _userManager;

    private readonly JwtOptions _jwtOptions;

    #endregion

    #region Constructors

    /// <summary>
    /// Initializes a new instance of the <see cref="JwtTokenService"/> class.
    /// </summary>
    /// <param name="userManager">
    /// The ASP.NET Core Identity user manager.
    /// </param>
    /// <param name="jwtOptions">
    /// The JWT configuration options.
    /// </param>
    public JwtTokenService(
        UserManager<ApplicationUser> userManager,
        IOptions<JwtOptions> jwtOptions)
    {
        ArgumentNullException.ThrowIfNull(userManager);
        ArgumentNullException.ThrowIfNull(jwtOptions);

        _userManager = userManager;
        _jwtOptions = jwtOptions.Value;
    }

    #endregion

    #region Public Methods

    /// <inheritdoc />
    public async Task<string> GenerateAccessTokenAsync(ApplicationUser user)
    {
        ArgumentNullException.ThrowIfNull(user);

        string email = user.Email
            ?? throw new InvalidOperationException(
                "Cannot generate an access token for a user without an email address.");

        string name = user.UserName ?? email;

        DateTime utcNow = DateTime.UtcNow;

        List<Claim> claims =
        [
            new Claim(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
            new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
            new Claim(
                JwtRegisteredClaimNames.Iat,
                new DateTimeOffset(utcNow).ToUnixTimeSeconds().ToString(),
                ClaimValueTypes.Integer64),
            new Claim(JwtRegisteredClaimNames.Email, email),
            new Claim(JwtRegisteredClaimNames.Name, name),
            new Claim(JwtRegisteredClaimNames.GivenName, user.FirstName),
            new Claim(JwtRegisteredClaimNames.FamilyName, user.LastName)
        ];

        HashSet<string> reservedClaimTypes =
            claims
                .Select(claim => claim.Type)
                .Append(ClaimTypes.Role)
                .ToHashSet(StringComparer.Ordinal);

        IList<Claim> userClaims =
            await _userManager
                .GetClaimsAsync(user)
                .ConfigureAwait(false);

        claims.AddRange(
            userClaims.Where(
                claim => !reservedClaimTypes.Contains(claim.Type)));

        IList<string> roles =
            await _userManager
                .GetRolesAsync(user)
                .ConfigureAwait(false);

        claims.AddRange(
            roles
                .Distinct(StringComparer.Ordinal)
                .Select(role => new Claim(ClaimTypes.Role, role)));

        SymmetricSecurityKey signingKey = new(
            Encoding.UTF8.GetBytes(_jwtOptions.SecretKey));

        SigningCredentials signingCredentials = new(
            signingKey,
            SecurityAlgorithms.HmacSha256);

        JwtSecurityToken token = new(
            issuer: _jwtOptions.Issuer,
            audience: _jwtOptions.Audience,
            claims: claims,
            notBefore: utcNow,
            expires: utcNow.AddMinutes(
                _jwtOptions.AccessTokenExpirationMinutes),
            signingCredentials: signingCredentials);

        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    #endregion
}
