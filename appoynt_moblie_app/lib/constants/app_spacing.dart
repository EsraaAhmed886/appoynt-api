/*
 * File Name: app_spacing.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/06/2026
 * Version Information: 1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/06/2026]
 * File Description: Defines centralized dimension, spacing, border radius, and animation constants.
 */

// Centralized spacing class containing constant values to eliminate raw hardcoded numbers
class AppSpacing {
  // Extra tiny space constant value equal to two units
  static const double space_xs = 2.0;

  // Tiny padding configuration representation for logo icon layout (1.0 pixel)
  static const double padding_logo_tiny = 1.0;

  // Tiny space constant value equal to four units
  static const double space_s = 4.0;

  // Extra small spacing dimension equivalent to eight units
  static const double space_m = 8.0;

  // Medium spacing dimension equivalent to twelve units
  static const double space_l = 12.0;

  // Standard component spacing dimension equivalent to sixteen units
  static const double space_xl = 16.0;

  // Large layout spacing dimension equivalent to twenty-four units
  static const double space_xxl = 24.0;

  // Extra large layout spacing dimension equivalent to thirty-two units
  static const double space_xxxl = 32.0;

  // Extreme layout spacing dimension equivalent to forty-eight units
  static const double space_extreme = 48.0;

  // Small border radius constant value equivalent to four units
  static const double radius_s = 4.0;

  // Medium border radius constant value equivalent to eight units
  static const double radius_m = 8.0;

  // Standard/large border radius constant value equivalent to twelve units
  static const double radius_l = 12.0;

  // Extra large border radius constant value equivalent to sixteen units
  static const double radius_xl = 16.0;

  // Fully rounded/circular border radius representation
  static const double radius_circular = 999.0;

  // Splash screen logo animation duration in milliseconds
  static const int duration_splash_animation_ms = 1500;

  // Splash screen sheen sweep duration in milliseconds
  static const int duration_sheen_sweep_ms = 2000;

  // Splash screen total delay duration in milliseconds before navigating
  static const int duration_splash_delay_ms = 4500;

  // Default cross fade transition duration in milliseconds
  static const int duration_fade_ms = 500;

  // Logo box height and width constraint size
  static const double size_logo_box = 380.0;

  // Small logo container side dimension constraint
  static const double size_logo_box_small = 56.0;

  // Default opacity constant value representing a fully transparent state
  static const double opacity_none = 0.0;

  // Default opacity constant value representing a fully opaque state
  static const double opacity_full = 1.0;

  // Diameter dimension constant for page indicator dots
  static const double size_dot = 10.0;

  // Top spacing constraint for onboarding page layout alignment
  static const double spacing_onboarding_top = 60.0;

  // Bottom margin constraint for dot indicators row spacing
  static const double spacing_dot_bottom = 20.0;

  // Horizontal padding constraint for onboarding content text column
  static const double padding_onboarding_content = 28.0;

  // Spacing height between onboarding title and description text
  static const double spacing_title_subtitle = 14.0;

  // Spacing height reserved at screen bottom for button navigation layouts
  static const double spacing_bottom_reserve = 104.0;

  // Edge offset constraint for positioning skip action button
  static const double offset_skip_button = 20.0;

  // Typography font size constraint for skip button label
  static const double font_size_skip_button = 15.0;

  // Typography font size constraint for main onboarding CTA button
  static const double font_size_action_button = 17.0;

  // Duration in milliseconds for skip button fade animation
  static const int duration_onboarding_fade_ms = 250;

  // Duration in milliseconds for page controller sliding transition
  static const int duration_page_slide_ms = 400;

  // Duration in milliseconds for illustration entrance scaling pop
  static const int duration_illustration_pop_ms = 500;
}
// End of app_spacing.dart
