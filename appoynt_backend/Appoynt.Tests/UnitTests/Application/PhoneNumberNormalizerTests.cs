using Appoynt.Application.Common.Validation;
using FluentAssertions;

namespace Appoynt.Tests.UnitTests.Application;

/// <summary>
/// Tests the shared Egyptian mobile-number normalization rules.
/// </summary>
public sealed class PhoneNumberNormalizerTests
{
    [Theory]
    [InlineData("01012345678", "01012345678")]
    [InlineData("+20 10 1234 5678", "01012345678")]
    [InlineData("00201012345678", "01012345678")]
    [InlineData("٢٠١٠١٢٣٤٥٦٧٨", "01012345678")]
    public void Normalize_ShouldReturnCanonicalEgyptianNumber(
        string input,
        string expected)
    {
        PhoneNumberNormalizationResult result = PhoneNumberNormalizer.Normalize(input);

        result.PhoneNumber.Should().Be(expected);
        result.ContainsUnsupportedCharacters.Should().BeFalse();
    }

    [Fact]
    public void Normalize_ShouldFlagUnsupportedAlphabeticCharacters()
    {
        PhoneNumberNormalizationResult result =
            PhoneNumberNormalizer.Normalize("01012abc5678");

        result.ContainsUnsupportedCharacters.Should().BeTrue();
    }
}
