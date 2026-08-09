/*
 * File Name: profile_remote_data_source.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V1.1.0
 * Dependencies: package:dio/dio.dart, change_password_request_model.dart, user_profile_model.dart, update_profile_request_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 09/08/2026]
 * File Description: Remote data source for profile feature operations, including fetching and updating user profiles.
 */

// Importing Dart standard libraries for json decoding operations
import 'dart:convert';
// Importing Dio client library
import 'package:dio/dio.dart';
// Importing token storage dependency
import 'package:appoynt_mobile_app/core/storage/token_storage.dart';
// Importing ChangePassword DTO request model representation
import 'package:appoynt_mobile_app/features/profile/data/models/change_password_request_model.dart';
// Importing UserProfile DTO model representation
import 'package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart';
// Importing UpdateProfile DTO request model representation
import 'package:appoynt_mobile_app/features/profile/data/models/update_profile_request_model.dart';

/// Abstract contract defining remote profile actions.
abstract class ProfileRemoteDataSource {
  /// Calls the change password API.
  Future<void> changePassword(ChangePasswordRequestModel requestModel);

  /// Fetches the user profile details from the remote API.
  Future<UserProfileModel> getUserProfile();

  /// Updates the user profile details via the remote API.
  Future<void> updateUserProfile(UpdateProfileRequestModel requestModel);
}

/// Concrete implementation of ProfileRemoteDataSource using Dio.
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  // Configured Dio client instance dependency
  final Dio dio;

  // Constructor mapping required dio client
  const ProfileRemoteDataSourceImpl(this.dio);

  @override
  // Submits a password update PUT request to the server
  Future<void> changePassword(ChangePasswordRequestModel requestModel) async {
    // Perform standard PUT network call on users path
    await dio.put(
      // Change password sub-route definition
      'users/change-password',
      // Pass serialized body parameters
      data: requestModel.toJson(),
    );
  }

  @override
  // Retrieves the profile representation matching the authenticated user
  Future<UserProfileModel> getUserProfile() async {
    // Retrieve target user identifier from stored token
    final String user_id = await _get_user_id();
    // Execute GET network request fetching data
    final Response response = await dio.get(
      // Dynamic profile route mapping target ID
      'users/$user_id',
    );
    // Parse received map into UserProfileModel representation
    return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  // Sends update profile request PUT method
  Future<void> updateUserProfile(UpdateProfileRequestModel requestModel) async {
    // Retrieve target user identifier from stored token
    final String user_id = await _get_user_id();
    // Execute PUT network request modifying data
    await dio.put(
      // Dynamic profile route mapping target ID
      'users/$user_id',
      // Pass serialized update request body parameters
      data: requestModel.toJson(),
    );
  }

  // Decodes active JWT access token to retrieve subject user identity identifier
  Future<String> _get_user_id() async {
    // Read secure access token
    final String? token = await TokenStorage.get_access_token();
    // Validate if token is null or empty
    if (null == token || token.isEmpty) {
      // Throw authentication failure exception
      throw Exception('Unauthenticated: Access token not found.');
    } else {
      // Split JWT components
      final List<String> parts = token.split('.');
      // Check for valid segment counts
      if (parts.length < 2) {
        // Throw format error exception
        throw Exception('Invalid token format.');
      } else {
        // Extract payload segment
        final String payload = parts[1];
        // Normalize base64 encoding bounds
        final String normalized = base64.normalize(payload);
        // Decode payload string bytes
        final String decoded = utf8.decode(base64.decode(normalized));
        // Parse JSON claims map
        final Map<String, dynamic> claims = json.decode(decoded) as Map<String, dynamic>;
        // Extract user id from common schemas
        final String id = claims['nameid'] ??
            claims['sub'] ??
            claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] ??
            '';
        // Return resolved string representation
        return id;
      }
    }
  }
}
