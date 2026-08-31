/**
 * File Name      : ApplicationDbContext.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v1.0.0
 * Dependencies   : Entity Framework Core, ASP.NET Core Identity,
 *                  ICurrentUserService, IDateTimeProvider,
 *                  ApplicationUser, BaseEntity, OtpChallenge
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
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

    /// <summary>
    /// Gets the audit logs for system modifications.
    /// </summary>
    public DbSet<AuditLog> AuditLogs => Set<AuditLog>();

    /// <summary>
    /// Gets the family members linked to patient accounts.
    /// </summary>
    public DbSet<FamilyMember> FamilyMembers => Set<FamilyMember>();

    /// <summary>
    /// Gets the additional contact phone numbers for doctors.
    /// </summary>
    public DbSet<DoctorPhoneNumber> DoctorPhoneNumbers => Set<DoctorPhoneNumber>();

    /// <summary>
    /// Gets the medical specializations registered in the system.
    /// </summary>
    public DbSet<Specialization> Specializations => Set<Specialization>();

    /// <summary>
    /// Gets the doctor-specialization join entries.
    /// </summary>
    public DbSet<DoctorSpecialization> DoctorSpecializations => Set<DoctorSpecialization>();

    /// <summary>
    /// Gets the governorates available in the system.
    /// </summary>
    public DbSet<Governorate> Governorates => Set<Governorate>();

    /// <summary>
    /// Gets the cities available in the system.
    /// </summary>
    public DbSet<City> Cities => Set<City>();

    /// <summary>
    /// Gets the clinics registered in the system.
    /// </summary>
    public DbSet<Clinic> Clinics => Set<Clinic>();

    /// <summary>
    /// Gets the additional contact phone numbers for clinics.
    /// </summary>
    public DbSet<ClinicPhoneNumber> ClinicPhoneNumbers => Set<ClinicPhoneNumber>();

    /// <summary>
    /// Gets the working periods for clinics.
    /// </summary>
    public DbSet<ClinicWorkingPeriod> ClinicWorkingPeriods => Set<ClinicWorkingPeriod>();

    /// <summary>
    /// Gets the breaks during clinic working periods.
    /// </summary>
    public DbSet<ClinicBreak> ClinicBreaks => Set<ClinicBreak>();

    /// <summary>
    /// Gets the appointment slots for clinics.
    /// </summary>
    public DbSet<AppointmentSlot> AppointmentSlots => Set<AppointmentSlot>();

    /// <summary>
    /// Gets the confirmed patient appointments.
    /// </summary>
    public DbSet<Appointment> Appointments => Set<Appointment>();

    /// <summary>
    /// Gets the clinic-receptionist join entries.
    /// </summary>
    public DbSet<ClinicReceptionist> ClinicReceptionists => Set<ClinicReceptionist>();

    /// <summary>
    /// Gets the patient-doctor favorite entries.
    /// </summary>
    public DbSet<PatientFavoriteDoctor> PatientFavoriteDoctors => Set<PatientFavoriteDoctor>();

    /// <summary>
    /// Gets the patient-clinic favorite entries.
    /// </summary>
    public DbSet<PatientFavoriteClinic> PatientFavoriteClinics => Set<PatientFavoriteClinic>();

    /// <summary>
    /// Gets the global standard ICD-10 diagnoses catalog.
    /// </summary>
    public DbSet<Diagnosis> Diagnoses => Set<Diagnosis>();

    /// <summary>
    /// Gets the global standardized medications catalog.
    /// </summary>
    public DbSet<Medication> Medications => Set<Medication>();

    /// <summary>
    /// Gets the global diagnostic and laboratory test catalog.
    /// </summary>
    public DbSet<TestCatalog> TestCatalogs => Set<TestCatalog>();

    /// <summary>
    /// Gets the doctor-submitted custom medication requests.
    /// </summary>
    public DbSet<CustomMedicationRequest> CustomMedicationRequests => Set<CustomMedicationRequest>();

    /// <summary>
    /// Gets the electronic medical records created for consultations.
    /// </summary>
    public DbSet<MedicalRecord> MedicalRecords => Set<MedicalRecord>();

    /// <summary>
    /// Gets the diagnoses recorded on medical records.
    /// </summary>
    public DbSet<MedicalRecordDiagnosis> MedicalRecordDiagnoses => Set<MedicalRecordDiagnosis>();

    /// <summary>
    /// Gets the medications prescribed on medical records.
    /// </summary>
    public DbSet<MedicalRecordMedication> MedicalRecordMedications => Set<MedicalRecordMedication>();

    /// <summary>
    /// Gets the diagnostic and laboratory tests requested on medical records.
    /// </summary>
    public DbSet<MedicalRecordTestRequest> MedicalRecordTestRequests => Set<MedicalRecordTestRequest>();

    /// <summary>
    /// Gets the file attachments and documents linked to medical records.
    /// </summary>
    public DbSet<MedicalRecordAttachment> MedicalRecordAttachments => Set<MedicalRecordAttachment>();

    /// <summary>
    /// Gets the audit change log history of post-finalization edits.
    /// </summary>
    public DbSet<MedicalRecordChangeLog> MedicalRecordChangeLogs => Set<MedicalRecordChangeLog>();

    /// <summary>
    /// Gets the allergy alerts recorded for patients.
    /// </summary>
    public DbSet<PatientAllergy> PatientAllergies => Set<PatientAllergy>();

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

        // Prepare audit entries before saving.
        var auditEntries = OnBeforeSaveChanges();

        int result = base.SaveChanges();

        // Save audit entries that had temporary properties after the initial save.
        OnAfterSaveChanges(auditEntries);

        return result;
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

        // Prepare audit entries before saving.
        var auditEntries = OnBeforeSaveChanges();

        int result = base.SaveChanges(acceptAllChangesOnSuccess);

        // Save audit entries that had temporary properties after the initial save.
        OnAfterSaveChanges(auditEntries);

        return result;
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

        // Prepare audit entries before saving.
        var auditEntries = OnBeforeSaveChanges();

        int result = await base.SaveChangesAsync(cancellationToken);

        // Save audit entries that had temporary properties after the initial save.
        await OnAfterSaveChangesAsync(auditEntries, cancellationToken);

        return result;
    }

    private void PrepareEntitiesForSave()
    {
        if (!ChangeTracker.HasChanges())
        {
            return;
        }
        else
        {
        }

        // Convert delete operations into soft-delete updates.
        ApplySoftDelete();

        // Apply audit information to all tracked entities.
        ApplyAuditInformation();
    }

    private void ApplyAuditInformation()
    {
        // Apply audit information to entities derived from BaseEntity.
        HandleBaseEntities();

        // Apply audit information to ApplicationUser entities.
        HandleApplicationUsers();
    }

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
            else
            {
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
            else
            {
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
            else
            {
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
            else
            {
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

    #endregion

    #region Audit Logs

    private List<AuditEntry> OnBeforeSaveChanges()
    {
        var (currentUserId, utcNow) = GetAuditContext();
        ChangeTracker.DetectChanges();
        var auditEntries = new List<AuditEntry>();

        foreach (var entry in ChangeTracker.Entries())
        {
            if (entry.Entity is AuditLog || entry.State == EntityState.Detached || entry.State == EntityState.Unchanged)
            {
                continue;
            }
            else
            {
            }

            // Exclude noise/temporary entities
            if (entry.Entity is OtpChallenge || entry.Entity is RefreshToken)
            {
                continue;
            }
            else
            {
            }

            var auditEntry = new AuditEntry(entry)
            {
                TableName = entry.Metadata.GetTableName() ?? entry.Metadata.Name,
                UserId = currentUserId,
                DateTimeOffset = utcNow,
                AuditType = entry.State switch
                {
                    EntityState.Added => Appoynt.Domain.Enums.AuditType.Create,
                    EntityState.Modified => Appoynt.Domain.Enums.AuditType.Update,
                    EntityState.Deleted => Appoynt.Domain.Enums.AuditType.Delete,
                    _ => Appoynt.Domain.Enums.AuditType.None
                }
            };

            auditEntries.Add(auditEntry);

            foreach (var property in entry.Properties)
            {
                if (property.IsTemporary)
                {
                    auditEntry.TemporaryProperties.Add(property);
                    continue;
                }
                else
                {
                }

                string propertyName = property.Metadata.Name;

                if (property.Metadata.IsPrimaryKey())
                {
                    auditEntry.KeyValues[propertyName] = property.CurrentValue;
                    continue;
                }
                else
                {
                }

                // Exclude sensitive properties
                if (IsSensitiveProperty(propertyName))
                {
                    continue;
                }
                else
                {
                }

                switch (entry.State)
                {
                    case EntityState.Added:
                        auditEntry.NewValues[propertyName] = property.CurrentValue;
                        break;
                    case EntityState.Deleted:
                        auditEntry.OldValues[propertyName] = property.OriginalValue;
                        break;
                    case EntityState.Modified:
                        if (property.IsModified)
                        {
                            auditEntry.ChangedColumns.Add(propertyName);
                            auditEntry.OldValues[propertyName] = property.OriginalValue;
                            auditEntry.NewValues[propertyName] = property.CurrentValue;
                        }
                        else
                        {
                        }
                        break;
                    default:
                        break;
                }
            }
        }

        foreach (var auditEntry in auditEntries.Where(a => !a.HasTemporaryProperties))
        {
            AuditLogs.Add(auditEntry.ToAuditLog());
        }

        return auditEntries.Where(a => a.HasTemporaryProperties).ToList();
    }

    private void OnAfterSaveChanges(List<AuditEntry> auditEntries)
    {
        if (auditEntries == null || auditEntries.Count == 0)
        {
            return;
        }
        else
        {
        }

        foreach (var auditEntry in auditEntries)
        {
            foreach (var prop in auditEntry.TemporaryProperties)
            {
                if (prop.Metadata.IsPrimaryKey())
                {
                    auditEntry.KeyValues[prop.Metadata.Name] = prop.CurrentValue;
                }
                else
                {
                    auditEntry.NewValues[prop.Metadata.Name] = prop.CurrentValue;
                }
            }

            AuditLogs.Add(auditEntry.ToAuditLog());
        }

        base.SaveChanges();
    }

    private async Task OnAfterSaveChangesAsync(List<AuditEntry> auditEntries, CancellationToken cancellationToken)
    {
        if (auditEntries == null || auditEntries.Count == 0)
        {
            return;
        }
        else
        {
        }

        foreach (var auditEntry in auditEntries)
        {
            foreach (var prop in auditEntry.TemporaryProperties)
            {
                if (prop.Metadata.IsPrimaryKey())
                {
                    auditEntry.KeyValues[prop.Metadata.Name] = prop.CurrentValue;
                }
                else
                {
                    auditEntry.NewValues[prop.Metadata.Name] = prop.CurrentValue;
                }
            }

            AuditLogs.Add(auditEntry.ToAuditLog());
        }

        await base.SaveChangesAsync(cancellationToken);
    }

    private static bool IsSensitiveProperty(string propertyName)
    {
        var sensitiveNames = new[] { "PasswordHash", "SecurityStamp", "ConcurrencyStamp" };
        return sensitiveNames.Contains(propertyName, StringComparer.OrdinalIgnoreCase);
    }

    #endregion

}
