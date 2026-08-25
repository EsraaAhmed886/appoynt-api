/*
 * File Name: doctor_quick_stats_row.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.2.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   app_localizations.dart, doctor_profile_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Modern 4-pillar quick statistics banner displaying years of
 *   experience, patients served, total reviews count, and star rating with
 *   balanced layout across all screen widths and full localization support.
 */

// Import Flutter material library
import 'package:flutter/material.dart';
// Import layout design tokens, colors, and localization
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/entities/doctor_profile_entity.dart';

/// Modern 4-stat banner widget displaying quick practice metrics.
class DoctorQuickStatsRow extends StatelessWidget {
  // Doctor domain entity
  final DoctorProfileEntity profile;

  // Constant constructor
  const DoctorQuickStatsRow({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final AppLocalizations localizations = AppLocalizations.of(context);

    // Formatting patient count
    final String patients_formatted = profile.patients_count >= 1000
        ? "${(profile.patients_count / 1000).toStringAsFixed(1)}k+"
        : "${profile.patients_count}+";

    // Formatting review count
    final String reviews_formatted = profile.reviews_count >= 1000
        ? "${(profile.reviews_count / 1000).toStringAsFixed(1)}k+"
        : "${profile.reviews_count}";

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space_xl,
        vertical: AppSpacing.space_m,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space_s,
        vertical: AppSpacing.space_l,
      ),
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : AppColors.background_light,
        borderRadius: BorderRadius.circular(AppSpacing.radius_xl),
        border: Border.all(
          color: is_dark ? AppColors.border_dark : AppColors.slate_200,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: is_dark
                ? AppColors.black.withValues(alpha: 0.2)
                : AppColors.slate_200.withValues(alpha: 0.4),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. Experience
          Expanded(
            child: _build_stat_item(
              icon: Icons.work_outline_rounded,
              icon_color: AppColors.primary_color,
              value: "${profile.experience_years} ${localizations.years_exp}",
              label: localizations.experience_label,
              is_dark: is_dark,
            ),
          ),
          _build_vertical_divider(is_dark),

          // 2. Patients
          Expanded(
            child: _build_stat_item(
              icon: Icons.people_outline_rounded,
              icon_color: AppColors.teal,
              value: patients_formatted,
              label: localizations.patients_label,
              is_dark: is_dark,
            ),
          ),
          _build_vertical_divider(is_dark),

          // 3. Reviews
          Expanded(
            child: _build_stat_item(
              icon: Icons.chat_bubble_outline_rounded,
              icon_color: AppColors.deepOrange,
              value: reviews_formatted,
              label: localizations.reviews_label,
              is_dark: is_dark,
            ),
          ),
          _build_vertical_divider(is_dark),

          // 4. Rating
          Expanded(
            child: _build_stat_item(
              icon: Icons.star_rounded,
              icon_color: AppColors.amber,
              value: profile.average_rating.toStringAsFixed(1),
              label: localizations.rating_label,
              is_dark: is_dark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _build_stat_item({
    required IconData icon,
    required Color icon_color,
    required String value,
    required String label,
    required bool is_dark,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            color: icon_color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16.0,
            color: icon_color,
          ),
        ),
        const SizedBox(height: AppSpacing.space_xs),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              fontSize: AppSpacing.font_size_body_medium,
              fontWeight: FontWeight.w800,
              color: is_dark
                  ? AppColors.text_dark_primary
                  : AppColors.text_light_primary,
            ),
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppSpacing.font_size_caption,
              fontWeight: FontWeight.w500,
              color: is_dark
                  ? AppColors.text_dark_secondary
                  : AppColors.text_light_secondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _build_vertical_divider(bool is_dark) {
    return Container(
      width: 1.0,
      height: 32.0,
      color: is_dark ? AppColors.border_dark : AppColors.slate_200,
    );
  }
}
