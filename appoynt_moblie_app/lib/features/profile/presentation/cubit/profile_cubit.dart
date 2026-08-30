/*
 * File Name: profile_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.5.0
 * Dependencies: package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart,
 *   package:appoynt_mobile_app/features/profile/domain/entities/patient_profile.dart,
 *   package:appoynt_mobile_app/features/profile/domain/entities/insurance_card.dart,
 *   package:appoynt_mobile_app/features/profile/domain/entities/test_result.dart,
 *   package:image_picker/image_picker.dart,
 *   package:appoynt_mobile_app/core/error/error_handler.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Implements the Patient Profile Cubit orchestrating UI updates,
 *   validations, local photo staging, and saves/deletions on form submit.
 */

import 'dart:io';
import 'package:flutter/painting.dart';
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
import 'package:appoynt_mobile_app/core/error/error_handler.dart';
import 'package:appoynt_mobile_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:appoynt_mobile_app/features/profile/data/models/change_password_request_model.dart';
import 'package:appoynt_mobile_app/features/profile/data/models/update_profile_request_model.dart';
import 'package:appoynt_mobile_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:appoynt_mobile_app/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:appoynt_mobile_app/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart';
// Importing GovernorateModel & CityModel representations
import 'package:appoynt_mobile_app/features/profile/data/models/governorate_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
// Importing image_picker for camera and gallery photo selection
import 'package:image_picker/image_picker.dart';
// Importing upload profile photo use case for Clean Architecture compliance
import 'package:appoynt_mobile_app/features/profile/domain/usecases/upload_profile_photo_usecase.dart';
// Importing delete profile photo use case for Clean Architecture compliance
import 'package:appoynt_mobile_app/features/profile/domain/usecases/delete_profile_photo_usecase.dart';

// Profile business logic Cubit controller class
class ProfileCubit extends Cubit<ProfileState> {
  // Cascading Governorates & Cities for Address Selection
  List<GovernorateModel> governoratesList = [];
  List<CityModel> citiesList = [];
  GovernorateModel? selectedGovernorate;
  CityModel? selectedCity;
  bool isGovernoratesLoading = false;
  bool isCitiesLoading = false;

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

  // Fetches Egyptian Governorates lookup dataset
  Future<void> fetchGovernorates({
    dynamic initialGovId,
    dynamic initialCityId,
    String? initialGovName,
    String? initialCityName,
  }) async {
    isGovernoratesLoading = true;
    if (!isClosed) {
      emit(state.copyWith(
        profile: state.profile,
        temp_profile: state.temp_profile,
      ));
    } else {
      // Cubit closed
    }

    try {
      final List<GovernorateModel> data =
          await get_it<ProfileRepository>().getGovernorates();
      governoratesList = data;
      debugPrint(
          '[ProfileCubit] Loaded ${governoratesList.length} governorates successfully.');

      if (initialGovId != null) {
        for (final gov in governoratesList) {
          if (gov.id.toString() == initialGovId.toString()) {
            selectedGovernorate = gov;
            break;
          } else {
            // Check next
          }
        }
      } else if (initialGovName != null && initialGovName.trim().isNotEmpty) {
        final String search = initialGovName.trim().toLowerCase();
        for (final gov in governoratesList) {
          if (gov.nameEn.toLowerCase() == search ||
              gov.nameAr.toLowerCase() == search) {
            selectedGovernorate = gov;
            break;
          } else {
            // Check next
          }
        }
      } else {
        // No initial governorate match
      }

      if (selectedGovernorate != null) {
        if (initialCityId != null) {
          for (final city in selectedGovernorate!.cities) {
            if (city.id.toString() == initialCityId.toString()) {
              selectedCity = city;
              break;
            } else {
              // Check next
            }
          }
        } else if (initialCityName != null &&
            initialCityName.trim().isNotEmpty) {
          final String searchCity = initialCityName.trim().toLowerCase();
          for (final city in selectedGovernorate!.cities) {
            if (city.nameEn.toLowerCase() == searchCity ||
                city.nameAr.toLowerCase() == searchCity) {
              selectedCity = city;
              break;
            } else {
              // Check next
            }
          }
        } else {
          // No initial city match
        }
      } else {
        // No governorate selected
      }
      isGovernoratesLoading = false;
      if (!isClosed) {
        emit(state.copyWith(
          profile: state.profile,
          temp_profile: state.temp_profile,
        ));
      } else {
        // Cubit closed
      }
    } catch (e) {
      governoratesList = [];
      isGovernoratesLoading = false;
      debugPrint('[ProfileCubit] Failed to load governorates from API: $e.');
      if (!isClosed) {
        emit(state.copyWith(
          profile: state.profile,
          temp_profile: state.temp_profile,
        ));
      } else {
        // Cubit closed
      }
    }
  }

