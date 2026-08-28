/*
 * File Name: profile_repository.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V1.2.0
 * Dependencies: user_profile_model.dart, update_profile_request_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Defines the repository interface for profile operations in
 *   the domain layer. V1.2.0 adds the deleteProfilePhoto contract method that
 *   removes the user avatar on the backend and clears it from local cache.
 */

// Importing UserProfileModel representation
import 'package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart';
// Importing UpdateProfileRequestModel representation
import 'package:appoynt_mobile_app/features/profile/data/models/update_profile_request_model.dart';

/// Repository interface defining domain business tasks for user profile.
abstract class ProfileRepository {
  /// Retrieves the current user's profile details from the remote API
  /// and writes the result to local cache automatically.
  Future<UserProfileModel> getUserProfile();

  /// Returns the locally cached UserProfileModel instantly, or null on miss.
  Future<UserProfileModel?> getCachedProfile();

  /// Updates the user's profile details with the specified parameters.
  Future<void> updateUserProfile(UpdateProfileRequestModel requestModel);

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
