/*
 * File Name: profile_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart,
 *   package:appoynt_mobile_app/features/profile/domain/entities/patient_profile.dart,
 *   package:appoynt_mobile_app/features/profile/domain/entities/insurance_card.dart,
 *   package:appoynt_mobile_app/features/profile/domain/entities/test_result.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/07/2026]
 * File Description: Implement the Patient Profile Cubit orchestrating UI updates, validations, and saves.
 */

// Importing the BLoC library
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing the profile state definitions
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';
// Importing the patient profile entity definition
import 'package:appoynt_mobile_app/features/profile/domain/entities/patient_profile.dart';
// Importing the insurance card model definition
import 'package:appoynt_mobile_app/features/profile/domain/entities/insurance_card.dart';
// Importing the test result model definition
import 'package:appoynt_mobile_app/features/profile/domain/entities/test_result.dart';
import 'package:appoynt_mobile_app/core/di/service_locator.dart';
import 'package:appoynt_mobile_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:appoynt_mobile_app/features/profile/data/models/change_password_request_model.dart';
import 'package:appoynt_mobile_app/features/profile/data/models/update_profile_request_model.dart';
import 'package:appoynt_mobile_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:appoynt_mobile_app/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:appoynt_mobile_app/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

// Profile business logic Cubit controller class
class ProfileCubit extends Cubit<ProfileState> {
  // Master list of available chronic conditions options (to be fetched from API/DB)
  final List<Map<String, String>> available_conditions = const [
    // Diabetes details EN/AR and icon key
    {
      // English label
      'en': 'Diabetes',
      // Arabic label
      'ar': 'مرض السكري',
      // Icon identifier
      'icon_key': 'diabetes',
    },
    // Hypertension details EN/AR and icon key
    {
      // English label
      'en': 'Hypertension',
      // Arabic label
      'ar': 'ارتفاع ضغط الدم',
      // Icon identifier
      'icon_key': 'hypertension',
    },
    // Gout details EN/AR and icon key
    {
      // English label
      'en': 'Gout',
      // Arabic label
      'ar': 'النقرس',
      // Icon identifier
      'icon_key': 'gout',
    },
    // Asthma details EN/AR and icon key
    {
      // English label
      'en': 'Asthma',
      // Arabic label
      'ar': 'الربو',
      // Icon identifier
      'icon_key': 'asthma',
    },
    // Heart Disease details EN/AR and icon key
    {
      // English label
      'en': 'Heart Disease',
      // Arabic label
      'ar': 'أمراض القلب',
      // Icon identifier
      'icon_key': 'heart_disease',
    },
  ];

  // Constructor initializing with initial blank state configuration
  ProfileCubit() : super(ProfileState.initial());

  // Fetches the user profile data from the remote API and updates state
  Future<void> fetchUserProfile() async {
    // Emit ProfileLoading state to trigger loading UI
    emit(ProfileLoading(
      // Keep existing profile
      profile: state.profile,
      // Keep existing temp profile
      temp_profile: state.temp_profile,
      // Keep existing dirty state
      is_dirty: state.is_dirty,
    ));
    // Try catch block to handle network exceptions
    try {
      // Call GetUserProfileUseCase to fetch user details
      final user_profile = await get_it<GetUserProfileUseCase>().call();
      // Map API model values to domain PatientProfile entity to populate local UI fields
      final loaded_profile = PatientProfile(
        // Map first name
        first_name: user_profile.first_name,
        // Map last name
        last_name: user_profile.last_name,
        // Map phone number
        phone: user_profile.phone_number,
        // Map email
        email: user_profile.email,
        // Convert gender integer to localized text string
        gender: 0 == user_profile.gender ? 'Male' : (1 == user_profile.gender ? 'Female' : ''),
        // Map address
        address: user_profile.address ?? '',
        // Keep existing local national ID
        national_id: state.profile.national_id,
        // Keep existing local weight
        weight: state.profile.weight,
        // Keep existing local height
        height: state.profile.height,
        // Keep existing local smoking status
        smoking: state.profile.smoking,
        // Keep existing local food allergies
        food_allergies: state.profile.food_allergies,
        // Keep existing local medication allergies
        medication_allergies: state.profile.medication_allergies,
        // Keep existing local prescriptions
        prescriptions: state.profile.prescriptions,
        // Keep existing local lab tests
        lab_tests: state.profile.lab_tests,
        // Keep existing local scans
        scans: state.profile.scans,
        // Keep existing local chronic conditions
        chronic_conditions: state.profile.chronic_conditions,
        // Keep existing local insurance cards
        insurance_cards: state.profile.insurance_cards,
        // Keep existing local avatar url
        avatar_url: state.profile.avatar_url,
        // Keep existing local payment cards
        payment_cards: state.profile.payment_cards,
      );
      // Emit ProfileLoaded state with fetched user model and mapped patient profile
      emit(ProfileLoaded(
        // Bind fetched user profile model
        user: user_profile,
        // Bind mapped profile
        profile: loaded_profile,
        // Bind temp profile
        temp_profile: loaded_profile,
        // Reset dirty status
        is_dirty: false,
      ));
      // Catch all block for network and parsing exceptions
    } catch (e) {
      // Emit ProfileUpdateError state with the error message
      emit(ProfileUpdateError(
        // Set error message
        message: e.toString(),
        // Keep existing profile
        profile: state.profile,
        // Keep existing temp profile
        temp_profile: state.temp_profile,
        // Keep existing dirty status
        is_dirty: state.is_dirty,
      ));
    }
  }

