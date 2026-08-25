/**
 * File Name      : DoctorSeeder.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : UserManager<ApplicationUser>, ApplicationDbContext, SeedOptions, RoleConstants, IDoctorSeeder
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Seeds a default doctor user account, doctor profile, specialization, and contact phone number.
 */

using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
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
/// Seeds the default doctor account and profile required for development and testing.
/// </summary>
public sealed class DoctorSeeder : SeederBase, IDoctorSeeder
{
    #region Fields

    private readonly UserManager<ApplicationUser> _userManager;
    private readonly ApplicationDbContext _dbContext;
    private readonly SeedOptions _seedOptions;
    private readonly ILogger<DoctorSeeder> _logger;

    #endregion

    #region Constructors

    /// <summary>
    /// Initializes a new instance of the <see cref="DoctorSeeder"/> class.
    /// </summary>
    /// <param name="userManager">The ASP.NET Core Identity user manager.</param>
    /// <param name="dbContext">The application database context.</param>
    /// <param name="seedOptions">Seed configuration options.</param>
    /// <param name="logger">The logger instance.</param>
    public DoctorSeeder(
        UserManager<ApplicationUser> userManager,
        ApplicationDbContext dbContext,
        IOptions<SeedOptions> seedOptions,
        ILogger<DoctorSeeder> logger)
    {
        // Store user manager dependency.
        _userManager = userManager;

        // Store database context dependency.
        _dbContext = dbContext;

        // Store seed options dependency.
        _seedOptions = seedOptions.Value;

        // Store logger dependency.
        _logger = logger;
    }

    #endregion

    #region Public Methods

    /// <inheritdoc />
    public async Task SeedAsync(CancellationToken cancellationToken = default)
    {
        // Check for cancellation request.
        cancellationToken.ThrowIfCancellationRequested();

        // Validate doctor options.
        ValidateDoctorOptions();

        DoctorOptions doctorOptions = _seedOptions.Doctor;

        // Look up existing user by email.
        ApplicationUser? user = await _userManager.FindByEmailAsync(doctorOptions.Email);

        // If user does not exist, create the Identity user.
        if (user == null)
        {
            // Create user entity.
            user = new ApplicationUser
            {
                FirstName = doctorOptions.FirstName,
                LastName = doctorOptions.LastName,
                Email = doctorOptions.Email,
                UserName = doctorOptions.Email,
                PhoneNumber = doctorOptions.PhoneNumber,
                EmailConfirmed = true,
                PhoneNumberConfirmed = true,
                IsActive = true
            };

            // Create user in Identity store.
            var createResult = await _userManager.CreateAsync(user, doctorOptions.Password);
            ThrowIfFailed(createResult, $"Failed to create default doctor user '{doctorOptions.Email}'.");

            _logger.LogInformation("Created default doctor user '{Email}'.", doctorOptions.Email);
        }
        else
        {
            _logger.LogInformation("Default doctor user '{Email}' already exists.", doctorOptions.Email);
        }

        // Ensure doctor role is assigned.
        await EnsureDoctorRoleAsync(user);

        // Ensure doctor profile entity and associations exist.
        await EnsureDoctorProfileAsync(user, doctorOptions, cancellationToken);
    }

    #endregion

    #region Private Methods

    /// <summary>
    /// Validates that the doctor seed configuration is valid.
    /// </summary>
    private void ValidateDoctorOptions()
    {
        DoctorOptions doc = _seedOptions.Doctor;

        if (string.IsNullOrWhiteSpace(doc.FirstName))
        {
            throw new InvalidOperationException("Seed configuration is missing Doctor:FirstName.");
        }
        else
        {
            // First name valid.
        }

        if (string.IsNullOrWhiteSpace(doc.LastName))
        {
            throw new InvalidOperationException("Seed configuration is missing Doctor:LastName.");
        }
        else
        {
            // Last name valid.
        }

        if (string.IsNullOrWhiteSpace(doc.Email))
        {
            throw new InvalidOperationException("Seed configuration is missing Doctor:Email.");
        }
        else
        {
            // Email valid.
        }

        if (string.IsNullOrWhiteSpace(doc.Password))
        {
            throw new InvalidOperationException("Seed configuration is missing Doctor:Password.");
        }
        else
        {
            // Password valid.
        }
    }

