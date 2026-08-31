/**
 * File Name      : TestCategory.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Defines test classification categories for investigations.
 */

namespace Appoynt.Domain.Enums;

/// <summary>
/// Major medical investigation and diagnostic test categories.
/// </summary>
public enum TestCategory
{
    /// <summary>Clinical laboratory analyses (hematology, biochemistry, etc.).</summary>
    Laboratory = 1,

    /// <summary>Radiological imaging (X-Ray, CT, MRI, Ultrasound).</summary>
    RadiologyAndImaging = 2,

    /// <summary>Cardiology diagnostic tests (ECG, Echocardiogram, Stress Test).</summary>
    CardiologyDiagnostics = 3,

    /// <summary>Histopathology, biopsy, and cytopathology tests.</summary>
    PathologyAndBiopsy = 4
}
