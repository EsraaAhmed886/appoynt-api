/*
 * File Name: edit_profile_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/08/2026
 * Version Information: V1.2.0
 * Dependencies: dart:io, package:flutter/painting.dart,
 *   package:flutter_bloc/flutter_bloc.dart, package:image_picker/image_picker.dart,
 *   package:appoynt_mobile_app/features/profile/domain/repositories/profile_repository.dart,
 *   package:appoynt_mobile_app/features/profile/data/models/governorate_model.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 29/08/2026]
 * File Description: Cubit managing the Edit Profile flow by staging photo picks and deletions,
 *   loading cascading Egyptian Governorates and Cities, and updating backend profile data.
 */

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appoynt_mobile_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:appoynt_mobile_app/features/profile/data/models/governorate_model.dart';
import 'package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final ProfileRepository profileRepository;
  final ImagePicker _picker = ImagePicker();

  List<GovernorateModel> governorates = [];
  List<CityModel> cities = [];
  GovernorateModel? selectedGovernorate;
  CityModel? selectedCity;
  bool isCitiesLoading = false;

  List<GovernorateModel> get governoratesList => governorates;
  List<CityModel> get citiesList => cities;

  EditProfileCubit({required this.profileRepository})
      : super(const EditProfileState());

  // Alias for fetchGovernorates matching user specification
  Future<void> fetchGovernorates({
    dynamic initialGovId,
    dynamic initialCityId,
    String? initialGovName,
    String? initialCityName,
  }) =>
      loadGovernorates(
        initialGovId: initialGovId,
        initialCityId: initialCityId,
        initialGovName: initialGovName,
        initialCityName: initialCityName,
      );

  // 1. Load Governorates & Cities
  Future<void> loadGovernorates({
    dynamic initialGovId,
    dynamic initialCityId,
    String? initialGovName,
    String? initialCityName,
  }) async {
    emit(state.copyWith(
      isGovernoratesLoading: true,
      governoratesError: null,
    ));

    try {
      final List<GovernorateModel> data =
          await profileRepository.getGovernorates();
      governorates = data;

      // Resolve initial selections if provided
      if (initialGovId != null) {
        for (final gov in governorates) {
          if (gov.id.toString() == initialGovId.toString()) {
            selectedGovernorate = gov;
            break;
          } else {
            // Check next
          }
        }
      } else if (initialGovName != null && initialGovName.trim().isNotEmpty) {
        final String search = initialGovName.trim().toLowerCase();
        for (final gov in governorates) {
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

      // If a governorate was resolved, populate cities
      if (selectedGovernorate != null) {
        if (selectedGovernorate!.cities.isNotEmpty) {
          cities = selectedGovernorate!.cities;
        } else {
          cities = await profileRepository
              .getCitiesByGovernorate(selectedGovernorate!.id);
        }

        if (initialCityId != null) {
          for (final city in cities) {
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
          for (final city in cities) {
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

      emit(state.copyWith(
        governorates: governorates,
        selectedGovernorate: selectedGovernorate,
        selectedCity: selectedCity,
        cities: cities,
        isGovernoratesLoading: false,
      ));
    } catch (e) {
      governorates = [];
      emit(state.copyWith(
        governorates: governorates,
        isGovernoratesLoading: false,
        governoratesError: e.toString(),
      ));
    }
  }

  // 2. Select Governorate & Fetch Cities
  Future<void> selectGovernorate(GovernorateModel? governorate) async {
    if (governorate == null) {
      selectedGovernorate = null;
      selectedCity = null;
      cities = [];
      emit(state.copyWith(
        selectedGovernorate: null,
        clearSelectedGovernorate: true,
        selectedCity: null,
        clearSelectedCity: true,
        cities: [],
        isCitiesLoading: false,
      ));
      return;
    } else {
      selectedGovernorate = governorate;
      selectedCity = null; // Reset city selection
      cities = [];
    }

    // If cities are already embedded in the governorate object, use them directly:
    if (governorate.cities.isNotEmpty) {
      cities = governorate.cities;
      emit(state.copyWith(
        selectedGovernorate: governorate,
        selectedCity: null,
        clearSelectedCity: true,
        cities: cities,
        isCitiesLoading: false,
      ));
      return;
    } else {
      // Otherwise, fetch cities dynamically:
      isCitiesLoading = true;
      emit(state.copyWith(
        selectedGovernorate: governorate,
        selectedCity: null,
        clearSelectedCity: true,
        cities: [],
        isCitiesLoading: true,
      ));
    }

    try {
      final fetchedCities =
          await profileRepository.getCitiesByGovernorate(governorate.id);
      cities = fetchedCities;
      isCitiesLoading = false;
      debugPrint(
          '[EditProfileCubit] Loaded ${cities.length} cities for ${governorate.nameEn}');
      emit(state.copyWith(
        cities: cities,
        isCitiesLoading: false,
      ));
    } catch (e) {
      isCitiesLoading = false;
      debugPrint('[EditProfileCubit] Failed to load cities: $e');
      emit(state.copyWith(
        cities: cities,
        isCitiesLoading: false,
        citiesError: e.toString(),
      ));
    }
  }

  // Alias for onGovernorateChanged
  void onGovernorateChanged(GovernorateModel? governorate) =>
      selectGovernorate(governorate);

  // 3. Select City
  void selectCity(CityModel? city) {
    selectedCity = city;
    emit(state.copyWith(
      selectedCity: city,
    ));
  }

  // Alias for onCityChanged
  void onCityChanged(CityModel? city) => selectCity(city);

  /// Matches and binds governorate and city from profile model into cubit selection state
  void populateProfileData(UserProfileModel profile) {
    if (governorates.isNotEmpty) {
      try {
        selectedGovernorate = governorates.firstWhere(
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
          cities = selectedGovernorate!.cities;
          selectedCity = cities.firstWhere(
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
      emit(state.copyWith(
        governorates: governorates,
        selectedGovernorate: selectedGovernorate,
        selectedCity: selectedCity,
        cities: cities,
      ));
    } else {
      // No action needed
    }
  }

  // 4. Pick Image (Gallery / Camera) - LOCAL STAGING ONLY
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (null != pickedFile) {
        emit(state.copyWith(
          stagedProfileImage: File(pickedFile.path),
          isPhotoDeleted: false,
        ));
      } else {
        // User cancelled image selection
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to select image. Please try again.',
      ));
    }
  }

  // 5. Stage Photo Removal - LOCAL STAGING ONLY
  void stagePhotoDeletion() {
    emit(state.copyWith(
      clearStagedImage: true,
      isPhotoDeleted: true,
    ));
  }

  // 6. Save All Profile Changes (Text fields + Staged Image)
  Future<void> saveProfile({
    required String firstName,
    required String lastName,
    required String phone,
    String? address,
    dynamic governorateId,
    String? governorateName,
    dynamic cityId,
    String? cityName,
    String? nationalId,
    String? birthDate,
  }) async {
    // 1. Capture the staged image before any async state mutation
    final File? imageToUpload = state.stagedProfileImage;
    final bool shouldDelete = state.isPhotoDeleted;

    // Compose resolved address if omitted
    String? resolvedAddress = address;
    if (null == resolvedAddress || resolvedAddress.trim().isEmpty) {
      final String? cName = cityName ?? selectedCity?.nameEn;
      final String? gName = governorateName ?? selectedGovernorate?.nameEn;
      if (null != cName && null != gName) {
        resolvedAddress = '$cName, $gName';
      } else if (null != cName) {
        resolvedAddress = cName;
      } else if (null != gName) {
        resolvedAddress = gName;
      } else {
        resolvedAddress = null;
      }
    } else {
      // Address provided explicitly
    }

    debugPrint(
      '[EditProfileCubit] Attempting to save profile. Staged image path: ${imageToUpload?.path}, shouldDelete: $shouldDelete',
    );

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      await profileRepository.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        address: resolvedAddress,
        nationalId: nationalId,
        birthDate: birthDate,
        imageFile: imageToUpload,
        deleteCurrentPhoto: shouldDelete,
      );

      // Invalidate image cache so UI immediately displays new avatar without restart
      try {
        PaintingBinding.instance.imageCache.clear();
        PaintingBinding.instance.imageCache.clearLiveImages();
      } catch (_) {
        // Safe fallback in headless/unit test environments
      }

      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
        clearStagedImage: true,
      ));
    } catch (failure) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.toString(),
      ));
    }
  }
}
