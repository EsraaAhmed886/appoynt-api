/**
 * File Name      : IClinicService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-20
 * Version        : v1.0.0
 * Dependencies   : CreateClinicRequest, UpdateClinicRequest, ClinicResponse, ClinicResult, ClinicPhoneNumberDto, WorkingPeriodRequest, BreakRequest, SlotResponse
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-20
 * Description    : Defines operations for managing clinics, schedules, breaks, phone numbers, receptionist assignments, and slots.
 */

using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Features.Clinics.Contracts;

namespace Appoynt.Application.Common.Interfaces;

/// <summary>
/// Defines the contract for clinic management and scheduling operations.
/// </summary>
public interface IClinicService
{
    #region Clinic CRUD

    /// <summary>
    /// Creates a new clinic for the currently authenticated doctor.
    /// </summary>
    /// <param name="request">The clinic creation request data.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The result containing the created clinic ID if successful.</returns>
    Task<ClinicResult> CreateClinicAsync(CreateClinicRequest request, CancellationToken cancellationToken = default);

    /// <summary>
    /// Updates an existing clinic owned by the currently authenticated doctor.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="request">The clinic update request data.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The result indicating success or errors.</returns>
    Task<ClinicResult> UpdateClinicAsync(Guid clinicId, UpdateClinicRequest request, CancellationToken cancellationToken = default);

    /// <summary>
    /// Soft deletes a clinic owned by the currently authenticated doctor.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The result indicating success or errors.</returns>
    Task<ClinicResult> DeleteClinicAsync(Guid clinicId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Retrieves a clinic by its unique identifier.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The clinic response if found; otherwise, null.</returns>
    Task<ClinicResponse?> GetClinicByIdAsync(Guid clinicId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Retrieves all clinics owned by the currently authenticated doctor.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A list of clinics for the authenticated doctor.</returns>
    Task<List<ClinicResponse>> GetMyClinicsAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Retrieves all active clinics for a specified doctor (public view).
    /// </summary>
    /// <param name="doctorId">The unique identifier of the doctor.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A list of active clinics for the specified doctor.</returns>
    Task<List<ClinicResponse>> GetDoctorClinicsAsync(Guid doctorId, CancellationToken cancellationToken = default);

    #endregion

    #region Phone Numbers

    /// <summary>
    /// Adds a contact phone number to a clinic.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="dto">The phone number data.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The result indicating success or errors.</returns>
    Task<ClinicResult> AddPhoneNumberAsync(Guid clinicId, ClinicPhoneNumberDto dto, CancellationToken cancellationToken = default);

    /// <summary>
    /// Removes a contact phone number from a clinic.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="phoneNumberId">The unique identifier of the phone number entity.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The result indicating success or errors.</returns>
    Task<ClinicResult> RemovePhoneNumberAsync(Guid clinicId, Guid phoneNumberId, CancellationToken cancellationToken = default);

    #endregion

    #region Working Periods

    /// <summary>
    /// Adds a working period to a clinic schedule.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="request">The working period request data.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The result indicating success or errors.</returns>
    Task<ClinicResult> AddWorkingPeriodAsync(Guid clinicId, WorkingPeriodRequest request, CancellationToken cancellationToken = default);

    /// <summary>
    /// Updates an existing working period for a clinic schedule.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="periodId">The unique identifier of the working period.</param>
    /// <param name="request">The working period request data.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The result indicating success or errors.</returns>
    Task<ClinicResult> UpdateWorkingPeriodAsync(Guid clinicId, Guid periodId, WorkingPeriodRequest request, CancellationToken cancellationToken = default);

    /// <summary>
    /// Deletes a working period from a clinic schedule.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="periodId">The unique identifier of the working period.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The result indicating success or errors.</returns>
    Task<ClinicResult> DeleteWorkingPeriodAsync(Guid clinicId, Guid periodId, CancellationToken cancellationToken = default);

    #endregion

    #region Breaks

    /// <summary>
    /// Adds a break to a working period.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="periodId">The unique identifier of the working period.</param>
    /// <param name="request">The break request data.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The result indicating success or errors.</returns>
    Task<ClinicResult> AddBreakAsync(Guid clinicId, Guid periodId, BreakRequest request, CancellationToken cancellationToken = default);

    /// <summary>
    /// Removes a break from a clinic working period.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="breakId">The unique identifier of the break entity.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The result indicating success or errors.</returns>
    Task<ClinicResult> RemoveBreakAsync(Guid clinicId, Guid breakId, CancellationToken cancellationToken = default);

    #endregion

    #region Receptionist Assignment

    /// <summary>
    /// Assigns a receptionist to a clinic. The receptionist must belong to the same doctor.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="receptionistId">The unique identifier of the receptionist.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The result indicating success or errors.</returns>
    Task<ClinicResult> AssignReceptionistAsync(Guid clinicId, Guid receptionistId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Removes a receptionist assignment from a clinic.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="receptionistId">The unique identifier of the receptionist.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The result indicating success or errors.</returns>
    Task<ClinicResult> RemoveReceptionistAsync(Guid clinicId, Guid receptionistId, CancellationToken cancellationToken = default);

    #endregion

    #region Slots

    /// <summary>
    /// Retrieves available appointment slots for a clinic on a specific date.
    /// </summary>
    /// <param name="clinicId">The unique identifier of the clinic.</param>
    /// <param name="date">The target date.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A list of available slot responses.</returns>
    Task<List<SlotResponse>> GetAvailableSlotsAsync(Guid clinicId, DateOnly date, CancellationToken cancellationToken = default);

    #endregion
}

