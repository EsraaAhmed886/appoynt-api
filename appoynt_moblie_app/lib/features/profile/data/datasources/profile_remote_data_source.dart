/*
 * File Name: profile_remote_data_source.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V1.3.0
 * Dependencies: package:dio/dio.dart, change_password_request_model.dart,
 *   user_profile_model.dart, update_profile_request_model.dart,
 *   api_constants.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Remote data source for profile feature operations. V1.3.0
 *   adds deleteProfilePhoto DELETE method for avatar removal.
 */

// Importing Dart standard libraries for JSON decoding operations
import 'dart:convert';
// Importing Dart I/O for File operations
import 'dart:io';
// Importing Flutter foundation for debugPrint
import 'package:flutter/foundation.dart';
// Importing Dio client library
import 'package:dio/dio.dart';
// Importing token storage dependency
import 'package:appoynt_mobile_app/core/storage/token_storage.dart';
// Importing API constants
import 'package:appoynt_mobile_app/core/api/api_constants.dart';
// Importing change password request model representation
import 'package:appoynt_mobile_app/features/profile/data/models/change_password_request_model.dart';
// Importing user profile model representation
import 'package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart';
// Importing update profile request model representation
import 'package:appoynt_mobile_app/features/profile/data/models/update_profile_request_model.dart';

/// Contract definition for remote profile operations.
abstract class ProfileRemoteDataSource {
  /// Submits a request to change the current user's password.
  Future<void> changePassword(ChangePasswordRequestModel requestModel);

  /// Fetches the user profile details from the remote API
  /// using GET /api/patients/profile (returns PatientProfileResponse).
  Future<UserProfileModel> getUserProfile();

  /// Updates the user profile details via the remote API.
  Future<void> updateUserProfile(UpdateProfileRequestModel requestModel);

  /// Uploads a profile photo file using multipart/form-data.
  /// Endpoint: POST /api/patients/profile-photo
  /// Returns the constructed network URL for the uploaded image.
  Future<String> uploadProfilePhoto(String file_path);

  /// Deletes the patient profile photo on the backend.
  /// Endpoint: DELETE /api/patients/profile-photo
  Future<void> deleteProfilePhoto();

  /// Builds the network URL to fetch the patient profile photo.
  /// Endpoint: GET /api/patients/{patientId}/profile-photo
  Future<String> buildProfilePhotoUrl(String patient_id);
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
  // Retrieves the profile using the correct GET /api/patients/profile endpoint
  // which returns PatientProfileResponse including hasProfilePhoto and pid fields
  Future<UserProfileModel> getUserProfile() async {
    // Execute GET request on the patients/profile route (no ID in path)
    final Response response = await dio.get(
      // Correct endpoint for patient profile per Swagger documentation
      'patients/profile',
    );
    // Parse received map into UserProfileModel from PatientProfileResponse layout
    return UserProfileModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  @override
  // Sends update profile request PUT method to both Patient Profile (patients/profile)
  // and User Identity (users/{userId}) endpoints to persist medical details and name changes
  Future<void> updateUserProfile(UpdateProfileRequestModel requestModel) async {
    // 1. Execute PUT network request on patients/profile endpoint carrying patient medical payload
    await dio.put(
      // Patient profile update endpoint
      'patients/profile',
      // Serialized update request payload (birthDate, weightKg, heightCm, bloodGroup, etc.)
      data: requestModel.toJson(),
    );

    // 2. Also execute PUT on users/{userId} (Identity User endpoint) for firstName and lastName persistence
    try {
      final String user_id = await _get_user_id();
      if (user_id.isNotEmpty) {
        await dio.put(
          'users/$user_id',
          data: {
            'firstName': requestModel.first_name,
            'lastName': requestModel.last_name,
          },
        );
      } else {
        // No action needed
      }
    } catch (identity_error) {
      // Log identity update error notice without failing the primary patient update flow
      debugPrint('[ProfileRemoteDataSource] User identity update notice: $identity_error');
    }
  }

  @override
  // Uploads the profile image using POST /api/patients/profile-photo with
  // multipart/form-data encoding and field name 'file' per Swagger spec.
  // Returns the constructed network URL for the new profile photo.
  Future<String> uploadProfilePhoto(String file_path) async {
    // Create a File reference from the provided local path
    final File image_file = File(file_path);
    // Extract the base filename from the local path for MIME inference
    final String file_name = image_file.path.split(Platform.pathSeparator).last;
    // Build MultipartFile instance from the local file on disk
    final MultipartFile multipart_file = await MultipartFile.fromFile(
      // Source file path string
      file_path,
      // Attach filename for server-side storage and MIME detection
      filename: file_name,
    );
    // Construct FormData container with the required 'file' field
    final FormData form_data = FormData.fromMap({
      // Field name 'file' as specified in the Swagger multipart schema
      'file': multipart_file,
    });
    // Execute POST multipart request to the profile-photo endpoint
    final Response response = await dio.post(
      // Upload endpoint per Swagger specification
      'patients/profile-photo',
      // Attach constructed form data payload
      data: form_data,
    );
    // Extract patient_id or patientId from response
    final Map<String, dynamic> result_body =
        response.data as Map<String, dynamic>;
    final String? patient_id_from_response =
        result_body['patientId'] as String?
            ?? result_body['id'] as String?;
    // Guard against null patient_id in the upload response
    if (null == patient_id_from_response ||
        patient_id_from_response.isEmpty) {
      // Fall back to token-derived ID when server omits patientId
      final String fallback_id = await _get_user_id();
      return await buildProfilePhotoUrl(fallback_id);
    } else {
      return await buildProfilePhotoUrl(patient_id_from_response);
    }
  }

  @override
  // Deletes the patient profile photo on the backend via DELETE /api/patients/profile-photo
  Future<void> deleteProfilePhoto() async {
    // Perform standard DELETE network call on patients profile-photo path
    await dio.delete('patients/profile-photo');
  }

  @override
  // Constructs the full network URL for the patient profile photo endpoint.
  // When patient_id (GUID) is non-empty, constructs GET /api/patients/{patientId}/profile-photo.
  // When patient_id is empty, targets GET /api/patients/profile-photo for current user.
  Future<String> buildProfilePhotoUrl(String patient_id) async {
    // Build target route path using patient GUID or current patient profile-photo route
    final String path = patient_id.isNotEmpty
        ? 'patients/$patient_id/profile-photo'
        : 'patients/profile-photo';
    // Build the full URL using ApiConstants base URL
    final String photo_url = '${ApiConstants.base_url}$path';
    return photo_url;
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
        final Map<String, dynamic> claims =
            json.decode(decoded) as Map<String, dynamic>;
        // Extract user id from common schemas
        final String id = claims['nameid'] ??
            claims['sub'] ??
            claims[
                'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] ??
            '';
        // Return resolved string representation
        return id;
      }
    }
  }
}
