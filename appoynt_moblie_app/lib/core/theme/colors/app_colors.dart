/*
 * File Name: app_colors.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/06/2026
 * Version Information: V2.2.0
 * Dependencies: package:flutter/material.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 29/08/2026]
 * File Description: Defines centralized color constants and palettes
 *   for light and dark theme modes including dark slate tokens.
 */

// Importing the flutter material package to utilize the Color class
import 'package:flutter/material.dart';

// Centralized app colors class to host color design tokens
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // --- Dark Theme Color Tokens (Extracted from Appointments) ---
  static const Color darkBackground = Color(0xFF0F172A); // Deep Slate background
  static const Color darkSurface = Color(0xFF1E293B);    // Card & container surface
  static const Color darkSurfaceElevated = Color(0xFF243047); // Popups, elevated chips
  static const Color darkBorder = Color(0xFF334155);     // Subtle card & input borders

  // Text Colors (Dark Mode)
  static const Color darkTextPrimary = Color(0xFFF8FAFC);   // Pure crisp white/slate 50
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Muted slate 400
  static const Color darkTextMuted = Color(0xFF64748B);     // Subtext / hints slate 500

  // Accents (Consistent across themes)
  static const Color primary = Color(0xFF0284C7);           // Vibrant Appoynt Blue
  static const Color primaryDarkSurface = Color(0xFF0C4A6E); // Primary chip/badge background in dark mode

  // Primary & Secondary Brand Colors
  static const Color primary_color = Color(0xFF0284C7); // Brand vibrant blue
  static const Color primaryDark = Color(0xFF0369A1); // Blue 700
  static const Color primary_dark = Color(0xFF0369A1);
  static const Color secondary = Color(0xFF4F46E5); // Indigo 600

  // Standard Material Base Colors Mapping
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white80 = Color(0xCCFFFFFF);
  static const Color white60 = Color(0x99FFFFFF);
  static const Color white54 = Color(0x8AFFFFFF);
  static const Color white38 = Color(0x62FFFFFF);
  static const Color white30 = Color(0x4DFFFFFF);
  static const Color white24 = Color(0x3DFFFFFF);
  static const Color white12 = Color(0x1FFFFFFF);
  static const Color white10 = Color(0x1AFFFFFF);

  static const Color black12 = Color(0x1F000000);
  static const Color black26 = Color(0x42000000);
  static const Color black38 = Color(0x61000000);
  static const Color black45 = Color(0x73000000);
  static const Color black54 = Color(0x8A000000);

  // Material Palette Helpers
  static const Color blue = Color(0xFF2196F3);
  static const Color red = Color(0xFFF44336);
  static const Color redAccent = Color(0xFFFF5252);
  static const Color amber = Color(0xFFFFC107);
  static const Color deepOrange = Color(0xFFFF5722);
  static const Color teal = Color(0xFF009688);
  static const Color deepPurple = Color(0xFF673AB7);
  static const Color indigo = Color(0xFF3F51B5);
  static const Color purple = Color(0xFF9C27B0);
  static const Color orange = Color(0xFFFF9800);

  // Grey Scale Helpers
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey_300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Neutrals / Slate Palette (Full Scale)
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate_50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate_100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate_200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate_300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate_400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate_500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate_600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate_700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate_800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate_900 = Color(0xFF0F172A);

  // Extended Cool & Warm Greys
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF2F4F7);
  static const Color gray200 = Color(0xFFE4E7EC);
  static const Color gray_light_bg = Color(0xFFEDF1F7);
  static const Color gray_soft_bg = Color(0xFFF6F8FB);
  static const Color dark_surface_2 = darkSurfaceElevated;

  // Status & Feedback Colors - Success (Emerald / Green)
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color successLight = Color(0xFFECFDF5); // Emerald 50
  static const Color success_light = Color(0xFFECFDF5);
  static const Color emerald50 = Color(0xFFECFDF5);
  static const Color emerald100 = Color(0xFFD1FAE5);
  static const Color emerald200 = Color(0xFFA7F3D0);
  static const Color emerald300 = Color(0xFF6EE7B7);
  static const Color emerald400 = Color(0xFF34D399);
  static const Color emerald500 = Color(0xFF10B981);
  static const Color emerald600 = Color(0xFF059669);
  static const Color emerald700 = Color(0xFF047857);
  static const Color emerald800 = Color(0xFF065F46);
  static const Color emerald900 = Color(0xFF064E3B);
  static const Color green50 = Color(0xFFF0FDF4);
  static const Color green100 = Color(0xFFDCFCE7);
  static const Color green300 = Color(0xFF86EFAC);
  static const Color green400 = Color(0xFF4ADE80);
  static const Color green700 = Color(0xFF15803D);
  static const Color green800 = Color(0xFF166534);
  static const Color green900 = Color(0xFF14532D);

  // Status & Feedback Colors - Warning (Amber / Orange)
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color warningLight = Color(0xFFFFFBEB); // Amber 50
  static const Color warning_light = Color(0xFFFFFBEB);
  static const Color amber50 = Color(0xFFFFFBEB);
  static const Color amber100 = Color(0xFFFEF3C7);
  static const Color amber200 = Color(0xFFFDE68A);
  static const Color amber300 = Color(0xFFFCD34D);
  static const Color amber400 = Color(0xFFFBBF24);
  static const Color amber500 = Color(0xFFF59E0B);
  static const Color amber600 = Color(0xFFD97706);
  static const Color amber700 = Color(0xFFB45309);
  static const Color amber800 = Color(0xFF92400E);
  static const Color amber900 = Color(0xFF78350F);
  static const Color amber950 = Color(0xFF451A03);
  static const Color amberDarkBg = Color(0xFF2E2412);
  static const Color orange50 = Color(0xFFFFF7ED);
  static const Color orange100 = Color(0xFFFFEDD5);
  static const Color orange200 = Color(0xFFFED7AA);
  static const Color orange300 = Color(0xFFFDBA74);
  static const Color orange700 = Color(0xFFC2410C);
  static const Color orange800 = Color(0xFF9A3412);
  static const Color orange900 = Color(0xFF7C2D12);

  // Status & Feedback Colors - Error / Danger (Red / Rose)
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color errorLight = Color(0xFFFEF2F2); // Red 50
  static const Color error_light = Color(0xFFFEF2F2);
  static const Color red50 = Color(0xFFFEF2F2);
  static const Color red100 = Color(0xFFFEE2E2);
  static const Color red200 = Color(0xFFFECACA);
  static const Color red300 = Color(0xFFFCA5A5);
  static const Color red400 = Color(0xFFF87171);
  static const Color red500 = Color(0xFFEF4444);
  static const Color red600 = Color(0xFFDC2626);
  static const Color red700 = Color(0xFFB91C1C);
  static const Color red800 = Color(0xFF991B1B);
  static const Color red900 = Color(0xFF7F1D1D);
  static const Color red950 = Color(0xFF450A0A);
  static const Color redDarkBg = Color(0xFF3B1212);
  static const Color redDarkBorder = Color(0xFF5F1212);

  // Status & Feedback Colors - Info & Extended Blues / Purples
  static const Color info = Color(0xFF0EA5E9); // Sky 500
  static const Color sky50 = Color(0xFFF0F9FF);
  static const Color sky100 = Color(0xFFE0F2FE);
  static const Color sky200 = Color(0xFFBAE6FD);
  static const Color sky500 = Color(0xFF0EA5E9);
  static const Color sky600 = Color(0xFF0284C7);
  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color blue100 = Color(0xFFE8F1FF);
  static const Color blue200 = Color(0xFFBFDBFE);
  static const Color blue300 = Color(0xFF93C5FD);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color blue700 = Color(0xFF1D4ED8);
  static const Color indigo500 = Color(0xFF6366F1);
  static const Color indigo600 = Color(0xFF4338CA);
  static const Color indigo900 = Color(0xFF312E81);
  static const Color indigo950 = Color(0xFF1E1B4B);
  static const Color violet500 = Color(0xFF8B5CF6);
  static const Color purple_badge = Color(0xFF6C5CE7);
  static const Color purple900 = Color(0xFF3E1E68);
  static const Color purple950 = Color(0xFF1E0E36);
  static const Color teal600 = Color(0xFF0D9488);
  static const Color teal_deep = Color(0xFF0D5E6F);
  static const Color navy_dark = Color(0xFF0F2042);
  static const Color gold = Color(0xFFFFD700);

  // Soft Pastel Backgrounds, Borders, and Icons for Notification Banners & Toasts
  static const Color successBg = Color(0xFFE8F8EA);
  static const Color success_bg = Color(0xFFE8F8EA);
  static const Color successBorder = Color(0xFFC3EBC7);
  static const Color success_border = Color(0xFFC3EBC7);
  static const Color successIcon = Color(0xFF22C55E);
  static const Color success_icon = Color(0xFF22C55E);

  static const Color errorBg = Color(0xFFFFEBEB);
  static const Color error_bg = Color(0xFFFFEBEB);
  static const Color errorBorder = Color(0xFFFFC7C7);
  static const Color error_border = Color(0xFFFFC7C7);
  static const Color errorIcon = Color(0xFFEF4444);
  static const Color error_icon = Color(0xFFEF4444);

  static const Color warningBg = Color(0xFFFFF7DB);
  static const Color warning_bg = Color(0xFFFFF7DB);
  static const Color warningBorder = Color(0xFFFDEBB2);
  static const Color warning_border = Color(0xFFFDEBB2);
  static const Color warningIcon = Color(0xFFF59E0B);
  static const Color warning_icon = Color(0xFFF59E0B);

  static const Color infoBg = Color(0xFFE8F4FD);
  static const Color info_bg = Color(0xFFE8F4FD);
  static const Color infoBorder = Color(0xFFBCE1FD);
  static const Color info_border = Color(0xFFBCE1FD);
  static const Color infoIcon = Color(0xFF3B82F6);
  static const Color info_icon = Color(0xFF3B82F6);

  static const Color notificationText = Color(0xFF1E293B); // Slate 800
  static const Color notification_text = Color(0xFF1E293B);

  // Background color constant representation for the light theme mode
  static const Color background_light = Color(0xFFFFFFFF);

  // Background color constant representation for the light theme mode scaffold
  static const Color scaffold_light = Color(0xFFF8FAFC);

  // Soft, modern dimming barrier overlay color representation (black with 0.3 opacity)
  static const Color barrier_color = Color(0x4D000000);

  // Background color constant representation for the dark theme mode (Deep Slate)
  static const Color background_dark = darkBackground;

  // Primary text color constant representation for the light theme mode
  static const Color text_light_primary = Color(0xFF171717);

  // Primary text color constant representation for the dark theme mode
  static const Color text_dark_primary = darkTextPrimary;

  // Secondary text color constant representation for the light theme mode
  static const Color text_light_secondary = Color(0xFF767676);

  // Secondary text color constant representation for the dark theme mode
  static const Color text_dark_secondary = darkTextSecondary;

  // Surface container color constant representation for the light theme mode
  static const Color surface_light = Color(0xFFF4F4F4);

  // Surface container color constant representation for the dark theme mode
  static const Color surface_dark = darkSurface;

  // Divider and border color constant representation for the light theme mode
  static const Color border_light = Color(0xFFE0E0E0);

  // Divider and border color constant representation for the dark theme mode
  static const Color border_dark = darkBorder;

  // Distinct darker slate-gray background tint for inner bounding boxes in Light Mode
  static const Color inner_container_light = Color(0xFFCBD5E1);

  // Background color constant representation for inner bounding boxes in Dark Mode
  static const Color inner_container_dark = darkSurfaceElevated;

  // Defined 1px border outline for inner track containers in Light Mode
  static const Color inner_container_border_light = Color(0xFF94A3B8);

  // Defined 1px border outline for inner track containers in Dark Mode
  static const Color inner_container_border_dark = darkBorder;

  // Background color constant for the onboarding screens layout
  static const Color onboarding_background = Color(0xFFF0F3FA);

  // Color representation for inactive dot indicators in pagination
  static const Color dot_inactive = Color(0xFFCDD5E0);

  // Background fill color representation for user input text fields
  static const Color input_fill = Color(0xFFF7F8F9);

  // Pale blue color constant representation for unfilled segments in light theme
  static const Color pale_blue = Color(0xFFD2E3FC);

  // Pale blue color constant representation for unfilled segments in dark theme
  static const Color pale_blue_dark = Color(0xFF1B2E4F);

  // Dummy Home Screen Color Tokens
  static const Color dummy_secondary_color = Color(0xFF00BFA5);
  static const Color dummy_custom_purple = Color(0xFF9B59B6);
  static const Color dummy_accent_color = Color(0xFFFF6D00);
  static const Color dummy_custom_red = Color(0xFFE74C3C);
  static const Color dummy_primary_dark = Color(0xFF0D47A1);
  static const Color dummy_custom_blue = Color(0xFF3498DB);
  static const Color dummy_custom_green = Color(0xFF2ECC71);
  static const Color dummy_custom_orange = Color(0xFFE67E22);
  static const Color dummy_rating_star_yellow = Color(0xFFF39C12);
  static const Color dummy_shadow_color = Color(0x12000000);
  static const Color dummy_unselected_item_color = Color(0xFF767676);

  // Search & Filters Color Tokens
  static const Color search_card_bg = Color(0xFFFFFFFF);
  static const Color search_chip_bg = Color(0xFFF5F5F5);
  static const Color search_chip_active_bg = Color(0xFFE0F2F1);
  static const Color search_chip_text_color = Color(0xFF757575);
  static const Color search_text_slate = Color(0xFF2C3E50);
  static const Color search_alert_modal_bg = Color(0xFFFFFFFF);
  static const Color search_modal_barrier = Color(0x80000000);
  static const Color search_text_muted = Color(0xFF888888);

  // Avatar Outlines
  static const Color avatar_border_light = Color(0xFF94A3B8);
  static const Color avatar_border_dark = Color(0xFF475569);

  // Icon Colors
  static const Color icon_dark = Color(0xFF9E9E9E);
  static const Color icon_light = Color(0xFF767676);
}
// End of app_colors.dart
