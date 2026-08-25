/**
 * File Name      : SlotMaintenanceService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : ISlotGenerationService
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Background service responsible for periodic slot maintenance,
 *                  such as releasing expired slots and extending slots daily.
 */

using Appoynt.Application.Common.Interfaces;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace Appoynt.Infrastructure.BackgroundServices;

/// <summary>
/// Hosted service that performs background maintenance for clinic slots.
/// </summary>
public sealed class SlotMaintenanceService : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<SlotMaintenanceService> _logger;
    
    // Interval for releasing expired slots
    private readonly TimeSpan _shortInterval = TimeSpan.FromMinutes(5);
    
    // Interval for extending slots daily
    private readonly TimeSpan _longInterval = TimeSpan.FromHours(24);

    /// <summary>
    /// Initializes a new instance of the <see cref="SlotMaintenanceService"/> class.
    /// </summary>
    /// <param name="serviceProvider">Service provider to create scopes.</param>
    /// <param name="logger">The logger instance.</param>
    public SlotMaintenanceService(
        IServiceProvider serviceProvider,
        ILogger<SlotMaintenanceService> logger)
    {
        _serviceProvider = serviceProvider;
        _logger = logger;
    }

    /// <summary>
    /// Executes the background service logic.
    /// </summary>
    /// <param name="stoppingToken">Token to monitor for cancellation requests.</param>
    /// <returns>A task that represents the long-running operation.</returns>
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        // Log service startup
        _logger.LogInformation("Slot Maintenance Background Service is starting.");

        // Start background tasks
        Task releaseExpiredTask = RunReleaseExpiredSlotsLoopAsync(stoppingToken);
        Task extendDailyTask = RunExtendDailySlotsLoopAsync(stoppingToken);

        // Await all tasks to complete or be cancelled
        await Task.WhenAll(releaseExpiredTask, extendDailyTask).ConfigureAwait(false);

        // Log service stop
        _logger.LogInformation("Slot Maintenance Background Service is stopping.");
    }

    /// <summary>
    /// Runs a periodic loop to release expired pending slots.
    /// </summary>
    /// <param name="stoppingToken">Token to cancel the loop.</param>
    private async Task RunReleaseExpiredSlotsLoopAsync(CancellationToken stoppingToken)
    {
        // Use a periodic timer for accurate interval execution
        using var timer = new PeriodicTimer(_shortInterval);

        while (await timer.WaitForNextTickAsync(stoppingToken).ConfigureAwait(false))
        {
            try
            {
                // Log execution start
                _logger.LogInformation("Running short interval task: Release Expired Pending Slots.");

                // Create DI scope to resolve scoped services
                using var scope = _serviceProvider.CreateScope();
                
                // Retrieve required service from scope
                var slotService = scope.ServiceProvider.GetRequiredService<ISlotGenerationService>();

                // Perform background operation
                await slotService.ResetExpiredPendingSlotsAsync(stoppingToken).ConfigureAwait(false);
            }
            catch (Exception ex)
            {
                // Handle exceptions without crashing the background service
                _logger.LogError(ex, "An error occurred while releasing expired pending slots.");
            }
        }
    }

    /// <summary>
    /// Runs a periodic loop to extend slots for all clinics daily.
    /// </summary>
    /// <param name="stoppingToken">Token to cancel the loop.</param>
    private async Task RunExtendDailySlotsLoopAsync(CancellationToken stoppingToken)
    {
        // Small delay to ensure it doesn't conflict during system startup immediately
        await Task.Delay(TimeSpan.FromMinutes(1), stoppingToken).ConfigureAwait(false);

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                // Log execution start
                _logger.LogInformation("Running long interval task: Extend Slots for All Clinics.");

                // Create DI scope to resolve scoped services
                using var scope = _serviceProvider.CreateScope();
                
                // Retrieve required service from scope
                var slotService = scope.ServiceProvider.GetRequiredService<ISlotGenerationService>();

                // Perform background operation
                await slotService.ExtendSlotsForAllClinicsAsync(stoppingToken).ConfigureAwait(false);
            }
            catch (Exception ex)
            {
                // Handle exceptions without crashing the background service
                _logger.LogError(ex, "An error occurred while extending daily clinic slots.");
            }

            // Wait for 24 hours before next execution, respecting cancellation
            await Task.Delay(_longInterval, stoppingToken).ConfigureAwait(false);
        }
    }
}
