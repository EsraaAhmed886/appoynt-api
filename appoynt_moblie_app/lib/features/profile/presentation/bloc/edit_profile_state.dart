/*
 * File Name: edit_profile_state.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/08/2026
 * Version Information: V1.2.0
 * Dependencies: dart:io, package:appoynt_mobile_app/features/profile/data/models/governorate_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 29/08/2026]
 * File Description: Defines the immutable state representation for the Edit Profile
 *   flow, holding the locally staged profile image file, photo deletion flag,
 *   cascading governorates/cities selection state, and async statuses.
 */

import 'dart:io';
import 'package:appoynt_mobile_app/features/profile/data/models/governorate_model.dart';

/// Immutable state representation for the Edit Profile flow.
class EditProfileState {
  final File? stagedProfileImage;
  final bool isPhotoDeleted;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  // Cascading Governorates & Cities
  final List<GovernorateModel> governorates;
  final GovernorateModel? selectedGovernorate;
  final CityModel? selectedCity;
  final bool isGovernoratesLoading;
  final String? governoratesError;
  final List<CityModel> cities;
  final bool isCitiesLoading;
  final String? citiesError;

  const EditProfileState({
    this.stagedProfileImage,
    this.isPhotoDeleted = false,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.governorates = const [],
    this.selectedGovernorate,
    this.selectedCity,
    this.isGovernoratesLoading = false,
    this.governoratesError,
    this.cities = const [],
    this.isCitiesLoading = false,
    this.citiesError,
  });

  EditProfileState copyWith({
    File? stagedProfileImage,
    bool? isPhotoDeleted,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    bool clearStagedImage = false,
    List<GovernorateModel>? governorates,
    GovernorateModel? selectedGovernorate,
    CityModel? selectedCity,
    bool clearSelectedCity = false,
    bool clearSelectedGovernorate = false,
    bool? isGovernoratesLoading,
    String? governoratesError,
    List<CityModel>? cities,
    bool? isCitiesLoading,
    String? citiesError,
  }) {
    return EditProfileState(
      stagedProfileImage: clearStagedImage
          ? null
          : (stagedProfileImage ?? this.stagedProfileImage),
      isPhotoDeleted: isPhotoDeleted ?? this.isPhotoDeleted,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? false,
      governorates: governorates ?? this.governorates,
      selectedGovernorate: clearSelectedGovernorate
          ? null
          : (selectedGovernorate ?? this.selectedGovernorate),
      selectedCity: clearSelectedCity
          ? null
          : (selectedCity ?? this.selectedCity),
      isGovernoratesLoading:
          isGovernoratesLoading ?? this.isGovernoratesLoading,
      governoratesError: governoratesError,
      cities: cities ?? this.cities,
      isCitiesLoading: isCitiesLoading ?? this.isCitiesLoading,
      citiesError: citiesError,
    );
  }
}

/// Initial state for EditProfileCubit
class EditProfileInitial extends EditProfileState {
  const EditProfileInitial() : super();
}

/// State emitted while loading governorates
class GovernoratesLoadingState extends EditProfileState {
  const GovernoratesLoadingState({
    super.stagedProfileImage,
    super.isPhotoDeleted,
    super.isLoading,
    super.errorMessage,
    super.isSuccess,
    super.governorates,
    super.selectedGovernorate,
    super.selectedCity,
    super.cities,
    super.isCitiesLoading,
    super.citiesError,
  }) : super(isGovernoratesLoading: true);
}

/// State emitted when governorates have loaded successfully
class GovernoratesLoadedState extends EditProfileState {
  const GovernoratesLoadedState(
    List<GovernorateModel> loadedGovernorates, {
    super.stagedProfileImage,
    super.isPhotoDeleted,
    super.isLoading,
    super.errorMessage,
    super.isSuccess,
    super.selectedGovernorate,
    super.selectedCity,
    super.cities,
    super.isCitiesLoading,
    super.citiesError,
  }) : super(
          governorates: loadedGovernorates,
          isGovernoratesLoading: false,
        );
}

/// State emitted when governorates loading fails
class GovernoratesErrorState extends EditProfileState {
  final String message;

  const GovernoratesErrorState(
    this.message, {
    super.stagedProfileImage,
    super.isPhotoDeleted,
    super.isLoading,
    super.isSuccess,
    super.governorates,
    super.selectedGovernorate,
    super.selectedCity,
    super.cities,
    super.isCitiesLoading,
    super.citiesError,
  }) : super(
          governoratesError: message,
          isGovernoratesLoading: false,
        );
}

/// State emitted while loading cities
class CitiesLoadingState extends EditProfileState {
  const CitiesLoadingState({
    super.stagedProfileImage,
    super.isPhotoDeleted,
    super.isLoading,
    super.errorMessage,
    super.isSuccess,
    super.governorates,
    super.selectedGovernorate,
    super.selectedCity,
    super.isGovernoratesLoading,
    super.governoratesError,
  }) : super(isCitiesLoading: true);
}

/// State emitted when cities have loaded successfully
class CitiesLoadedState extends EditProfileState {
  const CitiesLoadedState(
    List<CityModel> loadedCities, {
    super.stagedProfileImage,
    super.isPhotoDeleted,
    super.isLoading,
    super.errorMessage,
    super.isSuccess,
    super.governorates,
    super.selectedGovernorate,
    super.selectedCity,
    super.isGovernoratesLoading,
    super.governoratesError,
  }) : super(
          cities: loadedCities,
          isCitiesLoading: false,
        );
}

/// State emitted when cities loading fails
class CitiesErrorState extends EditProfileState {
  final String message;

  const CitiesErrorState(
    this.message, {
    super.stagedProfileImage,
    super.isPhotoDeleted,
    super.isLoading,
    super.isSuccess,
    super.governorates,
    super.selectedGovernorate,
    super.selectedCity,
    super.isGovernoratesLoading,
    super.governoratesError,
  }) : super(
          citiesError: message,
          isCitiesLoading: false,
        );
}

/// State emitted when a governorate is selected
class GovernorateSelectedState extends EditProfileState {
  const GovernorateSelectedState(
    GovernorateModel? governorate, {
    super.stagedProfileImage,
    super.isPhotoDeleted,
    super.isLoading,
    super.errorMessage,
    super.isSuccess,
    super.governorates,
    super.selectedCity,
    super.isGovernoratesLoading,
    super.governoratesError,
    super.cities,
    super.isCitiesLoading,
    super.citiesError,
  }) : super(selectedGovernorate: governorate);
}

/// State emitted when a city is selected
class CitySelectedState extends EditProfileState {
  const CitySelectedState(
    CityModel? city, {
    super.stagedProfileImage,
    super.isPhotoDeleted,
    super.isLoading,
    super.errorMessage,
    super.isSuccess,
    super.governorates,
    super.selectedGovernorate,
    super.isGovernoratesLoading,
    super.governoratesError,
    super.cities,
    super.isCitiesLoading,
    super.citiesError,
  }) : super(selectedCity: city);
}
