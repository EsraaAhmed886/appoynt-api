/**
 * File Name      : DomainConstantsBoundaryTests.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-24
 * Version        : v1.0.0
 * Dependencies   : PatientConstants, DoctorConstants, ClinicConstants,
 *                  UserConstants, ProfilePictureConstants, RoleConstants,
 *                  FamilyRelationship, PidGenerator, FluentAssertions
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-24
 * Description    : Boundary tests asserting that domain constants stay mutually
 *                  consistent (PID composition, photo extension allow-lists,
 *                  role registry completeness, OTP and lockout limits) so that a
 *                  silent constants drift fails the build instead of production.
 */

using System;
using System.Linq;
using Appoynt.Domain.Common.Constants;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Authentication.Patient;
using FluentAssertions;
using Xunit;

namespace Appoynt.Tests.UnitTests.Application;

/// <summary>
/// Boundary and consistency tests for shared domain constant classes.
/// </summary>
public class DomainConstantsBoundaryTests
{
    #region PID Constants

    /// <summary>
    /// The PID length must equal family number plus relationship code plus sequence digit.
    /// </summary>
    [Fact]
    public void PidLength_ShouldEqualFamilyNumberPlusCodeAndSequence()
    {
        // Assert the documented PID composition holds.
        PatientConstants.PidLength.Should().Be(PatientConstants.FamilyNumberLength + 2);
    }

    /// <summary>
    /// Family number bounds must both produce exactly seven-digit strings.
    /// </summary>
    [Fact]
    public void FamilyNumberBounds_ShouldProduceSevenDigitStrings()
    {
        // Assert both bounds render at the required length.
        PatientConstants.FamilyNumberMinValue.ToString().Should().HaveLength(PatientConstants.FamilyNumberLength);
        PatientConstants.FamilyNumberMaxValue.ToString().Should().HaveLength(PatientConstants.FamilyNumberLength);
    }

    /// <summary>
    /// A generated random family number must always fall within the configured bounds.
    /// </summary>
    [Fact]
    public void GeneratedFamilyNumbers_ShouldStayWithinConfiguredBounds()
    {
        // Arrange a deterministic random source for reproducibility.
        var random = new Random(20260824);

        // Act generating many samples to cover the range statistically.
        var samples = Enumerable.Range(0, 1000)
            .Select(_ => int.Parse(PidGenerator.GenerateRandomFamilyNumber(random)))
            .ToList();

        // Assert every sample respects min/max inclusive bounds.
        samples.Should().OnlyContain(n => n >= PatientConstants.FamilyNumberMinValue && n <= PatientConstants.FamilyNumberMaxValue);
    }

    /// <summary>
    /// The sequence space must allow ten members (zero through nine) per family.
    /// </summary>
    [Fact]
    public void MaxFamilyMemberSequence_ShouldAllowTenMembersPerFamily()
    {
        // Assert the inclusive upper bound matches the documented capacity.
        (PatientConstants.MaxFamilyMemberSequence + 1).Should().Be(10);
    }

    /// <summary>
    /// Every relationship enum member must map to one of the valid PID codes.
    /// </summary>
    [Fact]
    public void ValidRelationshipCodes_ShouldCoverAllFamilyRelationships()
    {
        // Act mapping each defined relationship to its PID code character.
        var mappedCodes = Enum.GetValues<FamilyRelationship>()
            .Select(PidGenerator.GetRelationshipCode)
            .ToList();

        // Assert every mapped code is part of the valid code set.
        mappedCodes.Should().OnlyContain(code => PatientConstants.ValidRelationshipCodes.Contains(code));
    }

    #endregion

    #region Photo Constants

    /// <summary>
    /// Patient photo rules must never exceed the platform-wide profile picture limit.
    /// </summary>
    [Fact]
    public void PatientPhotoMaxSize_ShouldNotExceedPlatformLimit()
    {
        // Assert the patient-specific cap is bounded by the global upload cap.
        PatientConstants.ProfilePhotoMaxSizeBytes.Should().BeLessThanOrEqualTo(ProfilePictureConstants.MaxSizeBytes);
    }

    /// <summary>
    /// Both photo extension allow-lists must accept exactly the same image types.
    /// </summary>
    [Fact]
    public void PhotoExtensionAllowLists_ShouldBeEquivalent()
    {
        // Assert set equality between patient photos and platform profile pictures.
        PatientConstants.AllowedPhotoExtensions.Should().BeEquivalentTo(ProfilePictureConstants.AllowedExtensions);
    }

    /// <summary>
    /// The processed output format must be standardized JPEG with matching content type.
    /// </summary>
    [Fact]
    public void ProcessedImageFormat_ShouldBeStandardizedJpeg()
    {
        // Assert the standardized processing pipeline outputs JPEG consistently.
        ProfilePictureConstants.OutputExtension.Should().Be(".jpg");
        ProfilePictureConstants.ContentType.Should().Be("image/jpeg");
    }

