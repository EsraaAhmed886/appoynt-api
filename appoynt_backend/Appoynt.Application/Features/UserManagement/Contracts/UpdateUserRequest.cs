/**
 * File Name      : UpdateUserRequest.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 28/07/2026
 * Version        : v1.0.0
 * Dependencies   : Gender
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 28/07/2026
 * Description    : Payload for updating basic user information.
 */

using Appoynt.Domain.Enums;

namespace Appoynt.Application.Features.UserManagement.Contracts;

public sealed class UpdateUserRequest
{
    public string? FirstName { get; init; }
    public string? LastName { get; init; }
    public Gender? Gender { get; init; }
    public DateOnly? DateOfBirth { get; init; }
    public string? Address { get; init; }
}
