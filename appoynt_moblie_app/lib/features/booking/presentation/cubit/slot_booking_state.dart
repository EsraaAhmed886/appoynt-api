/*
 * File Name: slot_booking_state.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.1.0
 * Dependencies: package:equatable/equatable.dart, clinic_location_entity.dart,
 *   doctor_slot_entity.dart, slot_hold_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Immutable state definitions for the doctor multi-clinic and
 *   time slot booking cubit workflow.
 */

// Import Equatable for value-based comparisons
import 'package:equatable/equatable.dart';
// Import booking domain entities
import 'package:appoynt_mobile_app/features/booking/domain/entities/clinic_location_entity.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/doctor_slot_entity.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/slot_hold_entity.dart';

/// Base abstract class for slot booking state.
abstract class SlotBookingState extends Equatable {
  const SlotBookingState();

  @override
  List<Object?> get props => [];
}

/// Initial state when entering the screen.
class SlotBookingInitial extends SlotBookingState {
  const SlotBookingInitial();
}

/// Loading state during initial clinic/slot bootstrap.
class SlotBookingLoading extends SlotBookingState {
  const SlotBookingLoading();
}

/// Primary active state holding complete multi-clinic and slot data.
class SlotBookingLoaded extends SlotBookingState {
  // Available clinic branches for this doctor
  final List<ClinicLocationEntity> clinics;
  // Currently active clinic branch
  final ClinicLocationEntity selected_clinic;
  // Currently selected date
  final DateTime selected_date;
  // All slots for the active date and clinic
  final List<DoctorSlotEntity> slots;
  // Active time-of-day filter (null = All)
  final SlotTimeOfDay? active_filter;
  // Selected slot entity
  final DoctorSlotEntity? selected_slot;
  // Active slot hold entity
  final SlotHoldEntity? active_hold;
  // Remaining TTL countdown seconds for the active hold
  final int remaining_seconds;
  // Loading flag when hold request is in flight
  final bool is_holding_slot;
  // Loading flag when refreshing slots
  final bool is_refreshing_slots;
  // User feedback message (e.g. info or warning)
  final String? feedback_message;

  const SlotBookingLoaded({
    required this.clinics,
    required this.selected_clinic,
    required this.selected_date,
    required this.slots,
    this.active_filter,
    this.selected_slot,
    this.active_hold,
    this.remaining_seconds = 0,
    this.is_holding_slot = false,
    this.is_refreshing_slots = false,
    this.feedback_message,
  });

  /// Filtered slots matching the active time of day filter.
  List<DoctorSlotEntity> get filtered_slots {
    if (active_filter == null) return slots;
    return slots.where((slot) => slot.time_of_day == active_filter).toList();
  }

  /// Whether a valid active hold exists with positive remaining countdown seconds.
  bool get has_active_hold =>
      active_hold != null && remaining_seconds > 0 && selected_slot != null;

  /// CopyWith helper for state transitions.
  SlotBookingLoaded copyWith({
    List<ClinicLocationEntity>? clinics,
    ClinicLocationEntity? selected_clinic,
    DateTime? selected_date,
    List<DoctorSlotEntity>? slots,
    SlotTimeOfDay? active_filter,
    bool clear_filter = false,
    DoctorSlotEntity? selected_slot,
    bool clear_selected_slot = false,
    SlotHoldEntity? active_hold,
    bool clear_active_hold = false,
    int? remaining_seconds,
    bool? is_holding_slot,
    bool? is_refreshing_slots,
    String? feedback_message,
    bool clear_feedback_message = false,
  }) {
    return SlotBookingLoaded(
      clinics: clinics ?? this.clinics,
      selected_clinic: selected_clinic ?? this.selected_clinic,
      selected_date: selected_date ?? this.selected_date,
      slots: slots ?? this.slots,
      active_filter: clear_filter ? null : (active_filter ?? this.active_filter),
      selected_slot: clear_selected_slot ? null : (selected_slot ?? this.selected_slot),
      active_hold: clear_active_hold ? null : (active_hold ?? this.active_hold),
      remaining_seconds: remaining_seconds ?? this.remaining_seconds,
      is_holding_slot: is_holding_slot ?? this.is_holding_slot,
      is_refreshing_slots: is_refreshing_slots ?? this.is_refreshing_slots,
      feedback_message: clear_feedback_message
          ? null
          : (feedback_message ?? this.feedback_message),
    );
  }

  @override
  List<Object?> get props => [
        clinics,
        selected_clinic,
        selected_date,
        slots,
        active_filter,
        selected_slot,
        active_hold,
        remaining_seconds,
        is_holding_slot,
        is_refreshing_slots,
        feedback_message,
      ];
}

/// Failure/Error state.
class SlotBookingError extends SlotBookingState {
  final String message_key;

  const SlotBookingError(this.message_key);

  @override
  List<Object?> get props => [message_key];
}
