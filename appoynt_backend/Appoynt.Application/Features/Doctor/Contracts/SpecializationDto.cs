/**
 * File Name      : SpecializationDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : System
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-23
 * Description    : Data transfer object for specialization in doctor profile.
 */

using System;

namespace Appoynt.Application.Features.Doctor.Contracts;

/// <summary>
/// Represents a doctor's specialization in the profile response.
/// </summary>
public class SpecializationDto
{
    /// <summary>
    /// Gets or sets the specialization identifier.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the specialization name in Arabic.
    /// </summary>
    public string NameAr { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the specialization name in English.
    /// </summary>
    public string NameEn { get; set; } = string.Empty;
}