  // Stale-While-Revalidate entry point called by ProfilePage on initState.
  // Phase 1: emits cached profile instantly (zero-latency UI render).
  // Phase 2: fetches fresh profile from the API silently in the background
  //   and re-emits only when the remote data differs from the cached snapshot.
  Future<void> load_from_cache_then_refresh() async {
    // Read the cached profile from SharedPreferences synchronously via repo
    final UserProfileModel? cached_profile =
        await get_it<ProfileRepository>().getCachedProfile();

    // PHASE 1 — Cache hit: emit immediately so the UI renders with zero delay
    if (null != cached_profile) {
      // Map cached UserProfileModel into PatientProfile domain entity structure
      final PatientProfile cached_entity = _map_model_to_entity(cached_profile);
      // Emit ProfileLoaded with cached data — UI becomes interactive instantly
      if (!isClosed) {
        emit(ProfileLoaded(
          // Bind the cached user profile model for PID/email display
          user: cached_profile,
          // Bind mapped patient profile entity for all form fields
          profile: cached_entity,
          // Bind temp profile to cached snapshot for edit form baseline
          temp_profile: cached_entity,
          // Reset dirty flag on cache-sourced load
          is_dirty: false,
        ));
      } else {
        // Cubit was closed before cache emit — abort safely
        return;
      }
    } else {
      // Cache miss — emit loading state so the UI shows a shimmer indicator
      if (!isClosed) {
        emit(ProfileLoading(
          // Carry existing profile state during initial load
          profile: state.profile,
          // Carry existing temp profile state during initial load
          temp_profile: state.temp_profile,
          // Carry existing dirty flag value during initial load
          is_dirty: state.is_dirty,
        ));
      } else {
        // Cubit was closed before loading emit — abort safely
        return;
      }
    }

    // PHASE 2 — Background refresh: fetch from remote, update cache and UI
    try {
      // Fetch fresh profile from the remote API (also writes to cache internally)
      final UserProfileModel fresh_profile =
          await get_it<GetUserProfileUseCase>().call();
      // Map fresh remote model into the PatientProfile domain entity structure
      final PatientProfile fresh_entity = _map_model_to_entity(fresh_profile);

      // Only emit a state update when the fresh data differs from the cache
      final bool data_changed = null == cached_profile ||
          fresh_profile.first_name != cached_profile.first_name ||
          fresh_profile.last_name != cached_profile.last_name ||
          fresh_profile.email != cached_profile.email ||
          fresh_profile.phone_number != cached_profile.phone_number ||
          fresh_profile.gender != cached_profile.gender ||
          fresh_profile.date_of_birth != cached_profile.date_of_birth ||
          fresh_profile.address != cached_profile.address ||
          fresh_profile.patient_id != cached_profile.patient_id;

      // Guard against emitting on a closed cubit after the async network call
      if (!isClosed && data_changed) {
        // Emit refreshed state so UI silently updates with the latest data
        emit(ProfileLoaded(
          // Bind fresh remote user profile model
          user: fresh_profile,
          // Bind mapped fresh patient profile entity
          profile: fresh_entity,
          // Bind fresh entity as the edit form baseline
          temp_profile: fresh_entity,
          // Reset dirty flag after successful background refresh
          is_dirty: false,
        ));
        // Log silent refresh for audit diagnostics
        debugPrint(
          '[ProfileCubit] Background refresh completed — UI updated silently.',
        );
      } else if (!isClosed) {
        // Data is identical to cache — no UI re-emit needed
        debugPrint(
          '[ProfileCubit] Background refresh completed — data unchanged.',
        );
      } else {
        // Cubit was closed during background network call — discard result
      }
    } catch (refresh_error) {
      // Background refresh failed — do NOT overwrite existing cache-sourced state
      debugPrint(
        '[ProfileCubit] Background refresh failed (non-fatal): $refresh_error',
      );
      // Emit error only when no cached data was available (cold start failure)
      if (null == cached_profile && !isClosed) {
        emit(ProfileUpdateError(
          // Set error message from the caught exception
          message: refresh_error.toString(),
          // Carry existing profile state
          profile: state.profile,
          // Carry existing temp profile state
          temp_profile: state.temp_profile,
          // Carry existing dirty flag value
          is_dirty: state.is_dirty,
        ));
      } else {
        // Cached data was already emitted — silently absorb the refresh failure
      }
    }
  }

