/*
 * File Name: app_text_styles.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/06/2026
 * Version Information: V1.0.0
 * Dependencies: package:google_fonts/google_fonts.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Typographic directory holding all text style definitions.
 */

// Importing google fonts package to pull dynamic typography formats
import 'package:google_fonts/google_fonts.dart';
// Importing central global barrel file for design tokens
import 'package:appoynt_mobile_app/core/routing/route_export.dart';

// Typography registry utility class housing centralized text styles
class AppTextStyles {
  // Private constructor to prevent direct class instantiation
  AppTextStyles._();

  // Getter returning text style representation for large headers
  static TextStyle get headline_large {
    // Return custom TextStyle configuring size, weight, and spacing
    return const TextStyle(
      // Set font size to twenty-four pixels
      fontSize: 24.0,
      // Set weight parameter using bold helper
      fontWeight: FontWeightHelper.bold,
      // Set line height multiplier for text block spacing
      height: 1.2,
    );
  }

  // Method to fetch dynamically configured title text style for onboarding flow
  static TextStyle get_onboarding_title(BuildContext context, bool is_arabic) {
    // Check if system brightness is dark mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Resolve dynamic text color token based on active mode using Yoda style comparison
    final Color text_color = is_dark
        ? AppColors.text_dark_primary
        : AppColors.text_light_primary;

    // Return GoogleFonts widget based on active system language direction check
    return is_arabic
        // If language direction is Arabic, return Cairo Google Font configuration
        ? GoogleFonts.cairo(
            // Set font size to twenty pixels
            fontSize: 20.0,
            // Set weight parameter using bold helper
            fontWeight: FontWeightHelper.bold,
            // Apply centralized color token
            color: text_color,
          )
        // If language direction is English, return Inter Google Font configuration
        : GoogleFonts.inter(
            // Set font size to seventeen pixels
            fontSize: 17.0,
            // Set weight parameter using semi-bold helper
            fontWeight: FontWeightHelper.semi_bold,
            // Apply centralized color token
            color: text_color,
          );
  }

  // Method to fetch dynamically configured subtitle text style for onboarding flow
  static TextStyle get_onboarding_subtitle(BuildContext context, bool is_arabic) {
    // Check if system brightness is dark mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Resolve dynamic text color token based on active mode using Yoda style comparison
    final Color text_color = is_dark
        ? AppColors.text_dark_secondary
        : AppColors.text_light_secondary;

    // Return GoogleFonts widget based on active system language direction check
    return is_arabic
        // If language direction is Arabic, return Cairo Google Font configuration
        ? GoogleFonts.cairo(
            // Set font size to fourteen pixels
            fontSize: 14.0,
            // Set weight parameter using regular helper
            fontWeight: FontWeightHelper.regular,
            // Apply centralized color token
            color: text_color,
            // Set relative line height value for readable Arabic line wrapping
            height: 1.6,
          )
        // If language direction is English, return Inter Google Font configuration
        : GoogleFonts.inter(
            // Set font size to thirteen pixels
            fontSize: 13.0,
            // Set weight parameter using regular helper
            fontWeight: FontWeightHelper.regular,
            // Apply centralized color token
            color: text_color,
            // Set relative line height value for readable English line wrapping
            height: 1.6,
          );
  }

  // Method to fetch dynamically configured title text style for the login page
  static TextStyle get_login_title(BuildContext context, bool is_arabic) {
    // Check if system brightness matches dark theme mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Resolve dynamic text color token based on active mode using Yoda style comparison
    final Color text_color = is_dark
        ? AppColors.text_dark_primary
        : AppColors.text_light_primary;
    // Return GoogleFonts config based on language check
    return is_arabic
        // For Arabic, use Cairo font family
        ? GoogleFonts.cairo(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_title,
            // Set weight parameter using extra bold helper
            fontWeight: FontWeightHelper.extra_bold,
            // Apply text color definition token
            color: text_color,
          )
        // For English, use Inter font family
        : GoogleFonts.inter(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_title,
            // Set weight parameter using extra bold helper
            fontWeight: FontWeightHelper.extra_bold,
            // Apply text color definition token
            color: text_color,
          );
  }

  // Method to fetch dynamically configured subtitle text style for the login page
  static TextStyle get_login_subtitle(BuildContext context, bool is_arabic) {
    // Check if system brightness matches dark theme mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Resolve dynamic text color token based on active mode using Yoda style comparison
    final Color text_color = is_dark
        ? AppColors.text_dark_secondary
        : AppColors.text_light_secondary;
    // Return GoogleFonts config based on language check
    return is_arabic
        // For Arabic, use Cairo font family
        ? GoogleFonts.cairo(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_subtitle,
            // Set weight parameter using regular helper
            fontWeight: FontWeightHelper.regular,
            // Apply text color definition token
            color: text_color,
          )
        // For English, use Inter font family
        : GoogleFonts.inter(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_subtitle,
            // Set weight parameter using regular helper
            fontWeight: FontWeightHelper.regular,
            // Apply text color definition token
            color: text_color,
          );
  }

