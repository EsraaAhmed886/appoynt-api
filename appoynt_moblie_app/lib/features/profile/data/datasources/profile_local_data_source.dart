/*
 * File Name: profile_local_data_source.dart
 * Author: Kholoud Khaled
 * Date of Creation: 10/08/2026
 * Version Information: V1.1.0
 * Dependencies: package:shared_preferences/shared_preferences.dart,
 *   user_profile_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 13/08/2026]
 * File Description: Local data source for caching the authenticated user's
 *   profile using SharedPreferences as a JSON string blob. V1.1.0 bumps the
 *   cache key version to invalidate stale entries missing has_profile_photo,
 *   and adds separate photo URL persistence methods so the avatar loads
 *   instantly on cold start without a network round-trip.
 */

// Importing dart:convert for JSON encoding and decoding operations
import 'dart:convert';
// Importing SharedPreferences for lightweight key-value local persistence
import 'package:shared_preferences/shared_preferences.dart';
// Importing UserProfileModel for type-safe JSON serialization mapping
import 'package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart';
// Importing Flutter foundation for debug logging support
import 'package:flutter/foundation.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ABSTRACT CONTRACT
// ─────────────────────────────────────────────────────────────────────────────

// Abstract interface defining the local profile cache operations contract
abstract class ProfileLocalDataSource {
  // Reads the cached UserProfileModel from local storage, or null if absent
  Future<UserProfileModel?> getCachedProfile();

  // Persists a UserProfileModel JSON blob to local SharedPreferences storage
  Future<void> saveProfileToCache(UserProfileModel profile);

  // Purges the cached profile entry from local SharedPreferences storage
  Future<void> clearCachedProfile();

  // Persists the resolved profile photo URL string separately for instant loads
  Future<void> saveProfilePhotoUrl(String photo_url);

  // Reads the previously persisted profile photo URL, or null if absent
  Future<String?> getProfilePhotoUrl();

  // Purges the locally cached profile photo URL entry
  Future<void> clearProfilePhotoUrl();
}

// ─────────────────────────────────────────────────────────────────────────────
// IMPLEMENTATION
// ─────────────────────────────────────────────────────────────────────────────

// Concrete SharedPreferences-backed implementation of ProfileLocalDataSource
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  // SharedPreferences key used to store and retrieve the profile JSON blob
  // Version bumped from v2 to v3 to invalidate caches missing blood_group & national_id
  static const String _cache_key = 'cached_user_profile_v3';

  // Separate SharedPreferences key for the resolved profile photo URL string
  static const String _photo_url_key = 'cached_profile_photo_url_v1';

  // Override: reads and deserializes the cached profile JSON string from prefs
  @override
  Future<UserProfileModel?> getCachedProfile() async {
    // Obtain the singleton SharedPreferences instance asynchronously
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Attempt to read the cached JSON string using the constant storage key
    final String? json_string = prefs.getString(_cache_key);
    // Guard: return null immediately when no cache entry exists in storage
    if (null == json_string || json_string.isEmpty) {
      // No cached profile found — return null to signal a cache miss
      return null;
    } else {
      // Cached JSON string is present — proceed with deserialization
    }
    // Attempt to parse and map the JSON string into a UserProfileModel instance
    try {
      // Decode the raw JSON string into a Map<String, dynamic> structure
      final Map<String, dynamic> json_map =
          json.decode(json_string) as Map<String, dynamic>;
      // Construct and return a UserProfileModel from the decoded JSON map
      return UserProfileModel.fromJson(json_map);
    } catch (parse_error) {
      // Parsing failed — log the error and treat as a cache miss
      debugPrint(
        '[ProfileLocalDataSource] Cache deserialization failed: $parse_error',
      );
      // Return null to signal a graceful cache miss on parse error
      return null;
    }
  }

  // Override: serializes and persists a UserProfileModel to SharedPreferences
  @override
  Future<void> saveProfileToCache(UserProfileModel profile) async {
    // Obtain the singleton SharedPreferences instance asynchronously
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Serialize the UserProfileModel instance into a JSON map representation
    final Map<String, dynamic> json_map = profile.toJson();
    // Encode the JSON map to a raw string for SharedPreferences storage
    final String json_string = json.encode(json_map);
    // Persist the encoded JSON string under the designated cache storage key
    await prefs.setString(_cache_key, json_string);
    // Log successful cache write for debug audit trail purposes
    debugPrint(
      '[ProfileLocalDataSource] Profile cached successfully '
      '(id: ${profile.id}).',
    );
  }

  // Override: removes the cached profile entry from SharedPreferences storage
  @override
  Future<void> clearCachedProfile() async {
    // Obtain the singleton SharedPreferences instance asynchronously
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Remove the profile cache entry using the designated storage key
    await prefs.remove(_cache_key);
    // Log successful cache eviction for debug audit trail purposes
    debugPrint('[ProfileLocalDataSource] Cached profile cleared.');
  }

  // Override: persists the resolved profile photo URL to SharedPreferences
  @override
  Future<void> saveProfilePhotoUrl(String photo_url) async {
    // Obtain the singleton SharedPreferences instance asynchronously
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Persist the photo URL string under the designated photo URL cache key
    await prefs.setString(_photo_url_key, photo_url);
    // Log successful photo URL cache write for debug audit trail
    debugPrint(
      '[ProfileLocalDataSource] Profile photo URL cached: $photo_url',
    );
  }

  // Override: reads the previously persisted profile photo URL from prefs
  @override
  Future<String?> getProfilePhotoUrl() async {
    // Obtain the singleton SharedPreferences instance asynchronously
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Read the photo URL string from the designated cache key
    final String? photo_url = prefs.getString(_photo_url_key);
    // Return the URL or null if absent
    return photo_url;
  }

  // Override: removes the cached photo URL entry from SharedPreferences storage
  @override
  Future<void> clearProfilePhotoUrl() async {
    // Obtain the singleton SharedPreferences instance asynchronously
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Remove the photo URL cache entry using the designated storage key
    await prefs.remove(_photo_url_key);
    // Log successful cache eviction for debug audit trail purposes
    debugPrint('[ProfileLocalDataSource] Cached profile photo URL cleared.');
  }
}
