/*
 * File Name: insurance_card_widget.dart
 * Author: Kholoud Khaled
 * Date of Creation: 25/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/profile/domain/entities/insurance_card.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Shared, zero-overflow InsuranceCard and NoInsuranceCard widget components matching global app design system specifications.
 */

// Importing central routing and design system barrel export
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing insurance card domain entity model
import 'package:appoynt_mobile_app/features/profile/domain/entities/insurance_card.dart';

/// A shared, zero-overflow Insurance Card widget component.
class InsuranceCardWidget extends StatelessWidget {
  /// The insurance card model data
  final InsuranceCard card;
  /// Optional tap callback handler
  final VoidCallback? onTap;
  /// Optional flag to render as a styled digital gradient card
  final bool isGradientStyle;

  /// Constructor mapping standard properties
  const InsuranceCardWidget({
    super.key,
    required this.card,
    this.onTap,
    this.isGradientStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    // Resolve theme brightness modes status
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    if (true == isGradientStyle) {
      // ── Premium Digital Gradient Insurance Card ─────────────────────
      return Directionality(
        // LTR text direction for credit/insurance card layout aesthetics
        textDirection: TextDirection.ltr,
        child: Container(
          // Full width canvas bounds
          width: double.infinity,
          // Card decoration
          decoration: BoxDecoration(
            // MetLife premium dark navy to teal linear gradient finish
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.navy_dark, // Premium Dark Navy
                AppColors.teal_deep, // Deep Teal
              ],
            ),
            // 16px corner radius
            borderRadius: BorderRadius.circular(16.0),
            // Ambient soft shadow
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.15),
                blurRadius: 10.0,
                offset: const Offset(0.0, 4.0),
              ),
            ],
          ),
          child: Material(
            color: AppColors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16.0),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.space_xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row: Card title & Security verification badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            card.card_name.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.white70,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.space_s),
                        Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: const BoxDecoration(
                            color: AppColors.white12,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified_user_rounded,
                            color: AppColors.gold,
                            size: 16.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space_l),
                    // Provider Name Text
                    Text(
                      card.provider_name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space_m),
                    // Policy info and Expiry date Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'POLICY NUMBER',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.white60,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                card.card_number,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.space_m),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'EXPIRY DATE',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.white60,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                card.expiry_date,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      // ── Standard White/Dark Surface List Insurance Card ───────────────
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.space_s),
        decoration: BoxDecoration(
          color: is_dark ? AppColors.surface_dark : AppColors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: is_dark ? AppColors.border_dark : AppColors.slate200,
            width: AppSpacing.border_width_thin,
          ),
          boxShadow: [
            BoxShadow(
              color: is_dark
                  ? AppColors.black.withValues(alpha: 0.25)
                  : AppColors.black.withValues(alpha: 0.04),
              blurRadius: 8.0,
              offset: const Offset(0.0, 2.0),
            ),
          ],
        ),
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.0),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.space_m),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Heart icon badge container
                  Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: AppColors.primary_color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: AppColors.primary_color,
                      size: AppSpacing.icon_size_m,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space_m),
                  // Card details column wrapped in Expanded
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          card.card_name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppSpacing.font_size_body_medium,
                            fontWeight: FontWeight.w700,
                            color: is_dark
                                ? AppColors.text_dark_primary
                                : AppColors.text_light_primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space_xs),
                        Text(
                          card.provider_name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: AppSpacing.font_size_body_small,
                            color: AppColors.text_light_secondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space_xs),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Policy: ',
                              style: TextStyle(
                                fontSize: AppSpacing.font_size_caption,
                                color: is_dark
                                    ? AppColors.text_dark_secondary
                                    : AppColors.text_light_secondary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.space_xs),
                            Expanded(
                              child: Text(
                                card.card_number,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: AppSpacing.font_size_caption,
                                  fontWeight: FontWeight.w600,
                                  color: is_dark
                                      ? AppColors.text_dark_primary
                                      : AppColors.text_light_primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Optional chevron / selection indicator
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.text_light_secondary,
                    size: AppSpacing.icon_size_m,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

/// A shared, zero-overflow empty state No Insurance Card widget component.
class NoInsuranceCardWidget extends StatelessWidget {
  /// Localized title string
  final String title;
  /// Muted count badge label string
  final String badgeText;
  /// Optional icon override
  final IconData icon;
  /// Optional click callback
  final VoidCallback onTap;

  /// Constructor mapping standard properties
  const NoInsuranceCardWidget({
    super.key,
    required this.title,
    required this.badgeText,
    this.icon = Icons.wallet_membership_rounded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Resolve theme brightness mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : AppColors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: is_dark
                ? AppColors.black.withValues(alpha: 0.2)
                : AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: is_dark ? AppColors.border_dark : AppColors.slate200,
          width: AppSpacing.border_width_thin,
        ),
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space_xl,
              vertical: AppSpacing.space_l,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Medical Icon graphic representation container
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.blue,
                    size: 20.0,
                  ),
                ),
                const SizedBox(width: AppSpacing.space_m),
                // Title widget taking expanded horizontal space
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: is_dark
                          ? AppColors.white
                          : AppColors.text_light_primary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.space_xs),
                // Muted count items badge container wrapped in Flexible
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: is_dark
                          ? AppColors.white.withValues(alpha: 0.05)
                          : AppColors.primary_color.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      badgeText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w600,
                        color: is_dark
                            ? AppColors.white70
                            : AppColors.primary_color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.space_s),
                // Right navigation chevron indicator
                Icon(
                  Icons.chevron_right_rounded,
                  color: is_dark
                      ? AppColors.white30
                      : AppColors.text_light_secondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
