/*
 * File Name: profile_repository_impl.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V2.1.0
 * Dependencies: profile_repository.dart, profile_remote_data_source.dart,
 *   profile_local_data_source.dart, user_profile_model.dart,
 *   update_profile_request_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 13/08/2026]
 * File Description: Implements the ProfileRepository interface coordinating
 *   remote API calls with local SharedPreferences caching. Implements the
 *   Stale-While-Revalidate strategy: cache writes occur automatically after
 *   every successful remote fetch so the cubit can read stale data instantly
 *   while a background refresh silently revalidates and updates the cache.
 *   V2.1.0 adds uploadProfilePhoto with URL cache persistence and the
 *   getCachedProfilePhotoUrl convenience reader.
 */

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
      final String? existing_url =
          await local_data_source.getProfilePhotoUrl();
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
      // Server reports no profile photo — clear stale URL from cache
      await local_data_source.clearProfilePhotoUrl();
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
    // Silently refresh and re-cache profile after a successful update operation
    try {
      // Fetch the updated profile so the cache reflects the server-side state
      final UserProfileModel updated_profile =
          await remote_data_source.getUserProfile();
      // Overwrite the stale cache entry with the newly updated profile data
      await local_data_source.saveProfileToCache(updated_profile);
    } catch (refresh_error) {
      // Cache refresh failed — log but do not propagate to preserve update success
      debugPrint(
        '[ProfileRepositoryImpl] Post-update cache refresh failed: '
        '$refresh_error',
      );
    }
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

  // Reads the cached profile photo URL from local storage without a network call
  @override
  Future<String?> getCachedProfilePhotoUrl() async {
    // Delegate the photo URL cache read to the local data source implementation
    return await local_data_source.getProfilePhotoUrl();
  }
}
