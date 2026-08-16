/*
 * File Name: doctor_profile_state.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:equatable/equatable.dart, doctor_profile_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Defines the presentation state models for the Doctor Profile feature,
 *   supporting loading skeletons, full profile display, appointment slot selection,
 *   and favorite state management.
 */

// Import Equatable for value-based state equality comparisons
import 'package:equatable/equatable.dart';
// Import domain entities
import 'package:appoynt_mobile_app/features/doctor_profile/domain/entities/doctor_profile_entity.dart';

/// Loading status enumeration for DoctorProfile.
enum DoctorProfileStatus {
  initial,
  loading,
  loaded,
  error,
}

/// Base abstract class for DoctorProfileState.
abstract class DoctorProfileState extends Equatable {
  const DoctorProfileState();

  @override
  List<Object?> get props {
    return [];
  }
}

/// Initial uninitialized state.
class DoctorProfileInitial extends DoctorProfileState {
  const DoctorProfileInitial();
}

/// Loading state triggering skeleton shimmer loaders.
class DoctorProfileLoading extends DoctorProfileState {
  const DoctorProfileLoading();
}

/// Loaded state containing full doctor profile, available slots, and selection.
class DoctorProfileLoaded extends DoctorProfileState {
  // Doctor profile domain entity
  final DoctorProfileEntity profile;
  // List of available appointment slots
  final List<AppointmentSlotEntity> available_slots;
  // Currently selected date string (e.g. "2026-08-17")
  final String selected_date;
  // Currently selected time string (e.g. "10:30 AM")
  final String? selected_time_slot;
  // Local optimistic favorite state
  final bool is_favorited;
  // In-flight booking progress flag
  final bool is_booking_in_progress;

  const DoctorProfileLoaded({
    required this.profile,
    required this.available_slots,
    required this.selected_date,
    this.selected_time_slot,
    required this.is_favorited,
    this.is_booking_in_progress = false,
  });

  /// Copy with helper for state modifications
  DoctorProfileLoaded copyWith({
    DoctorProfileEntity? profile,
    List<AppointmentSlotEntity>? available_slots,
    String? selected_date,
    String? selected_time_slot,
    bool? is_favorited,
    bool? is_booking_in_progress,
    bool clear_time_slot = false,
  }) {
    return DoctorProfileLoaded(
      profile: profile ?? this.profile,
      available_slots: available_slots ?? this.available_slots,
      selected_date: selected_date ?? this.selected_date,
      selected_time_slot:
          clear_time_slot ? null : (selected_time_slot ?? this.selected_time_slot),
      is_favorited: is_favorited ?? this.is_favorited,
      is_booking_in_progress:
          is_booking_in_progress ?? this.is_booking_in_progress,
    );
  }

  @override
  List<Object?> get props {
    return [
      profile,
      available_slots,
      selected_date,
      selected_time_slot,
      is_favorited,
      is_booking_in_progress,
    ];
  }
}

/// Slot selected state indicating a specific slot was picked.
class DoctorSlotSelectedState extends DoctorProfileLoaded {
  const DoctorSlotSelectedState({
    required super.profile,
    required super.available_slots,
    required super.selected_date,
    required String super.selected_time_slot,
    required super.is_favorited,
    super.is_booking_in_progress = false,
  });
}

/// Error state containing the failure message.
class DoctorProfileError extends DoctorProfileState {
  final String error_message;

  const DoctorProfileError(this.error_message);

  @override
  List<Object?> get props {
    return [error_message];
  }
}
