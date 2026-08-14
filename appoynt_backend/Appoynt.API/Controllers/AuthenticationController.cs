/**
 * File Name      : AuthenticationController.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : ILoginService, IRegistrationService, IOtpService, IPasswordRecoveryService,
 *                  LoginRequest, LoginResponse, RegisterRequest, RegisterResponse,
 *                  AuthenticationError, AuthenticationErrorCodes
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Exposes authentication endpoints available to unauthenticated clients.
 */

using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Authentication.Login;
using Appoynt.Application.Features.Authentication.Login.Contracts;
using Appoynt.Application.Features.Authentication.Otp;
using Appoynt.Application.Features.Authentication.Otp.Contracts;
using Appoynt.Application.Features.Authentication.PasswordRecovery;
using Appoynt.Application.Features.Authentication.PasswordRecovery.Contracts;
using Appoynt.Application.Features.Authentication.Registration;
using Appoynt.Application.Features.Authentication.Registration.Contracts;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

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
    private readonly IPasswordRecoveryService _passwordRecoveryService;
    private readonly IRegistrationService _registrationService;

    /// <summary>
    /// Initializes a new instance of the <see cref="AuthenticationController"/> class.
    /// </summary>
    /// <param name="loginService">The account login service.</param>
    /// <param name="otpService">The one-time password verification service.</param>
    /// <param name="passwordRecoveryService">The password recovery management service.</param>
    /// <param name="registrationService">The patient registration service.</param>
    public AuthenticationController(
        ILoginService loginService,
        IOtpService otpService,
        IPasswordRecoveryService passwordRecoveryService,
        IRegistrationService registrationService)
    {
        // Store login service dependency
        _loginService = loginService;

        // Store OTP service dependency
        _otpService = otpService;

        // Store password recovery service dependency
        _passwordRecoveryService = passwordRecoveryService;

        // Store registration service dependency
        _registrationService = registrationService;
    }

    /// <summary>
    /// Authenticates an active account with a confirmed phone number and returns a JWT access token.
    /// </summary>
    /// <param name="request">The login request.</param>
    /// <param name="cancellationToken">A token used to cancel the operation.</param>
    /// <returns>The JWT access token.</returns>
    /// <response code="200">The account was authenticated successfully.</response>
    /// <response code="401">The supplied credentials are invalid.</response>
    [AllowAnonymous]
    [EnableRateLimiting("Login")]
    [HttpPost("login")]
    [ProducesResponseType(typeof(LoginResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(
        typeof(IReadOnlyList<AuthenticationError>),
        StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> LoginAsync(
        [FromBody] LoginRequest request,
        CancellationToken cancellationToken)
    {
        // Invoking authentication service to validate user credentials
        LoginResult result = await _loginService.LoginAsync(
            request,
            cancellationToken);

        // Check if authentication operation succeeded
        if (result.Succeeded)
        {
            // Return 200 OK with token and user details
            return Ok(result.Response);
        }
        else
        {
            // Return 401 Unauthorized with credential errors
            return Unauthorized(result.Errors);
        }
    }

    /// <summary>
    /// Verifies a Registration phone-confirmation or Login OTP challenge.
    /// </summary>
    /// <param name="request">The OTP verification request.</param>
    /// <param name="cancellationToken">A token used to cancel the operation.</param>
    /// <returns>The OTP verification response.</returns>
    [AllowAnonymous]
    [EnableRateLimiting("OtpVerify")]
    [HttpPost("otp/verify")]
    [ProducesResponseType(typeof(OtpVerificationResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(IReadOnlyList<AuthenticationError>), StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> VerifyOtpAsync(
        [FromBody] VerifyOtpRequest request,
        CancellationToken cancellationToken)
    {
        // Execute OTP code verification against stored challenge
        OtpResult result = await _otpService.VerifyAsync(request, cancellationToken);

        // Evaluate verification outcome
        if (result.Succeeded)
        {
            // Return 200 OK with verification metadata
            return Ok(result.Verification);
        }
        else
        {
            // Return 400 Bad Request with validation errors
            return BadRequest(result.Errors);
        }
    }

    /// <summary>
    /// Replaces an expired OTP challenge with a new challenge.
    /// </summary>
    /// <param name="request">The OTP resend request.</param>
    /// <param name="cancellationToken">A token used to cancel the operation.</param>
    /// <returns>The new OTP challenge details.</returns>
    [AllowAnonymous]
    [EnableRateLimiting("OtpResend")]
    [HttpPost("otp/resend")]
    [ProducesResponseType(typeof(OtpChallengeResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(IReadOnlyList<AuthenticationError>), StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> ResendOtpAsync(
        [FromBody] ResendOtpRequest request,
        CancellationToken cancellationToken)
    {
        // Issue replacement OTP challenge
        OtpResult result = await _otpService.ResendAsync(request, cancellationToken);

        // Evaluate challenge reissue outcome
        if (result.Succeeded)
        {
            // Return 200 OK with newly issued challenge details
            return Ok(result.Challenge);
        }
        else
        {
            // Return 400 Bad Request with resend error details
            return BadRequest(result.Errors);
        }
    }

    /// <summary>
    /// Creates a patient account, assigns the Patient role, and creates the associated patient profile.
    /// </summary>
    /// <param name="request">The registration request.</param>
    /// <param name="cancellationToken">A token used to cancel the operation.</param>
    /// <returns>The identifier of the newly created user account.</returns>
    /// <response code="201">The patient account was created successfully.</response>
    /// <response code="400">The request failed one or more validation rules.</response>
    /// <response code="409">The email address or phone number is already registered.</response>
    /// <response code="500">Registration could not be completed.</response>
    [AllowAnonymous]
    [EnableRateLimiting("Register")]
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
        // Execute patient account registration
        RegistrationResult result = await _registrationService.RegisterAsync(
            request,
            cancellationToken);

        // Check if registration succeeded
        if (result.Succeeded)
        {
            // Return 201 Created with new user registration details
            return StatusCode(StatusCodes.Status201Created, result.Response);
        }
        else
        {
            // Check if failure is due to email or phone conflicts
            if (result.Errors.Any(error =>
                    error.Code is AuthenticationErrorCodes.EmailAlreadyRegistered
                        or AuthenticationErrorCodes.PhoneAlreadyRegistered))
            {
                // Return 409 Conflict when unique field duplicate occurs
                return Conflict(result.Errors);
            }
            else if (result.Errors.Any(error =>
                    error.Code == AuthenticationErrorCodes.RegistrationFailed))
            {
                // Return 500 Internal Server Error when server-side persistence fails
                return StatusCode(StatusCodes.Status500InternalServerError, result.Errors);
            }
            else
            {
                // Return 400 Bad Request for standard input validation errors
                return BadRequest(result.Errors);
            }
        }
    }

    /// <summary>
    /// Initiates a password recovery request by issuing an OTP challenge.
    /// </summary>
    /// <param name="request">The password recovery request.</param>
    /// <param name="cancellationToken">A token used to cancel the operation.</param>
    /// <returns>The OTP challenge response.</returns>
    [AllowAnonymous]
    [EnableRateLimiting("ForgotPassword")]
    [HttpPost("forgot-password")]
    [ProducesResponseType(typeof(OtpChallengeResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(IReadOnlyList<AuthenticationError>), StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> ForgotPasswordAsync(
        [FromBody] ForgotPasswordRequest request,
        CancellationToken cancellationToken)
    {
        // Initiate password reset challenge via service
        OtpResult result = await _passwordRecoveryService.ForgotPasswordAsync(request, cancellationToken);

        // Check if OTP challenge generation succeeded
        if (result.Succeeded)
        {
            // Return 200 OK with recovery challenge metadata
            return Ok(result.Challenge);
        }
        else
        {
            // Return 400 Bad Request with recovery errors
            return BadRequest(result.Errors);
        }
    }

    /// <summary>
    /// Resets the user's password using a valid reset token.
    /// </summary>
    /// <param name="request">The password reset payload.</param>
    /// <param name="cancellationToken">A token used to cancel the operation.</param>
    /// <returns>An HTTP 200 OK response if password was updated.</returns>
    [AllowAnonymous]
    [EnableRateLimiting("ResetPassword")]
    [HttpPost("reset-password")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(IReadOnlyList<AuthenticationError>), StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> ResetPasswordAsync(
        [FromBody] ResetPasswordRequest request,
        CancellationToken cancellationToken)
    {
        // Execute password reset with verification token
        var (succeeded, errors) = await _passwordRecoveryService.ResetPasswordAsync(request, cancellationToken);

        // Evaluate password update outcome
        if (succeeded)
        {
            // Return 200 OK upon successful password reset
            return Ok();
        }
        else
        {
            // Return 400 Bad Request with reset error details
            return BadRequest(errors);
        }
    }
}
