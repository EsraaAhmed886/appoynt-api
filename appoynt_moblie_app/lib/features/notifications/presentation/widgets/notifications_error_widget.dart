/*
 * File Name: notifications_error_widget.dart
 * Author: Kholoud Khaled
 * Date of Creation: 15/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_spacing.dart,
 *   app_colors.dart, app_localizations.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 15/08/2026]
 * File Description: Error and offline fallback widget displaying a pure Flutter code
 *   illustration, localized error descriptions, and a Try Again retry action.
 */

// Import standard UI framework
import 'package:flutter/material.dart';
// Import layout design tokens
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
// Import central color palette tokens
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
// Import localization dictionary
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';

// Local dimension constants strictly eliminating raw numbers
class _LocalDimensions {
  static const double outer_ring_size = 140.0;
  static const double inner_ring_size = 100.0;
  static const double icon_size = 56.0;
  static const double max_subtitle_width = 300.0;
  static const double btn_height = 48.0;
  static const double btn_radius = 12.0;
  static const double btn_max_width = 240.0;
}

// Reusable NotificationsErrorWidget definition
class NotificationsErrorWidget extends StatelessWidget {
  // Callback when Try Again button is pressed
  final VoidCallback on_retry;

  // Constant constructor mapping callback
  const NotificationsErrorWidget({
    super.key,
    required this.on_retry,
  });

  @override
  // Build method drawing the centered error state layout
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space_xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Concentric circle code illustration with Wi-Fi off icon
            Container(
              width: _LocalDimensions.outer_ring_size,
              height: _LocalDimensions.outer_ring_size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error.withValues(
                  alpha: is_dark ? 0.12 : 0.08,
                ),
              ),
              child: Center(
                child: Container(
                  width: _LocalDimensions.inner_ring_size,
                  height: _LocalDimensions.inner_ring_size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.error.withValues(
                      alpha: is_dark ? 0.22 : 0.15,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.wifi_off_rounded,
                      size: _LocalDimensions.icon_size,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space_xxl),
            // Error Title: "Couldn't load notifications"
            Text(
              localizations.notifications_error_title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppSpacing.font_size_dialog_title,
                fontWeight: FontWeight.bold,
                color: is_dark
                    ? AppColors.text_dark_primary
                    : AppColors.text_light_primary,
              ),
            ),
            const SizedBox(height: AppSpacing.space_s),
            // Error Subtitle: "Please check your internet connection and try again."
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: _LocalDimensions.max_subtitle_width,
              ),
              child: Text(
                localizations.notifications_error_subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppSpacing.font_size_body_medium,
                  color: is_dark
                      ? AppColors.text_dark_secondary
                      : AppColors.text_light_secondary,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space_xxl),
            // "Try Again" Retry Button
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: _LocalDimensions.btn_max_width,
                minWidth: _LocalDimensions.btn_max_width,
                minHeight: _LocalDimensions.btn_height,
              ),
              child: ElevatedButton(
                onPressed: on_retry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary_color,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_LocalDimensions.btn_radius),
                  ),
                  elevation: 0.0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space_xl,
                    vertical: AppSpacing.space_m,
                  ),
                ),
                child: Text(
                  localizations.notifications_retry_btn,
                  style: const TextStyle(
                    fontSize: AppSpacing.font_size_body_medium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
