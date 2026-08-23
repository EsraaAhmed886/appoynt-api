/**
 * File Name      : DoctorOptions.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Represents the default doctor account configuration loaded from appsettings.json.
 */

namespace Appoynt.Infrastructure.Options;

/// <summary>
/// Represents the default doctor seed configuration.
/// </summary>
public sealed class DoctorOptions
{
    /// <summary>
    /// Gets or sets the doctor first name.
    /// </summary>
    public string FirstName { get; init; } = "Mohamed";

    /// <summary>
    /// Gets or sets the doctor last name.
    /// </summary>
    public string LastName { get; init; } = "Ali";

    /// <summary>
    /// Gets or sets the doctor full display name in Arabic.
    /// </summary>
    public string NameAr { get; init; } = "د. محمد علي";

    /// <summary>
    /// Gets or sets the doctor full display name in English.
    /// </summary>
    public string NameEn { get; init; } = "Dr. Mohamed Ali";

    /// <summary>
    /// Gets or sets the doctor professional biography.
    /// </summary>
    public string Bio { get; init; } = "استشاري طب وجراحة القلب والأوعية الدموية.";

    /// <summary>
    /// Gets or sets the doctor education details.
    /// </summary>
    public string Education { get; init; } = "دكتوراه في أمراض القلب والأوعية الدموية - كلية الطب جامعة القاهرة.";

    /// <summary>
    /// Gets or sets the doctor email address.
    /// </summary>
    public string Email { get; init; } = "doctor@appoynt.com";

    /// <summary>
    /// Gets or sets the doctor phone number.
    /// </summary>
    public string PhoneNumber { get; init; } = "01000000001";

    /// <summary>
    /// Gets or sets the doctor account password.
    /// </summary>
    public string Password { get; init; } = "Password123!";

    /// <summary>
    /// Gets or sets the primary specialization name in English to assign to the doctor.
    /// </summary>
    public string SpecializationNameEn { get; init; } = "Cardiology";
}
