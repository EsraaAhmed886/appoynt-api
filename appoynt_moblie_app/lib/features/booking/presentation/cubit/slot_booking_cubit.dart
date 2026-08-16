/*
 * File Name: slot_booking_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter_bloc/flutter_bloc.dart, package:dartz/dartz.dart,
 *   get_doctor_clinics_use_case.dart, get_available_slots_use_case.dart,
 *   create_slot_hold_use_case.dart, release_slot_hold_use_case.dart,
 *   slot_booking_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Presentation Cubit managing multi-clinic scheduling, slot availability,
 *   server-synced TTL countdown timers, safe hold invalidations, and conflict handling.
 */

// Import asynchronous timer and BLoC framework
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
// Import failures, use cases, and entities
import 'package:appoynt_mobile_app/core/error/failures.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/clinic_location_entity.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/doctor_slot_entity.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/slot_hold_entity.dart';
import 'package:appoynt_mobile_app/features/booking/domain/usecases/get_doctor_clinics_use_case.dart';
import 'package:appoynt_mobile_app/features/booking/domain/usecases/get_available_slots_use_case.dart';
import 'package:appoynt_mobile_app/features/booking/domain/usecases/create_slot_hold_use_case.dart';
import 'package:appoynt_mobile_app/features/booking/domain/usecases/release_slot_hold_use_case.dart';
import 'package:appoynt_mobile_app/features/booking/presentation/cubit/slot_booking_state.dart';

/// Cubit governing the complete doctor slot booking state machine.
class SlotBookingCubit extends Cubit<SlotBookingState> {
  // Use cases
  final GetDoctorClinicsUseCase get_doctor_clinics_use_case;
  final GetAvailableSlotsUseCase get_available_slots_use_case;
  final CreateSlotHoldUseCase create_slot_hold_use_case;
  final ReleaseSlotHoldUseCase release_slot_hold_use_case;

  // Active countdown timer reference
  Timer? _countdown_timer;
  // Current doctor ID
  String _doctor_id = '';

  SlotBookingCubit({
    required this.get_doctor_clinics_use_case,
    required this.get_available_slots_use_case,
    required this.create_slot_hold_use_case,
    required this.release_slot_hold_use_case,
  }) : super(const SlotBookingInitial());

  /// Initializes the booking screen with doctor clinics and starting slot schedule.
  Future<void> init({required String doctor_id}) async {
    _doctor_id = doctor_id;
    emit(const SlotBookingLoading());

    final Either<Failure, List<ClinicLocationEntity>> result =
        await get_doctor_clinics_use_case(doctor_id);

    result.fold(
      (failure) {
        emit(SlotBookingError(failure.message_key ?? 'error_server'));
      },
      (clinics) async {
        if (clinics.isEmpty) {
          emit(const SlotBookingError('error_not_found'));
          return;
        }

        final ClinicLocationEntity initial_clinic = clinics.first;
        final DateTime initial_date = _get_first_available_date(initial_clinic);

        // Fetch slots for initial clinic and date
        final List<DoctorSlotEntity> slots = await _fetch_slots(
          clinic_id: initial_clinic.clinic_id,
          date: _format_date(initial_date),
        );

        emit(
          SlotBookingLoaded(
            clinics: clinics,
            selected_clinic: initial_clinic,
            selected_date: initial_date,
            slots: slots,
          ),
        );
      },
    );
  }

  /// Switches active clinic branch, clears existing hold, and reloads slots.
  Future<void> selectClinic(ClinicLocationEntity new_clinic) async {
    final SlotBookingState current = state;
    if (current is! SlotBookingLoaded) return;
    if (current.selected_clinic.clinic_id == new_clinic.clinic_id) return;

    // Release any active hold before switching clinic
    await _release_current_hold_silently();

    DateTime target_date = current.selected_date;
    if (!_is_clinic_open_on_date(new_clinic, target_date)) {
      target_date = _get_first_available_date(new_clinic);
    }

    emit(
      current.copyWith(
        selected_clinic: new_clinic,
        selected_date: target_date,
        clear_selected_slot: true,
        clear_active_hold: true,
        remaining_seconds: 0,
        is_refreshing_slots: true,
        clear_feedback_message: true,
      ),
    );

    final List<DoctorSlotEntity> slots = await _fetch_slots(
      clinic_id: new_clinic.clinic_id,
      date: _format_date(target_date),
    );

    emit(
      (state as SlotBookingLoaded).copyWith(
        slots: slots,
        is_refreshing_slots: false,
      ),
    );
  }

  /// Selects an appointment date, releases any active hold, and refreshes slots.
  Future<void> selectDate(DateTime new_date) async {
    final SlotBookingState current = state;
    if (current is! SlotBookingLoaded) return;

    // Normalize date to compare day/month/year
    if (current.selected_date.year == new_date.year &&
        current.selected_date.month == new_date.month &&
        current.selected_date.day == new_date.day) {
      return;
    }

    // Release any active hold before changing date
    await _release_current_hold_silently();

    emit(
      current.copyWith(
        selected_date: new_date,
        clear_selected_slot: true,
        clear_active_hold: true,
        remaining_seconds: 0,
        is_refreshing_slots: true,
        clear_feedback_message: true,
      ),
    );

    final List<DoctorSlotEntity> slots = await _fetch_slots(
      clinic_id: current.selected_clinic.clinic_id,
      date: _format_date(new_date),
    );

    emit(
      (state as SlotBookingLoaded).copyWith(
        slots: slots,
        is_refreshing_slots: false,
      ),
    );
  }

