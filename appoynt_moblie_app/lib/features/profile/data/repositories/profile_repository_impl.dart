/*
 * File Name: profile_repository_impl.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V2.4.0
 * Dependencies: dart:io, profile_repository.dart, profile_remote_data_source.dart,
 *   profile_local_data_source.dart, user_profile_model.dart,
 *   update_profile_request_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 31/08/2026]
 * File Description: Implements the ProfileRepository interface coordinating
 *   remote API calls with local SharedPreferences caching. V2.3.0 adds
 *   updateProfile coordinating staged photo updates and profile saves.
 */

import 'dart:io';

// Importing domain repository contract interface definition
import 'package:appoynt_mobile_app/features/profile/domain/repositories/profile_repository.dart';
// Importing remote data source dependency for API network calls
import 'package:appoynt_mobile_app/features/profile/data/datasources/profile_remote_data_source.dart';
// Importing local data source dependency for SharedPreferences cache operations
import 'package:appoynt_mobile_app/features/profile/data/datasources/profile_local_data_source.dart';
// Importing UserProfileModel representation for type-safe data transfer
import 'package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart';
// Importing UpdateProfileRequestModel representation for update payloads
import 'package:appoynt_mobile_app/features/profile/data/models/update_profile_request_model.dart';
// Importing GovernorateModel & CityModel representations
import 'package:appoynt_mobile_app/features/profile/data/models/governorate_model.dart';
// Importing Flutter foundation for debug logging support
import 'package:flutter/foundation.dart';

// Concrete implementation of ProfileRepository coordinating all data source ops
class ProfileRepositoryImpl implements ProfileRepository {
  // Remote profile data source dependency for API network operations
  final ProfileRemoteDataSource remote_data_source;
  // Local profile data source dependency for SharedPreferences cache operations
  final ProfileLocalDataSource local_data_source;

  // Constructor mapping both remote and local data source dependencies
  const ProfileRepositoryImpl({
    // Required remote data source for API calls
    required this.remote_data_source,
    // Required local data source for cache reads and writes
    required this.local_data_source,
  });

  // Fetches fresh profile from the remote API, writes it to cache, returns it
  @override
  Future<UserProfileModel> getUserProfile() async {
    // Call the remote API to retrieve the most current profile data snapshot
    final UserProfileModel fresh_profile =
        await remote_data_source.getUserProfile();
    // Persist the freshly fetched profile to local cache for instant future reads
    await local_data_source.saveProfileToCache(fresh_profile);
    // If the server reports an active profile photo, ensure the photo URL is
    // populated in local cache so the avatar renders immediately on next launch
    if (fresh_profile.has_profile_photo) {
      // Only refresh the photo URL cache when the server confirms photo exists
      final String? existing_url = await local_data_source.getProfilePhotoUrl();
      // Use Patient GUID (fresh_profile.id) first to target /api/patients/{patientGuid}/profile-photo
      final String patient_guid = fresh_profile.id.isNotEmpty
          ? fresh_profile.id
          : (fresh_profile.patient_id ?? '');
      // Guard: derive photo URL using patient_guid or authenticated current user route
      if (patient_guid.isNotEmpty) {
        // Construct the image URL from the patient GUID
        final String photo_url =
            await remote_data_source.buildProfilePhotoUrl(patient_guid);
        // Only overwrite the cache when the URL has changed
        if (existing_url != photo_url) {
          // Persist the newly derived photo URL to local cache
          await local_data_source.saveProfilePhotoUrl(photo_url);
        } else {
          // URL is unchanged — no cache write needed
        }
      } else {
        // patient_guid unavailable — use fallback authenticated route without ID
        final String photo_url =
            await remote_data_source.buildProfilePhotoUrl('');
        // Persist the photo URL to local cache
        await local_data_source.saveProfilePhotoUrl(photo_url);
      }
    } else {
      final String? existing_url = await local_data_source.getProfilePhotoUrl();
      if (null != existing_url && existing_url.isNotEmpty) {
        // Retain recently cached photo URL to prevent race-condition wipe
      } else {
        // Server reports no profile photo and no active cache — clear cache
        await local_data_source.clearProfilePhotoUrl();
      }
    }
    // Return the fresh remote profile to the caller
    return fresh_profile;
  }

  // Returns instantly from cache if available; null signals a cache miss
  @override
  Future<UserProfileModel?> getCachedProfile() async {
    // Delegate the cache read operation to the local data source implementation
    return await local_data_source.getCachedProfile();
  }

