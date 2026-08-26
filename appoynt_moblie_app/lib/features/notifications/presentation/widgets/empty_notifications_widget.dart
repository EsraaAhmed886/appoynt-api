/*
 * File Name: empty_notifications_widget.dart
 * Author: Kholoud Khaled
 * Date of Creation: 15/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_spacing.dart,
 *   app_colors.dart, app_localizations.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Centered scrollable empty state layout displaying a pure Flutter code-rendered
 *   concentric bell illustration, localized titles, and a Go to Home action button with zero overflow.
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
  static const double outer_ring_size = 110.0;
  static const double inner_ring_size = 80.0;
  static const double icon_size = 46.0;
  static const double max_subtitle_width = 300.0;
  static const double btn_height = 46.0;
  static const double btn_radius = 12.0;
  static const double btn_max_width = 240.0;
}

/// Reusable EmptyNotificationsWidget displaying pure Flutter code illustration and CTA without overflow.
class EmptyNotificationsWidget extends StatelessWidget {
  final String? message;
  final String? subtitle;
  final VoidCallback? on_go_home;
  final VoidCallback? onRefresh;

  const EmptyNotificationsWidget({
    super.key,
    this.message,
    this.subtitle,
    this.on_go_home,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final VoidCallback? ctaAction = on_go_home ?? onRefresh;

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space_xxl,
          vertical: AppSpacing.space_l,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: AppSpacing.space_xl),

            // Primary Message
            Text(
              message ?? localizations.notifications_empty_title,
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

            // Subtitle Description
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: _LocalDimensions.max_subtitle_width,
              ),
              child: Text(
                subtitle ?? localizations.notifications_empty_subtitle,
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

            if (ctaAction != null) ...[
              const SizedBox(height: AppSpacing.space_xl),
              // "Go to Home" / Action CTA Button
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: _LocalDimensions.btn_max_width,
                  minWidth: _LocalDimensions.btn_max_width,
                  minHeight: _LocalDimensions.btn_height,
                ),
                child: ElevatedButton(
                  onPressed: ctaAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary_color,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(_LocalDimensions.btn_radius),
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
          ],
        ),
      ),
    );
  }
}
