/*
 * File Name: app_colors.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/06/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Defines centralized color constants and palettes
 *   for light and dark theme modes.
 */

// Importing the flutter material package to utilize the Color class
import 'package:flutter/material.dart';

// Centralized app colors class to host color design tokens
class AppColors {
  // Brand primary color representation (vibrant blue)
  static const Color primary_color = Color(0xFF0F62FE);

  // Background color constant representation for the light theme mode
  static const Color background_light = Color(0xFFFFFFFF);

  // Background color constant representation for the dark theme mode (lighter dark gray)
  static const Color background_dark = Color(0xFF121212);

  // Primary text color constant representation for the light theme mode
  static const Color text_light_primary = Color(0xFF171717);

  // Primary text color constant representation for the dark theme mode
  static const Color text_dark_primary = Color(0xFFEDEDED);

  // Secondary text color constant representation for the light theme mode
  static const Color text_light_secondary = Color(0xFF767676);

  // Secondary text color constant representation for the dark theme mode
  static const Color text_dark_secondary = Color(0xFF9E9E9E);

  // Surface container color constant representation for the light theme mode
  static const Color surface_light = Color(0xFFF4F4F4);

  // Surface container color constant representation for the dark theme mode
  static const Color surface_dark = Color(0xFF1E1E1E);

  // Divider and border color constant representation for the light theme mode
  static const Color border_light = Color(0xFFE0E0E0);

  // Divider and border color constant representation for the dark theme mode
  static const Color border_dark = Color(0xFF2C2C2C);

  // Background color constant for the onboarding screens layout
  static const Color onboarding_background = Color(0xFFF0F3FA);

  // Color representation for inactive dot indicators in pagination
  static const Color dot_inactive = Color(0xFFCDD5E0);

  // Color representation for invalid validation errors or alert messages
  static const Color error = Color(0xFFE74C3C);

  // Background fill color representation for user input text fields
  static const Color input_fill = Color(0xFFF7F8F9);

  // Pale blue color constant representation for unfilled segments in light theme
  static const Color pale_blue = Color(0xFFD2E3FC);

  // Pale blue color constant representation for unfilled segments in dark theme
  static const Color pale_blue_dark = Color(0xFF1B2E4F);
}
// End of app_colors.dart
