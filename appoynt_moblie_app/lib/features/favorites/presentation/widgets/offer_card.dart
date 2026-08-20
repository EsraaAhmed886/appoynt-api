/*
 * File Name: offer_card.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_spacing.dart,
 *   app_colors.dart, app_localizations.dart, app_network_image.dart,
 *   favorited_offer.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Defines a reusable, highly polished Offer Card component
 *   displaying discount pill, original and discounted price, provider, expiry date,
 *   backend removal loading guard, and expired CTA guard.
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
import 'package:appoynt_mobile_app/features/favorites/domain/entities/favorited_offer.dart';
// Import unified ECG pulse heart button
import 'package:appoynt_mobile_app/features/shared/widgets/favorite_heart_button.dart';

// Local dimension constants strictly eliminating raw numbers
class _LocalDimensions {
  static const double card_radius = 16.0;
  static const double image_height = 130.0;
  static const double image_radius = 12.0;
  static const double badge_radius = 8.0;
  static const double badge_padding_h = 8.0;
  static const double badge_padding_v = 4.0;
  static const double icon_size = 16.0;
  static const double btn_radius = 10.0;
  static const double font_size_caption = 11.0;
}

// Reusable OfferCard widget definition
class OfferCard extends StatelessWidget {
  // Favorited offer entity data model
  final FavoritedOffer offer;
  // Flag indicating if removal API is in progress
  final bool is_removing;
  // Booking CTA tap callback
  final VoidCallback? on_book_tap;
  // Favorite removal tap callback
  final VoidCallback? on_favorite_tap;

  // Constant constructor mapping required parameters
  const OfferCard({
    super.key,
    required this.offer,
    this.is_removing = false,
    this.on_book_tap,
    this.on_favorite_tap,
  });

  @override
  // Build method constructing offer card layout hierarchy
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final bool is_expired = offer.is_expired;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.space_xl),
      padding: const EdgeInsets.all(AppSpacing.space_l),
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
          // Banner Image Container with Stack overlays for Discount and Favorite
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(_LocalDimensions.image_radius),
                child: AppNetworkImage(
                  image_url: offer.image_url,
                  width: double.infinity,
                  height: _LocalDimensions.image_height,
                  border_radius: _LocalDimensions.image_radius,
                  fallback_icon: Icons.local_offer_rounded,
                ),
              ),
              // Top-Start: Discount Percentage Badge Pill
              Positioned(
                top: AppSpacing.space_m,
                left: AppSpacing.space_m,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _LocalDimensions.badge_padding_h,
                    vertical: _LocalDimensions.badge_padding_v,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.dummy_custom_red,
                    borderRadius:
                        BorderRadius.circular(_LocalDimensions.badge_radius),
                  ),
                  child: Text(
                    '${offer.discount_percentage}% ${localizations.favorites_off_badge}',
                    style: const TextStyle(
                      fontSize: _LocalDimensions.font_size_caption,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              // Top-End: Favorite Removal Button or Loading Spinner
              Positioned(
                top: AppSpacing.space_s,
                right: AppSpacing.space_s,
                child: Material(
                  color: is_dark
                      ? AppColors.surface_dark.withValues(alpha: 0.8)
                      : AppColors.white.withValues(alpha: 0.9),
                  shape: const CircleBorder(),
                  child: FavoriteHeartButton(
                    is_favorite: offer.is_favorite,
                    is_removing: is_removing,
                    on_tap: is_removing ? null : on_favorite_tap,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space_m),
          // Offer Title
          Text(
            offer.title,
            maxLines: 2,
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
          // Provider Name Row
          Row(
            children: [
              const Icon(
                Icons.business_rounded,
                size: _LocalDimensions.icon_size,
                color: AppColors.primary_color,
              ),
              const SizedBox(width: AppSpacing.space_xs),
              Expanded(
                child: Text(
                  offer.provider_name,
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
          const SizedBox(height: AppSpacing.space_s),
          // Price and Expiry Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Prices Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Original Price (Strikethrough)
                  Text(
                    '${offer.original_price.toStringAsFixed(0)} EGP',
                    style: TextStyle(
                      fontSize: _LocalDimensions.font_size_caption,
                      decoration: TextDecoration.lineThrough,
                      color: is_dark
                          ? AppColors.text_dark_secondary
                          : AppColors.text_light_secondary,
                    ),
                  ),
                  // Discounted Final Price
                  Text(
                    '${offer.discounted_price.toStringAsFixed(0)} EGP',
                    style: const TextStyle(
                      fontSize: AppSpacing.font_size_dialog_title,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary_color,
                    ),
                  ),
                ],
              ),
              // Expiry Date Badge or Expired Indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: _LocalDimensions.badge_padding_h,
                  vertical: _LocalDimensions.badge_padding_v,
                ),
                decoration: BoxDecoration(
                  color: is_expired
                      ? (is_dark
                          ? AppColors.dummy_custom_red.withValues(alpha: 0.2)
                          : AppColors.dummy_custom_red.withValues(alpha: 0.1))
                      : (is_dark
                          ? AppColors.primary_color.withValues(alpha: 0.15)
                          : AppColors.primary_color.withValues(alpha: 0.08)),
                  borderRadius:
                      BorderRadius.circular(_LocalDimensions.badge_radius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      is_expired
                          ? Icons.warning_amber_rounded
                          : Icons.access_time_rounded,
                      size: _LocalDimensions.icon_size,
                      color: is_expired
                          ? AppColors.dummy_custom_red
                          : AppColors.primary_color,
                    ),
                    const SizedBox(width: AppSpacing.space_xs),
                    Text(
                      is_expired
                          ? localizations.favorites_expired_badge
                          : '${localizations.favorites_expires_on} ${offer.expiry_date.day}/${offer.expiry_date.month}/${offer.expiry_date.year}',
                      style: TextStyle(
                        fontSize: _LocalDimensions.font_size_caption,
                        fontWeight: FontWeight.w600,
                        color: is_expired
                            ? AppColors.dummy_custom_red
                            : AppColors.primary_color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space_m),
          // Book Now CTA Button (strictly disabled if offer is expired per Phase 7)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: is_expired ? null : on_book_tap,
              style: ElevatedButton.styleFrom(
                backgroundColor: is_expired
                    ? (is_dark ? Colors.grey[800] : Colors.grey[300])
                    : AppColors.primary_color,
                disabledBackgroundColor:
                    is_dark ? Colors.grey[800] : Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(_LocalDimensions.btn_radius),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.space_m,
                ),
                elevation: 0,
              ),
              child: Text(
                is_expired
                    ? localizations.favorites_expired_badge
                    : localizations.favorites_book_now,
                style: TextStyle(
                  fontSize: AppSpacing.font_size_body_medium,
                  fontWeight: FontWeight.bold,
                  color: is_expired
                      ? (is_dark
                          ? AppColors.text_dark_secondary
                          : AppColors.text_light_secondary)
                      : AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