  // Method to fetch dynamically configured label text style for input form fields
  static TextStyle get_field_label(BuildContext context, bool is_arabic) {
    // Check if system brightness matches dark theme mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Resolve dynamic text color token based on active mode using Yoda style comparison
    final Color text_color = is_dark
        ? AppColors.text_dark_primary
        : AppColors.text_light_primary;
    // Return GoogleFonts config based on language check
    return is_arabic
        // For Arabic, use Cairo font family
        ? GoogleFonts.cairo(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_label,
            // Set weight parameter using semi bold helper
            fontWeight: FontWeightHelper.semi_bold,
            // Apply text color definition token
            color: text_color,
          )
        // For English, use Inter font family
        : GoogleFonts.inter(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_label,
            // Set weight parameter using semi bold helper
            fontWeight: FontWeightHelper.semi_bold,
            // Apply text color definition token
            color: text_color,
          );
  }

  // Method to fetch dynamically configured body text style with optional custom colors
  static TextStyle get_body_medium(BuildContext context, bool is_arabic, {Color? custom_color}) {
    // Check if system brightness matches dark theme mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Resolve fallback secondary text color token using Yoda style comparison
    final Color text_color = custom_color ?? (is_dark
        ? AppColors.text_dark_secondary
        : AppColors.text_light_secondary);
    // Return GoogleFonts config based on language check
    return is_arabic
        // For Arabic, use Cairo font family
        ? GoogleFonts.cairo(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_body_medium,
            // Set weight parameter using regular helper
            fontWeight: FontWeightHelper.regular,
            // Apply resolved text color token
            color: text_color,
          )
        // For English, use Inter font family
        : GoogleFonts.inter(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_body_medium,
            // Set weight parameter using regular helper
            fontWeight: FontWeightHelper.regular,
            // Apply resolved text color token
            color: text_color,
          );
  }

  // Method to fetch dynamically configured title text style for the register page
  static TextStyle get_register_title(BuildContext context, bool is_arabic) {
    // Check if system brightness matches dark theme mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Resolve dynamic text color token based on active mode using Yoda style comparison
    final Color text_color = is_dark
        ? AppColors.text_dark_primary
        : AppColors.text_light_primary;
    // Return GoogleFonts config based on language check
    return is_arabic
        // For Arabic, use Cairo font family
        ? GoogleFonts.cairo(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_title,
            // Set weight parameter using extra bold helper
            fontWeight: FontWeightHelper.extra_bold,
            // Apply text color definition token
            color: text_color,
          )
        // For English, use Inter font family
        : GoogleFonts.inter(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_title,
            // Set weight parameter using extra bold helper
            fontWeight: FontWeightHelper.extra_bold,
            // Apply text color definition token
            color: text_color,
          );
  }

  // Method to fetch dynamically configured subtitle text style for the register page
  static TextStyle get_register_subtitle(BuildContext context, bool is_arabic) {
    // Check if system brightness matches dark theme mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Resolve dynamic text color token based on active mode using Yoda style comparison
    final Color text_color = is_dark
        ? AppColors.text_dark_secondary
        : AppColors.text_light_secondary;
    // Return GoogleFonts config based on language check
    return is_arabic
        // For Arabic, use Cairo font family
        ? GoogleFonts.cairo(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_subtitle,
            // Set weight parameter using regular helper
            fontWeight: FontWeightHelper.regular,
            // Apply text color definition token
            color: text_color,
          )
        // For English, use Inter font family
        : GoogleFonts.inter(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_subtitle,
            // Set weight parameter using regular helper
            fontWeight: FontWeightHelper.regular,
            // Apply text color definition token
            color: text_color,
          );
  }

  // Method to fetch dynamically configured title text style for the OTP page
  static TextStyle get_otp_title(BuildContext context, bool is_arabic) {
    // Check if system brightness matches dark theme mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Resolve dynamic text color token based on active mode using Yoda style comparison
    final Color text_color = is_dark
        ? AppColors.text_dark_primary
        : AppColors.text_light_primary;
    // Return GoogleFonts config based on language check
    return is_arabic
        // For Arabic, use Cairo font family
        ? GoogleFonts.cairo(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_title,
            // Set weight parameter using extra bold helper
            fontWeight: FontWeightHelper.extra_bold,
            // Apply text color definition token
            color: text_color,
          )
        // For English, use Inter font family
        : GoogleFonts.inter(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_title,
            // Set weight parameter using extra bold helper
            fontWeight: FontWeightHelper.extra_bold,
            // Apply text color definition token
            color: text_color,
          );
  }

  // Method to fetch dynamically configured subtitle text style for the OTP page
  static TextStyle get_otp_subtitle(BuildContext context, bool is_arabic) {
    // Check if system brightness matches dark theme mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Resolve dynamic text color token based on active mode using Yoda style comparison
    final Color text_color = is_dark
        ? AppColors.text_dark_secondary
        : AppColors.text_light_secondary;
    // Return GoogleFonts config based on language check
    return is_arabic
        // For Arabic, use Cairo font family
        ? GoogleFonts.cairo(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_subtitle,
            // Set weight parameter using regular helper
            fontWeight: FontWeightHelper.regular,
            // Apply text color definition token
            color: text_color,
          )
        // For English, use Inter font family
        : GoogleFonts.inter(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_subtitle,
            // Set weight parameter using regular helper
            fontWeight: FontWeightHelper.regular,
            // Apply text color definition token
            color: text_color,
          );
  }

