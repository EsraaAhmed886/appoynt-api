/*
 * File Name: clinic_card.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_spacing.dart,
 *   app_colors.dart, app_localizations.dart, app_network_image.dart,
 *   favorited_clinic.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Defines a reusable, highly polished Clinic Card component
 *   displaying clinic name, specialties, address, star rating, phone, removal loading
 *   guard, and inactive CTA guard.
 */

// Import standard UI framework
import 'package:flutter/material.dart';
// Import layout design tokens
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
// Import central color palette tokens
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
// Import localization dictionary
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
// Import performance-optimized network image widget
import 'package:appoynt_mobile_app/core/widgets/app_network_image.dart';
// Import domain entity
import 'package:appoynt_mobile_app/features/favorites/domain/entities/favorited_clinic.dart';
// Import unified ECG pulse heart button
import 'package:appoynt_mobile_app/features/shared/widgets/favorite_heart_button.dart';


// Local layout dimensions strictly eliminating raw numbers
class _LocalDimensions {
  static const double card_radius = 16.0;
  static const double image_size = 72.0;
  static const double image_radius = 36.0;
  static const double icon_size = 16.0;
  static const double chip_radius = 6.0;
  static const double btn_radius = 10.0;
  static const double font_size_caption = 11.0;
}



// Reusable ClinicCard widget definition
class ClinicCard extends StatelessWidget {
  // Favorited clinic data entity
  final FavoritedClinic clinic;
  // Flag indicating if removal API is in progress
  final bool is_removing;
  // View clinic details callback
  final VoidCallback? on_view_tap;
  // Favorite removal tap callback
  final VoidCallback? on_favorite_tap;

  // Constant constructor mapping required parameters
  const ClinicCard({
    super.key,
    required this.clinic,
    this.is_removing = false,
    this.on_view_tap,
    this.on_favorite_tap,
  });

  @override
  // Build method constructing clinic card layout hierarchy
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final bool is_active = clinic.is_active;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.space_xl),
      padding: const EdgeInsets.all(AppSpacing.space_xl),
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : AppColors.background_light,
        borderRadius: BorderRadius.circular(_LocalDimensions.card_radius),
        border: Border.all(
          color: is_dark ? AppColors.border_dark : AppColors.slate_200,
          width: AppSpacing.border_width_thin,
        ),
        boxShadow: [
          BoxShadow(
            color: is_dark
                ? AppColors.black.withValues(alpha: 0.2)
                : AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10.0,
            offset: const Offset(0.0, 4.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Clinic Image, Metadata Column, and Favorite Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Clinic Circular Image Avatar
              AppNetworkImage(
                image_url: clinic.image_url,
                width: _LocalDimensions.image_size,
                height: _LocalDimensions.image_size,
                border_radius: _LocalDimensions.image_radius,
                fallback_icon: Icons.local_hospital_rounded,
              ),
              const SizedBox(width: AppSpacing.space_l),
              // Clinic Details Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Clinic Name
                    Text(
                      clinic.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppSpacing.font_size_forgot_link,
                        fontWeight: FontWeight.bold,
                        color: is_dark
                            ? AppColors.text_dark_primary
                            : AppColors.text_light_primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space_xs),
                    // Rating and Reviews Row
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: _LocalDimensions.icon_size,
                          color: AppColors.primary_color,
                        ),
                        const SizedBox(width: AppSpacing.space_xs),
                        Text(
                          '${clinic.rating} (${clinic.reviews_count})',
                          style: TextStyle(
                            fontSize: AppSpacing.font_size_body_small,
                            fontWeight: FontWeight.w600,
                            color: is_dark
                                ? AppColors.text_dark_secondary
                                : AppColors.text_light_secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space_xs),
                    // Address Row
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: _LocalDimensions.icon_size,
                          color: AppColors.primary_color,
                        ),
                        const SizedBox(width: AppSpacing.space_xs),
                        Expanded(
                          child: Text(
                            clinic.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: AppSpacing.font_size_body_small,
                              color: is_dark
                                  ? AppColors.text_dark_secondary
                                  : AppColors.text_light_secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.space_m),
              // Favorite Heart Button / Removal Spinner
              FavoriteHeartButton(
                is_favorite: clinic.is_favorite,
                is_removing: is_removing,
                on_tap: is_removing ? null : on_favorite_tap,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.space_m),
          // Specialties Chips Wrap
          if (clinic.specialties.isNotEmpty)
            Wrap(
              spacing: AppSpacing.space_s,
              runSpacing: AppSpacing.space_xs,
              children: clinic.specialties.take(3).map((spec) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space_s,
                    vertical: AppSpacing.space_xs,
                  ),
                  decoration: BoxDecoration(
                    color: is_dark
                        ? AppColors.primary_color.withValues(alpha: 0.15)
                        : AppColors.primary_color.withValues(alpha: 0.08),
                    borderRadius:
                        BorderRadius.circular(_LocalDimensions.chip_radius),
                  ),
                  child: Text(
                    spec,
                    style: const TextStyle(
                      fontSize: _LocalDimensions.font_size_caption,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary_color,
                    ),
                  ),

                );
              }).toList(),
            ),
          const SizedBox(height: AppSpacing.space_l),
          // Bottom Row: Status Badge and View Clinic Action Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Inactive / Active status indicator
              Text(
                is_active
                    ? localizations.search_doctor_available_today
                    : localizations.favorites_unavailable_badge,
                style: TextStyle(
                  fontSize: AppSpacing.font_size_body_medium,
                  fontWeight: FontWeight.w600,
                  color: is_active
                      ? AppColors.dummy_custom_green
                      : AppColors.dummy_custom_red,
                ),
              ),
              // View Clinic CTA Button
              ElevatedButton(
                onPressed: is_active ? on_view_tap : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary_color,
                  disabledBackgroundColor:
                      is_dark ? Colors.grey[800] : Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(_LocalDimensions.btn_radius),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space_xl,
                    vertical: AppSpacing.space_m,
                  ),
                  elevation: 0,
                ),
                child: Text(
                  localizations.favorites_view_clinic,
                  style: TextStyle(
                    fontSize: AppSpacing.font_size_body_medium,
                    fontWeight: FontWeight.bold,
                    color: is_active
                        ? AppColors.white
                        : (is_dark
                            ? AppColors.text_dark_secondary
                            : AppColors.text_light_secondary),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
