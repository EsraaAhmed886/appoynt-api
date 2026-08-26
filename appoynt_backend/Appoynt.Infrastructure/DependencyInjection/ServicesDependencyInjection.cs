/**
 * File Name      : ServicesDependencyInjection.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 22/07/2026
 * Version        : v1.1.0
 * Dependencies   : CurrentUserService, DateTimeProvider, LocalFileStorageService, ImageProcessingService, ProfileImageService
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-26
 * Description    : Registers infrastructure services used throughout the application.
 */

using Appoynt.Application.Common.Interfaces;
using Appoynt.Infrastructure.Services;
using Microsoft.Extensions.DependencyInjection;

namespace Appoynt.Infrastructure.DependencyInjection;

/// <summary>
/// Provides extension methods for registering infrastructure services.
/// </summary>
internal static class ServicesDependencyInjection
{
    /// <summary>
    /// Registers infrastructure services.
    /// </summary>
    /// <param name="services">
    /// The application service collection.
    /// </param>
    /// <returns>
    /// The updated <see cref="IServiceCollection"/>.
    /// </returns>
    internal static IServiceCollection AddInfrastructureServices(
        this IServiceCollection services)
    {
        // Register access to the current HTTP context.
        services.AddHttpContextAccessor();

        // Register the current authenticated user service.
        services.AddScoped<ICurrentUserService, CurrentUserService>();

        // Register the system date and time provider.
        services.AddSingleton<IDateTimeProvider, DateTimeProvider>();

        // Register local file storage service.
        services.AddSingleton<IFileStorageService, Appoynt.Infrastructure.FileStorage.LocalFileStorageService>();

        // Register image processing and compression service.
        services.AddSingleton<IImageProcessingService, ImageProcessingService>();

        // Register centralized profile image management service.
        services.AddScoped<IProfileImageService, ProfileImageService>();

        // Register clinic management and slot services
        services.AddScoped<Appoynt.Application.Common.Interfaces.IClinicService, Appoynt.Infrastructure.Services.ClinicService>();
        services.AddScoped<Appoynt.Application.Common.Interfaces.ISlotGenerationService, Appoynt.Infrastructure.Services.SlotGenerationService>();

        // Register the patient booking screen service and its cache backing.
        services.AddMemoryCache();
        services.AddSingleton<Appoynt.Application.Common.Interfaces.ICacheService, Appoynt.Infrastructure.Services.MemoryCacheService>();
        services.AddScoped<Appoynt.Application.Features.Booking.IPatientBookingService, Appoynt.Infrastructure.Services.PatientBookingService>();

        // Register the doctor appointments screen service.
        services.AddScoped<Appoynt.Application.Features.DoctorAppointments.IDoctorAppointmentsService, Appoynt.Infrastructure.Services.DoctorAppointmentsService>();
        services.AddScoped<Appoynt.Application.Common.Interfaces.Seeding.IGovernorateSeeder, Appoynt.Infrastructure.Persistence.Seed.GovernorateSeeder>();
        services.AddHostedService<Appoynt.Infrastructure.BackgroundServices.SlotMaintenanceService>();

        // Register clinic validators
        services.AddScoped<FluentValidation.IValidator<Appoynt.Application.Features.Clinics.Contracts.CreateClinicRequest>, Appoynt.Application.Features.Clinics.Validation.CreateClinicRequestValidator>();
        services.AddScoped<FluentValidation.IValidator<Appoynt.Application.Features.Clinics.Contracts.UpdateClinicRequest>, Appoynt.Application.Features.Clinics.Validation.UpdateClinicRequestValidator>();
        services.AddScoped<FluentValidation.IValidator<Appoynt.Application.Features.Clinics.Contracts.WorkingPeriodRequest>, Appoynt.Application.Features.Clinics.Validation.WorkingPeriodRequestValidator>();
        services.AddScoped<FluentValidation.IValidator<Appoynt.Application.Features.Clinics.Contracts.BreakRequest>, Appoynt.Application.Features.Clinics.Validation.BreakRequestValidator>();

        return services;
    }
}
