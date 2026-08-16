/*
 * File Name: doctor_reviews_section.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   app_localizations.dart, doctor_profile_entity.dart, doctor_review_card.dart,
 *   all_doctor_reviews_bottom_sheet.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Dedicated Patient Reviews profile section displaying rating stats,
 *   clickable "See All" bottom sheet trigger, and modern patient review cards.
 */

// Import Flutter material framework
import 'package:flutter/material.dart';
// Import design tokens, colors, and localization
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/entities/doctor_profile_entity.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/widgets/doctor_review_card.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/widgets/all_doctor_reviews_bottom_sheet.dart';

/// Patient reviews profile section with "See All" modal trigger.
class DoctorReviewsSection extends StatelessWidget {
  // Complete doctor entity
  final DoctorProfileEntity profile;

  // Constant constructor
  const DoctorReviewsSection({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final AppLocalizations localizations = AppLocalizations.of(context);

    if (profile.reviews_list.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space_xl,
        vertical: AppSpacing.space_s,
      ),
      padding: const EdgeInsets.all(AppSpacing.space_xl),
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : AppColors.background_light,
        borderRadius: BorderRadius.circular(AppSpacing.radius_xl),
        border: Border.all(
          color: is_dark ? AppColors.border_dark : AppColors.slate_200,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header: Title & "See All" Action
          Row(
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

              // Clickable "See All" Button
              GestureDetector(
                onTap: () {
                  AllDoctorReviewsBottomSheet.show(
                    context: context,
                    profile: profile,
                  );
                },
                child: Row(
                  children: [
                    Text(
                      localizations.see_all,
                      style: const TextStyle(
                        fontSize: AppSpacing.font_size_body_small,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary_color,
                      ),
                    ),
                    const SizedBox(width: 2.0),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11.0,
                      color: AppColors.primary_color,
                      textDirection: Directionality.of(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space_l),

          // Render top reviews preview
          ...profile.reviews_list.take(3).map((review) {
            return DoctorReviewCard(review: review);
          }),
        ],
      ),
    );
  }
}
