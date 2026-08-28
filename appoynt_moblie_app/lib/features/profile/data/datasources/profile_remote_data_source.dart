/*
 * File Name: profile_remote_data_source.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V1.4.0
 * Dependencies: package:dio/dio.dart, change_password_request_model.dart,
 *   user_profile_model.dart, update_profile_request_model.dart,
 *   api_constants.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Remote data source for profile feature operations. V1.4.0
 *   adds multipart FormData updateProfile and cache-busting uploadProfilePhoto.
 */

// Importing Dart standard libraries for JSON decoding operations
import 'dart:convert';
// Importing Dart I/O for File operations
import 'dart:io';
// Importing Flutter foundation for debugPrint
import 'package:flutter/foundation.dart';
// Importing Dio client library
import 'package:dio/dio.dart';
// Importing MediaType from http_parser
import 'package:http_parser/http_parser.dart';
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

  /// Updates profile details with optional multipart image and photo deletion support.
  Future<UserProfileModel> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    String? address,
    String? nationalId,
    String? birthDate,
    File? imageFile,
    bool deleteCurrentPhoto = false,
  });

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
  // Sends update profile request PUT method to Patient Profile (patients/profile)
  // endpoint to persist medical and identity name details without unauthorized /api/users calls
  Future<void> updateUserProfile(UpdateProfileRequestModel requestModel) async {
    // Execute PUT network request on patients/profile endpoint carrying patient payload
    await dio.put(
      // Patient profile update endpoint
      'patients/profile',
      // Serialized update request payload
      data: requestModel.toJson(),
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  @override
  // Updates profile details with multipart image upload or photo deletion in a unified call
  Future<UserProfileModel> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    String? address,
    String? nationalId,
    String? birthDate,
    File? imageFile,
    bool deleteCurrentPhoto = false,
  }) async {
    // 1. Update text attributes first via patients/profile
    final UpdateProfileRequestModel requestModel = UpdateProfileRequestModel(
      first_name: firstName,
      last_name: lastName,
      address: address,
      national_id: nationalId,
      date_of_birth: birthDate,
    );
    await updateUserProfile(requestModel);

    // 2. Handle photo upload or deletion
    if (null != imageFile) {
      await uploadProfilePhoto(imageFile.path);
    } else if (deleteCurrentPhoto) {
      await deleteProfilePhoto();
    } else {
      // No photo change requested
    }

    // 3. Return fresh remote profile from server
    return await getUserProfile();
  }

  @override
  // Uploads the profile image using in-memory byte buffer to provide explicit Content-Length
  // and prevent Android stream boundary ANR deadlocks.
  // Returns the constructed network URL with cache-busting timestamp for immediate UI refresh.
  Future<String> uploadProfilePhoto(String file_path) async {
    // Create a File reference from the provided local path
    final File image_file = File(file_path);
    // Extract the base filename from the local path for MIME inference
    final String file_name = image_file.path.split(Platform.pathSeparator).last;
    final String file_extension = file_name.split('.').last.toLowerCase();
    debugPrint(
      '[ProfileRemoteDataSource] Uploading profile photo: $file_path (filename: $file_name, ext: $file_extension)',
    );

    // 1. Read bytes asynchronously into memory to provide explicit Content-Length
    final List<int> image_bytes = await image_file.readAsBytes();

    // 2. Build MultipartFile instance from in-memory byte array with explicit MediaType
    final MultipartFile multipart_file = MultipartFile.fromBytes(
      image_bytes,
      filename: file_name,
      contentType: MediaType(
        'image',
        'png' == file_extension ? 'png' : 'jpeg',
      ),
    );

    // 3. Attach exact Swagger parameter key 'file' (ASP.NET IFormFile binding)
    final FormData form_data = FormData.fromMap({
      'file': multipart_file,
    });

    debugPrint(
      '[ProfileRemoteDataSource] Sending POST ${ApiConstants.patient_profile_photo} with file: $file_name',
    );

    // 4. Send POST to exact Swagger endpoint: POST /api/patients/profile-photo
    final Response response = await dio.post(
      ApiConstants.patient_profile_photo,
      data: form_data,
      options: Options(
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    // 5. Validate response status code
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } else {
      // Success response code confirmed
    }

    // 6. Extract patient_id or direct URL from PatientResult schema response
    final Map<String, dynamic> result_body =
        response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : <String, dynamic>{};
    final String? direct_url = result_body['photoUrl'] as String? ??
        result_body['avatarUrl'] as String? ??
        result_body['imageUrl'] as String? ??
        result_body['url'] as String?;

    String resolved_url;
    if (null != direct_url && direct_url.isNotEmpty) {
      resolved_url = direct_url.startsWith('http')
          ? direct_url
          : '${ApiConstants.base_url}$direct_url';
    } else {
      final String? patient_id_from_response =
          result_body['patientId'] as String? ??
              result_body['id'] as String?;
      // Guard against null patient_id in the upload response
      if (null == patient_id_from_response ||
          patient_id_from_response.isEmpty) {
        // Fall back to token-derived ID when server omits patientId
        final String fallback_id = await _get_user_id();
        resolved_url = await buildProfilePhotoUrl(fallback_id);
      } else {
        resolved_url = await buildProfilePhotoUrl(patient_id_from_response);
      }
    }

    // Append cache-busting timestamp query parameter to ensure UI updates immediately
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String separator = resolved_url.contains('?') ? '&' : '?';
    return '$resolved_url${separator}v=$timestamp';
  }

  @override
  // Deletes the patient profile photo via exact Swagger endpoint: DELETE /api/patients/profile-photo
  Future<void> deleteProfilePhoto() async {
    debugPrint(
      '[ProfileRemoteDataSource] Sending DELETE ${ApiConstants.patient_profile_photo}',
    );
    final Response response = await dio.delete(
      ApiConstants.patient_profile_photo,
      options: Options(
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } else {
      // Succeeded
    }
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
