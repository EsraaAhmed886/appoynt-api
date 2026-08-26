/*
 * File Name: get_doctor_clinics_use_case.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:dartz/dartz.dart, failures.dart,
 *   availability_repository.dart, clinic_location_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Domain use case for retrieving practicing clinics and working
 *   schedule details for a specific doctor.
 */

// Import Dartz functional programming library
import 'package:dartz/dartz.dart';
// Import failures and repository contracts
import 'package:appoynt_mobile_app/core/error/failures.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/clinic_location_entity.dart';
import 'package:appoynt_mobile_app/features/booking/domain/repositories/availability_repository.dart';

/// Use case retrieving clinic locations for a given doctor.
class GetDoctorClinicsUseCase {
  // Injected domain repository
  final AvailabilityRepository repository;

  // Constructor
  const GetDoctorClinicsUseCase(this.repository);

  /// Executes the use case with doctorId parameter.
  Future<Either<Failure, List<ClinicLocationEntity>>> call(
    String doctor_id,
  ) async {
    return await repository.getDoctorClinics(doctor_id);
  }
}
