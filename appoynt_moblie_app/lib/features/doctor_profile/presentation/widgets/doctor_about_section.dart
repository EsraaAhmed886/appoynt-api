/*
 * File Name: doctor_about_section.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   app_localizations.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Expandable biography card featuring smooth animation between
 *   collapsed snippet and full medical narrative with localized Read More / Read Less toggle.
 */

// Import Flutter material library
import 'package:flutter/material.dart';
// Import layout design tokens, colors, and localization
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';

/// Expandable biography section card.
class DoctorAboutSection extends StatefulWidget {
  // Biography string
  final String bio;

  // Constant constructor
  const DoctorAboutSection({
    super.key,
    required this.bio,
  });

  @override
  State<DoctorAboutSection> createState() => _DoctorAboutSectionState();
}

class _DoctorAboutSectionState extends State<DoctorAboutSection>
    with SingleTickerProviderStateMixin {
  // Expansion boolean state
  bool _is_expanded = false;

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final AppLocalizations localizations = AppLocalizations.of(context);

    if (widget.bio.isEmpty) {
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
          // Section Title Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: AppColors.primary_color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Icons.person_pin_outlined,
                  size: 20.0,
                  color: AppColors.primary_color,
                ),
              ),
              const SizedBox(width: AppSpacing.space_m),
              Text(
                localizations.about_doctor,
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
          const SizedBox(height: AppSpacing.space_m),

          // Animated Biography Text
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topLeft,
            child: Text(
              widget.bio,
              maxLines: _is_expanded ? null : 3,
              overflow: _is_expanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppSpacing.font_size_body_medium,
                height: 1.55,
                color: is_dark
                    ? AppColors.text_dark_secondary
                    : AppColors.text_light_secondary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.space_xs),

          // Read More / Read Less Button
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              borderRadius: BorderRadius.circular(4.0),
              onTap: () {
                setState(() {
                  _is_expanded = !_is_expanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 2.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _is_expanded
                          ? localizations.read_less
                          : localizations.read_more,
                      style: const TextStyle(
                        fontSize: AppSpacing.font_size_body_small,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary_color,
                      ),
                    ),
                    Icon(
                      _is_expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 18.0,
                      color: AppColors.primary_color,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
