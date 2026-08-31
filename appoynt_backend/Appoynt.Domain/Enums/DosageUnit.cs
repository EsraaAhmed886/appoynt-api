/**
 * File Name      : DosageUnit.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Defines standard managed clinical measurement units for medication dosage.
 */

namespace Appoynt.Domain.Enums;

/// <summary>
/// Managed standard dosage units for medication prescribing.
/// </summary>
public enum DosageUnit
{
    /// <summary>Milligrams (mg).</summary>
    Mg = 1,

    /// <summary>Grams (g).</summary>
    G = 2,

    /// <summary>Micrograms (mcg).</summary>
    Mcg = 3,

    /// <summary>Milliliters (mL).</summary>
    Ml = 4,

    /// <summary>Liters (L).</summary>
    L = 5,

    /// <summary>Tablet unit.</summary>
    Tablet = 6,

    /// <summary>Capsule unit.</summary>
    Capsule = 7,

    /// <summary>Drop unit.</summary>
    Drop = 8,

    /// <summary>Puff unit.</summary>
    Puff = 9,

    /// <summary>International or standard biological unit (IU/Unit).</summary>
    Unit = 10,

    /// <summary>Sachet unit.</summary>
    Sachet = 11
}
