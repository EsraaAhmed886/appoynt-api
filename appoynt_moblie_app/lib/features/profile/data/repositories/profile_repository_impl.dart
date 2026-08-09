/*
 * File Name: profile_repository_impl.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V1.0.0
 * Dependencies: profile_repository.dart, profile_remote_data_source.dart, user_profile_model.dart, update_profile_request_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 09/08/2026]
 * File Description: Implements the ProfileRepository interface to coordinate API tasks using the remote data source.
 */

// Importing domain repository contract
import 'package:appoynt_mobile_app/features/profile/domain/repositories/profile_repository.dart';
// Importing remote data source dependency
import 'package:appoynt_mobile_app/features/profile/data/datasources/profile_remote_data_source.dart';
// Importing UserProfileModel representation
import 'package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart';
// Importing UpdateProfileRequestModel representation
import 'package:appoynt_mobile_app/features/profile/data/models/update_profile_request_model.dart';

/// Concrete implementation of ProfileRepository coordinating data source requests.
class ProfileRepositoryImpl implements ProfileRepository {
  // Remote profile data source dependency
  final ProfileRemoteDataSource remote_data_source;

  // Constructor mapping data source dependency
  const ProfileRepositoryImpl(this.remote_data_source);

  @override
  // Forwards profile fetch call to remote data source
  Future<UserProfileModel> getUserProfile() async {
    // Return remote data source response
    return await remote_data_source.getUserProfile();
  }

  @override
  // Forwards profile update request call to remote data source
  Future<void> updateUserProfile(UpdateProfileRequestModel requestModel) async {
    // Call remote data source update method
    await remote_data_source.updateUserProfile(requestModel);
  }
}
