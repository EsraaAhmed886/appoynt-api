/**
 * File Name      : ApplicationDbContext.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : Entity Framework Core, ASP.NET Core Identity,
 *                  ICurrentUserService, IDateTimeProvider,
 *                  ApplicationUser, BaseEntity, OtpChallenge
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 25/07/2026
 * Description    : Represents the application's primary database context.
 *                  Responsible for entity mapping, persistence operations,
 *                  auditing, and soft-delete behavior.
 */

using Appoynt.Application.Common.Interfaces;
using Appoynt.Domain.Common;
using Appoynt.Domain.Entities;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace Appoynt.Infrastructure.Persistence;

/// <summary>
/// Represents the application's primary Entity Framework Core database context.
/// </summary>
/// <remarks>
/// This context manages entity persistence, ASP.NET Core Identity integration,
/// auditing, soft-delete behavior, and database configurations.
/// </remarks>
public class ApplicationDbContext
    : IdentityDbContext<ApplicationUser, IdentityRole<Guid>, Guid>
{
    #region Dependencies

    /// <summary>
    /// Provides information about the currently authenticated user.
    /// </summary>
    private readonly ICurrentUserService _currentUserService;

    /// <summary>
    /// Provides the current UTC date and time.
    /// </summary>
    private readonly IDateTimeProvider _dateTimeProvider;

    #endregion

    #region Constructors

    /// <summary>
    /// Initializes a new instance of the <see cref="ApplicationDbContext"/> class.
    /// </summary>
    /// <param name="options">
    /// The Entity Framework Core database context options.
    /// </param>
    /// <param name="currentUserService">
    /// Provides information about the currently authenticated user.
    /// </param>
    /// <param name="dateTimeProvider">
    /// Provides the current UTC date and time.
    /// </param>
    public ApplicationDbContext(
        DbContextOptions<ApplicationDbContext> options,
        ICurrentUserService currentUserService,
        IDateTimeProvider dateTimeProvider)
        : base(options)
    {
        _currentUserService = currentUserService;
        _dateTimeProvider = dateTimeProvider;
    }

    #endregion

    #region DbSets

    /// <summary>
    /// Gets the doctors available in the system.
    /// </summary>
    public DbSet<Doctor> Doctors => Set<Doctor>();

    /// <summary>
    /// Gets the patients registered in the system.
    /// </summary>
    public DbSet<Patient> Patients => Set<Patient>();

    /// <summary>
    /// Gets the administrators of the system.
    /// </summary>
    public DbSet<Admin> Admins => Set<Admin>();

    /// <summary>
    /// Gets the receptionists assigned within the system.
    /// </summary>
    public DbSet<Receptionist> Receptionists => Set<Receptionist>();

    /// <summary>
    /// Gets the refresh tokens issued for application users.
    /// </summary>
    public DbSet<RefreshToken> RefreshTokens => Set<RefreshToken>();

    /// <summary>
    /// Gets the mobile one-time-password challenges issued to users.
    /// </summary>
    public DbSet<OtpChallenge> OtpChallenges => Set<OtpChallenge>();

    #endregion

    #region Model Configuration

    /// <summary>
    /// Configures the application's entity model and applies all
    /// Entity Framework Core configurations.
    /// </summary>
    /// <param name="modelBuilder">
    /// The builder used to configure the entity model.
    /// </param>
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Configure the ASP.NET Core Identity model.
        base.OnModelCreating(modelBuilder);

        // Automatically apply all IEntityTypeConfiguration
        // implementations from the current assembly.
        modelBuilder.ApplyConfigurationsFromAssembly(
            typeof(ApplicationDbContext).Assembly);
    }

    #endregion

    #region Save Changes

    /// <summary>
    /// Saves all changes made in this context after applying
    /// audit information and soft-delete processing.
    /// </summary>
    /// <returns>
    /// The number of state entries written to the database.
    /// </returns>
    public override int SaveChanges()
    {
        // Apply audit information and soft-delete rules
        // before persisting changes.
        PrepareEntitiesForSave();

        return base.SaveChanges();
    }

    /// <summary>
    /// Saves all changes made in this context after applying
    /// audit information and soft-delete processing.
    /// </summary>
    /// <param name="acceptAllChangesOnSuccess">
    /// Indicates whether <see cref="Microsoft.EntityFrameworkCore.ChangeTracking.ChangeTracker.AcceptAllChanges"/>
    /// is called after the changes have been successfully saved.
    /// </param>
    /// <returns>
    /// The number of state entries written to the database.
    /// </returns>
    public override int SaveChanges(bool acceptAllChangesOnSuccess)
    {
        // Apply audit information and soft-delete rules
        // before persisting changes.
        PrepareEntitiesForSave();

        return base.SaveChanges(acceptAllChangesOnSuccess);
    }

    /// <summary>
    /// Asynchronously saves all changes made in this context after applying
    /// audit information and soft-delete processing.
    /// </summary>
    /// <param name="cancellationToken">
    /// A token used to cancel the save operation.
    /// </param>
    /// <returns>
    /// A task representing the asynchronous save operation.
    /// </returns>
    public override async Task<int> SaveChangesAsync(
        CancellationToken cancellationToken = default)
    {
        // Apply audit information and soft-delete rules
        // before persisting changes.
        PrepareEntitiesForSave();

        return await base.SaveChangesAsync(cancellationToken);
    }

    /// <summary>
    /// Asynchronously saves all changes made in this context after applying
    /// audit information and soft-delete processing.
    /// </summary>
    /// <param name="acceptAllChangesOnSuccess">
    /// Indicates whether <see cref="Microsoft.EntityFrameworkCore.ChangeTracking.ChangeTracker.AcceptAllChanges"/>
    /// is called after the changes have been successfully saved.
    /// </param>
    /// <param name="cancellationToken">
    /// A token used to cancel the save operation.
    /// </param>
    /// <returns>
    /// A task representing the asynchronous save operation.
    /// </returns>
    public override async Task<int> SaveChangesAsync(
        bool acceptAllChangesOnSuccess,
        CancellationToken cancellationToken = default)
    {
        // Apply audit information and soft-delete rules
        // before persisting changes.
        PrepareEntitiesForSave();

        return await base.SaveChangesAsync(
            acceptAllChangesOnSuccess,
            cancellationToken);
    }

    #endregion

    #region Audit Preparation

    /// <summary>
    /// Prepares tracked entities before they are persisted by applying
    /// audit information and soft-delete rules.
    /// </summary>
    private void PrepareEntitiesForSave()
    {
        // Exit early when there are no tracked changes.
        if (!ChangeTracker.HasChanges())
        {
            return;
        }

        // Apply audit information to all tracked entities.
        ApplyAuditInformation();

        // Convert delete operations into soft-delete updates.
        ApplySoftDelete();
    }

    /// <summary>
    /// Applies audit information to all supported entity types.
    /// </summary>
    private void ApplyAuditInformation()
    {
        // Apply audit information to entities derived from BaseEntity.
        HandleBaseEntities();

        // Apply audit information to ApplicationUser entities.
        HandleApplicationUsers();
    }

    /// <summary>
    /// Retrieves the current audit context used during save operations.
    /// </summary>
    /// <returns>
    /// A tuple containing the current authenticated user's identifier
    /// and the current UTC date and time.
    /// </returns>
    private (Guid? CurrentUserId, DateTime UtcNow) GetAuditContext()
    {
        return (_currentUserService.UserId, _dateTimeProvider.UtcNow);
    }

    #endregion

    /// <summary>
    /// Applies audit information to all tracked entities that inherit from
    /// <see cref="BaseEntity"/>.
    /// </summary>
    private void HandleBaseEntities()
    {
        // Retrieve all tracked entities that inherit from BaseEntity.
        var entries = ChangeTracker.Entries<BaseEntity>();

        // Retrieve the current user identifier and UTC timestamp.
        var (currentUserId, utcNow) = GetAuditContext();

        // Process each tracked entity.
        foreach (var entry in entries)
        {
            // Skip entities that have not changed or are not tracked.
            if (entry.State is EntityState.Unchanged or EntityState.Detached)
            {
                continue;
            }

            switch (entry.State)
            {
                case EntityState.Added:

                    // Set creation audit information.
                    entry.Entity.CreatedAt = utcNow;
                    entry.Entity.CreatedById = currentUserId;

                    // Initialize the last update audit information
                    // with the same values as creation.
                    entry.Entity.UpdatedAt = utcNow;
                    entry.Entity.UpdatedById = currentUserId;

                    break;

                case EntityState.Modified:

                    // Prevent overwriting the original creation audit values.
                    entry.Property(entity => entity.CreatedAt).IsModified = false;
                    entry.Property(entity => entity.CreatedById).IsModified = false;

                    // Update the modification audit information.
                    entry.Entity.UpdatedAt = utcNow;
                    entry.Entity.UpdatedById = currentUserId;

                    break;

                default:

                    // Reject unsupported entity states to ensure
                    // audit consistency.
                    throw new InvalidOperationException(
                        $"Unsupported entity state: {entry.State}");
            }
        }
    }
    /// <summary>
    /// Applies audit information to all tracked
    /// <see cref="ApplicationUser"/> entities.
    /// </summary>
    private void HandleApplicationUsers()
    {
        // Retrieve all tracked ApplicationUser entities.
        var entries = ChangeTracker.Entries<ApplicationUser>();

        // Retrieve the current user identifier and UTC timestamp.
        var (currentUserId, utcNow) = GetAuditContext();

        // Process each tracked ApplicationUser entity.
        foreach (var entry in entries)
        {
            // Skip entities that have not changed or are not tracked.
            if (entry.State is EntityState.Unchanged or EntityState.Detached)
            {
                continue;
            }

            switch (entry.State)
            {
                case EntityState.Added:

                    // Set creation audit information.
                    entry.Entity.CreatedAt = utcNow;
                    entry.Entity.CreatedById = currentUserId;

                    // Initialize the last update audit information
                    // with the same values as creation.
                    entry.Entity.UpdatedAt = utcNow;
                    entry.Entity.UpdatedById = currentUserId;

                    break;

                case EntityState.Modified:

                    // Prevent overwriting the original creation audit values.
                    entry.Property(user => user.CreatedAt).IsModified = false;
                    entry.Property(user => user.CreatedById).IsModified = false;

                    // Update the modification audit information.
                    entry.Entity.UpdatedAt = utcNow;
                    entry.Entity.UpdatedById = currentUserId;

                    break;

                default:

                    // Reject unsupported entity states to ensure
                    // audit consistency.
                    throw new InvalidOperationException(
                        $"Unsupported entity state: {entry.State}");
            }
        }
    }

    #region Soft Delete

    /// <summary>
    /// Applies the soft-delete behavior to all supported entity types.
    /// </summary>
    private void ApplySoftDelete()
    {
        // Apply soft-delete behavior to entities derived from BaseEntity.
        HandleBaseEntitiesSoftDelete();

        // Apply soft-delete behavior to ApplicationUser entities.
        HandleApplicationUsersSoftDelete();
    }

    /// <summary>
    /// Converts delete operations for entities derived from
    /// <see cref="BaseEntity"/> into soft-delete updates.
    /// </summary>
    private void HandleBaseEntitiesSoftDelete()
    {
        // Retrieve the current user identifier and UTC timestamp.
        var (currentUserId, utcNow) = GetAuditContext();

        // Process all tracked BaseEntity instances.
        foreach (var entry in ChangeTracker.Entries<BaseEntity>())
        {
            // Skip entities that are not being deleted.
            if (entry.State != EntityState.Deleted)
            {
                continue;
            }

            // Convert the delete operation into an update.
            entry.State = EntityState.Modified;

            // Update the last modification audit information.
            entry.Entity.UpdatedAt = utcNow;
            entry.Entity.UpdatedById = currentUserId;

            // Record the soft-delete audit information.
            entry.Entity.DeletedAt = utcNow;
            entry.Entity.DeletedById = currentUserId;
        }
    }

    /// <summary>
    /// Converts delete operations for <see cref="ApplicationUser"/>
    /// entities into soft-delete updates.
    /// </summary>
    private void HandleApplicationUsersSoftDelete()
    {
        // Retrieve the current user identifier and UTC timestamp.
        var (currentUserId, utcNow) = GetAuditContext();

        // Process all tracked ApplicationUser entities.
        foreach (var entry in ChangeTracker.Entries<ApplicationUser>())
        {
            // Skip entities that are not being deleted.
            if (entry.State != EntityState.Deleted)
            {
                continue;
            }

            // Convert the delete operation into an update.
            entry.State = EntityState.Modified;

            // Mark the user account as inactive.
            entry.Entity.IsActive = false;

            // Update the last modification audit information.
            entry.Entity.UpdatedAt = utcNow;
            entry.Entity.UpdatedById = currentUserId;

            // Record the soft-delete audit information.
            entry.Entity.DeletedAt = utcNow;
            entry.Entity.DeletedById = currentUserId;
        }
    }
}

    #endregion
