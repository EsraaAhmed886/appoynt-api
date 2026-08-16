/*
 * File Name: guest_favorites_widget.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_spacing.dart,
 *   app_colors.dart, app_localizations.dart, route_export.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Defines the guest unauthenticated guard widget displaying
 *   a friendly login prompt and direct navigation action to the Login screen.
 */

// Import route and framework exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';


// Local layout dimension constants strictly eliminating raw numbers
class _LocalDimensions {
  static const double outer_ring_size = 140.0;
  static const double inner_ring_size = 100.0;
  static const double icon_size = 56.0;
  static const double max_subtitle_width = 300.0;
  static const double btn_height = 48.0;
  static const double btn_radius = 12.0;
  static const double btn_max_width = 240.0;
}

// Reusable GuestFavoritesWidget representation
class GuestFavoritesWidget extends StatelessWidget {
  // Constant constructor
  const GuestFavoritesWidget({super.key});

  @override
  // Build method constructing centered guest layout
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
            // Concentric circle illustration with lock / heart badge
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
                      Icons.lock_outline_rounded,
                      size: _LocalDimensions.icon_size,
                      color: AppColors.primary_color,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space_xxl),
            // Title text: "Sign in to view favorites"
            Text(
              localizations.favorites_guest_title,
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
            // Subtitle text with max width constraint
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: _LocalDimensions.max_subtitle_width,
              ),
              child: Text(
                localizations.favorites_guest_subtitle,
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
            // Sign In Action Button
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: _LocalDimensions.btn_max_width,
              ),
              child: SizedBox(
                width: double.infinity,
                height: _LocalDimensions.btn_height,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.login);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary_color,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(_LocalDimensions.btn_radius),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    localizations.favorites_guest_login_button,
                    style: const TextStyle(
                      fontSize: AppSpacing.font_size_body_medium,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
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
}
