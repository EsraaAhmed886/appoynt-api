/*
 * File Name: dark_mode.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/06/2026
 * Version Information: 1.0.0
 * Dependencies:
 *   - flutter/material.dart
 *   - package:appoynt_mobile_app/core/theme/colors/app_colors.dart
 *   - package:appoynt_mobile_app/core/routing/route_export.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 19/06/2026]
 * File Description: Defines the dark theme configuration for the Appoynt mobile application.
 */

// Importing standard material framework widgets and configurations
import 'package:flutter/material.dart';
// Importing application central color design token constants
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';

// Defining the dark mode ThemeData configuration utilizing centralized tokens
final ThemeData dark_mode_theme = ThemeData(
  // Specifying brightness parameter as dark mode standard
  brightness: Brightness.dark,
  // Defining background color token configuration
  scaffoldBackgroundColor: AppColors.background_dark,
  // Configuring visual elements theme extension colors
  colorScheme: const ColorScheme.dark(
    // Setting primary color scheme token mapping
    primary: AppColors.primary_color,
    // Setting surface containers scheme token mapping
    surface: AppColors.surface_dark,
  ),
  // Configuring navigation app bar top headers
  appBarTheme: const AppBarTheme(
    // Setting app bar background color token mapping
    backgroundColor: AppColors.background_dark,
    // Setting elevated shadow height as zero to keep layout flat
    elevation: 0.0,
    // Setting foreground content color standard (text & icons)
    foregroundColor: AppColors.text_dark_primary,
  ),
);
// End of dark_mode.dart
