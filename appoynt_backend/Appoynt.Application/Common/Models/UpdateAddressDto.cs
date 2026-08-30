/**
 * File Name      : UpdateAddressDto.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-30
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-30
 * Description    : DTO representing the inputs for updating a user's location/address.
 */

using System;

namespace Appoynt.Application.Common.Models;

/// <summary>
/// Inputs for updating a user's location details.
/// </summary>
public sealed class UpdateAddressDto
{
    public Guid? GovernorateId { get; init; }
    public Guid? CityId { get; init; }
}