  // Private helper: maps a UserProfileModel API response to PatientProfile entity
  PatientProfile _map_model_to_entity(UserProfileModel model) {
    // Return a fully populated PatientProfile using the model field values
    return PatientProfile(
      // Map first name from the API model
      first_name: model.first_name,
      // Map last name from the API model
      last_name: model.last_name,
      // Map phone number from the API model
      phone: model.phone_number,
      // Map email from the API model
      email: model.email,
      // Map gender integer (0=Male, 1=Female) to display string
      gender: 0 == model.gender
          ? 'Male'
          : (1 == model.gender ? 'Female' : ''),
      // Map address from the API model with empty-string fallback
      address: model.address ?? '',
      // Carry existing local national ID (not in API response)
      national_id: state.profile.national_id,
      // Carry existing local weight (not in API response)
      weight: state.profile.weight,
      // Carry existing local height (not in API response)
      height: state.profile.height,
      // Carry existing local smoking status (not in API response)
      smoking: state.profile.smoking,
      // Carry existing local food allergies (not in API response)
      food_allergies: state.profile.food_allergies,
      // Carry existing local medication allergies (not in API response)
      medication_allergies: state.profile.medication_allergies,
      // Carry existing local prescriptions (not in API response)
      prescriptions: state.profile.prescriptions,
      // Carry existing local lab tests (not in API response)
      lab_tests: state.profile.lab_tests,
      // Carry existing local scans (not in API response)
      scans: state.profile.scans,
      // Carry existing local chronic conditions (not in API response)
      chronic_conditions: state.profile.chronic_conditions,
      // Carry existing local insurance cards (not in API response)
      insurance_cards: state.profile.insurance_cards,
      // Carry existing local avatar URL (not in API response)
      avatar_url: state.profile.avatar_url,
      // Carry existing local payment cards (not in API response)
      payment_cards: state.profile.payment_cards,
    );
  }

