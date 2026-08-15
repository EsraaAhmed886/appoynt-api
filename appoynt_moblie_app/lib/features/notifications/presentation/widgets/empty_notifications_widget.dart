/*
 * File Name: empty_notifications_widget.dart
 * Author: Kholoud Khaled
 * Date of Creation: 15/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_spacing.dart,
 *   app_colors.dart, app_localizations.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 15/08/2026]
 * File Description: Centered empty state layout displaying a pure Flutter code-rendered
 *   concentric bell illustration, localized titles, and a Go to Home action button.
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

// Reusable EmptyNotificationsWidget displaying pure Flutter code illustration and CTA
class EmptyNotificationsWidget extends StatelessWidget {
  // Callback when Go to Home CTA is pressed
  final VoidCallback on_go_home;

  // Constant constructor mapping callback
  const EmptyNotificationsWidget({
    super.key,
    required this.on_go_home,
  });

  @override
  // Build method drawing the centered empty state hierarchy
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
            // Concentric circle code illustration with bell icon
            Container(
              width: _LocalDimensions.outer_ring_size,
              height: _LocalDimensions.outer_ring_size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary_color.withValues(
                  alpha: is_dark ? 0.12 : 0.08,
                ),
              ),
              child: Center(
                child: Container(
                  width: _LocalDimensions.inner_ring_size,
                  height: _LocalDimensions.inner_ring_size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary_color.withValues(
                      alpha: is_dark ? 0.22 : 0.15,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.notifications_none_rounded,
                      size: _LocalDimensions.icon_size,
                      color: AppColors.primary_color,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space_xxl),
            // Title text: "No notifications yet"
            Text(
              localizations.notifications_empty_title,
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
            // Subtitle text: "We'll notify you when there is something important."
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: _LocalDimensions.max_subtitle_width,
              ),
              child: Text(
                localizations.notifications_empty_subtitle,
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
            // "Go to Home" CTA Button
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: _LocalDimensions.btn_max_width,
                minWidth: _LocalDimensions.btn_max_width,
                minHeight: _LocalDimensions.btn_height,
              ),
              child: ElevatedButton(
                onPressed: on_go_home,
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
                  localizations.notifications_empty_cta,
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
