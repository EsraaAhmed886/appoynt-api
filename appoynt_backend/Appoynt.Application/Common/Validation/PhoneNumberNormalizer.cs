/**
 * File Name      : PhoneNumberNormalizer.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 24/07/2026
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 24/07/2026
 * Description    : Provides deterministic normalization for supported Egyptian
 *                  mobile phone-number input.
 */

using System.Globalization;
using System.Text;

namespace Appoynt.Application.Common.Validation;

/// <summary>
/// Provides deterministic normalization for supported Egyptian mobile
/// phone-number input.
/// </summary>
public static class PhoneNumberNormalizer
{
    /// <summary>
    /// Converts supported Arabic numerals to ASCII digits, removes permitted
    /// separator symbols and country-code prefixes, and reports unsupported
    /// input for the validation stage to reject.
    /// </summary>
    /// <param name="phoneNumber">The submitted phone number.</param>
    /// <returns>The canonical phone-number normalization result.</returns>
    public static PhoneNumberNormalizationResult Normalize(string? phoneNumber)
    {
        if (string.IsNullOrEmpty(phoneNumber))
        {
            return new PhoneNumberNormalizationResult(string.Empty, false);
        }

        var digits = new StringBuilder(phoneNumber.Length);
        bool containsUnsupportedCharacters = false;

        foreach (Rune rune in phoneNumber.EnumerateRunes())
        {
            if (TryConvertToAsciiDigit(rune, out char digit))
            {
                digits.Append(digit);
                continue;
            }

            UnicodeCategory category = Rune.GetUnicodeCategory(rune);

            if (Rune.IsWhiteSpace(rune) ||
                category is UnicodeCategory.Format or UnicodeCategory.ConnectorPunctuation
                    or UnicodeCategory.DashPunctuation or UnicodeCategory.OpenPunctuation
                    or UnicodeCategory.ClosePunctuation or UnicodeCategory.InitialQuotePunctuation
                    or UnicodeCategory.FinalQuotePunctuation or UnicodeCategory.OtherPunctuation
                    or UnicodeCategory.MathSymbol or UnicodeCategory.CurrencySymbol
                    or UnicodeCategory.ModifierSymbol or UnicodeCategory.OtherSymbol)
            {
                continue;
            }

            containsUnsupportedCharacters = true;
        }

        string normalizedPhoneNumber = digits.ToString();

        if (normalizedPhoneNumber.StartsWith("0020", StringComparison.Ordinal))
        {
            normalizedPhoneNumber = $"0{normalizedPhoneNumber[4..]}";
        }
        else if (normalizedPhoneNumber.StartsWith("20", StringComparison.Ordinal))
        {
            normalizedPhoneNumber = $"0{normalizedPhoneNumber[2..]}";
        }

        return new PhoneNumberNormalizationResult(
            normalizedPhoneNumber,
            containsUnsupportedCharacters);
    }

    /// <summary>
    /// Converts supported ASCII and Arabic numeral forms to an ASCII digit.
    /// </summary>
    /// <param name="rune">The rune to convert.</param>
    /// <param name="digit">The converted ASCII digit.</param>
    /// <returns><see langword="true"/> when the rune is a supported digit.</returns>
    private static bool TryConvertToAsciiDigit(Rune rune, out char digit)
    {
        int value = rune.Value;

        if (value is >= '0' and <= '9')
        {
            digit = (char)value;
            return true;
        }

        if (value is >= 0x0660 and <= 0x0669)
        {
            digit = (char)('0' + value - 0x0660);
            return true;
        }

        if (value is >= 0x06F0 and <= 0x06F9)
        {
            digit = (char)('0' + value - 0x06F0);
            return true;
        }

        digit = default;
        return false;
    }
}

/// <summary>
/// Represents the canonical result of normalizing a submitted phone number.
/// </summary>
/// <param name="phoneNumber">The canonical normalized phone number.</param>
/// <param name="containsUnsupportedCharacters">
/// Indicates whether the original input included characters that are not
/// supported by the approved phone-input sanitization rules.
/// </param>
public sealed class PhoneNumberNormalizationResult(
    string phoneNumber,
    bool containsUnsupportedCharacters)
{
    /// <summary>
    /// Gets the canonical normalized phone number.
    /// </summary>
    public string PhoneNumber { get; } = phoneNumber;

    /// <summary>
    /// Gets a value indicating whether the original input included unsupported
    /// characters.
    /// </summary>
    public bool ContainsUnsupportedCharacters { get; } =
        containsUnsupportedCharacters;
}
