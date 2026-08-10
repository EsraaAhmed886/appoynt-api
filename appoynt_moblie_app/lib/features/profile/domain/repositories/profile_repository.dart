/*
 * File Name: profile_repository.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V1.0.0
 * Dependencies: user_profile_model.dart, update_profile_request_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 09/08/2026]
 * File Description: Defines the repository interface for profile operations in the domain layer.
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
}
