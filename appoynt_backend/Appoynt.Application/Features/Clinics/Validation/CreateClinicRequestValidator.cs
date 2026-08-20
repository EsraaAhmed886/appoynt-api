/**
 * File Name      : CreateClinicRequestValidator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : FluentValidation, ClinicConstants, ClinicErrorCodes, CreateClinicRequest
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Defines validation rules for creating a clinic including general info, booking settings, phone numbers, and working periods.
 */

using System.Linq;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Features.Clinics.Contracts;
using Appoynt.Domain.Common.Constants;
using FluentValidation;

namespace Appoynt.Application.Features.Clinics.Validation;

/// <summary>
/// Validator for the <see cref="CreateClinicRequest"/> to ensure data integrity before processing.
/// </summary>
public sealed class CreateClinicRequestValidator : AbstractValidator<CreateClinicRequest>
{
    /// <summary>
    /// Initializes a new instance of the <see cref="CreateClinicRequestValidator"/> class.
    /// </summary>
    public CreateClinicRequestValidator()
    {
        #region Clinic Info Validation

        // Validates the clinic name for presence and maximum length.
        RuleFor(x => x.Name)
            .NotEmpty().WithMessage(ClinicErrorCodes.ClinicNameRequired)
            .MaximumLength(ClinicConstants.NameMaxLength).WithMessage(ClinicErrorCodes.ClinicNameLengthInvalid);

        // Validates the governorate identifier is not empty.
        RuleFor(x => x.GovernorateId)
            .NotNull().WithMessage(ClinicErrorCodes.GovernorateNotFound);

        // Validates the city identifier is not empty.
        RuleFor(x => x.CityId)
            .NotNull().WithMessage(ClinicErrorCodes.CityNotFound);

        // Validates the consultation fee is required and greater than zero.
        RuleFor(x => x.ConsultationFee)
            .NotNull().WithMessage(ClinicErrorCodes.ConsultationFeeRequired)
            .GreaterThan(0).WithMessage(ClinicErrorCodes.ConsultationFeeInvalid);

        // Validates the detailed address maximum length if provided.
        RuleFor(x => x.DetailedAddress)
            .MaximumLength(ClinicConstants.DetailedAddressMaxLength).WithMessage(ClinicErrorCodes.AddressLengthInvalid)
            .When(x => !string.IsNullOrEmpty(x.DetailedAddress));

        #endregion

        #region Booking Settings Validation

        // Validates the appointment duration matches an allowed value.
        RuleFor(x => x.AppointmentDurationMinutes)
            .NotNull().WithMessage(ClinicErrorCodes.DurationInvalid)
            .Must(v => v.HasValue && ClinicConstants.AllowedDurationMinutes.Contains(v.Value))
            .WithMessage(ClinicErrorCodes.DurationInvalid);

        // Validates the max advance booking days matches an allowed value.
        RuleFor(x => x.MaxAdvanceBookingDays)
            .NotNull().WithMessage(ClinicErrorCodes.AdvanceBookingInvalid)
            .Must(v => v.HasValue && ClinicConstants.AllowedAdvanceBookingDays.Contains(v.Value))
            .WithMessage(ClinicErrorCodes.AdvanceBookingInvalid);

        #endregion

        #region Phone Numbers Validation

        // Validates phone numbers count and content if provided.
        When(x => x.PhoneNumbers != null && x.PhoneNumbers.Count > 0, () =>
        {
            // Validates total count doesn't exceed maximum limit.
            RuleFor(x => x.PhoneNumbers!.Count)
                .LessThanOrEqualTo(ClinicConstants.MaxPhoneNumbersPerClinic)
                .WithMessage(ClinicErrorCodes.PhoneMaxExceeded);

            // Validates no duplicate phone numbers.
            RuleFor(x => x.PhoneNumbers!)
                .Must(phones => phones.Select(p => p.PhoneNumber).Distinct().Count() == phones.Count)
                .WithMessage(ClinicErrorCodes.PhoneDuplicate);

            // Validate individual phone numbers.
            RuleForEach(x => x.PhoneNumbers)
                .ChildRules(phone =>
                {
                    phone.RuleFor(p => p.PhoneNumber)
                        .NotEmpty().WithMessage(ClinicErrorCodes.PhoneNumberRequired)
                        .Matches(@"^\+?[1-9]\d{1,14}$").WithMessage(ClinicErrorCodes.PhoneFormatInvalid);

                    phone.RuleFor(p => p.Label)
                        .NotEmpty().WithMessage(ClinicErrorCodes.PhoneLabelRequired)
                        .MaximumLength(ClinicConstants.PhoneLabelMaxLength).WithMessage(ClinicErrorCodes.PhoneLabelLengthInvalid);
                });
        });

        #endregion

        #region Working Periods Validation

        // Validates working periods collection if provided.
        When(x => x.WorkingPeriods != null && x.WorkingPeriods.Count > 0, () =>
        {
            RuleForEach(x => x.WorkingPeriods)
                .SetValidator(new WorkingPeriodRequestValidator());
        });

        #endregion
    }
}
