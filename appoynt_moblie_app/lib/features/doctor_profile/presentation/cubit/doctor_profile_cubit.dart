/*
 * File Name: doctor_profile_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter_bloc/flutter_bloc.dart, get_doctor_profile_use_case.dart,
 *   get_doctor_available_slots_use_case.dart, toggle_favorite_doctor_use_case.dart,
 *   doctor_profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: BLoC Cubit managing the presentation business logic for the
 *   Doctor Profile screen, including profile retrieval, slot picking, optimistic
 *   favorite toggling, and appointment scheduling interactions.
 */

// Import Flutter BLoC package
import 'package:flutter_bloc/flutter_bloc.dart';
// Import use cases
import 'package:appoynt_mobile_app/features/doctor_profile/domain/usecases/get_doctor_profile_use_case.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/usecases/get_doctor_available_slots_use_case.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/usecases/toggle_favorite_doctor_use_case.dart';
// Import states
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/cubit/doctor_profile_state.dart';

/// Cubit controlling the lifecycle and state transitions of the Doctor Profile page.
class DoctorProfileCubit extends Cubit<DoctorProfileState> {
  // Use case dependencies
  final GetDoctorProfileUseCase get_doctor_profile_use_case;
  final GetDoctorAvailableSlotsUseCase get_doctor_available_slots_use_case;
  final ToggleFavoriteDoctorUseCase toggle_favorite_doctor_use_case;

  // Constructor mapping use cases
  DoctorProfileCubit({
    required this.get_doctor_profile_use_case,
    required this.get_doctor_available_slots_use_case,
    required this.toggle_favorite_doctor_use_case,
  }) : super(const DoctorProfileInitial());

  /// Loads full doctor profile and upcoming available appointment slots.
  Future<void> load_doctor_profile(String doctor_id) async {
    emit(const DoctorProfileLoading());

    // Fetch profile
    final profile_result = await get_doctor_profile_use_case(
      GetDoctorProfileParams(doctor_id: doctor_id),
    );

    await profile_result.fold(
      (failure) async {
        emit(
          DoctorProfileError(
            failure.message_key ?? 'Failed to load doctor profile.',
          ),
        );
      },
      (profile) async {
        // Fetch slots for current month
        final DateTime now = DateTime.now();
        final String month_param =
            "${now.year}-${now.month.toString().padLeft(2, '0')}";

        final slots_result = await get_doctor_available_slots_use_case(
          GetDoctorAvailableSlotsParams(
            doctor_id: doctor_id,
            month: month_param,
          ),
        );

        slots_result.fold(
          (failure) {
            // Emits profile even if slots fail with empty slots list
            final String today_str =
                "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
            emit(
              DoctorProfileLoaded(
                profile: profile,
                available_slots: const [],
                selected_date: today_str,
                selected_time_slot: null,
                is_favorited: profile.is_favorited,
              ),
            );
          },
          (slots) {
            final String initial_date = slots.isNotEmpty
                ? slots.first.date
                : "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

            emit(
              DoctorProfileLoaded(
                profile: profile,
                available_slots: slots,
                selected_date: initial_date,
                selected_time_slot: null,
                is_favorited: profile.is_favorited,
              ),
            );
          },
        );
      },
    );
  }

  /// Selects an appointment date and clears currently picked time.
  void select_date(String date) {
    final current_state = state;
    if (current_state is DoctorProfileLoaded) {
      emit(
        current_state.copyWith(
          selected_date: date,
          clear_time_slot: true,
        ),
      );
    } else {
      // No action needed
    }
  }

  /// Selects a specific time slot string.
  void select_time_slot(String time_slot) {
    final current_state = state;
    if (current_state is DoctorProfileLoaded) {
      emit(
        DoctorSlotSelectedState(
          profile: current_state.profile,
          available_slots: current_state.available_slots,
          selected_date: current_state.selected_date,
          selected_time_slot: time_slot,
          is_favorited: current_state.is_favorited,
        ),
      );
    } else {
      // No action needed
    }
  }

  /// Optimistically toggles favorite status and synchronizes with the server.
  Future<void> toggle_favorite() async {
    final current_state = state;
    if (current_state is DoctorProfileLoaded) {
      final bool previous_status = current_state.is_favorited;
      final bool new_status = !previous_status;

      // Optimistic emit
      emit(
        current_state.copyWith(
          is_favorited: new_status,
          profile: current_state.profile.copyWith(is_favorited: new_status),
        ),
      );

      final result = await toggle_favorite_doctor_use_case(
        ToggleFavoriteDoctorParams(
          doctor_id: current_state.profile.doctor_id,
        ),
      );

      result.fold(
        (failure) {
          // Revert optimistic update on failure
          if (state is DoctorProfileLoaded) {
            final loaded = state as DoctorProfileLoaded;
            emit(
              loaded.copyWith(
                is_favorited: previous_status,
                profile: loaded.profile.copyWith(is_favorited: previous_status),
              ),
            );
          } else {
            // No action needed
          }
        },
        (is_favorited) {
          // Keep server-confirmed favorite state
        },
      );
    } else {
      // No action needed
    }
  }
}
