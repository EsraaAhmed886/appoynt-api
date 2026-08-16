/*
 * File Name: create_slot_hold_use_case.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:dartz/dartz.dart, failures.dart,
 *   availability_repository.dart, slot_hold_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Domain use case for placing a temporary slot reservation lock
 *   returning an expiring hold token for checkout completion.
 */

// Import Dartz functional programming library
import 'package:dartz/dartz.dart';
// Import failures and repository contracts
import 'package:appoynt_mobile_app/core/error/failures.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/slot_hold_entity.dart';
import 'package:appoynt_mobile_app/features/booking/domain/repositories/availability_repository.dart';

/// Parameters for creating a slot reservation hold.
class CreateSlotHoldParams {
  final String slot_id;
  final String clinic_id;
  final String doctor_id;
  final String service_type_id;

  const CreateSlotHoldParams({
    required this.slot_id,
    required this.clinic_id,
    required this.doctor_id,
    this.service_type_id = 'srv_general_consultation',
  });
}

/// Use case creating a temporary slot reservation hold.
class CreateSlotHoldUseCase {
  // Injected domain repository
  final AvailabilityRepository repository;

  // Constructor
  const CreateSlotHoldUseCase(this.repository);

  /// Executes the use case.
  Future<Either<Failure, SlotHoldEntity>> call(
    CreateSlotHoldParams params,
  ) async {
    return await repository.createSlotHold(
      slot_id: params.slot_id,
      clinic_id: params.clinic_id,
      doctor_id: params.doctor_id,
      service_type_id: params.service_type_id,
    );
  }
}
