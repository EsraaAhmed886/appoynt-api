/*
 * File Name: doctor_card.dart
 * Author: Kholoud Khaled
 * Date of Creation: 04/08/2026
 * Version Information: v1.1.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/constants/app_spacing.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart,
 *   package:appoynt_mobile_app/core/widgets/app_network_image.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Defines a reusable, highly polished Doctor Card component
 *   displaying details, rating, fee, ecg-heart icon, and booking CTA.
 */

// Import standard UI framework
import 'package:flutter/material.dart';
// Import layout design tokens
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
// Import central color palette tokens
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
// Import localization dictionary
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
// Import reusable performance-optimized network image widget
import 'package:appoynt_mobile_app/core/widgets/app_network_image.dart';
// Import unified ECG pulse heart button
import 'package:appoynt_mobile_app/features/shared/widgets/favorite_heart_button.dart';


// Local layout dimensions class to strictly eliminate hardcoded numbers
class _LocalDimensions {
  static const double avatar_border_width = 1.5;
}


// Reusable DoctorCard widget definition
class DoctorCard extends StatelessWidget {
  // Doctor name property
  final String doctor_name;
  // Specialization/Specialty property
  final String specialization;
  // Doctor location property
  final String location;
  // Star rating rating count
  final double rating;
  // Review count value
  final int review_count;
  // Price/Fee property
  final double price;
  // Availability status indicator flag
  final bool is_available;
  // Favorite state indicator flag
  final bool is_favorite;
  // Doctor photo avatar URL
  final String avatar_url;
  // Main card tap callback
  final VoidCallback? on_tap;
  // Booking button callback
  final VoidCallback? on_book_tap;
  // Favorite toggling callback
  final VoidCallback? on_favorite_tap;

  // Constant constructor mapping required parameters
  const DoctorCard({
    super.key,
    required this.doctor_name,
    required this.specialization,
    required this.location,
    required this.rating,
    required this.review_count,
    required this.price,
    required this.is_available,
    required this.is_favorite,
    required this.avatar_url,
    this.on_tap,
    this.on_book_tap,
    this.on_favorite_tap,
  });

