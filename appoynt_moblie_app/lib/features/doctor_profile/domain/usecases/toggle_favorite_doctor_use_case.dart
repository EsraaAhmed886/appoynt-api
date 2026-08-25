/*
 * File Name: toggle_favorite_doctor_use_case.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:dartz/dartz.dart, failures.dart, usecase.dart,
 *   doctor_profile_repository.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Clean architecture business logic UseCase toggling the
 *   favorite/saved status of a doctor on the backend.
 */

// Import functional programming Either type
import 'package:dartz/dartz.dart';
// Import failure model
import 'package:appoynt_mobile_app/core/error/failures.dart';
// Import base UseCase contract
import 'package:appoynt_mobile_app/core/usecases/usecase.dart';
// Import repository contract
import 'package:appoynt_mobile_app/features/doctor_profile/domain/repositories/doctor_profile_repository.dart';

/// Parameters for toggling doctor favorite state.
class ToggleFavoriteDoctorParams {
  final String doctor_id;

  const ToggleFavoriteDoctorParams({
    required this.doctor_id,
  });
}

/// Use case that toggles favorite status for a doctor.
class ToggleFavoriteDoctorUseCase
    implements UseCase<bool, ToggleFavoriteDoctorParams> {
  // Domain repository reference
  final DoctorProfileRepository repository;

  // Constructor receiving repository
  const ToggleFavoriteDoctorUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(
    ToggleFavoriteDoctorParams params,
  ) async {
    return await repository.toggleFavoriteDoctor(params.doctor_id);
  }
}
