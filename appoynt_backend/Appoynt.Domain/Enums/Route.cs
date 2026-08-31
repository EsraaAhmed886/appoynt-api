/**
 * File Name      : Route.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Defines standard medication administration routes.
 */

namespace Appoynt.Domain.Enums;

/// <summary>
/// Clinical routes of medication administration.
/// </summary>
public enum Route
{
    /// <summary>Oral administration by mouth (PO).</summary>
    Oral = 1,

    /// <summary>Intravenous injection or infusion (IV).</summary>
    Intravenous = 2,

    /// <summary>Intramuscular injection (IM).</summary>
    Intramuscular = 3,

    /// <summary>Subcutaneous injection (SC).</summary>
    Subcutaneous = 4,

    /// <summary>Topical application on skin or mucous membrane.</summary>
    Topical = 5,

    /// <summary>Inhalation via respiratory tract.</summary>
    Inhalation = 6,

    /// <summary>Rectal administration (PR).</summary>
    Rectal = 7,

    /// <summary>Vaginal administration (PV).</summary>
    Vaginal = 8,

    /// <summary>Ophthalmic application to the eyes.</summary>
    Ophthalmic = 9,

    /// <summary>Otic application to the ears.</summary>
    Otic = 10,

    /// <summary>Nasal spray or drops.</summary>
    Nasal = 11,

    /// <summary>Sublingual administration under the tongue (SL).</summary>
    Sublingual = 12,

    /// <summary>Transdermal patch absorption.</summary>
    Transdermal = 13
}
