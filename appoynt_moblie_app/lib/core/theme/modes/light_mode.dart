/*
 * File Name: light_mode.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/06/2026
 * Version Information: 1.0.0
 * Dependencies:
 *   - flutter/material.dart
 *   - package:appoynt_mobile_app/core/theme/colors/app_colors.dart
 *   - package:appoynt_mobile_app/core/routing/route_export.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 19/06/2026]
 * File Description: Defines the light theme configuration for the Appoynt mobile application.
 */

// Importing standard material framework widgets and configurations
import 'package:flutter/material.dart';
// Importing application central color design token constants
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';

// Defining the light mode ThemeData configuration utilizing centralized tokens
final ThemeData light_mode_theme = ThemeData(
  // Specifying brightness parameter as light mode standard
  brightness: Brightness.light,
  // Defining background color token configuration
  scaffoldBackgroundColor: AppColors.background_light,
  // Configuring visual elements theme extension colors
  colorScheme: const ColorScheme.light(
    // Setting primary color scheme token mapping
    primary: AppColors.primary_color,
    // Setting surface containers scheme token mapping
    surface: AppColors.surface_light,
  ),
  // Configuring navigation app bar top headers
  appBarTheme: const AppBarTheme(
    // Setting app bar background color token mapping
    backgroundColor: AppColors.background_light,
    // Setting elevated shadow height as zero to keep layout flat
    elevation: 0.0,
    // Setting foreground content color standard (text & icons)
    foregroundColor: AppColors.text_light_primary,
  ),
);
// End of light_mode.dart