  /// Matches and binds governorate and city from profile model into cubit selection state
  void populateProfileData(UserProfileModel profile) {
    if (governoratesList.isNotEmpty) {
      try {
        selectedGovernorate = governoratesList.firstWhere(
          (gov) =>
              gov.id.toString() == profile.governorateId?.toString() ||
              (profile.governorateName != null &&
                  gov.nameEn.toLowerCase() ==
                      profile.governorateName!.toLowerCase()) ||
              (profile.governorateName != null &&
                  gov.nameAr == profile.governorateName),
        );
        if (selectedGovernorate != null &&
            selectedGovernorate!.cities.isNotEmpty) {
          citiesList = selectedGovernorate!.cities;
          selectedCity = citiesList.firstWhere(
            (city) =>
                city.id.toString() == profile.cityId?.toString() ||
                (profile.cityName != null &&
                    city.nameEn.toLowerCase() ==
                        profile.cityName!.toLowerCase()) ||
                (profile.cityName != null && city.nameAr == profile.cityName),
          );
        } else {
          // No action needed
        }
      } catch (_) {
        // Fallback safely if not found
      }
    } else {
      // No action needed
    }
  }

  // Handles governorate selection and fetches dependent cities
  Future<void> onGovernorateChanged(GovernorateModel? gov) async {
    if (gov == null) {
      selectedGovernorate = null;
      selectedCity = null;
      citiesList = [];
      if (!isClosed) {
        emit(state.copyWith(
          profile: state.profile,
          temp_profile: state.temp_profile,
        ));
      } else {
        // Cubit closed
      }
      return;
    } else {
      selectedGovernorate = gov;
      selectedCity = null; // Auto-reset city selection
      citiesList = [];
    }

    // If cities are already embedded in the governorate object, use them directly:
    if (gov.cities.isNotEmpty) {
      citiesList = gov.cities;
      if (!isClosed) {
        emit(state.copyWith(
          profile: state.profile,
          temp_profile: state.temp_profile,
        ));
      } else {
        // Cubit closed
      }
      return;
    } else {
      // Otherwise, fetch cities from the API dynamically:
      isCitiesLoading = true;
      if (!isClosed) {
        emit(state.copyWith(
          profile: state.profile,
          temp_profile: state.temp_profile,
        ));
      } else {
        // Cubit closed
      }
    }

    try {
      final fetchedCities =
          await get_it<ProfileRepository>().getCitiesByGovernorate(gov.id);
      citiesList = fetchedCities;
      isCitiesLoading = false;
      debugPrint(
          '[ProfileCubit] Loaded ${citiesList.length} cities for ${gov.nameEn}');
      if (!isClosed) {
        emit(state.copyWith(
          profile: state.profile,
          temp_profile: state.temp_profile,
        ));
      } else {
        // Cubit closed
      }
    } catch (e) {
      isCitiesLoading = false;
      debugPrint('[ProfileCubit] Failed to load cities: $e');
      if (!isClosed) {
        emit(state.copyWith(
          profile: state.profile,
          temp_profile: state.temp_profile,
        ));
      } else {
        // Cubit closed
      }
    }
  }

  // Handles city selection
  void onCityChanged(CityModel? city) {
    selectedCity = city;
    if (!isClosed) {
      emit(state.copyWith(
        profile: state.profile,
        temp_profile: state.temp_profile,
      ));
    } else {
      // Cubit closed
    }
  }