  @override
  // Build method constructing layout tree
  Widget build(BuildContext context) {
    // Resolve localizations context configuration
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Check if system brightness matches dark theme mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return gesture detector wrapping container displaying card contents
    return GestureDetector(
      onTap: on_tap,
      child: Container(
        // Apply margin at the bottom of the card using design tokens
        margin: const EdgeInsets.only(bottom: AppSpacing.space_xl),
        // Apply internal padding inside the card using design tokens
        padding: const EdgeInsets.all(AppSpacing.space_xl),
        // Visual styling decoration configurations
        decoration: BoxDecoration(
          // Set background color matching active theme
          color: is_dark
              ? AppColors.surface_dark
              : AppColors.background_light,
          // Set corner rounded curves using spacing constants
          borderRadius:
              BorderRadius.circular(AppSpacing.dummy_doctor_card_radius),
          // Draw outline border stroke
          border: Border.all(
            // Resolve border color based on theme
            color: is_dark ? AppColors.border_dark : AppColors.slate_200,
            // Set thin border width
            width: AppSpacing.border_width_thin,
          ),
        ),
        // Arrange items inside card vertically
        child: Column(
        // Align children starting from the horizontal edge
        crossAxisAlignment: CrossAxisAlignment.start,
        // Card children layout list
        children: [
          // Row aligning avatar, metadata, and favorite button side-by-side
          Row(
            // Align children starting from top coordinates
            crossAxisAlignment: CrossAxisAlignment.start,
            // Children list
            children: [
              // Left side: Doctor Avatar Image component wrapped in a border Container
              Container(
                // Decoration for the subtle light grey border outline
                decoration: BoxDecoration(
                  // Shape mapping perfect circle avatar outline
                  shape: BoxShape.circle,
                  // Border layout styling config
                  border: Border.all(
                    // Soft light grey color derived dynamically from theme divider with opacity
                    color:
                        Theme.of(context).dividerColor.withValues(alpha: 0.3),
                    // Thin outline stroke width (1.5px)
                    width: _LocalDimensions.avatar_border_width,
                  ),
                ),
                // Inner network image widget child representation
                child: AppNetworkImage(
                  // Set image URL
                  image_url: avatar_url,
                  // Layout width derived from design spacing tokens
                  width: AppSpacing.doctor_card_avatar_size,
                  // Layout height derived from design spacing tokens
                  height: AppSpacing.doctor_card_avatar_size,
                  // Outer corner radius shape derived from spacing tokens
                  border_radius: AppSpacing.doctor_card_avatar_radius,
                  // Default fallback icon when loading fails or offline
                  fallback_icon: Icons.person_rounded,
                ),
              ),
              // Gap spacing between image and content column using spacing tokens
              const SizedBox(width: AppSpacing.space_xl),
              // Middle: Doctor Metadata Column wrapped in Expanded to define bounds
              Expanded(
                // Column grouping name, specialty, location, rating, and fee
                child: Column(
                  // Align text to start horizontally
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Children list
                  children: [
                    // Text widget displaying doctor name with ellipsis constraint
                    Text(
                      // Doctor name
                      doctor_name,
                      // Single line constraint
                      maxLines: 1,
                      // Ellipsis truncation behavior
                      overflow: TextOverflow.ellipsis,
                      // Typography styling
                      style: TextStyle(
                        // Font size using spacing tokens
                        fontSize: AppSpacing.font_size_forgot_link,
                        // Emphasized bold weight
                        fontWeight: FontWeight.bold,
                        // Text color based on theme
                        color: is_dark
                            ? AppColors.text_dark_primary
                            : AppColors.search_text_slate,
                      ),
                    ),
                    // Vertical space divider using spacing constants
                    const SizedBox(height: AppSpacing.space_s),
                    // Specialty details row
                    _build_detail_row(
                      // Specialty Stethoscope Icon representation
                      const Icon(
                        Icons.medical_services_outlined,
                        size: AppSpacing.font_size_body_medium,
                        color: AppColors.primary_color,
                      ),
                      // Specialty name
                      specialization,
                      // Dark mode flag
                      is_dark,
                    ),
                    // Vertical space divider using spacing constants
                    const SizedBox(height: AppSpacing.space_xs),
                    // Location details row
                    _build_detail_row(
                      // Location pin icon
                      const Icon(
                        Icons.location_on_outlined,
                        size: AppSpacing.font_size_body_medium,
                        color: AppColors.primary_color,
                      ),
                      // Location string
                      location,
                      // Dark mode flag
                      is_dark,
                    ),
                    // Vertical space divider using spacing constants
                    const SizedBox(height: AppSpacing.space_xs),
                    // Rating details row
                    _build_detail_row(
                      // Star indicator icon
                      const Icon(
                        Icons.star_rounded,
                        size: AppSpacing.font_size_body_medium,
                        color: AppColors.primary_color,
                      ),
                      // Localized rating information
                      "$rating ($review_count ${localizations.search_doctor_reviews})",
                      // Dark mode flag
                      is_dark,
                    ),
                    // Vertical space divider using spacing constants
                    const SizedBox(height: AppSpacing.space_xs),
                    // Consultation Fee details row
                    _build_detail_row(
                      // Banknote cash icon representation
                      const Icon(
                        Icons.payments_outlined,
                        size: AppSpacing.font_size_body_medium,
                        color: AppColors.primary_color,
                      ),
                      // Value representation
                      "$price EGP",
                      // Dark mode flag
                      is_dark,
                    ),
                  ],
                ),
              ),
              // Gap spacing between metadata column and favorite button
              const SizedBox(width: AppSpacing.space_xl),
              // Right side: Custom ECG Heart Favorite Toggle Button
              FavoriteHeartButton(
                is_favorite: is_favorite,
                on_tap: on_favorite_tap,
              ),
            ],
          ),
          // Divider space gap using spacing constants
          const SizedBox(height: AppSpacing.space_xl),

          // Bottom Row: Availability Status and Book Now CTA Button aligned to far left and far right
          Padding(
            // Symmetrical horizontal padding to align with the card layout boundaries
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_m),
            // Row aligning availability status and Book Now CTA button
            child: Row(
              // Distribute elements horizontally with space between
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // Align elements vertically centered
              crossAxisAlignment: CrossAxisAlignment.center,
              // Children list
              children: [
                // Availability text label widget wrapped in Expanded to prevent overflows
                Expanded(
                  child: Text(
                    // Select label based on today availability state using Yoda check
                    is_available
                        ? localizations.search_doctor_available_today
                        : localizations.search_doctor_unavailable_today,
                    // Single line limit
                    maxLines: 1,
                    // Ellipsis overflow behavior
                    overflow: TextOverflow.ellipsis,
                    // Typography styling
                    style: TextStyle(
                      // Font size derived from spacing constants
                      fontSize: AppSpacing.font_size_body_medium,
                      // Semi bold layout helper weight
                      fontWeight: FontWeight.w600,
                      // Color highlight based on availability status
                      color: is_available
                          ? AppColors.dummy_custom_green
                          : AppColors.text_light_secondary,
                    ),
                  ),
                ),
                // Spacer horizontal gap between status text and book now button
                const SizedBox(width: AppSpacing.space_l),
                // Book Now elevated button widget
                ElevatedButton(
                  // Booking trigger callback invocation
                  onPressed: on_book_tap,
                  // Styling configurations
                  style: ElevatedButton.styleFrom(
                    // Background color changes based on availability status using Yoda check
                    backgroundColor: is_available
                        ? AppColors.primary_color
                        : AppColors.primary_color.withValues(alpha: 0.6),
                    // Flat shadow representation
                    elevation: AppSpacing.opacity_none,
                    // Rounded rectangle shape setup
                    shape: RoundedRectangleBorder(
                      // Corner radius derived from standard spacing constants
                      borderRadius: BorderRadius.circular(
                        AppSpacing.dummy_doctor_card_btn_radius,
                      ),
                    ),
                    // Symmetric internal padding using layout tokens
                    padding: const EdgeInsets.symmetric(
                      // Horizontal padding offset
                      horizontal: AppSpacing.space_xxl,
                      // Vertical padding offset
                      vertical: AppSpacing.space_l,
                    ),
                  ),
                  // Button text child
                  child: Text(
                    // Localized Book Now action label
                    localizations.search_doctor_book_now,
                    // Typography styling
                    style: const TextStyle(
                      // Font size from spacing constants
                      fontSize: AppSpacing.font_size_body_medium,
                      // Emphasized bold weight
                      fontWeight: FontWeight.bold,
                      // White text color
                      color: AppColors.background_light,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  // Helper details row layout constructing leading widget and label inline
  Widget _build_detail_row(
    Widget leadingWidget,
    String text,
    bool is_dark,
  ) {
    // Return Row arranging leading widget and label horizontally
    return Row(
      // Children list
      children: [
        // Leading widget
        leadingWidget,
        // Gap spacing between icon and text using spacing tokens
        const SizedBox(width: AppSpacing.space_s),
        // Expanded label text wrapper to prevent horizontal overflows
        Expanded(
          // Text widget displaying parameter string
          child: Text(
            // Parameter string
            text,
            // Single line limit
            maxLines: 1,
            // Ellipsis overflow truncation behavior
            overflow: TextOverflow.ellipsis,
            // Typography styling
            style: TextStyle(
              // Font size from spacing constants
              fontSize: AppSpacing.font_size_body_small,
              // Color selection based on theme
              color: is_dark
                  ? AppColors.text_dark_secondary
                  : AppColors.text_light_secondary,
            ),
          ),
        ),
      ],
    );
  }
}