  // Updates the user profile data via the remote API
  Future<void> updateUserProfile(UpdateProfileRequestModel requestModel) async {
    // Emit ProfileUpdating state to trigger spinner on save button
    emit(ProfileUpdating(
      // Keep existing profile
      profile: state.profile,
      // Keep existing temp profile
      temp_profile: state.temp_profile,
      // Keep existing dirty status
      is_dirty: state.is_dirty,
    ));
    // Try catch block to handle network exceptions
    try {
      // Call UpdateUserProfileUseCase to perform PUT update profile
      await get_it<UpdateUserProfileUseCase>().call(requestModel);
      // Create new PatientProfile mapping the updated details
      final saved_profile = state.profile.copyWith(
        // Map updated first name
        first_name: requestModel.first_name,
        // Map updated last name
        last_name: requestModel.last_name,
        // Map updated address
        address: requestModel.address ?? '',
        // Map updated gender
        gender: 0 == requestModel.gender ? 'Male' : (1 == requestModel.gender ? 'Female' : ''),
      );
      // Emit ProfileUpdateSuccess state indicating successful update
      emit(ProfileUpdateSuccess(
        // Bind new profile
        profile: saved_profile,
        // Bind new temp profile
        temp_profile: saved_profile,
        // Reset dirty status
        is_dirty: false,
      ));
      // Catch all block for network exceptions
    } catch (e) {
      // Emit ProfileUpdateError state with the error message
      emit(ProfileUpdateError(
        // Set error message
        message: e.toString(),
        // Keep existing profile
        profile: state.profile,
        // Keep existing temp profile
        temp_profile: state.temp_profile,
        // Keep existing dirty status
        is_dirty: state.is_dirty,
      ));
    }
  }

  // Triggers loading sequence for retrieving patient profile details
  Future<void> load_profile() async {
    // Forward directly to remote fetch API sequence
    await fetchUserProfile();
  }

  // Update temp draft properties inside profile state tracker
  void update_temp_profile(PatientProfile updated_temp) {
    // Clean string fields helper variables before comparisons
    final String initial_first = state.profile.first_name.trim();
    // Clean initial last name
    final String initial_last = state.profile.last_name.trim();
    // Clean initial email
    final String initial_email = state.profile.email.trim().toLowerCase();
    // Clean initial address
    final String initial_address = state.profile.address.trim();
    // Clean initial national_id
    final String initial_national_id = state.profile.national_id.trim();
    // Clean initial weight
    final String initial_weight = state.profile.weight.trim();
    // Clean initial height
    final String initial_height = state.profile.height.trim();
    // Clean initial gender
    final String initial_gender = state.profile.gender.trim();
    // Clean initial smoking choice
    final String initial_smoking = state.profile.smoking.trim();
    // Clean initial avatar URL path
    final String initial_avatar = state.profile.avatar_url.trim();

    // Clean current temp parameters inputs
    final String current_first = updated_temp.first_name.trim();
    // Clean temp last name
    final String current_last = updated_temp.last_name.trim();
    // Clean temp email
    final String current_email = updated_temp.email.trim().toLowerCase();
    // Clean temp address
    final String current_address = updated_temp.address.trim();
    // Clean temp national_id
    final String current_national_id = updated_temp.national_id.trim();
    // Clean temp weight
    final String current_weight = updated_temp.weight.trim();
    // Clean temp height
    final String current_height = updated_temp.height.trim();
    // Clean temp gender
    final String current_gender = updated_temp.gender.trim();
    // Clean temp smoking choice
    final String current_smoking = updated_temp.smoking.trim();
    // Clean temp avatar URL path
    final String current_avatar = updated_temp.avatar_url.trim();

    // Check if any property was changed using comparison checks
    bool has_changes = false;
    // Check first name change
    if (current_first != initial_first) {
      // Set changed
      has_changes = true;
    } else if (current_last != initial_last) {
      // Set changed
      has_changes = true;
    } else if (current_email != initial_email) {
      // Set changed
      has_changes = true;
    } else if (current_address != initial_address) {
      // Set changed
      has_changes = true;
    } else if (current_national_id != initial_national_id) {
      // Set changed
      has_changes = true;
    } else if (current_weight != initial_weight) {
      // Set changed
      has_changes = true;
    } else if (current_height != initial_height) {
      // Set changed
      has_changes = true;
    } else if (current_gender != initial_gender) {
      // Set changed
      has_changes = true;
    } else if (current_smoking != initial_smoking) {
      // Set changed
      has_changes = true;
    } else if (current_avatar != initial_avatar) {
      // Set changed
      has_changes = true;
    } else {
      // No changes found
      has_changes = false;
    }

    // Emit updated temp state tracking changes dirty status
    emit(
      // Copy current properties mapping modifications
      state.copyWith(
        // Maintain success state or generic trigger
        status: ProfileStatus.success,
        // Bind modified temp profile copy
        temp_profile: updated_temp,
        // Update dirty status
        is_dirty: has_changes,
      ),
    );
  }

