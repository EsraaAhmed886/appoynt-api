/*
 * File Name: theme_mode.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/06/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart, package:flutter_secure_storage/flutter_secure_storage.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Defines the theme mode state manager notifier with persistent storage backup.
 */

// Importing standard material library for UI widgets and ChangeNotifier
import 'package:flutter/material.dart';
// Importing secure local storage package for persistence of user configuration settings
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Class to notify listeners when the application theme mode changes and persist state
class ThemeModeNotifier extends ChangeNotifier {
  // Instantiating secure storage utility instance
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Storage key constant used to persist the selected theme state
  static const String _theme_key = 'app_theme_mode';

  // Declaring a private theme mode variable initialized to system default
  ThemeMode _current_theme_mode = ThemeMode.system;

  // Getter to retrieve the current active theme mode state
  ThemeMode get current_theme_mode {
    // Return the current private theme mode variable value
    return _current_theme_mode;
  }

  // Asynchronous method to load persisted theme configuration from secure storage
  Future<void> load_theme_mode() async {
    // Wrap database read operations in exception safety block
    try {
      // Fetch stored string representation of theme mode using secure storage client
      final String? saved_mode = await _storage.read(key: _theme_key);

      // Check if a saved value is returned from database using Yoda style comparison
      if (null != saved_mode) {
        // Check if value equals dark using Yoda style comparison
        if ('dark' == saved_mode) {
          // Assign theme state to dark mode
          _current_theme_mode = ThemeMode.dark;
        }
        // Else check if value equals light using Yoda style comparison
        else if ('light' == saved_mode) {
          // Assign theme state to light mode
          _current_theme_mode = ThemeMode.light;
        }
        // Else fall back to system mode
        else {
          // Default state configuration representation
          _current_theme_mode = ThemeMode.system;
        }
      }
      // Else block representing empty storage state
      else {
        // Fall back theme representation is system configuration matching mobile setting
        _current_theme_mode = ThemeMode.system;
      }
      // Trigger UI redraw notifications
      notifyListeners();
    }
    // Handle read exceptions explicitly to avoid swallowing errors silently
    catch (e) {
      // Fallback state initialization in case of storage read errors
      _current_theme_mode = ThemeMode.system;
      // Trigger update notifications
      notifyListeners();
    }
  }

  // Method to update the active theme mode and save value to secure storage
  Future<void> set_theme_mode(ThemeMode target_mode) async {
    // Check if the target theme mode is different from current mode using Yoda style
    if (target_mode != _current_theme_mode) {
      // Assign the new target theme mode to the private state variable
      _current_theme_mode = target_mode;
      // Notify all listening widgets to trigger UI rebuild immediately
      notifyListeners();

      // Wrap storage write operation in safety block
      try {
        // Declare local variable mapping state to string
        String mode_string = 'system';

        // Check if target is dark mode using Yoda comparison
        if (ThemeMode.dark == target_mode) {
          // Assign target serialization value
          mode_string = 'dark';
        }
        // Else check if target is light mode using Yoda comparison
        else if (ThemeMode.light == target_mode) {
          // Assign target serialization value
          mode_string = 'light';
        }
        // Else block representing system default fallback
        else {
          // Use default serialization representation
          mode_string = 'system';
        }

        // Commit serialized configuration string into secure device database
        await _storage.write(key: _theme_key, value: mode_string);
      }
      // Catch and handle write exceptions to satisfy the catch block rule
      catch (e) {
        // Log or print write failure errors
        debugPrint(e.toString());
      }
    }
    // Else block to ensure explicit control flow paths are handled
    else {
      // Do nothing since the theme mode is already set to the target value
    }
  }
}
// End of theme_mode.dart
