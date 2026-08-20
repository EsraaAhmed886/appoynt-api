/*
 * File Name: update_user_profile_usecase.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V1.0.0
 * Dependencies: profile_repository.dart, update_profile_request_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Defines the Update User Profile Use Case for sending profile updates in the domain layer.
 */

// Importing repository contract
import 'package:appoynt_mobile_app/features/profile/domain/repositories/profile_repository.dart';
// Importing UpdateProfileRequestModel representation
import 'package:appoynt_mobile_app/features/profile/data/models/update_profile_request_model.dart';

/// Use case responsible for updating user profile information.
class UpdateUserProfileUseCase {
  // Profile repository dependency
  final ProfileRepository repository;

  // Constructor mapping repository dependency
  const UpdateUserProfileUseCase(this.repository);

  /// Executes the profile update business action.
  Future<void> call(UpdateProfileRequestModel requestModel) async {
    // Dispatch update call to repository
    await repository.updateUserProfile(requestModel);
  }
}
