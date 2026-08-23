/*
 * File Name: get_doctor_profile_use_case.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:dartz/dartz.dart, failures.dart, usecase.dart,
 *   doctor_profile_entity.dart, doctor_profile_repository.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Clean architecture business logic UseCase orchestrating the
 *   retrieval of full doctor profile details by doctor ID.
 */

// Import functional programming Either type
import 'package:dartz/dartz.dart';
// Import failure model
import 'package:appoynt_mobile_app/core/error/failures.dart';
// Import base UseCase contract
import 'package:appoynt_mobile_app/core/usecases/usecase.dart';
// Import domain entities and repository contract
import 'package:appoynt_mobile_app/features/doctor_profile/domain/entities/doctor_profile_entity.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/repositories/doctor_profile_repository.dart';

/// Parameters for retrieving doctor profile.
class GetDoctorProfileParams {
  final String doctor_id;

  const GetDoctorProfileParams({
    required this.doctor_id,
  });
}

/// Use case that fetches the full profile specifications of a doctor.
class GetDoctorProfileUseCase
    implements UseCase<DoctorProfileEntity, GetDoctorProfileParams> {
  // Domain repository reference
  final DoctorProfileRepository repository;

  // Constructor receiving repository
  const GetDoctorProfileUseCase(this.repository);

  @override
  Future<Either<Failure, DoctorProfileEntity>> call(
    GetDoctorProfileParams params,
  ) async {
    return await repository.getDoctorProfile(params.doctor_id);
  }
}
