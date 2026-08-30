/*
 * File Name: profile_repository.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V1.3.0
 * Dependencies: dart:io, user_profile_model.dart, update_profile_request_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Defines the repository interface for profile operations in
 *   the domain layer. V1.3.0 adds updateProfile coordinating staged photo updates and profile saves.
 */

import 'dart:io';
// Importing UserProfileModel representation
import 'package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart';
// Importing UpdateProfileRequestModel representation
import 'package:appoynt_mobile_app/features/profile/data/models/update_profile_request_model.dart';
// Importing GovernorateModel & CityModel representations
import 'package:appoynt_mobile_app/features/profile/data/models/governorate_model.dart';

/// Repository interface defining domain business tasks for user profile.
abstract class ProfileRepository {
  /// Retrieves the current user's profile details from the remote API
  /// and writes the result to local cache automatically.
  Future<UserProfileModel> getUserProfile();

  /// Returns the locally cached UserProfileModel instantly, or null on miss.
  Future<UserProfileModel?> getCachedProfile();

  /// Updates the user's profile details with the specified parameters.
  Future<void> updateUserProfile(UpdateProfileRequestModel requestModel);

  /// Updates profile information and processes any staged photo changes on save.
  Future<UserProfileModel> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    String? address,
    String? nationalId,
    String? birthDate,
    File? imageFile,
    bool deleteCurrentPhoto = false,
    String? governorateId,
    String? cityId,
    int? gender,
    String? weight,
    String? height,
    String? bloodGroup,
  });

  /// Retrieves list of Egyptian Governorates (with associated cities).
  Future<List<GovernorateModel>> getGovernorates();

  /// Retrieves list of Cities for a specific Governorate.
  Future<List<CityModel>> getCitiesByGovernorate(dynamic governorateId);

  /// Uploads a new profile photo from a local file path using multipart POST.
  /// Persists the returned image URL to local cache and returns it.
  /// Endpoint: POST /api/patients/profile-photo
  Future<String> uploadProfilePhoto(String file_path);

  /// Deletes the current profile photo from the backend and clears it from local cache.
  /// Endpoint: DELETE /api/patients/profile-photo
  Future<void> deleteProfilePhoto();

  /// Reads the cached profile photo URL from local storage.
  /// Returns null when no URL has been persisted yet.
  Future<String?> getCachedProfilePhotoUrl();
}
