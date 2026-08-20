/*
 * File Name: favorites_local_data_source.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:shared_preferences/shared_preferences.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Local data source handling cache persistence and session-isolated
 *   purging for favorited records using SharedPreferences.
 */

// Import SharedPreferences for local key-value storage
import 'package:shared_preferences/shared_preferences.dart';

// Abstract contract for local favorites storage operations
abstract class FavoritesLocalDataSource {
  // Clears all cached favorites keys for session / account isolation
  Future<void> clearAllFavoritesCache();

  // Stores timestamp of last successful favorites sync
  Future<void> saveLastSyncTimestamp(String category, DateTime timestamp);

  // Reads timestamp of last successful favorites sync
  Future<DateTime?> getLastSyncTimestamp(String category);
}

// Concrete implementation of FavoritesLocalDataSource using SharedPreferences
class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  // Storage key prefix constant
  static const String _key_prefix = 'cached_favorites_';

  @override
  // Clears all cached favorites data upon logout or account switch
  Future<void> clearAllFavoritesCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Set<String> keys = prefs.getKeys();
    for (final String key in keys) {
      if (key.startsWith(_key_prefix)) {
        await prefs.remove(key);
      } else {
        // Retain unrelated keys
      }
    }
  }

  @override
  // Persists sync timestamp for a specific favorites category
  Future<void> saveLastSyncTimestamp(
      String category, DateTime timestamp) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '${_key_prefix}sync_$category',
      timestamp.toIso8601String(),
    );
  }

  @override
  // Retrieves sync timestamp for a specific favorites category
  Future<DateTime?> getLastSyncTimestamp(String category) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString('${_key_prefix}sync_$category');
    if (null == raw || raw.isEmpty) {
      return null;
    } else {
      return DateTime.tryParse(raw);
    }
  }
}