    /// <summary>
    /// Storage paths must fit inside their database column limits.
    /// </summary>
    [Fact]
    public void StoragePathLimits_ShouldStayWithinColumnCapacity()
    {
        // Assert both path length caps remain within five hundred characters.
        PatientConstants.ProfilePhotoPathMaxLength.Should().BeLessThanOrEqualTo(500);
        ProfilePictureConstants.PathMaxLength.Should().BeLessThanOrEqualTo(500);
    }

    #endregion

    #region Booking Constants

    /// <summary>
    /// Allowed appointment durations must be unique, positive, and ascending.
    /// </summary>
    [Fact]
    public void AllowedDurationMinutes_ShouldBeUniquePositiveAndAscending()
    {
        // Capture the configured duration options.
        var durations = ClinicConstants.AllowedDurationMinutes;

        // Assert ordering, positivity, and uniqueness invariants.
        durations.Should().BeInAscendingOrder();
        durations.Should().OnlyContain(d => d > 0);
        durations.Distinct().Should().HaveCount(durations.Length);
    }

    /// <summary>
    /// Allowed advance booking windows must be unique, positive, and ascending.
    /// </summary>
    [Fact]
    public void AllowedAdvanceBookingDays_ShouldBeUniquePositiveAndAscending()
    {
        // Capture the configured booking window options.
        var windows = ClinicConstants.AllowedAdvanceBookingDays;

        // Assert ordering, positivity, and uniqueness invariants.
        windows.Should().BeInAscendingOrder();
        windows.Should().OnlyContain(d => d > 0);
        windows.Distinct().Should().HaveCount(windows.Length);
    }

    /// <summary>
    /// The pending slot timeout must be strictly positive to expire reservations.
    /// </summary>
    [Fact]
    public void PendingTimeoutMinutes_ShouldBePositive()
    {
        // Assert slot reservation expiry remains meaningful.
        ClinicConstants.PendingTimeoutMinutes.Should().BeGreaterThan(0);
    }

    #endregion

    #region User and Security Constants

    /// <summary>
    /// Egyptian phone numbers must match the eleven-digit 01-prefixed convention.
    /// </summary>
    [Fact]
    public void PhoneConstants_ShouldMatchEgyptianConvention()
    {
        // Assert prefix and length describe the same number shape.
        UserConstants.PhonePrefix.Should().Be("01");
        UserConstants.PhoneNumberLength.Should().Be(11);
    }

    /// <summary>
    /// OTP codes must be six digits with attempts and resends capped identically.
    /// </summary>
    [Fact]
    public void OtpConstants_ShouldMatchDocumentedSecurityPolicy()
    {
        // Assert the OTP policy values match the security specification.
        UserConstants.OtpLength.Should().Be(6);
        UserConstants.MaxOtpAttempts.Should().Be(3);
        UserConstants.MaxOtpResends.Should().Be(3);
        UserConstants.OtpExpirySeconds.Should().BeGreaterThan(0);
    }

    /// <summary>
    /// Lockout thresholds must define a positive attempt count and duration.
    /// </summary>
    [Fact]
    public void LockoutConstants_ShouldDefinePositiveThresholds()
    {
        // Assert lockout policy values are usable as-is.
        UserConstants.MaxFailedAccessAttempts.Should().BeGreaterThan(0);
        UserConstants.DefaultLockoutTimeSpanMinutes.Should().BeGreaterThan(0);
    }

    /// <summary>
    /// Name limits must keep minimums below maximums across user and doctor profiles.
    /// </summary>
    [Fact]
    public void NameLimits_ShouldKeepMinimumsBelowMaximums()
    {
        // Assert all name range definitions are coherent.
        UserConstants.NameMinLength.Should().BeLessThan(UserConstants.NameMaxLength);
        DoctorConstants.NameMaxLength.Should().BeGreaterThan(0);
        PatientConstants.FullNameMinLength.Should().BeLessThan(PatientConstants.FullNameMaxLength);
    }

    #endregion

    #region Role Registry

    /// <summary>
    /// The role registry must contain exactly one entry per SystemRole value.
    /// </summary>
    [Fact]
    public void RoleRegistry_ShouldContainEverySystemRole()
    {
        // Act counting defined system roles against registered role names.
        var systemRoleCount = Enum.GetValues<SystemRole>().Length;

        // Assert no role is missing or duplicated in the Identity registry.
        RoleConstants.All.Should().HaveCount(systemRoleCount);
        RoleConstants.All.Distinct().Should().HaveCount(systemRoleCount);
    }

    #endregion
}