  // Submits the updated profile properties to mock repository backend
  Future<void> update_profile() async {
    // Verify changes exist using Yoda comparison
    if (false == state.is_dirty) {
      // Return early to save execution payload
      return;
    } else {
      // Proceed with update flow
      emit(state.copyWith(status: ProfileStatus.updating));
      // Simulate backend save delay duration
      await Future.delayed(
        // Delay settings
        const Duration(
          // Duration count
          milliseconds: 800,
        ),
      );
      // Construct final saved profile with trimmed inputs
      final PatientProfile saved_profile = state.temp_profile.copyWith(
        // Trim first name
        first_name: state.temp_profile.first_name.trim(),
        // Trim last name
        last_name: state.temp_profile.last_name.trim(),
        // Lowercase and trim email
        email: state.temp_profile.email.trim().toLowerCase(),
        // Trim address field
        address: state.temp_profile.address.trim(),
        // Force immutable phone number
        phone: state.profile.phone,
      );
      // Emit success state updating source profile snapshot
      emit(
        // Duplicate state configurations
        state.copyWith(
          // Set update success status
          status: ProfileStatus.updateSuccess,
          // Bind new profile
          profile: saved_profile,
          // Bind new temp copy
          temp_profile: saved_profile,
          // Clear dirty flag
          is_dirty: false,
        ),
      );
    }
  }

  // Restore current editing form values back to saved profile values
  void discard_changes() {
    // Revert draft changes back to initial state
    emit(
      // copy properties
      state.copyWith(
        // Status reset
        status: ProfileStatus.success,
        // Revert temp copy back to profile values
        temp_profile: state.profile,
        // Clear dirty status
        is_dirty: false,
      ),
    );
  }

  // Dynamic status modifier to resolve page navigation return triggers
  void reset_status() {
    // Reset state status back to base success mode
    emit(state.copyWith(status: ProfileStatus.success));
  }

