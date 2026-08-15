/*
 * File Name: app_spacing.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/06/2026
 * Version Information: V1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 19/07/2026]
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

  // Extra extra extra large layout spacing dimension equivalent to forty-eight units
  static const double space_xxxxl = 48.0;

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

  // Default cross fade transition duration in milliseconds (reduced to 250
  // for faster, snappier transitions)
  static const int duration_fade_ms = 250;

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

  // Standard height constraint for authentication action button components
  static const double height_auth_button = 52.0;

  // Layout size constraint representing the brand logo display on login
  static const double size_logo_login = 150.0;

  // Rounded corner radius value for form input text fields
  static const double radius_input = 14.0;

  // Vertical padding constraint for authentication input text fields
  // (decreased by 2.5px to shrink height by 5px)
  static const double padding_input_vertical = 13.5;

  // Typographic font size for input field labels
  static const double font_size_label = 13.0;

  // Typographic font size for default input field texts
  static const double font_size_text = 15.0;

  // Typographic font size for welcoming header titles
  static const double font_size_title = 26.0;

  // Typographic font size for welcoming sub-header subtitles
  static const double font_size_subtitle = 14.0;

  // Typographic font size for standard body text content
  static const double font_size_body_medium = 14.0;

  // Typographic font size for forgot password navigation link
  static const double font_size_forgot_link = 14.0;

  // Typographic font size for small body text content
  static const double font_size_body_small = 12.0;

  // Typographic font size for caption metadata and timestamps
  static const double font_size_caption = 11.0;

  // Typographic font size for standard dialog/bottom sheet titles
  static const double font_size_dialog_title = 18.0;

  // Standard line thickness definition for default borders
  static const double border_width_thin = 1.0;

  // Accent line thickness definition for focused component borders
  static const double border_width_thick = 2.0;

  // TODO: START OF DUMMY HOME SCREEN SPACING TOKENS - REMOVE ONCE FINAL HOME IS COMPLETED
  // Standard padding constraint for home tab contents
  static const double dummy_padding_home = 20.0;

  // Standard vertical spacing spacing between content sections on home page
  static const double dummy_spacing_home = 20.0;

  // Container height and width for notification bell icon
  static const double dummy_size_notification_bell = 44.0;

  // Container height for search text field on home page
  static const double dummy_height_search_bar = 50.0;

  // Font size for labels in the bottom navigation items
  static const double dummy_font_size_nav_label = 10.0;

  // Font size for greeting title text on home screen
  static const double dummy_font_size_welcome = 22.0;

  // Size of the notification icon inside the bell container
  static const double dummy_size_icon_notification = 22.0;

  // Size of the icons inside the bottom navigation bar
  static const double dummy_size_icon_nav = 24.0;

  // Larger spacing between sections on the home screen
  static const double dummy_spacing_large = 28.0;

  // Height constraint for horizontal specialties list view
  static const double dummy_height_specialties_list = 90.0;

  // Size constraint for the coming soon circle widget
  static const double dummy_size_coming_soon_circle = 80.0;

  // Size constraint for the coming soon icon widget
  static const double dummy_size_coming_soon_icon = 38.0;

  // Diameter of the doctor profile avatar icon
  static const double dummy_size_doctor_avatar = 54.0;

  // Tiny layout spacer dimension
  static const double dummy_space_tiny = 3.0;

  // Small layout spacer dimension
  static const double dummy_space_small = 6.0;

  // Padding inside small badge elements like buttons
  static const double dummy_padding_small_badge = 7.0;

  // Line height height spacing for bottom navigation text labels
  static const double dummy_line_height_nav = 1.3;

  // Blur radius for bottom navigation container shadow
  static const double dummy_bottom_nav_blur_radius = 20.0;

  // Vertical offset offset of bottom navigation shadow
  static const double dummy_bottom_nav_shadow_offset_y = -4.0;

  // Horizontal padding around bottom navigation layout row
  static const double dummy_bottom_nav_padding_horizontal = 8.0;

  // Vertical padding around bottom navigation layout row
  static const double dummy_bottom_nav_padding_vertical = 8.0;

  // Horizontal padding within bottom navigation items
  static const double dummy_bottom_nav_item_padding_horizontal = 16.0;

  // Vertical padding within bottom navigation items
  static const double dummy_bottom_nav_item_padding_vertical = 8.0;

  // Border radius for bottom navigation item backgrounds
  static const double dummy_bottom_nav_item_radius = 20.0;

  // Size constraint of notification alert badge dot
  static const double dummy_notification_badge_size = 8.0;

  // Offset position of notification alert badge dot
  static const double dummy_notification_badge_offset = 8.0;

  // Border radius for search text field container
  static const double dummy_search_bar_radius = 14.0;

  // Left side padding constraint within search text field container
  static const double dummy_search_bar_padding_left = 14.0;

  // Width spacer between search icon and text hint
  static const double dummy_search_bar_spacing = 10.0;

  // Vertical padding inside quick action buttons
  static const double dummy_quick_action_padding_vertical = 14.0;

  // Border radius for quick action button container
  static const double dummy_quick_action_radius = 14.0;

  // Size of the icon inside quick action buttons
  static const double dummy_quick_action_icon_size = 26.0;

  // Space between quick action buttons inside horizontal row
  static const double dummy_quick_action_spacing = 12.0;

  // Padding inside appointment banner container
  static const double dummy_banner_padding = 16.0;

  // Border radius for appointment banner container
  static const double dummy_banner_radius = 16.0;

  // Size of calendar icon in appointment banner
  static const double dummy_banner_icon_size = 64.0;

  // Right side spacing margin for specialty category chips
  static const double dummy_specialty_chip_margin_right = 12.0;

  // Horizontal padding inside specialty category chips
  static const double dummy_specialty_chip_padding_horizontal = 16.0;

  // Vertical padding inside specialty category chips
  static const double dummy_specialty_chip_padding_vertical = 12.0;

  // Border radius for specialty category chips container
  static const double dummy_specialty_chip_radius = 14.0;

  // Padding inside doctor card container
  static const double dummy_doctor_card_padding = 14.0;

  // Border radius for doctor card container
  static const double dummy_doctor_card_radius = 16.0;

  // Diameter of avatar inside doctor card components
  static const double dummy_doctor_card_avatar_size = 54.0;

  // Icon size of placeholder avatar inside doctor cards
  static const double dummy_doctor_card_avatar_icon_size = 28.0;

  // Star icon size inside doctor rating elements
  static const double dummy_doctor_card_rating_icon_size = 14.0;

  // Work bag icon size inside doctor experience elements
  static const double dummy_doctor_card_work_icon_size = 13.0;

  // Horizontal padding inside doctor card CTA button
  static const double dummy_doctor_card_btn_padding_horizontal = 14.0;

  // Vertical padding inside doctor card CTA button
  static const double dummy_doctor_card_btn_padding_vertical = 8.0;

  // Border radius for doctor card CTA button
  static const double dummy_doctor_card_btn_radius = 20.0;

  // Radius for circular border decorations on coming soon screen
  static const double dummy_coming_soon_radius = 40.0;

  // Opacity value for selected bottom navigation item background
  static const double dummy_opacity_active = 0.1;

  // Opacity value for notification bell badge layout overlay
  static const double dummy_opacity_bell_badge = 0.3;

  // Opacity value for doctor card placeholder profile avatar background
  static const double dummy_opacity_avatar = 0.12;

  // Opacity value for quick action card icon background
  static const double dummy_opacity_badge = 0.08;

  // Opacity value for quick action card outline borders
  static const double dummy_opacity_border = 0.15;

  // Font size for specialty chip label text
  static const double dummy_font_size_specialty = 11.0;

  // Font size for doctor card rating subtext
  static const double dummy_font_size_rating = 12.0;
  // TODO: END OF DUMMY HOME SCREEN SPACING TOKENS

  // Height dimension representation for the top search input bar
  static const double search_bar_height = 48.0;

  // Corner radius layout configuration for the top search input bar (matching Home Screen 14px radius)
  static const double search_bar_radius = 14.0;

  // Height dimension representation for Location and Specialty filter chips
  static const double search_chip_height = 38.0;

  // Corner radius layout configuration for Location and Specialty filter chips
  static const double search_chip_radius = 12.0;

  // Total height constraint dimension for fixed bottom navigation bar
  static const double search_nav_height = 84.0;

  // Width and height dimension constraint for circular doctor avatar images
  static const double search_avatar_size = 40.0;

  // Width and height dimension constraint for bottom navigation icons
  static const double search_nav_icon_size = 24.0;

  // Typographic font size for micro labels inside bottom navigation bar
  static const double search_nav_label_font = 11.0;

  // Vertical spacing offset between bottom navigation icon and text label
  static const double search_nav_label_top = 4.0;

  // Typographic font size for uppercase recent searches section title
  static const double search_recent_title_font = 12.0;

  // Height dimension representation for each doctor autocomplete suggestion row list item
  static const double search_row_height = 68.0;

  // Horizontal gap offset spacing between Location and Specialty filter chips
  static const double search_chips_gap = 8.0;

  // Corner radius layout configuration for suggestions container card layer
  static const double search_card_radius = 16.0;

  // Width and height dimension constraint for search result doctor card avatar (75px)
  static const double doctor_card_avatar_size = 75.0;

  // Corner radius layout configuration for search result doctor card avatar (37.5px for perfect circle)
  static const double doctor_card_avatar_radius = 37.5;

  // Icon size for fallback/placeholder states inside doctor card avatar (37.5px)
  static const double doctor_card_avatar_icon_size = 37.5;

  // Image decode cache width/height constraint for doctor card avatar to optimize memory usage (150px)
  static const double doctor_card_avatar_cache_size = 150.0;

  // Fixed height for validation error container below subtitle to prevent layout shifts (40px)
  static const double error_container_height = 40.0;

  // Height dimension constraint for profile header banner area (200px)
  static const double profile_header_height = 200.0;

  // Circular radius dimension for patient avatar layout in profile view (50px)
  static const double profile_avatar_radius = 50.0;

  // Circular radius dimension for patient avatar layout in profile edit mode (60px)
  static const double profile_edit_avatar_radius = 60.0;

  // Spacing padding offset dimension constraint for profile row cards (16px)
  static const double profile_card_padding = 16.0;

  // Small icon display size constraint (16px)
  static const double icon_size_s = 16.0;

  // Medium icon display size constraint (24px)
  static const double icon_size_m = 24.0;

  // Large icon display size constraint (32px)
  static const double icon_size_l = 32.0;

  // Extra large icon display size constraint (40px)
  static const double icon_size_xl = 40.0;

  // Double extra large icon display size constraint (48px)
  static const double icon_size_xxl = 48.0;

  // Width dimension for the custom calendar date picker dialog (320px)
  static const double calendar_dialog_width = 320.0;

  // Spacing border radius for custom calendar date picker card (20px)
  static const double calendar_dialog_radius = 20.0;

  // Cell width representation for custom calendar grid cells (36px)
  static const double calendar_grid_cell_size = 36.0;

  // Custom calendar date picker day text size (13px)
  static const double calendar_day_font_size = 13.0;

  // Custom calendar title month/year font size (16px)
  static const double calendar_title_font_size = 16.0;

  // Custom calendar action buttons height (40px)
  static const double calendar_action_button_height = 40.0;

  // Spacing padding offset dimension for custom calendar dialog layout (20px)
  static const double calendar_dialog_padding = 20.0;
}
// End of app_spacing.dart