  /// Sets the active time of day filter (Morning, Afternoon/Evening, or All).
  void setFilter(SlotTimeOfDay? filter) {
    final SlotBookingState current = state;
    if (current is! SlotBookingLoaded) return;

    emit(
      current.copyWith(
        active_filter: filter,
        clear_filter: filter == null,
      ),
    );
  }

  /// Places a temporary hold lock on a selected slot with 1-second countdown ticker.
  Future<void> selectSlot(DoctorSlotEntity slot) async {
    final SlotBookingState current = state;
    if (current is! SlotBookingLoaded) return;
    if (slot.status != SlotStatus.available) return;
    if (current.selected_slot?.slot_id == slot.slot_id && current.has_active_hold) return;

    // Release previous hold if one exists
    await _release_current_hold_silently();

    emit(
      current.copyWith(
        selected_slot: slot,
        is_holding_slot: true,
        clear_active_hold: true,
        remaining_seconds: 0,
        clear_feedback_message: true,
      ),
    );

    final Either<Failure, SlotHoldEntity> result = await create_slot_hold_use_case(
      CreateSlotHoldParams(
        slot_id: slot.slot_id,
        clinic_id: current.selected_clinic.clinic_id,
        doctor_id: _doctor_id,
      ),
    );

    result.fold(
      (failure) async {
        // Refresh slots in case of conflict
        final List<DoctorSlotEntity> refreshed_slots = await _fetch_slots(
          clinic_id: current.selected_clinic.clinic_id,
          date: _format_date(current.selected_date),
        );

        emit(
          (state as SlotBookingLoaded).copyWith(
            slots: refreshed_slots,
            is_holding_slot: false,
            clear_selected_slot: true,
            feedback_message: 'This slot is no longer available. Please choose another.',
          ),
        );
      },
      (hold) {
        emit(
          (state as SlotBookingLoaded).copyWith(
            active_hold: hold,
            remaining_seconds: hold.remaining_seconds,
            is_holding_slot: false,
          ),
        );

        _start_countdown_timer(hold.expires_at_utc);
      },
    );
  }

  /// Manually releases active hold (e.g. upon user deselecting or leaving).
  Future<void> releaseActiveHold() async {
    await _release_current_hold_silently();
    final SlotBookingState current = state;
    if (current is! SlotBookingLoaded) return;

    emit(
      current.copyWith(
        clear_selected_slot: true,
        clear_active_hold: true,
        remaining_seconds: 0,
      ),
    );
  }

  /// Starts the 1-second interval ticker synchronized against the server UTC expiration.
  void _start_countdown_timer(DateTime expires_at_utc) {
    _countdown_timer?.cancel();
    _countdown_timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final DateTime now_utc = DateTime.now().toUtc();
      final int remaining = expires_at_utc.difference(now_utc).inSeconds;

      if (remaining <= 0) {
        timer.cancel();
        _on_hold_expired();
      } else {
        if (state is SlotBookingLoaded) {
          emit(
            (state as SlotBookingLoaded).copyWith(
              remaining_seconds: remaining,
            ),
          );
        }
      }
    });
  }

  /// Handles expiration of the 5-minute hold lock.
  Future<void> _on_hold_expired() async {
    final SlotBookingState current = state;
    if (current is! SlotBookingLoaded) return;

    await _release_current_hold_silently();

    final List<DoctorSlotEntity> refreshed_slots = await _fetch_slots(
      clinic_id: current.selected_clinic.clinic_id,
      date: _format_date(current.selected_date),
    );

    emit(
      current.copyWith(
        slots: refreshed_slots,
        clear_selected_slot: true,
        clear_active_hold: true,
        remaining_seconds: 0,
        feedback_message: 'Reservation hold expired. Please select a time slot again.',
      ),
    );
  }

  /// Internal helper to release current hold without blocking or crashing.
  Future<void> _release_current_hold_silently() async {
    _countdown_timer?.cancel();
    _countdown_timer = null;

    if (state is SlotBookingLoaded) {
      final SlotHoldEntity? hold = (state as SlotBookingLoaded).active_hold;
      if (hold != null && hold.hold_token.isNotEmpty) {
        try {
          await release_slot_hold_use_case(hold.hold_token);
        } catch (_) {
          // Idempotent safe release ignore
        }
      }
    }
  }

  /// Internal helper fetching slots via use case.
  Future<List<DoctorSlotEntity>> _fetch_slots({
    required String clinic_id,
    required String date,
  }) async {
    final Either<Failure, List<DoctorSlotEntity>> result =
        await get_available_slots_use_case(
      GetAvailableSlotsParams(
        clinic_id: clinic_id,
        doctor_id: _doctor_id,
        date: date,
      ),
    );

    return result.fold((failure) => [], (slots) => slots);
  }

  /// Formats DateTime into YYYY-MM-DD string.
  String _format_date(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  /// Returns whether a clinic is open on the given date.
  bool _is_clinic_open_on_date(ClinicLocationEntity clinic, DateTime date) {
    const List<String> day_names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final String day_short = day_names[date.weekday - 1];
    return clinic.isOpenOn(day_short);
  }

  /// Finds the first upcoming date starting today when the clinic is open.
  DateTime _get_first_available_date(ClinicLocationEntity clinic) {
    DateTime candidate = DateTime.now();
    for (int i = 0; i < 14; i++) {
      if (_is_clinic_open_on_date(clinic, candidate)) {
        return candidate;
      }
      candidate = candidate.add(const Duration(days: 1));
    }
    return DateTime.now();
  }

  @override
  Future<void> close() async {
    await _release_current_hold_silently();
    return super.close();
  }
}
