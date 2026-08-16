/*
 * File Name: app_colors.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/06/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Defines centralized color constants and palettes
 *   for light and dark theme modes.
 */

// Importing the flutter material package to utilize the Color class
import 'package:flutter/material.dart';

// Centralized app colors class to host color design tokens
class AppColors {
  // Brand primary color representation (vibrant blue)
  static const Color primary_color = Color(0xFF0F62FE);

  // Standard material base colors mapping
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white60 = Color(0x99FFFFFF);
  static const Color white54 = Color(0x8AFFFFFF);
  static const Color white38 = Color(0x62FFFFFF);
  static const Color white30 = Color(0x4DFFFFFF);
  static const Color white12 = Color(0x1FFFFFFF);
  static const Color black12 = Color(0x1F000000);
  static const Color black26 = Color(0x42000000);
  static const Color black38 = Color(0x61000000);
  static const Color black45 = Color(0x73000000);
  static const Color black54 = Color(0x8A000000);
  static const Color grey_300 = Color(0xFFE0E0E0);
  static const Color blue = Color(0xFF2196F3);
  static const Color red = Color(0xFFF44336);
  static const Color amber = Color(0xFFFFC107);
  static const Color deepOrange = Color(0xFFFF5722);
  static const Color teal = Color(0xFF009688);
  static const Color deepPurple = Color(0xFF673AB7);
  static const Color indigo = Color(0xFF3F51B5);
  static const Color purple = Color(0xFF9C27B0);
  static const Color orange = Color(0xFFFF9800);
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color white24 = Color(0x3DFFFFFF);

  // Background color constant representation for the light theme mode
  static const Color background_light = Color(0xFFFFFFFF);

  // Background color constant representation for the light theme mode scaffold
  static const Color scaffold_light = Color(0xFFF8FAFC);

  // Soft, modern dimming barrier overlay color representation (black with 0.3 opacity)
  static const Color barrier_color = Color(0x4D000000);

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

  // Distinct darker slate-gray background tint for inner bounding boxes in Light Mode
  static const Color inner_container_light = Color(0xFFCBD5E1);

  // Background color constant representation for inner bounding boxes in Dark Mode
  static const Color inner_container_dark = Color(0xFF262626);

  // Defined 1px border outline for inner track containers in Light Mode
  static const Color inner_container_border_light = Color(0xFF94A3B8);

  // Defined 1px border outline for inner track containers in Dark Mode
  static const Color inner_container_border_dark = Color(0xFF3B4252);

  // Background color constant for the onboarding screens layout
  static const Color onboarding_background = Color(0xFFF0F3FA);

  // Color representation for inactive dot indicators in pagination
  static const Color dot_inactive = Color(0xFFCDD5E0);

  // Color representation for invalid validation errors or alert messages
  static const Color error = Color(0xFFE74C3C);

  // Color representation for successful validations or actions (active green)
  static const Color success = Color(0xFF10B981);

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

  // Border outline color for circular doctor avatar in light mode
  static const Color avatar_border_light = Color(0xFF94A3B8);

  // Border outline color for circular doctor avatar in dark mode
  static const Color avatar_border_dark = Color(0xFF475569);

  // Soft border slate gray color representation
  static const Color slate_200 = Color(0xFFE2E8F0);

  // Additional slate color design tokens for form inputs and widgets
  static const Color slate_50 = Color(0xFFF8FAFC);
  static const Color slate_300 = Color(0xFFCBD5E1);
  static const Color slate_400 = Color(0xFF94A3B8);
  static const Color slate_500 = Color(0xFF64748B);
  static const Color slate_600 = Color(0xFF475569);

  // Icon color representation for the dark theme mode
  static const Color icon_dark = Color(0xFF9E9E9E);

  // Icon color representation for the light theme mode
  static const Color icon_light = Color(0xFF767676);
}
// End of app_colors.dart
