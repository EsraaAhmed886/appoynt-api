/*
 * File Name: empty_favorites_widget.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V2.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/constants/app_spacing.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 14/08/2026]
 * File Description: Centered empty state layout displaying a pure Flutter code-rendered
 *   concentric heart illustration and localized title and subtitle when no favorited doctors exist.
 *   V2.0.0 eliminates external SVG asset dependencies completely.
 */

// Import standard material design widget framework
import 'package:flutter/material.dart';
// Import layout design tokens
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
// Import central color palette tokens
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
// Import localization dictionary
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';

// Local layout dimension constants strictly eliminating raw hardcoded numbers
class _LocalDimensions {
  // Outer decorative ring container diameter (140px)
  static const double outer_ring_size = 140.0;
  // Inner accent circle container diameter (100px)
  static const double inner_ring_size = 100.0;
  // Primary central heart icon logical size (60px)
  static const double icon_size = 60.0;
  // Vertical spacing after code illustration (24px)
  static const double spacing_illustration = 24.0;
  // Vertical spacing after title text (8px)
  static const double spacing_title = 8.0;
  // Max width constraint for subtitle text container (280px)
  static const double max_subtitle_width = 280.0;
}

// Reusable EmptyFavoritesWidget definition rendering pure code illustration
class EmptyFavoritesWidget extends StatelessWidget {
  // Constant constructor
  const EmptyFavoritesWidget({super.key});

  @override
  // Build method constructing centered layout hierarchy
  Widget build(BuildContext context) {
    // Resolve localization dictionary context
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Check if active brightness mode is dark
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return centered padding layout container
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space_xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Pure Flutter code-rendered concentric layered heart illustration
            _build_illustration(is_dark),
            const SizedBox(height: _LocalDimensions.spacing_illustration),
            // Title Text: "No favorites yet"
            Text(
              localizations.favorites_empty_title,
              style: TextStyle(
                fontSize: AppSpacing.font_size_dialog_title,
                fontWeight: FontWeight.bold,
                color: is_dark
                    ? AppColors.text_dark_primary
                    : AppColors.text_light_primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: _LocalDimensions.spacing_title),
            // Subtitle Text: "You haven't added any doctors to your favorites."
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: _LocalDimensions.max_subtitle_width,
              ),
              child: Text(
                localizations.favorites_empty_subtitle,
                style: TextStyle(
                  fontSize: AppSpacing.font_size_body_medium,
                  color: is_dark
                      ? AppColors.text_dark_secondary
                      : AppColors.text_light_secondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Private helper building a modern pure code-rendered concentric heart illustration
  Widget _build_illustration(bool is_dark) {
    // Return outer decorative ring container with primary tint background
    return Container(
      width: _LocalDimensions.outer_ring_size,
      height: _LocalDimensions.outer_ring_size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary_color.withValues(
          alpha: is_dark ? 0.12 : 0.08,
        ),
      ),
      child: Center(
        // Inner accent circle container with stronger primary opacity
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
            // Central large primary heart icon
            child: Icon(
              Icons.favorite_border_rounded,
              size: _LocalDimensions.icon_size,
              color: AppColors.primary_color,
            ),
          ),
        ),
      ),
    );
  }
}