  // Method to fetch dynamically configured timer text style for the OTP page
  static TextStyle get_otp_timer(BuildContext context, bool is_arabic) {
    // Resolve dynamic text color token based on active mode
    const Color text_color = AppColors.primary_color;
    // Return GoogleFonts config based on language check
    return is_arabic
        // For Arabic, use Cairo font family
        ? GoogleFonts.cairo(
            // Set font size
            fontSize: 14.0,
            // Set weight parameter using bold helper
            fontWeight: FontWeightHelper.bold,
            // Apply text color definition token
            color: text_color,
          )
        // For English, use Inter font family
        : GoogleFonts.inter(
            // Set font size
            fontSize: 14.0,
            // Set weight parameter using bold helper
            fontWeight: FontWeightHelper.bold,
            // Apply text color definition token
            color: text_color,
          );
  }

  // Method to fetch dynamically configured title text style for the Forgot Password page
  static TextStyle get_forgot_password_title(BuildContext context, bool is_arabic) {
    // Check if system brightness matches dark theme mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Resolve dynamic text color token based on active mode using Yoda style comparison
    final Color text_color = is_dark
        ? AppColors.text_dark_primary
        : AppColors.text_light_primary;
    // Return GoogleFonts config based on language check
    return is_arabic
        // For Arabic, use Cairo font family
        ? GoogleFonts.cairo(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_title,
            // Set weight parameter using extra bold helper
            fontWeight: FontWeightHelper.extra_bold,
            // Apply text color definition token
            color: text_color,
          )
        // For English, use Inter font family
        : GoogleFonts.inter(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_title,
            // Set weight parameter using extra bold helper
            fontWeight: FontWeightHelper.extra_bold,
            // Apply text color definition token
            color: text_color,
          );
  }

  // Method to fetch dynamically configured subtitle text style for the Forgot Password page
  static TextStyle get_forgot_password_subtitle(BuildContext context, bool is_arabic) {
    // Check if system brightness matches dark theme mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Resolve dynamic text color token based on active mode using Yoda style comparison
    final Color text_color = is_dark
        ? AppColors.text_dark_secondary
        : AppColors.text_light_secondary;
    // Return GoogleFonts config based on language check
    return is_arabic
        // For Arabic, use Cairo font family
        ? GoogleFonts.cairo(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_subtitle,
            // Set weight parameter using regular helper
            fontWeight: FontWeightHelper.regular,
            // Apply text color definition token
            color: text_color,
          )
        // For English, use Inter font family
        : GoogleFonts.inter(
            // Set font size from spacing constants
            fontSize: AppSpacing.font_size_subtitle,
            // Set weight parameter using regular helper
            fontWeight: FontWeightHelper.regular,
            // Apply text color definition token
            color: text_color,
          );
  }

  // Method to fetch dynamically configured title text style for the no internet page
  static TextStyle get_no_internet_title(BuildContext context, bool is_arabic) {
    // Check if system brightness matches dark theme mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Resolve dynamic text color token based on active mode using Yoda style comparison
    final Color text_color = is_dark
        ? AppColors.text_dark_primary
        : AppColors.text_light_primary;
    // Return GoogleFonts config based on language check
    return is_arabic
        // For Arabic, use Cairo font family
        ? GoogleFonts.cairo(
            // Set font size
            fontSize: 24.0,
            // Set weight parameter using extra bold helper
            fontWeight: FontWeightHelper.extra_bold,
            // Apply text color
            color: text_color,
          )
        // For English, use Inter font family
        : GoogleFonts.inter(
            // Set font size
            fontSize: 24.0,
            // Set weight parameter using extra bold helper
            fontWeight: FontWeightHelper.extra_bold,
            // Apply text color
            color: text_color,
          );
  }

  // Method to fetch dynamically configured subtitle text style for the no internet page
  static TextStyle get_no_internet_subtitle(BuildContext context, bool is_arabic) {
    // Check if system brightness matches dark theme mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Resolve dynamic text color token based on active mode using Yoda style comparison
    final Color text_color = is_dark
        ? AppColors.text_dark_secondary
        : AppColors.text_light_secondary;
    // Return GoogleFonts config based on language check
    return is_arabic
        // For Arabic, use Cairo font family
        ? GoogleFonts.cairo(
            // Set font size
            fontSize: 14.0,
            // Set weight parameter using regular helper
            fontWeight: FontWeightHelper.regular,
            // Set relative line height value for readable Arabic line wrapping
            height: 1.6,
            // Apply text color
            color: text_color,
          )
        // For English, use Inter font family
        : GoogleFonts.inter(
            // Set font size
            fontSize: 14.0,
            // Set weight parameter using regular helper
            fontWeight: FontWeightHelper.regular,
            // Set relative line height value for readable English line wrapping
            height: 1.6,
            // Apply text color
            color: text_color,
          );
  }
}
