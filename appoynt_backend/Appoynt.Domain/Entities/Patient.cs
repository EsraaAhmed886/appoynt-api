/**
 * File Name      : Patient.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 21/07/2026
 * Version        : v2.2.0
 * Dependencies   : BaseEntity, ApplicationUser, FamilyMember,
 *                  BloodGroup, SmokingStatus, PatientFavoriteDoctor, PatientFavoriteClinic
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-23
 * Description    : Represents a patient within the application, including
 *                  the Patient Identifier (PID), family association,
 *                  medical information, National ID, and favorites navigation.
 */

using Appoynt.Domain.Common;
using Appoynt.Domain.Enums;

namespace Appoynt.Domain.Entities;

/// <summary>
/// Represents a patient in the system.
/// </summary>
public class Patient : BaseEntity
{
    #region Identity Properties

    /// <summary>
    /// Gets or sets the Patient Identifier (PID).
    /// Format: 7-digit family number + relationship code + sequence digit.
    /// Example: 1234567U0.
    /// </summary>
    public string PID { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the 7-digit family number shared by all family members.
    /// </summary>
    public string FamilyNumber { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the Egyptian National ID number (14 digits).
    /// </summary>
    public string? NationalId { get; set; }

    #endregion

    #region Medical Properties

    /// <summary>
    /// Gets or sets the patient's date of birth, derived from the National ID.
    /// </summary>
    public DateOnly? BirthDate { get; set; }

    /// <summary>
    /// Gets or sets the patient's weight in kilograms.
    /// </summary>
    public decimal? WeightKg { get; set; }

    /// <summary>
    /// Gets or sets the patient's height in centimeters.
    /// </summary>
    public decimal? HeightCm { get; set; }

    /// <summary>
    /// Gets or sets the patient's blood group.
    /// </summary>
    public BloodGroup? BloodGroup { get; set; }

    /// <summary>
    /// Gets or sets the patient's smoking status.
    /// </summary>
    public SmokingStatus? SmokingStatus { get; set; }

    #endregion

    #region Relationship Properties

    /// <summary>
    /// Gets or sets the foreign key referencing the associated application user.
    /// </summary>
    public Guid UserId { get; set; }

    /// <summary>
    /// Gets or sets the navigation property to the associated application user.
    /// </summary>
    public required ApplicationUser User { get; set; }

    /// <summary>
    /// Gets or sets the collection of family members linked to this patient.
    /// </summary>
    public ICollection<FamilyMember> FamilyMembers { get; set; } = [];

    /// <summary>
    /// Gets or sets the collection of favorite doctors linked to this patient.
    /// </summary>
    public ICollection<PatientFavoriteDoctor> FavoriteDoctors { get; set; } = [];

    /// <summary>
    /// Gets or sets the collection of favorite clinics linked to this patient.
    /// </summary>
    public ICollection<PatientFavoriteClinic> FavoriteClinics { get; set; } = [];

    #endregion
}