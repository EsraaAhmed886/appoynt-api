/**
 * File Name      : AuthenticationController.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : ILoginService, IRegistrationService, LoginRequest,
 *                  LoginResponse, RegisterRequest, RegisterResponse,
 *                  AuthenticationError
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Exposes authentication endpoints available to unauthenticated
 *                  clients.
 */

using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Authentication.Login;
using Appoynt.Application.Features.Authentication.Login.Contracts;
using Appoynt.Application.Features.Authentication.Otp;
using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Application.Features.Authentication.Registration;
using Appoynt.Application.Features.Authentication.Registration.Contracts;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Appoynt.API.Controllers;

/// <summary>
/// Exposes authentication endpoints.
/// </summary>
[ApiController]
[Route("api/auth")]
[Tags("Authentication")]
public sealed class AuthenticationController : ControllerBase
{
    private readonly ILoginService _loginService;
    private readonly IOtpService _otpService;
    private readonly IRegistrationService _registrationService;

    /// <summary>
    /// Initializes a new instance of the <see cref="AuthenticationController"/> class.
    /// </summary>
    /// <param name="loginService">The account login service.</param>
    /// <param name="registrationService">The patient registration service.</param>
    public AuthenticationController(
        ILoginService loginService,
        IOtpService otpService,
        IRegistrationService registrationService)
    {
        _loginService = loginService;
        _otpService = otpService;
        _registrationService = registrationService;
    }

    /// <summary>
    /// Authenticates an active account with a confirmed phone number and
    /// returns a JWT access token.
    /// </summary>
    /// <param name="request">The login request.</param>
    /// <param name="cancellationToken">A token used to cancel the operation.</param>
    /// <returns>The JWT access token.</returns>
    /// <response code="200">The account was authenticated successfully.</response>
    /// <response code="401">The supplied credentials are invalid.</response>
    [AllowAnonymous]
    [HttpPost("login")]
    [ProducesResponseType(typeof(LoginResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(
        typeof(IReadOnlyList<AuthenticationError>),
        StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> LoginAsync(
        [FromBody] LoginRequest request,
        CancellationToken cancellationToken)
    {
        LoginResult result = await _loginService.LoginAsync(
            request,
            cancellationToken);

        return result.Succeeded
            ? Ok(result.Response)
            : Unauthorized(result.Errors);
    }

    /// <summary>
    /// Verifies a Registration phone-confirmation or Login OTP challenge.
    /// </summary>
    [AllowAnonymous]
    [HttpPost("otp/verify")]
    [ProducesResponseType(typeof(OtpVerificationResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(IReadOnlyList<AuthenticationError>), StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> VerifyOtpAsync(
        [FromBody] VerifyOtpRequest request,
        CancellationToken cancellationToken)
    {
        OtpResult result = await _otpService.VerifyAsync(request, cancellationToken);

        return result.Succeeded
            ? Ok(result.Verification)
            : BadRequest(result.Errors);
    }

    /// <summary>
    /// Creates a patient account, assigns the Patient role, and creates the
    /// associated patient profile.
    /// </summary>
    /// <param name="request">The registration request.</param>
    /// <param name="cancellationToken">A token used to cancel the operation.</param>
    /// <returns>The identifier of the newly created user account.</returns>
    /// <response code="201">The patient account was created successfully.</response>
    /// <response code="400">The request failed one or more validation rules.</response>
    /// <response code="409">The email address or phone number is already registered.</response>
    /// <response code="500">Registration could not be completed.</response>
    [AllowAnonymous]
    [HttpPost("register")]
    [ProducesResponseType(typeof(RegisterResponse), StatusCodes.Status201Created)]
    [ProducesResponseType(
        typeof(IReadOnlyList<AuthenticationError>),
        StatusCodes.Status400BadRequest)]
    [ProducesResponseType(
        typeof(IReadOnlyList<AuthenticationError>),
        StatusCodes.Status409Conflict)]
    [ProducesResponseType(
        typeof(IReadOnlyList<AuthenticationError>),
        StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> RegisterAsync(
        [FromBody] RegisterRequest request,
        CancellationToken cancellationToken)
    {
        RegistrationResult result = await _registrationService.RegisterAsync(
            request,
            cancellationToken);

        if (result.Succeeded)
        {
            return StatusCode(StatusCodes.Status201Created, result.Response);
        }

        if (result.Errors.Any(error =>
                error.Code is AuthenticationErrorCodes.EmailAlreadyRegistered
                    or AuthenticationErrorCodes.PhoneAlreadyRegistered))
        {
            return Conflict(result.Errors);
        }

        if (result.Errors.Any(error =>
                error.Code == AuthenticationErrorCodes.RegistrationFailed))
        {
            return StatusCode(StatusCodes.Status500InternalServerError, result.Errors);
        }

        return BadRequest(result.Errors);
    }
}
