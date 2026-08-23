/*
 * File Name: doctor_profile_repository_impl.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:dartz/dartz.dart, error_handler.dart, failures.dart,
 *   doctor_profile_repository.dart, doctor_profile_remote_data_source.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Implements the DoctorProfileRepository domain contract,
 *   coordinating network calls through DoctorProfileRemoteDataSource and mapping
 *   exceptions to structured domain Failure types with Either.
 */

// Import functional programming Either type
import 'package:dartz/dartz.dart';
// Import error handling
import 'package:appoynt_mobile_app/core/error/error_handler.dart';
import 'package:appoynt_mobile_app/core/error/failures.dart';
// Import domain entities and contract
import 'package:appoynt_mobile_app/features/doctor_profile/domain/entities/doctor_profile_entity.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/repositories/doctor_profile_repository.dart';
// Import data source
import 'package:appoynt_mobile_app/features/doctor_profile/data/datasources/doctor_profile_remote_data_source.dart';

/// Concrete repository implementation for doctor profile operations.
class DoctorProfileRepositoryImpl implements DoctorProfileRepository {
  // Remote data source dependency
  final DoctorProfileRemoteDataSource remote_data_source;

  // Constructor receiving remote data source
  const DoctorProfileRepositoryImpl({
    required this.remote_data_source,
  });

  @override
  Future<Either<Failure, DoctorProfileEntity>> getDoctorProfile(
    String doctor_id,
  ) async {
    try {
      final profile = await remote_data_source.getDoctorProfile(doctor_id);
      return Right(profile);
    } catch (error) {
      final ApiFailure api_failure = ErrorHandler.handle(error);
      return Left(api_failure.failure);
    }
  }

  @override
  Future<Either<Failure, List<AppointmentSlotEntity>>> getDoctorAvailableSlots(
    String doctor_id,
    String month,
  ) async {
    try {
      final slots =
          await remote_data_source.getDoctorAvailableSlots(doctor_id, month);
      return Right(slots);
    } catch (error) {
      final ApiFailure api_failure = ErrorHandler.handle(error);
      return Left(api_failure.failure);
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavoriteDoctor(
    String doctor_id,
  ) async {
    try {
      final is_favorited =
          await remote_data_source.toggleFavoriteDoctor(doctor_id);
      return Right(is_favorited);
    } catch (error) {
      final ApiFailure api_failure = ErrorHandler.handle(error);
      return Left(api_failure.failure);
    }
  }
}