  // Fetches the user profile data from the remote API and updates state
  Future<void> fetchUserProfile() async {
    // Get safe fallback profile if state.profile is null or uninitialized
    final PatientProfile currentProfile = state.profile;
    final PatientProfile currentTempProfile = state.temp_profile;

    // Emit ProfileLoading state to trigger loading UI
    emit(ProfileLoading(
      // Keep existing profile
      profile: currentProfile,
      // Keep existing temp profile
      temp_profile: currentTempProfile,
      // Keep existing dirty state
      is_dirty: state.is_dirty,
    ));

    // Try catch block to handle network exceptions
    try {
      // 1. Fetch user profile from API
      final user_profile = await get_it<GetUserProfileUseCase>().call();
      populateProfileData(user_profile);

      // 2. Safely map API response to domain PatientProfile entity
      final loaded_profile = PatientProfile(
        // Map first name safely
        first_name: user_profile.first_name.isNotEmpty
            ? user_profile.first_name
            : currentProfile.first_name,
        // Map last name safely
        last_name: user_profile.last_name.isNotEmpty
            ? user_profile.last_name
            : currentProfile.last_name,
        // Map phone number safely
        phone: user_profile.phone_number.isNotEmpty
            ? user_profile.phone_number
            : currentProfile.phone,
        // Map email safely
        email: user_profile.email.isNotEmpty
            ? user_profile.email
            : currentProfile.email,
        // Convert gender integer to localized text string
        gender: 0 == user_profile.gender
            ? 'Male'
            : (1 == user_profile.gender ? 'Female' : currentProfile.gender),
        // Map address with fallback
        address: user_profile.address ?? currentProfile.address,
        // Map national ID from model or keep local
        national_id: (user_profile.national_id != null &&
                user_profile.national_id!.isNotEmpty)
            ? user_profile.national_id!
            : currentProfile.national_id,
        // Map weight from model or keep local
        weight: user_profile.weight ?? currentProfile.weight,
        // Map height from model or keep local
        height: user_profile.height ?? currentProfile.height,
        // Map blood group from model or keep local
        blood_group: user_profile.blood_group ?? currentProfile.blood_group,
        // Keep existing local smoking status
        smoking: currentProfile.smoking,
        // Keep existing local food allergies
        food_allergies: currentProfile.food_allergies,
        // Keep existing local medication allergies
        medication_allergies: currentProfile.medication_allergies,
        // Keep existing local prescriptions
        prescriptions: currentProfile.prescriptions,
        // Keep existing local lab tests
        lab_tests: currentProfile.lab_tests,
        // Keep existing local scans
        scans: currentProfile.scans,
        // Keep existing local chronic conditions
        chronic_conditions: currentProfile.chronic_conditions,
        // Keep existing local insurance cards
        insurance_cards: currentProfile.insurance_cards,
        // Keep existing local avatar url
        avatar_url: currentProfile.avatar_url,
        // Keep existing local payment cards
        payment_cards: currentProfile.payment_cards,
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
    } on DioException catch (e) {
      // Ignore 401 errors here since AuthInterceptor delegates to SessionManager / AuthCubit logout
      if (401 == e.response?.statusCode) {
        return;
      } else {
        final String clean_msg = ErrorHandler.handleDioError(e);
        // Emit ProfileUpdateError state with the clean error message
        emit(ProfileUpdateError(
          // Set error message
          message: clean_msg,
          // Keep existing profile
          profile: currentProfile,
          // Keep existing temp profile
          temp_profile: currentTempProfile,
          // Keep existing dirty status
          is_dirty: state.is_dirty,
        ));
      }
    } catch (e) {
      // General error catch block
      emit(ProfileUpdateError(
        message: 'Failed to load profile. Please try again.',
        profile: currentProfile,
        temp_profile: currentTempProfile,
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
      populateProfileData(cached_profile);
      // Also read the cached photo URL for instant avatar rendering
      final String? cached_photo_url =
          await get_it<ProfileRepository>().getCachedProfilePhotoUrl();
      // Map cached UserProfileModel into PatientProfile domain entity structure
      // Pass resolved photo URL so avatar renders with zero network delay
      final PatientProfile cached_entity = _map_model_to_entity(
        cached_profile,
        // Provide photo URL from cache when available
        resolved_photo_url: cached_photo_url,
      );
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
      populateProfileData(fresh_profile);
      // Read updated photo URL from local cache (refreshed inside getUserProfile)
      final String? fresh_photo_url =
          await get_it<ProfileRepository>().getCachedProfilePhotoUrl();
      // Map fresh remote model into the PatientProfile domain entity structure
      // Pass updated photo URL so avatar stays current after background refresh
      final PatientProfile fresh_entity = _map_model_to_entity(
        fresh_profile,
        // Provide freshly derived photo URL from cache
        resolved_photo_url: fresh_photo_url,
      );

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

  // Private helper: maps a UserProfileModel API response to PatientProfile entity.
  // Accepts an optional resolved_photo_url to populate avatar_url directly from
  // the local cache or post-upload response without a redundant network call.
  PatientProfile _map_model_to_entity(
    UserProfileModel model, {
    // Optional pre-resolved profile photo URL from cache or upload response
    String? resolved_photo_url,
  }) {
    final PatientProfile baseProfile = state.profile;
    // Return a fully populated PatientProfile using the model field values
    return PatientProfile(
      // Map first name from the API model
      first_name: model.first_name.isNotEmpty
          ? model.first_name
          : baseProfile.first_name,
      // Map last name from the API model
      last_name: model.last_name.isNotEmpty
          ? model.last_name
          : baseProfile.last_name,
      // Map phone number from the API model
      phone: model.phone_number.isNotEmpty
          ? model.phone_number
          : baseProfile.phone,
      // Map email from the API model
      email: model.email.isNotEmpty ? model.email : baseProfile.email,
      // Map gender integer (0=Male, 1=Female) to display string
      gender: 0 == model.gender
          ? 'Male'
          : (1 == model.gender ? 'Female' : baseProfile.gender),
      // Map address from the API model with fallback
      address: model.address ?? baseProfile.address,
      // Map national ID from the API model or carry existing
      national_id: (model.national_id != null && model.national_id!.isNotEmpty)
          ? model.national_id!
          : baseProfile.national_id,
      // Map weight from the API model or carry existing
      weight: model.weight ?? baseProfile.weight,
      // Map height from the API model or carry existing
      height: model.height ?? baseProfile.height,
      // Map blood group from the API model or carry existing
      blood_group: model.blood_group ?? baseProfile.blood_group,
      // Carry existing local smoking status (not in API response)
      smoking: baseProfile.smoking,
      // Carry existing local food allergies (not in API response)
      food_allergies: baseProfile.food_allergies,
      // Carry existing local medication allergies (not in API response)
      medication_allergies: baseProfile.medication_allergies,
      // Carry existing local prescriptions (not in API response)
      prescriptions: baseProfile.prescriptions,
      // Carry existing local lab tests (not in API response)
      lab_tests: baseProfile.lab_tests,
      // Carry existing local scans (not in API response)
      scans: baseProfile.scans,
      // Carry existing local chronic conditions (not in API response)
      chronic_conditions: baseProfile.chronic_conditions,
      // Carry existing local insurance cards (not in API response)
      insurance_cards: baseProfile.insurance_cards,
      // Use resolved photo URL when provided, otherwise carry existing local URL
      avatar_url: resolved_photo_url ?? baseProfile.avatar_url,
      // Carry existing local payment cards (not in API response)
      payment_cards: baseProfile.payment_cards,
    );
  }

  // Updates the user profile data via the remote API
  Future<void> updateUserProfile(UpdateProfileRequestModel requestModel) async {
    // 1. Capture staged image and delete flag before any state transition
    final File? imageToUpload = state.staged_profile_image;
    final bool shouldDelete = state.is_photo_deleted;

    debugPrint(
      '[ProfileCubit] Attempting to save profile. Staged image path: ${imageToUpload?.path}, shouldDelete: $shouldDelete',
    );

    // Emit ProfileUpdating state preserving the staged image
    emit(ProfileUpdating(
      // Keep existing profile
      profile: state.profile,
      // Keep existing temp profile
      temp_profile: state.temp_profile,
      // Keep existing dirty status
      is_dirty: state.is_dirty,
      staged_profile_image: imageToUpload,
      is_photo_deleted: shouldDelete,
    ));
    // Try catch block to handle network exceptions
    try {
      // 2. Process any staged photo deletion or upload before updating profile info
      if (shouldDelete) {
        debugPrint('[ProfileCubit] Deleting profile photo...');
        await get_it<DeleteProfilePhotoUseCase>().call();
      } else if (null != imageToUpload) {
        debugPrint('[ProfileCubit] Uploading staged image: ${imageToUpload.path}');
        await get_it<UploadProfilePhotoUseCase>().call(imageToUpload.path);
      } else {
        // No staged photo changes
      }

      // 3. Call UpdateUserProfileUseCase to perform PUT /api/patients/profile
      await get_it<UpdateUserProfileUseCase>().call(requestModel);

      // 3. Clear Flutter imageCache to invalidate stale network image
      try {
        PaintingBinding.instance.imageCache.clear();
        PaintingBinding.instance.imageCache.clearLiveImages();
      } catch (_) {
        // Safe fallback in headless/test environments
      }

      // 4. Re-fetch fresh UserProfileModel from GET /api/patients/profile (also updates cache)
      final UserProfileModel fresh_user =
          await get_it<GetUserProfileUseCase>().call();
      // Read updated photo URL from local cache
      final String? fresh_photo_url =
          await get_it<ProfileRepository>().getCachedProfilePhotoUrl();
      // Map fresh model into domain entity
      final PatientProfile saved_profile = _map_model_to_entity(
        fresh_user,
        resolved_photo_url: fresh_photo_url,
      );
      // Emit ProfileUpdateSuccess state with fresh user model and mapped patient profile
      emit(ProfileUpdateSuccess(
        user: fresh_user,
        profile: saved_profile,
        temp_profile: saved_profile,
        is_dirty: false,
      ));
      // Emit ProfileLoaded state so all listening views refresh UI immediately
      emit(ProfileLoaded(
        user: fresh_user,
        profile: saved_profile,
        temp_profile: saved_profile,
        is_dirty: false,
      ));
      // Catch DioException to extract clean error message via ErrorHandler
    } on DioException catch (dio_error) {
      final String clean_message = ErrorHandler.handleDioError(dio_error);
      // Emit ProfileUpdateError state with extracted clean error message
      emit(ProfileUpdateError(
        message: clean_message,
        profile: state.profile,
        temp_profile: state.temp_profile,
        is_dirty: state.is_dirty,
      ));
    } catch (e) {
      // Emit ProfileUpdateError state with generic failure description
      emit(ProfileUpdateError(
        message: 'Failed to update profile. Please try again.',
        profile: state.profile,
        temp_profile: state.temp_profile,
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

    if (currentPwTrimmed.isEmpty) {
      emit(state.copyWith(
        status: ProfileStatus.passwordError,
        error_message: 'Current password cannot be empty.',
      ));
      return;
    } else {
      // Input is non-empty
    }

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
      final String errorMsg = ErrorHandler.handleDioError(e);
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
    } else {
      // No action needed
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

  // Presents a Camera/Gallery picker bottom sheet, then uploads the selected
  // image to POST /api/patients/profile-photo. Emits avatarUploading during
  // the upload, avatarUploadSuccess with the new URL on success, or
  // avatarUploadError with a message on failure.
  Future<void> pick_and_upload_avatar() async {
    // Instantiate the image picker service singleton
    final ImagePicker picker = ImagePicker();
    // Emit a brief avatarUploading status to signal picker is opening
    // (prevents double-taps during processing)
    emit(state.copyWith(status: ProfileStatus.avatarUploading));
    // Present the image source selection bottom sheet
    // NOTE: We call showDialog equivalent via ImagePicker directly here.
    // The picker returns null when the user cancels without selecting.
    XFile? picked_file;
    // Attempt to pick an image from the gallery as the default source
    // The actual source selection (camera vs gallery) is handled in the widget
    // layer via the _show_avatar_source_sheet helper — the cubit receives the
    // already-resolved XFile path from the widget to maintain SRP.
    // This method is called with a pre-selected source by the avatar widget.
    try {
      // Pick image from the gallery — source override provided by caller context
      picked_file = await picker.pickImage(
        // Default source: gallery — widget layer overrides this for camera
        source: ImageSource.gallery,
        // Limit maximum image dimension to 1024px to reduce upload payload size
        maxWidth: 1024.0,
        // Limit maximum height dimension to 1024px
        maxHeight: 1024.0,
        // Compress image quality to 85% to balance size vs visual fidelity
        imageQuality: 85,
      );
    } catch (picker_error) {
      // Picker failed or permission denied — emit error and abort
      debugPrint('[ProfileCubit] Image picker failed: $picker_error');
      // Emit avatarUploadError status with descriptive message
      if (!isClosed) {
        emit(state.copyWith(
          // Set avatar upload error status
          status: ProfileStatus.avatarUploadError,
          // Map picker error message for display
          error_message: 'Image selection failed: $picker_error',
        ));
      } else {
        // Cubit was closed — discard error emit safely
      }
      // Return early to abort upload sequence
      return;
    }
    // Guard: user cancelled the picker without selecting an image
    if (null == picked_file) {
      // Revert to previous success status — no upload action taken
      if (!isClosed) {
        emit(state.copyWith(status: ProfileStatus.success));
      } else {
        // Cubit was closed — discard revert emit safely
      }
      // Return early when no file was selected
      return;
    } else {
      // File was selected — proceed with the upload sequence
    }
    // Extract the local file path string from the XFile instance
    final String file_path = picked_file.path;
    // Emit avatarUploading status to display spinner overlay on avatar widget
    if (!isClosed) {
      emit(state.copyWith(status: ProfileStatus.avatarUploading));
    } else {
      // Cubit was closed — abort upload sequence
      return;
    }
    // Execute the upload request via the repository upload method
    try {
      // Call upload use case (Clean Architecture: cubit → use case → repository)
      final String new_photo_url =
          await get_it<UploadProfilePhotoUseCase>().call(file_path);
      // Update profile entity with the new resolved network URL immediately
      final PatientProfile updated_profile =
          state.profile.copyWith(avatar_url: new_photo_url);
      // Guard against emitting on a closed cubit after the async upload call
      if (!isClosed) {
        // Emit success state with the updated profile carrying the new URL
        emit(state.copyWith(
          // Set avatar upload success status
          status: ProfileStatus.avatarUploadSuccess,
          // Bind updated profile with new avatar URL
          profile: updated_profile,
          // Sync temp profile to avoid stale comparison on next dirty check
          temp_profile: updated_profile,
        ));
        // Log successful upload completion for diagnostics
        debugPrint(
          '[ProfileCubit] Avatar upload success. New URL: $new_photo_url',
        );
      } else {
        // Cubit was closed before success emit — discard result safely
      }
    } on DioException catch (dio_error) {
      final String error_msg = ErrorHandler.handleDioError(dio_error);
      // Guard against emitting on a closed cubit
      if (!isClosed) {
        // Emit avatar upload error state with descriptive message
        emit(state.copyWith(
          // Set avatar upload error status
          status: ProfileStatus.avatarUploadError,
          // Bind extracted error message for SnackBar display
          error_message: error_msg,
        ));
      } else {
        // Cubit was closed — discard error emit safely
      }
      // Log the Dio network error for diagnostics
      debugPrint('[ProfileCubit] Avatar upload DioException: $dio_error');
    } catch (generic_error) {
      // Guard against emitting on a closed cubit
      if (!isClosed) {
        // Emit avatar upload error state for unexpected exceptions
        emit(state.copyWith(
          // Set avatar upload error status
          status: ProfileStatus.avatarUploadError,
          // Provide generic user-facing error message
          error_message: 'An unexpected error occurred during upload.',
        ));
      } else {
        // Cubit was closed — discard error emit safely
      }
      // Log the generic error for diagnostics
      debugPrint('[ProfileCubit] Avatar upload error: $generic_error');
    }
  }

  // Launches the image picker for a specific source (camera or gallery),
  // and stages the selected image locally in state without calling the API.
  Future<void> pick_and_stage_avatar_from_source(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? picked_file = await picker.pickImage(
        source: source,
        maxWidth: 1024.0,
        maxHeight: 1024.0,
        imageQuality: 85,
      );
      if (null != picked_file) {
        final File staged_file = File(picked_file.path);
        if (!isClosed) {
          emit(state.copyWith(
            staged_profile_image: staged_file,
            is_photo_deleted: false,
            is_dirty: true,
          ));
        } else {
          // Cubit closed — discard emit
        }
      } else {
        // User cancelled picker
      }
    } catch (picker_error) {
      debugPrint('[ProfileCubit] Picker error: $picker_error');
      if (!isClosed) {
        emit(state.copyWith(
          error_message: 'Image selection failed. Please try again.',
        ));
      } else {
        // Cubit closed — discard emit
      }
    }
  }

  // Alias for pickImage
  Future<void> pickImage(ImageSource source) =>
      pick_and_stage_avatar_from_source(source);

  // Backward compatibility alias for immediate source picker calls
  Future<void> pick_and_upload_avatar_from_source(ImageSource source) =>
      pick_and_stage_avatar_from_source(source);

  // Stages photo deletion locally without calling the API.
  void stage_photo_deletion() {
    if (!isClosed) {
      emit(state.copyWith(
        clear_staged_image: true,
        is_photo_deleted: true,
        is_dirty: true,
      ));
    } else {
      // Cubit closed — discard emit
    }
  }

  // Alias for stagePhotoDeletion
  void stagePhotoDeletion() => stage_photo_deletion();

  // Backward compatibility alias for photo deletion
  Future<void> remove_profile_photo() async => stage_photo_deletion();

  // Backward compatibility camelCase alias
  Future<void> removeProfilePhoto() async => stage_photo_deletion();

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
