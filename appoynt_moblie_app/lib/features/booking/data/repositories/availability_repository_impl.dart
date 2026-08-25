/*
 * File Name: availability_repository_impl.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.1.0
 * Dependencies: package:dartz/dartz.dart, error_handler.dart, failures.dart,
 *   availability_repository.dart, availability_remote_data_source.dart,
 *   clinic_location_entity.dart, doctor_slot_entity.dart, slot_hold_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Concrete implementation of AvailabilityRepository delegating to
 *   AvailabilityRemoteDataSource and mapping exceptions into structured domain Failures.
 */

// Import Dartz functional programming library
import 'package:dartz/dartz.dart';
// Import error handling and domain contracts
import 'package:appoynt_mobile_app/core/error/error_handler.dart';
import 'package:appoynt_mobile_app/core/error/failures.dart';
import 'package:appoynt_mobile_app/features/booking/domain/repositories/availability_repository.dart';
import 'package:appoynt_mobile_app/features/booking/data/datasources/availability_remote_data_source.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/clinic_location_entity.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/doctor_slot_entity.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/slot_hold_entity.dart';

/// Concrete implementation of AvailabilityRepository.
class AvailabilityRepositoryImpl implements AvailabilityRepository {
  // Injected remote data source
  final AvailabilityRemoteDataSource remote_data_source;

  // Constructor
  const AvailabilityRepositoryImpl(this.remote_data_source);

  @override
  Future<Either<Failure, List<ClinicLocationEntity>>> getDoctorClinics(
    String doctor_id,
  ) async {
    try {
      final List<ClinicLocationEntity> clinics =
          await remote_data_source.getDoctorClinics(doctor_id);
      return Right(clinics);
    } catch (error) {
      final ApiFailure api_failure = ErrorHandler.handle(error);
      return Left(api_failure.failure);
    }
  }

  @override
  Future<Either<Failure, List<DoctorSlotEntity>>> getAvailableSlots({
    required String clinic_id,
    required String doctor_id,
    required String date,
    String? timezone,
    String? time_of_day,
  }) async {
    try {
      final List<DoctorSlotEntity> slots = await remote_data_source.getAvailableSlots(
        clinic_id: clinic_id,
        doctor_id: doctor_id,
        date: date,
        timezone: timezone,
        time_of_day: time_of_day,
      );
      return Right(slots);
    } catch (error) {
      final ApiFailure api_failure = ErrorHandler.handle(error);
      return Left(api_failure.failure);
    }
  }

  @override
  Future<Either<Failure, SlotHoldEntity>> createSlotHold({
    required String slot_id,
    required String clinic_id,
    required String doctor_id,
    required String service_type_id,
  }) async {
    try {
      final SlotHoldEntity hold = await remote_data_source.createSlotHold(
        slot_id: slot_id,
        clinic_id: clinic_id,
        doctor_id: doctor_id,
        service_type_id: service_type_id,
      );
      return Right(hold);
    } catch (error) {
      final ApiFailure api_failure = ErrorHandler.handle(error);
      return Left(api_failure.failure);
    }
  }

  @override
  Future<Either<Failure, bool>> releaseSlotHold(String hold_token) async {
    try {
      final bool released = await remote_data_source.releaseSlotHold(hold_token);
      return Right(released);
    } catch (error) {
      final ApiFailure api_failure = ErrorHandler.handle(error);
      return Left(api_failure.failure);
    }
  }
}
