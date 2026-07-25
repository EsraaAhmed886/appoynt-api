/**
 * File Name      : RegistrationValidator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : AuthenticationErrorCodes, AuthenticationError,
 *                  NormalizedRegisterRequest
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Validates normalized patient registration input according
 *                  to the approved input field requirements.
 */

using System.ComponentModel.DataAnnotations;
using System.Text;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Common.Models;

namespace Appoynt.Application.Features.Authentication.Registration.Validation;

/// <summary>
/// Validates normalized registration input using the approved backend rules.
/// </summary>
public static class RegistrationValidator
{
    private const int NameMinimumLength = 2;
    private const int NameMaximumLength = 50;
    private const int PhoneNumberLength = 11;
    private const int PasswordMinimumLength = 8;

    /// <summary>
    /// Validates normalized registration input and returns at most one error
    /// for each request field, in the approved per-field priority order.
    /// </summary>
    /// <param name="request">The normalized registration input.</param>
    /// <returns>The validation errors, if any.</returns>
    public static IReadOnlyList<AuthenticationError> Validate(
        NormalizedRegisterRequest request)
    {
        ArgumentNullException.ThrowIfNull(request);

        var errors = new List<AuthenticationError>();

        AddNameError(
            errors,
            request.FirstName,
            "FirstName",
            AuthenticationErrorCodes.FirstNameRequired,
            AuthenticationErrorCodes.FirstNameLengthInvalid,
            AuthenticationErrorCodes.FirstNameInvalidCharacters);

        AddNameError(
            errors,
            request.LastName,
            "LastName",
            AuthenticationErrorCodes.LastNameRequired,
            AuthenticationErrorCodes.LastNameLengthInvalid,
            AuthenticationErrorCodes.LastNameInvalidCharacters);

        AddPhoneError(errors, request);
        AddEmailError(errors, request.Email);
        AddPasswordError(errors, request);
        AddConfirmPasswordError(errors, request);

        return errors;
    }

    /// <summary>
    /// Validates a normalized name according to the required-empty-length-
    /// character priority.
    /// </summary>
    private static void AddNameError(
        ICollection<AuthenticationError> errors,
        string name,
        string field,
        string requiredCode,
        string lengthCode,
        string invalidCharactersCode)
    {
        if (string.IsNullOrEmpty(name))
        {
            errors.Add(new AuthenticationError(requiredCode, field));
            return;
        }

        int runeCount = name.EnumerateRunes().Count();

        if (runeCount is < NameMinimumLength or > NameMaximumLength)
        {
            errors.Add(new AuthenticationError(lengthCode, field));
            return;
        }

        if (name.EnumerateRunes().Any(rune => !Rune.IsLetter(rune)))
        {
            errors.Add(new AuthenticationError(invalidCharactersCode, field));
        }
    }

    /// <summary>
    /// Validates a normalized Egyptian mobile phone number according to the
    /// required-length-prefix-third-digit-format priority.
    /// </summary>
    private static void AddPhoneError(
        ICollection<AuthenticationError> errors,
        NormalizedRegisterRequest request)
    {
        string phoneNumber = request.PhoneNumber;

        if (string.IsNullOrEmpty(phoneNumber))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PhoneRequired,
                "PhoneNumber"));
            return;
        }

        if (phoneNumber.Length != PhoneNumberLength)
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PhoneLengthInvalid,
                "PhoneNumber"));
            return;
        }

        if (!phoneNumber.StartsWith("01", StringComparison.Ordinal))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PhonePrefixInvalid,
                "PhoneNumber"));
            return;
        }

        if (phoneNumber[2] is not ('0' or '1' or '2' or '5'))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PhoneThirdDigitInvalid,
                "PhoneNumber"));
            return;
        }

        if (request.PhoneNumberContainsUnsupportedCharacters ||
            phoneNumber.Any(character => character is < '0' or > '9'))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PhoneFormatInvalid,
                "PhoneNumber"));
        }
    }

    /// <summary>
    /// Validates a normalized email address according to the required-format
    /// priority.
    /// </summary>
    private static void AddEmailError(
        ICollection<AuthenticationError> errors,
        string email)
    {
        if (string.IsNullOrEmpty(email))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.EmailRequired,
                "Email"));
            return;
        }

        if (!new EmailAddressAttribute().IsValid(email))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.EmailInvalid,
                "Email"));
        }
    }

    /// <summary>
    /// Validates a password according to the required-length-complexity-
    /// content priority. Repeated-character and sequential-pattern rules are
    /// intentionally deferred because their thresholds are not defined.
    /// </summary>
    private static void AddPasswordError(
        ICollection<AuthenticationError> errors,
        NormalizedRegisterRequest request)
    {
        string password = request.Password;

        if (string.IsNullOrEmpty(password))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PasswordRequired,
                "Password"));
            return;
        }

        if (password.EnumerateRunes().Count() < PasswordMinimumLength)
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PasswordLengthInvalid,
                "Password"));
            return;
        }

        if (!HasRequiredPasswordComplexity(password))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PasswordComplexityInvalid,
                "Password"));
            return;
        }

        if (ContainsWhitespaceOrArabicCharacters(password))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PasswordInvalidCharacters,
                "Password"));
            return;
        }

        if (ContainsPersonalInformation(password, request))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PasswordContainsPersonalInformation,
                "Password"));
        }
    }

    /// <summary>
    /// Validates the password confirmation according to the required-match
    /// priority.
    /// </summary>
    private static void AddConfirmPasswordError(
        ICollection<AuthenticationError> errors,
        NormalizedRegisterRequest request)
    {
        if (string.IsNullOrEmpty(request.ConfirmPassword))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.ConfirmPasswordRequired,
                "ConfirmPassword"));
            return;
        }

        if (!string.Equals(
                request.Password,
                request.ConfirmPassword,
                StringComparison.Ordinal))
        {
            errors.Add(new AuthenticationError(
                AuthenticationErrorCodes.PasswordsDoNotMatch,
                "ConfirmPassword"));
        }
    }

    /// <summary>
    /// Determines whether the password contains all required character types.
    /// A special character is a non-letter, non-digit, non-whitespace Unicode
    /// character, matching the approved ASP.NET Core Identity definition.
    /// </summary>
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

    /// <summary>
    /// Determines whether a password contains whitespace or Arabic characters.
    /// </summary>
    private static bool ContainsWhitespaceOrArabicCharacters(string password)
    {
        return password.EnumerateRunes().Any(rune =>
            Rune.IsWhiteSpace(rune) || IsArabicRune(rune));
    }

    /// <summary>
    /// Determines whether a password contains submitted personal information.
    /// </summary>
    private static bool ContainsPersonalInformation(
        string password,
        NormalizedRegisterRequest request)
    {
        return Contains(password, request.FirstName) ||
               Contains(password, request.LastName) ||
               Contains(password, request.Email);
    }

    /// <summary>
    /// Determines whether a source contains a non-empty value without regard
    /// to case.
    /// </summary>
    private static bool Contains(string source, string value)
    {
        return !string.IsNullOrEmpty(value) &&
               source.Contains(value, StringComparison.OrdinalIgnoreCase);
    }

    /// <summary>
    /// Determines whether a rune belongs to an Arabic Unicode block.
    /// </summary>
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