  // Sends the update request to the remote API and refreshes the local cache
  @override
  Future<void> updateUserProfile(UpdateProfileRequestModel requestModel) async {
    // Call remote data source update method to persist changes on the server
    await remote_data_source.updateUserProfile(requestModel);
    // Refresh local cache with updated profile immediately
    try {
      // Fetch the updated profile so the cache reflects the server-side state
      final UserProfileModel updated_profile =
          await remote_data_source.getUserProfile();
      // Overwrite the stale cache entry with the newly updated profile data
      await local_data_source.saveProfileToCache(updated_profile);
    } catch (refresh_error) {
      // If remote GET fails post-update, update local cache manually with request values
      final UserProfileModel? cached =
          await local_data_source.getCachedProfile();
      if (null != cached) {
        final UserProfileModel fallback_updated = cached.copyWith(
          first_name: requestModel.first_name,
          last_name: requestModel.last_name,
          date_of_birth: requestModel.date_of_birth ?? cached.date_of_birth,
          address: requestModel.address ?? cached.address,
          national_id: requestModel.national_id ?? cached.national_id,
          weight: requestModel.weight ?? cached.weight,
          height: requestModel.height ?? cached.height,
          blood_group: requestModel.blood_group ?? cached.blood_group,
          gender: requestModel.gender ?? cached.gender,
        );
        await local_data_source.saveProfileToCache(fallback_updated);
      } else {
        // No action needed
      }
      debugPrint(
        '[ProfileRepositoryImpl] Post-update cache refresh notice: $refresh_error',
      );
    }
  }

  // Updates profile information and processes any staged photo changes on save
  @override
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
  }) async {
    // 1. Update text attributes first via PUT /api/patients/profile
    final UpdateProfileRequestModel requestModel = UpdateProfileRequestModel(
      first_name: firstName,
      last_name: lastName,
      address: address,
      national_id: nationalId,
      date_of_birth: birthDate,
      governorate_id: governorateId,
      city_id: cityId,
      gender: gender,
      weight: weight,
      height: height,
      blood_group: bloodGroup,
    );
    await updateUserProfile(requestModel);

    // 2. Upload photo if a new local image is staged or delete if flagged
    String? new_photo_url;
    if (null != imageFile) {
      debugPrint('[ProfileRepository] Uploading image file: ${imageFile.path}');
      new_photo_url = await uploadProfilePhoto(imageFile.path);
      await local_data_source.saveProfilePhotoUrl(new_photo_url);
    } else if (deleteCurrentPhoto) {
      debugPrint('[ProfileRepository] Deleting profile photo');
      await deleteProfilePhoto();
    } else {
      // No photo change
    }

    // 3. Read fresh profile from remote and persist to local cache
    final UserProfileModel fresh_profile = await getUserProfile();
    if (null != new_photo_url && new_photo_url.isNotEmpty) {
      await local_data_source.saveProfilePhotoUrl(new_photo_url);
    } else {
      // No explicit photo url override
    }
    return fresh_profile;
  }

  // Uploads a profile photo using POST /api/patients/profile-photo,
  // caches the resolved image URL locally, and returns it to the caller.
  @override
  Future<String> uploadProfilePhoto(String file_path) async {
    // Delegate multipart upload to the remote data source implementation
    final String photo_url =
        await remote_data_source.uploadProfilePhoto(file_path);
    // Persist the resolved image URL to local SharedPreferences cache
    await local_data_source.saveProfilePhotoUrl(photo_url);
    // Log the successful photo upload and URL cache write
    debugPrint(
      '[ProfileRepositoryImpl] Profile photo uploaded. URL cached: $photo_url',
    );
    // Return the resolved URL so the cubit can update state immediately
    return photo_url;
  }

  // Deletes the profile photo via remote DELETE endpoint and clears local cache
  @override
  Future<void> deleteProfilePhoto() async {
    // Delegate remote photo deletion to remote data source
    await remote_data_source.deleteProfilePhoto();
    // Clear persisted profile photo URL from local cache
    await local_data_source.clearProfilePhotoUrl();
    // Log the successful photo deletion
    debugPrint(
      '[ProfileRepositoryImpl] Profile photo deleted remotely and cleared from local cache',
    );
  }

  // Reads the cached profile photo URL from local storage without a network call
  @override
  Future<String?> getCachedProfilePhotoUrl() async {
    // Delegate the photo URL cache read to the local data source implementation
    return await local_data_source.getProfilePhotoUrl();
  }

  // Retrieves the list of Egyptian Governorates
  @override
  Future<List<GovernorateModel>> getGovernorates() async {
    return await remote_data_source.getGovernorates();
  }

  // Retrieves the list of Cities for a specific Governorate
  @override
  Future<List<CityModel>> getCitiesByGovernorate(dynamic governorateId) async {
    return await remote_data_source.getCitiesByGovernorate(governorateId);
  }
}
