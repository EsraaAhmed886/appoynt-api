/*
 * File Name: doctor_timeline_section.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   app_localizations.dart, doctor_profile_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Modern medical timeline widget rendering clinical career
 *   experience and academic education history with connected nodes and localized tabs.
 */

// Import Flutter material library
import 'package:flutter/material.dart';
// Import layout design tokens, colors, and localization
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/entities/doctor_profile_entity.dart';

/// Timeline component rendering experience and education nodes.
class DoctorTimelineSection extends StatefulWidget {
  // Experience list
  final List<ExperienceEntity> experience_list;
  // Education list
  final List<EducationEntity> education_list;

  // Constant constructor
  const DoctorTimelineSection({
    super.key,
    required this.experience_list,
    required this.education_list,
  });

  @override
  State<DoctorTimelineSection> createState() => _DoctorTimelineSectionState();
}

class _DoctorTimelineSectionState extends State<DoctorTimelineSection> {
  // Selected tab index: 0 = Experience, 1 = Education
  int _selected_tab = 0;

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final AppLocalizations localizations = AppLocalizations.of(context);

    if (widget.experience_list.isEmpty && widget.education_list.isEmpty) {
      return const SizedBox.shrink();
    } else {
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
          // Section Title & Tab Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: AppColors.teal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Icon(
                      Icons.history_edu_rounded,
                      size: 20.0,
                      color: AppColors.teal,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space_m),
                  Text(
                    localizations.career_and_education,
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
            ],
          ),
          const SizedBox(height: AppSpacing.space_l),

          // Tab Switcher Pills
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: is_dark
                  ? AppColors.inner_container_dark
                  : AppColors.slate_100,
              borderRadius: BorderRadius.circular(AppSpacing.radius_l),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _build_tab_pill(
                    title: '${localizations.experience_tab} (${widget.experience_list.length})',
                    index: 0,
                    is_dark: is_dark,
                  ),
                ),
                Expanded(
                  child: _build_tab_pill(
                    title: '${localizations.education_tab} (${widget.education_list.length})',
                    index: 1,
                    is_dark: is_dark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.space_xl),

          // Timeline Content
          _selected_tab == 0
              ? _build_experience_timeline(is_dark)
              : _build_education_timeline(is_dark),
        ],
      ),
    );
    }
  }

  Widget _build_tab_pill({
    required String title,
    required int index,
    required bool is_dark,
  }) {
    final bool is_active = _selected_tab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selected_tab = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: is_active
              ? (is_dark ? AppColors.surface_dark : AppColors.white)
              : AppColors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radius_m),
          boxShadow: is_active
              ? [
                  BoxShadow(
                    color: is_dark
                        ? AppColors.black.withValues(alpha: 0.3)
                        : AppColors.slate_200.withValues(alpha: 0.6),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppSpacing.font_size_body_small,
            fontWeight: is_active ? FontWeight.w700 : FontWeight.w500,
            color: is_active
                ? AppColors.primary_color
                : (is_dark
                    ? AppColors.text_dark_secondary
                    : AppColors.text_light_secondary),
          ),
        ),
      ),
    );
  }

  Widget _build_experience_timeline(bool is_dark) {
    if (widget.experience_list.isEmpty) {
      return Center(
        child: Text(
          '-',
          style: TextStyle(
            fontSize: AppSpacing.font_size_body_small,
            color: is_dark
                ? AppColors.text_dark_secondary
                : AppColors.text_light_secondary,
          ),
        ),
      );
    } else {
      return Column(
        children: List.generate(widget.experience_list.length, (index) {
          final exp = widget.experience_list[index];
          final bool is_last = index == widget.experience_list.length - 1;

          return _build_timeline_node(
            title: exp.position,
            subtitle: exp.hospital_or_clinic,
            badge: exp.duration,
            badge_color: AppColors.primary_color,
            icon: Icons.work_outline_rounded,
            is_last: is_last,
            is_dark: is_dark,
          );
        }),
      );
    }
  }

  Widget _build_education_timeline(bool is_dark) {
    if (widget.education_list.isEmpty) {
      return Center(
        child: Text(
          '-',
          style: TextStyle(
            fontSize: AppSpacing.font_size_body_small,
            color: is_dark
                ? AppColors.text_dark_secondary
                : AppColors.text_light_secondary,
          ),
        ),
      );
    } else {
      return Column(
        children: List.generate(widget.education_list.length, (index) {
          final edu = widget.education_list[index];
          final bool is_last = index == widget.education_list.length - 1;

          return _build_timeline_node(
            title: edu.degree,
            subtitle: edu.institution,
            badge: edu.year,
            badge_color: AppColors.teal,
            icon: Icons.school_outlined,
            is_last: is_last,
            is_dark: is_dark,
          );
        }),
      );
    }
  }

  Widget _build_timeline_node({
    required String title,
    required String subtitle,
    required String badge,
    required Color badge_color,
    required IconData icon,
    required bool is_last,
    required bool is_dark,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Node & Vertical Line
          Column(
            children: [
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: badge_color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: badge_color.withValues(alpha: 0.4),
                    width: 2.0,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 16.0,
                  color: badge_color,
                ),
              ),
              if (!is_last)
                Expanded(
                  child: Container(
                    width: 2.0,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    color: is_dark
                        ? AppColors.border_dark
                        : AppColors.slate_200,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.space_l),

          // Node Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: is_last ? 0 : AppSpacing.space_xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: AppSpacing.font_size_body_medium,
                            fontWeight: FontWeight.w700,
                            color: is_dark
                                ? AppColors.text_dark_primary
                                : AppColors.text_light_primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.space_s),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: badge_color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSpacing.radius_s),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            fontSize: AppSpacing.font_size_caption,
                            fontWeight: FontWeight.w700,
                            color: badge_color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: AppSpacing.font_size_body_small,
                      color: is_dark
                          ? AppColors.text_dark_secondary
                          : AppColors.text_light_secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
