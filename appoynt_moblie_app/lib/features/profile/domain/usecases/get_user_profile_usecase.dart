/*
 * File Name: get_user_profile_usecase.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V1.0.0
 * Dependencies: profile_repository.dart, user_profile_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 09/08/2026]
 * File Description: Defines the Get User Profile Use Case for retrieving user details in the domain layer.
 */

// Importing repository contract
import 'package:appoynt_mobile_app/features/profile/domain/repositories/profile_repository.dart';
// Importing UserProfileModel representation
import 'package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart';

/// Use case responsible for retrieving user profile information.
class GetUserProfileUseCase {
  // Profile repository dependency
  final ProfileRepository repository;

  // Constructor mapping repository dependency
  const GetUserProfileUseCase(this.repository);

  /// Executes the profile retrieval business action.
  Future<UserProfileModel> call() async {
    // Return fetch result from repository
    return await repository.getUserProfile();
  }
}
