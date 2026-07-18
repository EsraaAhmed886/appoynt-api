/*
 * File Name: app_colors.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/06/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/07/2026]
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

  // TODO: START OF DUMMY HOME SCREEN COLOR TOKENS - REMOVE ONCE FINAL HOME IS COMPLETED
  // Secondary color representation for the queue quick action button
  static const Color dummy_secondary_color = Color(0xFF00BFA5);

  // Purple color representation for the video consult quick action and doctor categories
  static const Color dummy_custom_purple = Color(0xFF9B59B6);

  // Accent orange color representation for the medical records quick action button
  static const Color dummy_accent_color = Color(0xFFFF6D00);

  // Cardiology red color representation for specialty category chips and avatars
  static const Color dummy_custom_red = Color(0xFFE74C3C);

  // Darker primary brand shade representation for gradient fills
  static const Color dummy_primary_dark = Color(0xFF0D47A1);

  // Pediatrics blue color representation for specialty category chips and avatars
  static const Color dummy_custom_blue = Color(0xFF3498DB);

  // Eye care green color representation for specialty category chips and avatars
  static const Color dummy_custom_green = Color(0xFF2ECC71);

  // Orthopedic orange color representation for specialty category chips and avatars
  static const Color dummy_custom_orange = Color(0xFFE67E22);

  // Star yellow color representation for doctor rating indicators
  static const Color dummy_rating_star_yellow = Color(0xFFF39C12);

  // Shadow color representation for bottom navigation bar layout decoration
  static const Color dummy_shadow_color = Color(0x12000000);

  // Light brand text secondary color representation for the unselected bottom navigation items
  static const Color dummy_unselected_item_color = Color(0xFF767676);
  // TODO: END OF DUMMY HOME SCREEN COLOR TOKENS

  // Color representation for autocomplete suggestions card background
  static const Color search_card_bg = Color(0xFFFFFFFF);

  // Color representation for default filter chip background fill
  static const Color search_chip_bg = Color(0xFFF5F5F5);

  // Color representation for highlighted active filter chip background fill
  static const Color search_chip_active_bg = Color(0xFFE0F2F1);

  // Color representation for default filter chip labels and icons text
  static const Color search_chip_text_color = Color(0xFF757575);

  // Dark slate color representation for doctor autocomplete suggestion row text labels
  static const Color search_text_slate = Color(0xFF2C3E50);

  // Color representation for alert confirmation dialogue background fill
  static const Color search_alert_modal_bg = Color(0xFFFFFFFF);

  // Color representation for modal barrier dark overlay transparency tint
  static const Color search_modal_barrier = Color(0x80000000);

  // Muted gray color representation for uppercase typography section headers
  static const Color search_text_muted = Color(0xFF888888);
}
// End of app_colors.dart
