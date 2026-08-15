/**
 * File Name      : UpdatePatientProfileValidator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : FluentValidation, Appoynt.Application.Features.Patient.Contracts, Appoynt.Application.Common.Constants, Appoynt.Domain.Common.Constants
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Validator for the update patient profile request.
 */

using Appoynt.Application.Common.Constants;
using Appoynt.Application.Features.Patient.Contracts;
using Appoynt.Domain.Common.Constants;
using FluentValidation;

namespace Appoynt.Application.Features.Patient.Validation;

/// <summary>
/// Validates the <see cref="UpdatePatientProfileRequest"/>.
/// </summary>
public class UpdatePatientProfileValidator : AbstractValidator<UpdatePatientProfileRequest>
{
    /// <summary>
    /// Initializes a new instance of the <see cref="UpdatePatientProfileValidator"/> class.
    /// </summary>
    public UpdatePatientProfileValidator()
    {
        // National ID Validation
        RuleFor(x => x.NationalId)
            .Length(PatientConstants.NationalIdLength)
            .WithMessage(PatientErrorCodes.NationalIdInvalidLength)
            .Matches("^[0-9]+$")
            .WithMessage(PatientErrorCodes.NationalIdInvalidFormat)
            .When(x => !string.IsNullOrEmpty(x.NationalId));

        // Weight Validation
        RuleFor(x => x.WeightKg!.Value)
            .InclusiveBetween(PatientConstants.WeightMinKg, PatientConstants.WeightMaxKg)
            .WithMessage(PatientErrorCodes.WeightOutOfRange)
            .When(x => x.WeightKg.HasValue);

        // Height Validation
        RuleFor(x => x.HeightCm!.Value)
            .InclusiveBetween(PatientConstants.HeightMinCm, PatientConstants.HeightMaxCm)
            .WithMessage(PatientErrorCodes.HeightOutOfRange)
            .When(x => x.HeightCm.HasValue);

        // Blood Group Validation
        RuleFor(x => x.BloodGroup)
            .IsInEnum()
            .WithMessage(PatientErrorCodes.BloodGroupInvalid)
            .When(x => x.BloodGroup.HasValue);

        // Smoking Status Validation
        RuleFor(x => x.SmokingStatus)
            .IsInEnum()
            .WithMessage(PatientErrorCodes.SmokingStatusInvalid)
            .When(x => x.SmokingStatus.HasValue);
    }
}
