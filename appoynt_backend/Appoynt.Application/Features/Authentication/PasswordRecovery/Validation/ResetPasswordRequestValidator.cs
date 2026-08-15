/**
 * File Name      : ResetPasswordRequestValidator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 27/07/2026
 * Version        : v1.0.0
 * Dependencies   : AuthenticationErrorCodes, AuthenticationError, ResetPasswordRequest
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 27/07/2026
 * Description    : Validates the reset password request payload, maintaining the same
 *                  strict password policies used during registration.
 */

using System.Text;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Models;
using Appoynt.Application.Features.Authentication.PasswordRecovery.Contracts;
using Appoynt.Domain.Entities;

namespace Appoynt.Application.Features.Authentication.PasswordRecovery.Validation;

/// <summary>
/// Validates reset password requests.
/// </summary>
public static class ResetPasswordRequestValidator
{
    private const int PasswordMinimumLength = 8;

    /// <summary>
    /// Validates the reset password request.
    /// </summary>
    /// <param name="request">The request to validate.</param>
    /// <param name="user">The user entity used to check for personal information in the password.</param>
    /// <returns>A list of validation errors, if any.</returns>
    public static IReadOnlyList<AuthenticationError> Validate(ResetPasswordRequest request, ApplicationUser user)
    {
        ArgumentNullException.ThrowIfNull(request);
        ArgumentNullException.ThrowIfNull(user);

        var errors = new List<AuthenticationError>();

        if (string.IsNullOrWhiteSpace(request.Identifier))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PasswordRecoveryRequestInvalid,
                nameof(request.Identifier)));
            return errors; // Fast fail
        }
        else
        {
        }

        if (string.IsNullOrWhiteSpace(request.ResetToken))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PasswordRecoveryRequestInvalid,
                nameof(request.ResetToken)));
            return errors; // Fast fail
        }
        else
        {
        }

        AddPasswordError(errors, request, user);
        AddConfirmPasswordError(errors, request);

        return errors;
    }

    private static void AddPasswordError(
        ICollection<AuthenticationError> errors,
        ResetPasswordRequest request,
        ApplicationUser user)
    {
        string password = request.NewPassword;

        if (string.IsNullOrEmpty(password))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PasswordRequired,
                "NewPassword"));
            return;
        }
        else
        {
        }

        if (password.EnumerateRunes().Count() < PasswordMinimumLength)
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PasswordLengthInvalid,
                "NewPassword"));
            return;
        }
        else
        {
        }

        if (!HasRequiredPasswordComplexity(password))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PasswordComplexityInvalid,
                "NewPassword"));
            return;
        }
        else
        {
        }

        if (ContainsWhitespaceOrArabicCharacters(password))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PasswordInvalidCharacters,
                "NewPassword"));
            return;
        }
        else
        {
        }

        if (ContainsPersonalInformation(password, user))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PasswordContainsPersonalInformation,
                "NewPassword"));
        }
        else
        {
        }
    }

    private static void AddConfirmPasswordError(
        ICollection<AuthenticationError> errors,
        ResetPasswordRequest request)
    {
        if (string.IsNullOrEmpty(request.ConfirmPassword))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.ConfirmPasswordRequired,
                "ConfirmPassword"));
            return;
        }
        else
        {
        }

        if (!string.Equals(
                request.NewPassword,
                request.ConfirmPassword,
                StringComparison.Ordinal))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PasswordsDoNotMatch,
                "ConfirmPassword"));
        }
        else
        {
        }
    }

    private static bool HasRequiredPasswordComplexity(string password)
    {
        bool hasUppercase = false;
        bool hasLowercase = false;
        bool hasDigit = false;
        bool hasSpecialCharacter = false;

        foreach (Rune rune in password.EnumerateRunes())
        {
            hasUppercase |= Rune.IsUpper(rune);
            hasLowercase |= Rune.IsLower(rune);
            hasDigit |= Rune.IsDigit(rune);
            hasSpecialCharacter |= !Rune.IsLetter(rune) &&
                                   !Rune.IsDigit(rune) &&
                                   !Rune.IsWhiteSpace(rune);
        }

        return hasUppercase && hasLowercase && hasDigit && hasSpecialCharacter;
    }

    private static bool ContainsWhitespaceOrArabicCharacters(string password)
    {
        return password.EnumerateRunes().Any(rune =>
            Rune.IsWhiteSpace(rune) || IsArabicRune(rune));
    }

    private static bool ContainsPersonalInformation(string password, ApplicationUser user)
    {
        return Contains(password, user.FirstName) ||
               Contains(password, user.LastName) ||
               Contains(password, user.Email);
    }

    private static bool Contains(string source, string? value)
    {
        return !string.IsNullOrEmpty(value) &&
               source.Contains(value, StringComparison.OrdinalIgnoreCase);
    }

    private static bool IsArabicRune(Rune rune)
    {
        int value = rune.Value;

        return value is >= 0x0600 and <= 0x06FF ||
               value is >= 0x0750 and <= 0x077F ||
               value is >= 0x08A0 and <= 0x08FF ||
               value is >= 0xFB50 and <= 0xFDFF ||
               value is >= 0xFE70 and <= 0xFEFF;
    }
}
