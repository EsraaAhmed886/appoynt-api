/**
 * File Name      : GovernorateSeeder.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : ApplicationDbContext, IGovernorateSeeder
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-20
 * Description    : Seeds the default Egyptian governorates and cities into the database.
 */

using System.Text.Json;
using Appoynt.Application.Common.Interfaces.Seeding;
using Appoynt.Domain.Entities;
using Appoynt.Infrastructure.Persistence.Seed.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace Appoynt.Infrastructure.Persistence.Seed;

/// <summary>
/// Seeds the Egyptian governorates and cities.
/// </summary>
public sealed class GovernorateSeeder : SeederBase, IGovernorateSeeder
{
    private readonly ApplicationDbContext _dbContext;
    private readonly ILogger<GovernorateSeeder> _logger;

    /// <summary>
    /// Initializes a new instance of the <see cref="GovernorateSeeder"/> class.
    /// </summary>
    /// <param name="dbContext">The application database context.</param>
    /// <param name="logger">The logger instance.</param>
    public GovernorateSeeder(
        ApplicationDbContext dbContext,
        ILogger<GovernorateSeeder> logger)
    {
        _dbContext = dbContext;
        _logger = logger;
    }

    /// <summary>
    /// Seeds governorates and cities asynchronously if they do not exist.
    /// </summary>
    /// <param name="cancellationToken">Cancellation token.</param>
    public async Task SeedAsync(CancellationToken cancellationToken = default)
    {
        // Check for cancellation
        cancellationToken.ThrowIfCancellationRequested();

        // Check if governorates already exist
        bool exists = await _dbContext.Governorates
            .AsNoTracking()
            .AnyAsync(cancellationToken)
            .ConfigureAwait(false);

        if (exists)
        {
            // Log that seeding is skipped
            _logger.LogInformation("Governorates already seeded.");
            return;
        }
        else
        {
            // Proceed to seed
        }

        // Determine JSON file path
        string jsonFilePath = Path.Combine(AppContext.BaseDirectory, "Persistence", "Seeding", "Data", "egypt_governorates_cities.json");

        // Fallback check if file is missing
        if (!File.Exists(jsonFilePath))
        {
            // Use fallback path based on current directory
            jsonFilePath = Path.Combine(Directory.GetCurrentDirectory(), "Persistence", "Seeding", "Data", "egypt_governorates_cities.json");
            
            if (!File.Exists(jsonFilePath))
            {
                // Cannot seed without the data file
                _logger.LogWarning("Governorates JSON data file not found at {FilePath}.", jsonFilePath);
                return;
            }
            else
            {
                // Found file via fallback
            }
        }
        else
        {
            // Found file in base directory
        }

        // Read JSON content
        string jsonContent = await File.ReadAllTextAsync(jsonFilePath, cancellationToken).ConfigureAwait(false);

        // Deserialize JSON to objects
        var governoratesData = JsonSerializer.Deserialize<GovernorateSeedDto[]>(
            jsonContent,
            new JsonSerializerOptions { PropertyNameCaseInsensitive = true });

        // Validate deserialization result
        if (governoratesData == null || governoratesData.Length == 0)
        {
            // Log missing or invalid data
            _logger.LogWarning("Governorates JSON data is empty or invalid.");
            return;
        }
        else
        {
            // Proceed with valid data
        }

        // Iterate over governorates and add to database
        foreach (var govDto in governoratesData)
        {
            // Create a new governorate entity
            var governorate = new Governorate
            {
                Id = Guid.NewGuid(),
                NameAr = govDto.NameAr,
                NameEn = govDto.NameEn
            };

            // Process cities if any exist
            if (govDto.Cities != null)
            {
                foreach (var cityDto in govDto.Cities)
                {
                    // Create a new city entity
                    var city = new City
                    {
                        Id = Guid.NewGuid(),
                        GovernorateId = governorate.Id,
                        Governorate = governorate,
                        NameAr = cityDto.NameAr,
                        NameEn = cityDto.NameEn
                    };

                    // Add city to governorate
                    governorate.Cities.Add(city);
                }
            }
            else
            {
                // No cities to process for this governorate
            }

            // Add governorate to DbContext
            _dbContext.Governorates.Add(governorate);
        }

        // Save all seeded entities to the database
        await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

        // Log successful seeding
        _logger.LogInformation("Successfully seeded {Count} governorates and their cities.", governoratesData.Length);
    }

    /// <summary>
    /// DTO for deserializing governorate seed data.
    /// </summary>
    private class GovernorateSeedDto
    {
        /// <summary>
        /// Governorate name in Arabic.
        /// </summary>
        public string NameAr { get; set; } = string.Empty;

        /// <summary>
        /// Governorate name in English.
        /// </summary>
        public string NameEn { get; set; } = string.Empty;

        /// <summary>
        /// Collection of cities within the governorate.
        /// </summary>
        public CitySeedDto[]? Cities { get; set; }
    }

    /// <summary>
    /// DTO for deserializing city seed data.
    /// </summary>
    private class CitySeedDto
    {
        /// <summary>
        /// City name in Arabic.
        /// </summary>
        public string NameAr { get; set; } = string.Empty;

        /// <summary>
        /// City name in English.
        /// </summary>
        public string NameEn { get; set; } = string.Empty;
    }
}
