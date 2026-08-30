/*
 * File Name: app_theme.dart
 * Author: Kholoud Khaled
 * Date of Creation: 29/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/theme/modes/dark_mode.dart,
 *   package:appoynt_mobile_app/core/theme/modes/light_mode.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 29/08/2026]
 * File Description: Unified static theme entry point exposing AppTheme.darkTheme
 *   and AppTheme.lightTheme for consistent global usage across the application.
 */

import 'package:flutter/material.dart';
import 'package:appoynt_mobile_app/core/theme/modes/dark_mode.dart';
import 'package:appoynt_mobile_app/core/theme/modes/light_mode.dart';

/// Centralized application theme repository exposing dark and light ThemeData instances.
class AppTheme {
  AppTheme._();

  /// Returns the standardized global Dark Slate theme data.
  static ThemeData get darkTheme => dark_mode_theme;

  /// Returns the standardized global Light theme data.
  static ThemeData get lightTheme => light_mode_theme;
}
