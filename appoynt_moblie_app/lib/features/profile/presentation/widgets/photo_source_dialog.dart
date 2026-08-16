/*
 * File Name: photo_source_dialog.dart
 * Author: Kholoud Khaled
 * Date of Creation: 13/08/2026
 * Version Information: V1.2.0
 * Dependencies: package:flutter/material.dart,
 *   package:image_picker/image_picker.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Modernized centered pop-up dialog with side-by-side action cards
 *   for selecting photo source (Camera vs Gallery) matching dark theme design standards.
 *   V1.2.0 fixes card text truncation with soft wrapping and 8px horizontal padding.
 */

// Importing Flutter material design widget library
import 'package:flutter/material.dart';
// Importing ImageSource enum for camera and gallery parameters
import 'package:image_picker/image_picker.dart';
// Importing AppColors design tokens for light/dark mode surfaces
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
// Importing AppLocalizations for string dictionary getters
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';

// Local dimension constants eliminating raw numbers in dialog
class _DialogDimensions {
  // Border radius for dialog card corners (24px)
  static const double card_radius = 24.0;
  // Internal padding for dialog card (20px)
  static const double card_padding = 20.0;
  // Action card border radius (16px)
  static const double action_card_radius = 16.0;
  // Action card internal horizontal padding (8px)
  static const double action_card_padding_h = 8.0;
  // Action card internal vertical padding (12px)
  static const double action_card_padding_v = 12.0;
  // Icon badge container size (44px)
  static const double icon_badge_size = 44.0;
  // Icon badge border radius (12px)
  static const double icon_badge_radius = 12.0;
  // Primary icon vector size (22px)
  static const double icon_size = 22.0;
  // Gap between title and subtitle in header (6px)
  static const double header_gap = 6.0;
  // Vertical gap after header (20px)
  static const double content_gap = 20.0;
  // Horizontal gap between side-by-side action cards (12px)
  static const double cards_gap = 12.0;
  // Vertical gap before cancel footer button (20px)
  static const double cancel_gap = 20.0;
  // Cancel button border radius (12px)
  static const double cancel_radius = 12.0;
  // Cancel button vertical padding (12px)
  static const double cancel_padding_v = 12.0;
  // Dialog shadow elevation (12.0)
  static const double elevation = 12.0;
}

// Centered custom pop-up dialog for selecting photo source (Camera vs Gallery)
class PhotoSourceDialog extends StatelessWidget {
  // Callback when a source (Camera or Gallery) is selected
  final ValueChanged<ImageSource> on_source_selected;

  // Constructor taking required selection callback
  const PhotoSourceDialog({
    super.key,
    required this.on_source_selected,
  });

