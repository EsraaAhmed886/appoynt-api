/*
 * File Name: availability_repository.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:dartz/dartz.dart, failures.dart, clinic_location_entity.dart,
 *   doctor_slot_entity.dart, slot_hold_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Domain repository contract for doctor clinic locations,
 *   time slot availability, and slot reservation hold lock lifecycles.
 */

// Import Dartz functional programming library
import 'package:dartz/dartz.dart';
// Import core failures and domain entities
import 'package:appoynt_mobile_app/core/error/failures.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/clinic_location_entity.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/doctor_slot_entity.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/slot_hold_entity.dart';

/// Contract defining availability operations in the domain layer.
abstract class AvailabilityRepository {
  /// Fetches the clinics where the doctor is practicing.
  Future<Either<Failure, List<ClinicLocationEntity>>> getDoctorClinics(
    String doctor_id,
  );

  /// Fetches available slots for a specific clinic and date.
  Future<Either<Failure, List<DoctorSlotEntity>>> getAvailableSlots({
    required String clinic_id,
    required String doctor_id,
    required String date,
    String? timezone,
    String? time_of_day,
  });

  /// Places a temporary hold reservation lock on a slot.
  Future<Either<Failure, SlotHoldEntity>> createSlotHold({
    required String slot_id,
    required String clinic_id,
    required String doctor_id,
    required String service_type_id,
  });

  /// Releases a temporary hold reservation lock.
  Future<Either<Failure, bool>> releaseSlotHold(String hold_token);
}
