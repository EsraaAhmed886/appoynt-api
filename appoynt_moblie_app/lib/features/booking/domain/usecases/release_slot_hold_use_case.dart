/*
 * File Name: release_slot_hold_use_case.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:dartz/dartz.dart, failures.dart, availability_repository.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Domain use case for releasing an active temporary slot hold.
 */

// Import Dartz functional programming library
import 'package:dartz/dartz.dart';
// Import failures and repository contracts
import 'package:appoynt_mobile_app/core/error/failures.dart';
import 'package:appoynt_mobile_app/features/booking/domain/repositories/availability_repository.dart';

/// Use case releasing a temporary slot reservation hold.
class ReleaseSlotHoldUseCase {
  // Injected domain repository
  final AvailabilityRepository repository;

  // Constructor
  const ReleaseSlotHoldUseCase(this.repository);

  /// Executes the use case with holdToken.
  Future<Either<Failure, bool>> call(
    String hold_token,
  ) async {
    return await repository.releaseSlotHold(hold_token);
  }
}
