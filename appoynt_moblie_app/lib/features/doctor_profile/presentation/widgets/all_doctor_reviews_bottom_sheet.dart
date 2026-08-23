/*
 * File Name: all_doctor_reviews_bottom_sheet.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   app_localizations.dart, doctor_profile_entity.dart, doctor_review_card.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Modern scrollable modal bottom sheet displaying the complete list
 *   of patient reviews, aggregate rating summary score, and star breakdown distributions.
 */

// Import Flutter material framework
import 'package:flutter/material.dart';
// Import design tokens, colors, and localization
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/entities/doctor_profile_entity.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/widgets/doctor_review_card.dart';

/// Modal bottom sheet displaying comprehensive doctor reviews.
class AllDoctorReviewsBottomSheet extends StatelessWidget {
  // Complete doctor entity
  final DoctorProfileEntity profile;

  // Constant constructor
  const AllDoctorReviewsBottomSheet({
    super.key,
    required this.profile,
  });

  /// Static helper to display the reviews bottom sheet.
  static Future<void> show({
    required BuildContext context,
    required DoctorProfileEntity profile,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (sheet_context) {
        return AllDoctorReviewsBottomSheet(profile: profile);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final AppLocalizations localizations = AppLocalizations.of(context);
    final double sheet_height = MediaQuery.of(context).size.height * 0.85;

    return Container(
      height: sheet_height,
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : AppColors.background_light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radius_xxl),
          topRight: Radius.circular(AppSpacing.radius_xxl),
        ),
      ),
      child: Column(
        children: [
          // 1. Drag Handle
          const SizedBox(height: 10.0),
          Container(
            width: 40.0,
            height: 4.5,
            decoration: BoxDecoration(
              color: is_dark ? AppColors.slate_600 : AppColors.slate_300,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),

          // 2. Header Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.space_xl,
              AppSpacing.space_m,
              AppSpacing.space_m,
              AppSpacing.space_s,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: AppColors.amber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Icon(
                        Icons.star_rounded,
                        size: 20.0,
                        color: AppColors.amber,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.space_m),
                    Text(
                      localizations.patient_reviews,
                      style: TextStyle(
                        fontSize: AppSpacing.font_size_title_medium,
                        fontWeight: FontWeight.w700,
                        color: is_dark
                            ? AppColors.text_dark_primary
                            : AppColors.text_light_primary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1.0),

          // 3. Scrollable Content: Summary + Review Cards
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.space_xl),
              children: [
                // Aggregate Rating Summary Card
                _build_rating_summary_card(context, is_dark, localizations),
                const SizedBox(height: AppSpacing.space_xl),

                // Review Section Subtitle
                Text(
                  localizations.all_reviews,
                  style: TextStyle(
                    fontSize: AppSpacing.font_size_body_medium,
                    fontWeight: FontWeight.w700,
                    color: is_dark
                        ? AppColors.text_dark_primary
                        : AppColors.text_light_primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.space_m),

                // List of Reviews
                ...profile.reviews_list.map((review) {
                  return DoctorReviewCard(review: review);
                }),
                const SizedBox(height: AppSpacing.space_xl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _build_rating_summary_card(
    BuildContext context,
    bool is_dark,
    AppLocalizations localizations,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: is_dark ? AppColors.inner_container_dark : AppColors.slate_50,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: is_dark ? AppColors.border_dark : AppColors.slate_200,
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Big Score & Stars
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  profile.average_rating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 38.0,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.0,
                    color: is_dark
                        ? AppColors.text_dark_primary
                        : AppColors.text_light_primary,
                  ),
                ),
                const SizedBox(height: 2.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return const Icon(
                      Icons.star_rounded,
                      color: AppColors.amber,
                      size: 16.0,
                    );
                  }),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '${profile.reviews_count} ${localizations.reviews_label}',
                  style: TextStyle(
                    fontSize: AppSpacing.font_size_caption,
                    fontWeight: FontWeight.w600,
                    color: is_dark
                        ? AppColors.text_dark_secondary
                        : AppColors.text_light_secondary,
                  ),
                ),
              ],
            ),
          ),

          // Vertical Separator
          Container(
            height: 70.0,
            width: 1.0,
            color: is_dark ? AppColors.border_dark : AppColors.slate_200,
          ),
          const SizedBox(width: 14.0),

          // Right: 5-Star Breakdown Progress Bars
          Expanded(
            flex: 6,
            child: Column(
              children: [
                _build_star_bar(5, 0.85, is_dark),
                const SizedBox(height: 4.0),
                _build_star_bar(4, 0.12, is_dark),
                const SizedBox(height: 4.0),
                _build_star_bar(3, 0.02, is_dark),
                const SizedBox(height: 4.0),
                _build_star_bar(2, 0.01, is_dark),
                const SizedBox(height: 4.0),
                _build_star_bar(1, 0.00, is_dark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _build_star_bar(int stars, double factor, bool is_dark) {
    return Row(
      children: [
        Text(
          '$stars',
          style: TextStyle(
            fontSize: 11.0,
            fontWeight: FontWeight.w700,
            color: is_dark
                ? AppColors.text_dark_secondary
                : AppColors.text_light_secondary,
          ),
        ),
        const SizedBox(width: 4.0),
        const Icon(Icons.star_rounded, size: 12.0, color: AppColors.amber),
        const SizedBox(width: 6.0),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: LinearProgressIndicator(
              value: factor,
              minHeight: 5.0,
              backgroundColor:
                  is_dark ? AppColors.surface_dark : AppColors.slate_200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.amber),
            ),
          ),
        ),
      ],
    );
  }
}
