/*
 * File Name: empty_favorites_widget.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:flutter_svg/flutter_svg.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/constants/app_spacing.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 14/08/2026]
 * File Description: Centered empty state layout displaying the empty_favorites SVG
 *   and localized title and subtitle when no favorited doctors exist.
 */

// Import standard material design widget framework
import 'package:flutter/material.dart';
// Import flutter_svg for SVG asset rendering
import 'package:flutter_svg/flutter_svg.dart';
// Import layout design tokens
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
// Import central color palette tokens
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
// Import localization dictionary
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';

// Local layout dimension constants to strictly eliminate raw numbers
class _LocalDimensions {
  // SVG illustration height in logical pixels
  static const double svg_height = 180.0;
  // SVG illustration width in logical pixels
  static const double svg_width = 180.0;
  // Vertical spacing after SVG illustration
  static const double spacing_svg = 24.0;
  // Vertical spacing after title text
  static const double spacing_title = 8.0;
  // Max width constraint for subtitle text container
  static const double max_subtitle_width = 280.0;
}

// Reusable EmptyFavoritesWidget definition
class EmptyFavoritesWidget extends StatelessWidget {
  // Constant constructor
  const EmptyFavoritesWidget({super.key});

  @override
  // Build method constructing centered layout
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
            // Centered Empty Favorites SVG illustration with error fallback
            SvgPicture.asset(
              'assets/svgs/empty_favorites.svg',
              height: _LocalDimensions.svg_height,
              width: _LocalDimensions.svg_width,
              placeholderBuilder: (BuildContext placeholder_context) {
                return Icon(
                  Icons.favorite_border_rounded,
                  size: 80.0,
                  color: AppColors.primary_color.withValues(alpha: 0.4),
                );
              },
            ),
            const SizedBox(height: _LocalDimensions.spacing_svg),
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
}
