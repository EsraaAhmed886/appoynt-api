/**
 * File Name      : UpdateClinicRequestValidator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : FluentValidation, ClinicConstants, ClinicErrorCodes, UpdateClinicRequest
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Defines validation rules for updating a clinic including name, fees, address, and booking parameters.
 */

using System.Linq;
using Appoynt.Application.Common.Constants;
using Appoynt.Application.Features.Clinics.Contracts;
using Appoynt.Domain.Common.Constants;
using FluentValidation;

namespace Appoynt.Application.Features.Clinics.Validation;

/// <summary>
/// Validator for the <see cref="UpdateClinicRequest"/> to ensure data integrity before processing updates.
/// </summary>
public sealed class UpdateClinicRequestValidator : AbstractValidator<UpdateClinicRequest>
{
    /// <summary>
    /// Initializes a new instance of the <see cref="UpdateClinicRequestValidator"/> class.
    /// </summary>
    public UpdateClinicRequestValidator()
    {
        #region Clinic Info Validation

        // Validates the clinic name maximum length when provided.
        RuleFor(x => x.Name)
            .MaximumLength(ClinicConstants.NameMaxLength).WithMessage(ClinicErrorCodes.ClinicNameLengthInvalid)
            .When(x => !string.IsNullOrEmpty(x.Name));

        // Validates the consultation fee is greater than zero if provided.
        RuleFor(x => x.ConsultationFee)
            .GreaterThan(0).WithMessage(ClinicErrorCodes.ConsultationFeeInvalid)
            .When(x => x.ConsultationFee.HasValue);

        // Validates the detailed address maximum length if provided.
        RuleFor(x => x.DetailedAddress)
            .MaximumLength(ClinicConstants.DetailedAddressMaxLength).WithMessage(ClinicErrorCodes.AddressLengthInvalid)
            .When(x => !string.IsNullOrEmpty(x.DetailedAddress));

        #endregion

        #region Booking Settings Validation

        // Validates the appointment duration matches an allowed value if provided.
        RuleFor(x => x.AppointmentDurationMinutes)
            .Must(v => !v.HasValue || ClinicConstants.AllowedDurationMinutes.Contains(v.Value))
            .WithMessage(ClinicErrorCodes.DurationInvalid)
            .When(x => x.AppointmentDurationMinutes.HasValue);

        // Validates the max advance booking days matches an allowed value if provided.
        RuleFor(x => x.MaxAdvanceBookingDays)
            .Must(v => !v.HasValue || ClinicConstants.AllowedAdvanceBookingDays.Contains(v.Value))
            .WithMessage(ClinicErrorCodes.AdvanceBookingInvalid)
            .When(x => x.MaxAdvanceBookingDays.HasValue);

        // Validates the clinic status is either Active (0) or Inactive (1) if provided.
        RuleFor(x => x.Status)
            .Must(v => v == 0 || v == 1).WithMessage(ClinicErrorCodes.StatusInvalid)
            .When(x => x.Status.HasValue);

        #endregion
    }
}
