/*
 * File Name: token_storage.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter_secure_storage/flutter_secure_storage.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Secure helper class utilizing FlutterSecureStorage to save, read, and delete authentication tokens.
 */

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure token storage helper implementing FlutterSecureStorage management.
class TokenStorage {
  // Prevent direct instantiation
  TokenStorage._();

  // Secure storage instance
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Access token key constant
  static const String _key_access_token = 'access_token';

  /// Saves the active access token securely.
  static Future<void> save_access_token(String token) async {
    await _storage.write(key: _key_access_token, value: token);
  }

  /// Retrieves the securely stored access token if present.
  static Future<String?> get_access_token() async {
    return await _storage.read(key: _key_access_token);
  }

  /// Clears the securely stored access token.
  static Future<void> clear_access_token() async {
    await _storage.delete(key: _key_access_token);
  }
}
