/**
 * File Name      : CreateDoctorRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : DoctorPhoneNumberDto
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Defines the contract for creating a doctor account with profile,
 *                  contact numbers, and specializations.
 */

using System;
using System.Collections.Generic;

namespace Appoynt.Application.Features.UserManagement.Contracts;

/// <summary>
/// Represents the input submitted to create a doctor account.
/// </summary>
public sealed class CreateDoctorRequest
{
    #region Identity Properties

    /// <summary>
    /// Gets or initializes the first name of the user.
    /// </summary>
    public string? FirstName { get; init; }

    /// <summary>
    /// Gets or initializes the last name of the user.
    /// </summary>
    public string? LastName { get; init; }

    /// <summary>
    /// Gets or initializes the mobile phone number for user authentication.
    /// </summary>
    public string? PhoneNumber { get; init; }

    /// <summary>
    /// Gets or initializes the email address for user authentication.
    /// </summary>
    public string? Email { get; init; }

    /// <summary>
    /// Gets or initializes the account password.
    /// </summary>
    public string? Password { get; init; }

    #endregion

    #region Doctor Profile Properties

    /// <summary>
    /// Gets or initializes the doctor's Arabic display name (required).
    /// </summary>
    public string? NameAr { get; init; }

    /// <summary>
    /// Gets or initializes the doctor's English display name (required).
    /// </summary>
    public string? NameEn { get; init; }

    /// <summary>
    /// Gets or initializes the doctor's professional biography (optional).
    /// </summary>
    public string? Bio { get; init; }

    /// <summary>
    /// Gets or initializes the doctor's education and qualifications summary (optional).
    /// </summary>
    public string? Education { get; init; }

    #endregion

    #region Relationship Properties

    /// <summary>
    /// Gets or initializes the list of specialization identifiers to associate with the doctor (optional).
    /// </summary>
    public List<Guid>? SpecializationIds { get; init; }

    /// <summary>
    /// Gets or initializes the list of additional contact phone numbers for the doctor (optional, maximum 5).
    /// </summary>
    public List<DoctorPhoneNumberDto>? PhoneNumbers { get; init; }

    #endregion
}
