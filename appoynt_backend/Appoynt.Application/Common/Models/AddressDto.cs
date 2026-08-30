/**
 * File Name      : AddressDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-30
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-30
 * Description    : DTO representing a user's location/address details.
 */

using System;

namespace Appoynt.Application.Common.Models;

/// <summary>
/// Represents the location details of a user.
/// </summary>
public sealed class AddressDto
{
    public Guid? GovernorateId { get; init; }
    public string? GovernorateNameAr { get; init; }
    public string? GovernorateNameEn { get; init; }

    public Guid? CityId { get; init; }
    public string? CityNameAr { get; init; }
    public string? CityNameEn { get; init; }
}
