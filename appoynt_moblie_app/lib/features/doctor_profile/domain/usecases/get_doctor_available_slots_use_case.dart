/*
 * File Name: get_doctor_available_slots_use_case.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:dartz/dartz.dart, failures.dart, usecase.dart,
 *   doctor_profile_entity.dart, doctor_profile_repository.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Clean architecture business logic UseCase orchestrating the
 *   retrieval of upcoming available booking dates and time slots for a doctor.
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

/// Parameters for retrieving doctor appointment slots.
class GetDoctorAvailableSlotsParams {
  final String doctor_id;
  final String month;

  const GetDoctorAvailableSlotsParams({
    required this.doctor_id,
    required this.month,
  });
}

/// Use case that fetches available appointment slots for a doctor.
class GetDoctorAvailableSlotsUseCase
    implements
        UseCase<List<AppointmentSlotEntity>, GetDoctorAvailableSlotsParams> {
  // Domain repository reference
  final DoctorProfileRepository repository;

  // Constructor receiving repository
  const GetDoctorAvailableSlotsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppointmentSlotEntity>>> call(
    GetDoctorAvailableSlotsParams params,
  ) async {
    return await repository.getDoctorAvailableSlots(
      params.doctor_id,
      params.month,
    );
  }
}