  @override
  // Build the centered dialog UI hierarchy
  Widget build(BuildContext context) {
    // Resolve localization dictionary context
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve dark mode status for adaptive styling
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Determine subtitle based on language context
    final String subtitle_text = localizations.is_arabic
        ? 'اختر خياراً لتغيير صورة الملف الشخصي'
        : 'Select an option to change your profile picture';
    // Determine camera subtitle text
    final String camera_sub = localizations.is_arabic
        ? 'التقاط صورة'
        : 'Take a photo';
    // Determine gallery subtitle text ("Choose photo")
    final String gallery_sub = localizations.is_arabic
        ? 'اختيار صورة'
        : 'Choose photo';

    // Return centered Dialog card with dark theme surface and 24px radius
    return Dialog(
      // Translucent surface shape with rounded corners (24px radius)
      shape: RoundedRectangleBorder(
        // Rounded border radius token
        borderRadius: BorderRadius.circular(_DialogDimensions.card_radius),
        // Subtle outer border stroke
        side: BorderSide(
          color: is_dark ? AppColors.white10 : AppColors.border_light,
          width: 1.0,
        ),
      ),
      // Dark surface background color matching dark theme (#1E1E2C)
      backgroundColor: is_dark ? AppColors.surface_dark : AppColors.white,
      // Card elevation depth
      elevation: _DialogDimensions.elevation,
      // Internal dialog content layout container
      child: Padding(
        padding: const EdgeInsets.all(_DialogDimensions.card_padding),
        child: Column(
          // Constrain column to its intrinsic size
          mainAxisSize: MainAxisSize.min,
          // Stretch child elements horizontally
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Title: "Update Profile Photo"
            Text(
              localizations.profile_photo_sheet_title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: is_dark ? AppColors.white : AppColors.text_light_primary,
              ),
              textAlign: TextAlign.center,
            ),
            // Header Gap
            const SizedBox(height: _DialogDimensions.header_gap),
            // Header Subtitle: "Select an option to change your profile picture"
            Text(
              subtitle_text,
              style: TextStyle(
                fontSize: 13.0,
                color: is_dark
                    ? AppColors.text_dark_secondary
                    : AppColors.text_light_secondary,
              ),
              textAlign: TextAlign.center,
            ),
            // Spacing after header
            const SizedBox(height: _DialogDimensions.content_gap),
            // Side-by-side action cards in a 2-column horizontal Row
            Row(
              children: [
                // Camera Action Card (Expanded left column)
                Expanded(
                  child: _build_action_card(
                    context: context,
                    icon: Icons.camera_alt_rounded,
                    title: localizations.profile_photo_camera_option,
                    subtitle: camera_sub,
                    badge_color: AppColors.primary_color,
                    source: ImageSource.camera,
                    is_dark: is_dark,
                  ),
                ),
                // Horizontal gap between action cards (12px)
                const SizedBox(width: _DialogDimensions.cards_gap),
                // Gallery Action Card (Expanded right column)
                Expanded(
                  child: _build_action_card(
                    context: context,
                    icon: Icons.photo_library_rounded,
                    title: localizations.profile_photo_gallery_option,
                    subtitle: gallery_sub,
                    badge_color: const Color(0xFF6C5CE7),
                    source: ImageSource.gallery,
                    is_dark: is_dark,
                  ),
                ),
              ],
            ),
            // Spacing before footer button
            const SizedBox(height: _DialogDimensions.cancel_gap),
            // Footer: Sleek styled Cancel button container
            Material(
              // Subtle gray background container for cancel button
              color: is_dark ? AppColors.white10 : const Color(0xFFEDF1F7),
              // Rounded corners for cancel button container
              borderRadius: BorderRadius.circular(_DialogDimensions.cancel_radius),
              child: InkWell(
                onTap: () {
                  // Dismiss popup dialog when cancel is tapped
                  Navigator.of(context).pop();
                },
                // Match ripple radius to cancel button container
                borderRadius: BorderRadius.circular(_DialogDimensions.cancel_radius),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: _DialogDimensions.cancel_padding_v,
                  ),
                  child: Center(
                    child: Text(
                      localizations.profile_cancel_button,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: is_dark
                            ? AppColors.white
                            : AppColors.text_light_primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper builder constructing styled action card for Camera or Gallery
  Widget _build_action_card({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color badge_color,
    required ImageSource source,
    required bool is_dark,
  }) {
    // Return Material card container for ink ripple interaction
    return Material(
      // Card surface color adapting to dark mode
      color: is_dark ? const Color(0xFF252536) : const Color(0xFFF6F8FB),
      // Rounded card corners (16px)
      borderRadius: BorderRadius.circular(_DialogDimensions.action_card_radius),
      child: InkWell(
        onTap: () {
          // Dismiss dialog prior to dispatching source callback
          Navigator.of(context).pop();
          // Dispatch selected source to callback handler
          on_source_selected(source);
        },
        // Match ink ripple radius to card container
        borderRadius: BorderRadius.circular(_DialogDimensions.action_card_radius),
        child: Container(
          // Card outer border stroke
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_DialogDimensions.action_card_radius),
            border: Border.all(
              color: is_dark ? AppColors.white10 : AppColors.border_light,
              width: 1.0,
            ),
          ),
          // Reduced horizontal internal padding (8px) and vertical (12px) to prevent truncation
          padding: const EdgeInsets.symmetric(
            horizontal: _DialogDimensions.action_card_padding_h,
            vertical: _DialogDimensions.action_card_padding_v,
          ),
          child: Column(
            // Center children inside card
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Badge container with tint background
              Container(
                width: _DialogDimensions.icon_badge_size,
                height: _DialogDimensions.icon_badge_size,
                decoration: BoxDecoration(
                  color: badge_color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(_DialogDimensions.icon_badge_radius),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: badge_color,
                    size: _DialogDimensions.icon_size,
                  ),
                ),
              ),
              // Gap between icon badge and title
              const SizedBox(height: 10.0),
              // Action Card Title text with w600 weight and 2-line soft wrapping
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: is_dark ? AppColors.white : AppColors.text_light_primary,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 2,
              ),
              // Tiny gap between title and subtitle
              const SizedBox(height: 4.0),
              // Action Card Subtitle text with 2-line soft wrapping
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11.0,
                  color: is_dark
                      ? AppColors.text_dark_secondary
                      : AppColors.text_light_secondary,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Global helper function to present the PhotoSourceDialog pop-up modal
Future<ImageSource?> show_photo_source_dialog(BuildContext context) async {
  // Variable storing the selected source
  ImageSource? selected_source;
  // Show pop-up dialog with transparent barrier
  await showDialog<void>(
    context: context,
    builder: (dialog_context) {
      return PhotoSourceDialog(
        on_source_selected: (source) {
          selected_source = source;
        },
      );
    },
  );
  // Return selected source or null if dismissed
  return selected_source;
}
