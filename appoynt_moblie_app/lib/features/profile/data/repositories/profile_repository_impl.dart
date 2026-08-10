/*
 * File Name: profile_repository_impl.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V2.0.0
 * Dependencies: profile_repository.dart, profile_remote_data_source.dart,
 *   profile_local_data_source.dart, user_profile_model.dart,
 *   update_profile_request_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 10/08/2026]
 * File Description: Implements the ProfileRepository interface coordinating
 *   remote API calls with local SharedPreferences caching. Implements the
 *   Stale-While-Revalidate strategy: cache writes occur automatically after
 *   every successful remote fetch so the cubit can read stale data instantly
 *   while a background refresh silently revalidates and updates the cache.
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
}
