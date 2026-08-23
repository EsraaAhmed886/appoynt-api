/**
 * File Name      : AuthenticationDependencyInjection.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 22/07/2026
 * Version        : v1.0.0
 * Dependencies   : JwtOptions, JwtTokenService, RegistrationService,
 *                  LoginService, ISmsSender,
 *                  JWT Bearer Authentication
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Registers authentication services used by the
 *                  application.
 * Description    : Registers authentication services used by the
 *                  application.
 */

using System.Text;
using Appoynt.Application.Common.Interfaces;
using Appoynt.Application.Features.Authentication.Login;
using Appoynt.Application.Features.Authentication.Otp;
using Appoynt.Application.Features.Authentication.PasswordRecovery;
using Appoynt.Application.Features.Authentication.Registration;
using Appoynt.Application.Features.Patient;
using Appoynt.Application.Features.UserManagement;
using Appoynt.Application.Features.UserManagement.Contracts;
using Appoynt.Application.Features.UserManagement.Validation;
using Appoynt.Infrastructure.Authentication;
using Appoynt.Infrastructure.Authentication.UserManagement;
using Appoynt.Infrastructure.Options;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace Appoynt.Infrastructure.DependencyInjection;

/// <summary>
/// Provides extension methods for registering authentication services.
/// </summary>
internal static class AuthenticationDependencyInjection
{
    /// <summary>
    /// Registers authentication services.
    /// </summary>
    /// <param name="services">
    /// The application service collection.
    /// </param>
    /// <param name="configuration">
    /// The application configuration.
    /// </param>
    /// <returns>
    /// The updated <see cref="IServiceCollection"/>.
    /// </returns>
    internal static IServiceCollection AddInfrastructureAuthentication(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        ArgumentNullException.ThrowIfNull(configuration);

        services
            .AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme =
                    JwtBearerDefaults.AuthenticationScheme;

                options.DefaultChallengeScheme =
                    JwtBearerDefaults.AuthenticationScheme;
            })
            .AddJwtBearer();

        services
            .AddOptions<JwtBearerOptions>(
                JwtBearerDefaults.AuthenticationScheme)
            .Configure<IOptions<JwtOptions>>(
                (options, jwtOptions) =>
            {
                options.MapInboundClaims = false;

                SymmetricSecurityKey signingKey = new(
                    Encoding.UTF8.GetBytes(jwtOptions.Value.SecretKey));

                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = signingKey,
                    ValidateIssuer = true,
                    ValidIssuer = jwtOptions.Value.Issuer,
                    ValidateAudience = true,
                    ValidAudience = jwtOptions.Value.Audience,
                    ValidateLifetime = true,
                    RequireExpirationTime = true,
                    RequireSignedTokens = true,
                    ValidAlgorithms = [SecurityAlgorithms.HmacSha256],
                    ClockSkew = TimeSpan.Zero
                };
            });

        services.AddScoped<ITokenService, JwtTokenService>();
        services.AddScoped<IRegistrationService, RegistrationService>();
        services.AddScoped<IUserManagementService, UserManagementService>();
        services.AddScoped<FluentValidation.IValidator<CreateStaffRequest>, CreateStaffRequestValidator>();
        services.AddScoped<FluentValidation.IValidator<CreateDoctorRequest>, CreateDoctorRequestValidator>();
        services.AddScoped<FluentValidation.IValidator<UpdateUserRequest>, UpdateUserRequestValidator>();
        services.AddScoped<ILoginService, LoginService>();
        services.AddScoped<IPasswordRecoveryService, PasswordRecoveryService>();
        services.AddScoped<IOtpService, OtpService>();
        services.AddScoped<DevelopmentSmsSender>();
        services.AddScoped<UnavailableSmsSender>();
        services.AddScoped<ISmsSender>(serviceProvider =>
        {
            // Default to DevelopmentSmsSender (logs OTP and returns success) until a production SMS gateway is configured.
            return serviceProvider.GetRequiredService<DevelopmentSmsSender>();
        });

        services.AddScoped<IPatientService, Appoynt.Infrastructure.Authentication.Patient.PatientService>();
        services.AddScoped<FluentValidation.IValidator<Appoynt.Application.Features.Patient.Contracts.UpdatePatientProfileRequest>, Appoynt.Application.Features.Patient.Validation.UpdatePatientProfileValidator>();
        services.AddScoped<FluentValidation.IValidator<Appoynt.Application.Features.Patient.Contracts.AddFamilyMemberRequest>, Appoynt.Application.Features.Patient.Validation.AddFamilyMemberValidator>();
        services.AddScoped<FluentValidation.IValidator<Appoynt.Application.Features.Patient.Contracts.UpdateFamilyMemberRequest>, Appoynt.Application.Features.Patient.Validation.UpdateFamilyMemberValidator>();

        // Doctor Profile Services
        services.AddScoped<Appoynt.Application.Features.Doctor.IDoctorProfileService, Appoynt.Infrastructure.Authentication.Doctor.DoctorProfileService>();
        services.AddScoped<FluentValidation.IValidator<Appoynt.Application.Features.Doctor.Contracts.UpdateDoctorProfileRequest>, Appoynt.Application.Features.Doctor.Validation.UpdateDoctorProfileValidator>();
        services.AddScoped<FluentValidation.IValidator<Appoynt.Application.Features.Doctor.Contracts.AddDoctorPhoneNumberRequest>, Appoynt.Application.Features.Doctor.Validation.AddDoctorPhoneNumberValidator>();
        services.AddScoped<FluentValidation.IValidator<Appoynt.Application.Features.Patient.Contracts.UpdatePatientPhoneNumberRequest>, Appoynt.Application.Features.Patient.Validation.UpdatePatientPhoneNumberValidator>();

        return services;
    }
}
