/*
 * File Name: doctor_profile_repository.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:dartz/dartz.dart, failures.dart, doctor_profile_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Domain repository interface defining the contract for retrieving
 *   doctor profile specifications, querying appointment slots, and toggling favorite
 *   status using functional error handling (Either).
 */

// Import functional programming Either type
import 'package:dartz/dartz.dart';
// Import error handling failures
import 'package:appoynt_mobile_app/core/error/failures.dart';
// Import domain entities
import 'package:appoynt_mobile_app/features/doctor_profile/domain/entities/doctor_profile_entity.dart';

/// Abstract domain contract defining all doctor profile data operations.
abstract class DoctorProfileRepository {
  /// Fetches the complete profile entity for the given doctor ID.
  Future<Either<Failure, DoctorProfileEntity>> getDoctorProfile(
    String doctor_id,
  );

  /// Fetches available booking slots for a doctor during a specific month.
  Future<Either<Failure, List<AppointmentSlotEntity>>> getDoctorAvailableSlots(
    String doctor_id,
    String month,
  );

  /// Toggles favorite status for a doctor. Returns true if favorited, false otherwise.
  Future<Either<Failure, bool>> toggleFavoriteDoctor(
    String doctor_id,
  );
}