    /// <summary>
    /// Ensures the doctor role is assigned to the specified user.
    /// </summary>
    /// <param name="user">The application user.</param>
    private async Task EnsureDoctorRoleAsync(ApplicationUser user)
    {
        // Check if user is in Doctor role.
        bool isInRole = await _userManager.IsInRoleAsync(user, RoleConstants.Doctor);
        if (isInRole)
        {
            _logger.LogInformation("Doctor user '{Email}' is already assigned to role '{Role}'.", user.Email, RoleConstants.Doctor);
            return;
        }
        else
        {
            // Add user to role.
        }

        var addRoleResult = await _userManager.AddToRoleAsync(user, RoleConstants.Doctor);
        ThrowIfFailed(addRoleResult, $"Failed to assign role '{RoleConstants.Doctor}' to doctor user '{user.Email}'.");

        _logger.LogInformation("Assigned role '{Role}' to doctor user '{Email}'.", RoleConstants.Doctor, user.Email);
    }

    /// <summary>
    /// Ensures the doctor domain entity, specialization, and phone numbers exist.
    /// </summary>
    /// <param name="user">The application user.</param>
    /// <param name="doctorOptions">The doctor configuration options.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    private async Task EnsureDoctorProfileAsync(
        ApplicationUser user,
        DoctorOptions doctorOptions,
        CancellationToken cancellationToken)
    {
        // Check if doctor profile already exists for this user.
        Doctor? doctor = await _dbContext.Doctors
            .Include(d => d.PhoneNumbers)
            .Include(d => d.DoctorSpecializations)
            .FirstOrDefaultAsync(d => d.UserId == user.Id, cancellationToken);

        if (doctor == null)
        {
            // Create new Doctor entity.
            doctor = new Doctor
            {
                Id = Guid.NewGuid(),
                UserId = user.Id,
                User = user,
                NameAr = doctorOptions.NameAr,
                NameEn = doctorOptions.NameEn,
                Bio = doctorOptions.Bio,
                Education = doctorOptions.Education
            };

            _dbContext.Doctors.Add(doctor);
            await _dbContext.SaveChangesAsync(cancellationToken);

            _logger.LogInformation("Created doctor profile entity for user '{Email}'.", user.Email);
        }
        else
        {
            _logger.LogInformation("Doctor profile entity for user '{Email}' already exists.", user.Email);
        }

        // Link specialization if not already linked.
        if (doctor.DoctorSpecializations.Count == 0)
        {
            // Find specialization matching requested name or fallback to first available.
            var specialization = await _dbContext.Specializations
                .FirstOrDefaultAsync(s => s.NameEn == doctorOptions.SpecializationNameEn, cancellationToken)
                ?? await _dbContext.Specializations.FirstOrDefaultAsync(cancellationToken);

            if (specialization != null)
            {
                // Create join entity.
                var doctorSpec = new DoctorSpecialization
                {
                    DoctorId = doctor.Id,
                    Doctor = doctor,
                    SpecializationId = specialization.Id,
                    Specialization = specialization
                };

                _dbContext.DoctorSpecializations.Add(doctorSpec);
                await _dbContext.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Linked specialization '{SpecName}' to doctor '{Email}'.", specialization.NameEn, user.Email);
            }
            else
            {
                // No specialization found.
            }
        }
        else
        {
            // Specialization already linked.
        }

        // Add default phone number if none exist.
        if (doctor.PhoneNumbers.Count == 0 && !string.IsNullOrWhiteSpace(doctorOptions.PhoneNumber))
        {
            // Create phone number entity.
            var phone = new DoctorPhoneNumber
            {
                Id = Guid.NewGuid(),
                DoctorId = doctor.Id,
                Doctor = doctor,
                PhoneNumber = doctorOptions.PhoneNumber,
                Label = "عيادة خاصة"
            };

            _dbContext.DoctorPhoneNumbers.Add(phone);
            await _dbContext.SaveChangesAsync(cancellationToken);

            _logger.LogInformation("Added default contact phone number '{Phone}' to doctor '{Email}'.", doctorOptions.PhoneNumber, user.Email);
        }
        else
        {
            // Phone numbers already exist.
        }
    }

    #endregion
}