  // Update password parameters validating requirements criteria
  Future<void> change_password(String current_pw, String new_pw) async {
    // Emits password updating status
    emit(state.copyWith(status: ProfileStatus.passwordUpdating));

    // Trim current password and new password to satisfy spec 3
    final String currentPwTrimmed = current_pw.trim();
    final String newPwTrimmed = new_pw.trim();

    try {
      final requestModel = ChangePasswordRequestModel(
        currentPassword: currentPwTrimmed,
        newPassword: newPwTrimmed,
        confirmPassword: newPwTrimmed,
      );

      // Log the exact JSON payload before dispatching (spec 1)
      debugPrint('Change Password Payload: ${requestModel.toJson()}');

      // Call the remote data source
      await get_it<ProfileRemoteDataSource>().changePassword(requestModel);

      // Emit password change success status
      emit(
        state.copyWith(
          status: ProfileStatus.passwordSuccess,
        ),
      );
    } on DioException catch (e) {
      final String errorMsg = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'Password update failed.')
          : 'Password update failed.';
      emit(
        state.copyWith(
          status: ProfileStatus.passwordError,
          error_message: errorMsg,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.passwordError,
          error_message: 'An unexpected error occurred.',
        ),
      );
    }
  }

  // Add customized food or medication allergy item to list
  void add_allergy(String allergy_name, String category_type) {
    // Verify allergy name is not empty after trim
    if (allergy_name.trim().isEmpty) {
      // Return early
      return;
    } else {
      // Check allergy category type using Yoda comparisons
      if ('food' == category_type) {
        // Create duplicate list appending new item
        final List<String> updated_list =
            List<String>.from(state.profile.food_allergies)
              ..add(allergy_name.trim());
        // Create profile instance clone
        final PatientProfile updated_profile =
            state.profile.copyWith(food_allergies: updated_list);
        // Emit updated profile state configurations
        emit(
          // Copy configs
          state.copyWith(
            // Success status
            status: ProfileStatus.success,
            // Bind profile
            profile: updated_profile,
            // Bind temp copy
            temp_profile: updated_profile,
          ),
        );
      } else {
        // Create duplicate list appending new medication allergy item
        final List<String> updated_list =
            List<String>.from(state.profile.medication_allergies)
              ..add(allergy_name.trim());
        // Create profile clone
        final PatientProfile updated_profile =
            state.profile.copyWith(medication_allergies: updated_list);
        // Emit updated state
        emit(
          // Copy configs
          state.copyWith(
            // Success status
            status: ProfileStatus.success,
            // Bind profile
            profile: updated_profile,
            // Bind temp copy
            temp_profile: updated_profile,
          ),
        );
      }
    }
  }

  // Remove customized food or medication allergy item from list
  void remove_allergy(String allergy_name, String category_type) {
    if ('food' == category_type) {
      final List<String> updated_list =
          List<String>.from(state.profile.food_allergies)..remove(allergy_name);
      final PatientProfile updated_profile =
          state.profile.copyWith(food_allergies: updated_list);
      emit(
        state.copyWith(
          status: ProfileStatus.success,
          profile: updated_profile,
          temp_profile: updated_profile,
        ),
      );
    } else {
      final List<String> updated_list =
          List<String>.from(state.profile.medication_allergies)
            ..remove(allergy_name);
      final PatientProfile updated_profile =
          state.profile.copyWith(medication_allergies: updated_list);
      emit(
        state.copyWith(
          status: ProfileStatus.success,
          profile: updated_profile,
          temp_profile: updated_profile,
        ),
      );
    }
  }

  // Add rich prescription map entry to the patient medications list
  void add_prescription(Map<String, dynamic> prescription_data) {
    // Verify medication name is valid after trim checks
    final String name = (prescription_data['name'] as String? ?? '').trim();
    // Return early if the name field is empty
    if (name.isEmpty) {
      return;
    } else {
      // Clone prescriptions list appending new rich entry
      final List<Map<String, dynamic>> updated_list =
          List<Map<String, dynamic>>.from(state.profile.prescriptions)
            ..add(prescription_data);
      // Clone profile structures with updated list
      final PatientProfile updated_profile =
          state.profile.copyWith(prescriptions: updated_list);
      // Emit updated states
      emit(
        // Copy configs
        state.copyWith(
          // Status success
          status: ProfileStatus.success,
          // Bind profile
          profile: updated_profile,
          // Bind temp copy
          temp_profile: updated_profile,
        ),
      );
    }
  }

  // Remove a prescription entry by its unique id field from the list
  void remove_prescription(String prescription_id) {
    // Filter out the entry matching the given id
    final List<Map<String, dynamic>> updated_list =
        List<Map<String, dynamic>>.from(state.profile.prescriptions)
          ..removeWhere((item) => item['id'] == prescription_id);
    // Clone profile with filtered list
    final PatientProfile updated_profile =
        state.profile.copyWith(prescriptions: updated_list);
    // Emit updated state
    emit(
      state.copyWith(
        status: ProfileStatus.success,
        profile: updated_profile,
        temp_profile: updated_profile,
      ),
    );
  }

  // Update an existing prescription entry in the patient medications list
  void update_prescription(
      String prescription_id, Map<String, dynamic> updated_data) {
    // Clone prescriptions list mapping the target element to its new state
    final List<Map<String, dynamic>> updated_list =
        state.profile.prescriptions.map((item) {
      if (item['id'] == prescription_id) {
        return updated_data;
      } else {
        return item;
      }
    }).toList();

    // Clone profile structures with updated list
    final PatientProfile updated_profile =
        state.profile.copyWith(prescriptions: updated_list);

    // Emit updated states
    emit(
      state.copyWith(
        status: ProfileStatus.success,
        profile: updated_profile,
        temp_profile: updated_profile,
      ),
    );
  }

  // Set the default payment card by updating the list of cards in state
  void set_default_card(String card_id) {
    // Clone and map payment cards list setting the target card to true and others to false
    final List<Map<String, dynamic>> updated_cards =
        state.profile.payment_cards.map((card) {
      // Map to mutable map so we can set values
      final Map<String, dynamic> mutable_card = Map<String, dynamic>.from(card);
      if (card['id'] == card_id) {
        mutable_card['is_default'] = 'true';
      } else {
        mutable_card['is_default'] = 'false';
      }
      return mutable_card;
    }).toList();

    // Clone profile structures with updated list
    final PatientProfile updated_profile =
        state.profile.copyWith(payment_cards: updated_cards);

    // Emit updated states
    emit(
      state.copyWith(
        status: ProfileStatus.success,
        profile: updated_profile,
        temp_profile: updated_profile,
      ),
    );
  }

  // Add a new payment card to the patient profile
  void add_payment_card(Map<String, dynamic> card_data) {
    // Clone payment cards list appending new card
    final List<Map<String, dynamic>> updated_cards =
        List<Map<String, dynamic>>.from(state.profile.payment_cards)
          ..add(card_data);

    // Clone profile structures with updated list
    final PatientProfile updated_profile =
        state.profile.copyWith(payment_cards: updated_cards);

    // Emit updated states
    emit(
      state.copyWith(
        status: ProfileStatus.success,
        profile: updated_profile,
        temp_profile: updated_profile,
      ),
    );
  }

  // Remove a payment card from the patient profile by its unique id
  void remove_payment_card(String card_id) {
    // Clone payment cards list removing the target card
    final List<Map<String, dynamic>> updated_cards =
        List<Map<String, dynamic>>.from(state.profile.payment_cards)
          ..removeWhere((card) => card['id'] == card_id);

    // Clone profile structures with updated list
    final PatientProfile updated_profile =
        state.profile.copyWith(payment_cards: updated_cards);

    // Emit updated states
    emit(
      state.copyWith(
        status: ProfileStatus.success,
        profile: updated_profile,
        temp_profile: updated_profile,
      ),
    );
  }

  // Add diagnostic reports tests or scans file attachment metadata
  void add_test_result(
    String doc_name,
    String upload_date,
    String file_path,
    String scan_type, {
    String? facility_name,
    String status = 'normal',
    String? doctor_name,
    String? notes,
  }) {
    // Verify attachment name parameter is valid
    if (doc_name.trim().isEmpty) {
      // Return early
      return;
    } else {
      // Build test result instance mapping metadata fields
      final TestResult result = TestResult(
        // Bind document name
        document_name: doc_name.trim(),
        // Bind calendar date
        date: upload_date,
        // Bind document physical path
        document_path: file_path,
        // Bind result type indicator
        type: scan_type,
        // Bind facility name
        facility_name: facility_name,
        // Bind result status
        status: status,
        // Bind prescribing doctor
        doctor_name: doctor_name,
        // Bind additional notes
        notes: notes,
      );
      // Check scan type classification using Yoda comparisons
      if ('lab_test' == scan_type) {
        // Clone lab list adding result entry
        final List<TestResult> updated_list =
            List<TestResult>.from(state.profile.lab_tests)..add(result);
        // Clone profile model details
        final PatientProfile updated_profile =
            state.profile.copyWith(lab_tests: updated_list);
        // Emit updated states
        emit(
          // Copy configs
          state.copyWith(
            // Status success
            status: ProfileStatus.success,
            // Bind profile
            profile: updated_profile,
            // Bind temp copy
            temp_profile: updated_profile,
          ),
        );
      } else {
        // Clone scan list adding result entry
        final List<TestResult> updated_list =
            List<TestResult>.from(state.profile.scans)..add(result);
        // Clone profile details
        final PatientProfile updated_profile =
            state.profile.copyWith(scans: updated_list);
        // Emit updated states
        emit(
          // Copy configs
          state.copyWith(
            // Status success
            status: ProfileStatus.success,
            // Bind profile
            profile: updated_profile,
            // Bind temp copy
            temp_profile: updated_profile,
          ),
        );
      }
    }
  }

  // Toggle chronic conditions selection flags dynamically
  void toggle_chronic_condition(String condition_label) {
    // Verify condition parameter label is valid
    if (condition_label.trim().isEmpty) {
      // Return early
      return;
    } else {
      // Clone chronic conditions array list representation
      final List<String> updated_list =
          List<String>.from(state.profile.chronic_conditions);
      // Check if tag is already selected using list checks
      if (updated_list.contains(condition_label)) {
        // Remove item from active selection list
        updated_list.remove(condition_label);
      } else {
        // Append item to active selection list
        updated_list.add(condition_label);
      }
      // Clone profile models parameters
      final PatientProfile updated_profile =
          state.profile.copyWith(chronic_conditions: updated_list);
      // Emit updated states
      emit(
        // Copy configs
        state.copyWith(
          // Status success
          status: ProfileStatus.success,
          // Bind profile
          profile: updated_profile,
          // Bind temp copy
          temp_profile: updated_profile,
        ),
      );
    }
  }

  // Update a list field inside the patient profile dynamically
  void update_profile_field(String field, List<String> values) {
    PatientProfile updated_profile = state.profile;
    if ('food_allergies' == field) {
      updated_profile = state.profile.copyWith(food_allergies: values);
    } else if ('medication_allergies' == field) {
      updated_profile = state.profile.copyWith(medication_allergies: values);
    } else if ('chronic_conditions' == field) {
      updated_profile = state.profile.copyWith(chronic_conditions: values);
    }
    emit(
      state.copyWith(
        status: ProfileStatus.success,
        profile: updated_profile,
        temp_profile: updated_profile,
      ),
    );
  }

  // Add insurance card coverage information models
  void add_insurance_card(String card_name, String card_number,
      String provider_name, String document_path, String expiry_date) {
    // Verify insurance card name parameter is valid
    if (card_name.trim().isEmpty) {
      // Return early
      return;
    } else {
      // Build insurance card policy instance
      final InsuranceCard card = InsuranceCard(
        // Bind card name
        card_name: card_name.trim(),
        // Bind card number
        card_number: card_number.trim(),
        // Bind provider brand
        provider_name: provider_name.trim(),
        // Bind file attachment path
        document_path: document_path,
        // Bind policy expiry date
        expiry_date: expiry_date,
      );
      // Clone insurance list adding card entry
      final List<InsuranceCard> updated_list =
          List<InsuranceCard>.from(state.profile.insurance_cards)..add(card);
      // Clone profile specifications
      final PatientProfile updated_profile =
          state.profile.copyWith(insurance_cards: updated_list);
      // Emit updated state properties
      emit(
        // Copy state properties
        state.copyWith(
          // Status success
          status: ProfileStatus.success,
          // Bind profile
          profile: updated_profile,
          // Bind temp copy
          temp_profile: updated_profile,
        ),
      );
    }
  }

  // Remove insurance card by list index
  void remove_insurance_card(int index) {
    // Verify if index resides within bounds
    if (index < 0 || index >= state.profile.insurance_cards.length) {
      // Return early
      return;
    } else {
      // Clone insurance list removing card at index
      final List<InsuranceCard> updated_list =
          List<InsuranceCard>.from(state.profile.insurance_cards)
            ..removeAt(index);
      // Clone profile specifications
      final PatientProfile updated_profile =
          state.profile.copyWith(insurance_cards: updated_list);
      // Emit updated state properties
      emit(
        // Copy state properties
        state.copyWith(
          // Status success
          status: ProfileStatus.success,
          // Bind profile
          profile: updated_profile,
          // Bind temp copy
          temp_profile: updated_profile,
        ),
      );
    }
  }

  // Edit insurance card by list index
  void edit_insurance_card(int index, String card_name, String card_number,
      String provider_name, String document_path, String expiry_date) {
    // Verify if index resides within bounds or empty parameters
    if (index < 0 ||
        index >= state.profile.insurance_cards.length ||
        card_name.trim().isEmpty) {
      // Return early
      return;
    } else {
      // Build updated insurance card policy instance
      final InsuranceCard card = InsuranceCard(
        // Bind card name
        card_name: card_name.trim(),
        // Bind card number
        card_number: card_number.trim(),
        // Bind provider brand
        provider_name: provider_name.trim(),
        // Bind file attachment path
        document_path: document_path,
        // Bind policy expiry date
        expiry_date: expiry_date,
      );
      // Clone insurance list
      final List<InsuranceCard> updated_list =
          List<InsuranceCard>.from(state.profile.insurance_cards);
      // Replace item at index
      updated_list[index] = card;
      // Clone profile specifications
      final PatientProfile updated_profile =
          state.profile.copyWith(insurance_cards: updated_list);
      // Emit updated state properties
      emit(
        // Copy state properties
        state.copyWith(
          // Status success
          status: ProfileStatus.success,
          // Bind profile
          profile: updated_profile,
          // Bind temp copy
          temp_profile: updated_profile,
        ),
      );
    }
  }
}
