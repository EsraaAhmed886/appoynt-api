/*
 * File Name: get_available_slots_use_case.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:dartz/dartz.dart, failures.dart,
 *   availability_repository.dart, doctor_slot_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Domain use case for retrieving available appointment slots
 *   filtered by clinic, doctor, selected date, and optional time period.
 */

// Import Dartz functional programming library
import 'package:dartz/dartz.dart';
// Import failures and repository contracts
import 'package:appoynt_mobile_app/core/error/failures.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/doctor_slot_entity.dart';
import 'package:appoynt_mobile_app/features/booking/domain/repositories/availability_repository.dart';

/// Parameters for retrieving available slots.
class GetAvailableSlotsParams {
  final String clinic_id;
  final String doctor_id;
  final String date;
  final String? timezone;
  final String? time_of_day;

  const GetAvailableSlotsParams({
    required this.clinic_id,
    required this.doctor_id,
    required this.date,
    this.timezone,
    this.time_of_day,
  });
}

/// Use case retrieving available slots.
class GetAvailableSlotsUseCase {
  // Injected domain repository
  final AvailabilityRepository repository;

  // Constructor
  const GetAvailableSlotsUseCase(this.repository);

  /// Executes the use case.
  Future<Either<Failure, List<DoctorSlotEntity>>> call(
    GetAvailableSlotsParams params,
  ) async {
    return await repository.getAvailableSlots(
      clinic_id: params.clinic_id,
      doctor_id: params.doctor_id,
      date: params.date,
      timezone: params.timezone,
      time_of_day: params.time_of_day,
    );
  }
}
