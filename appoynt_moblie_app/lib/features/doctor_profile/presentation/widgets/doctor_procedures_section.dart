/*
 * File Name: doctor_procedures_section.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   app_localizations.dart, doctor_profile_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Renders the clinical procedures, diagnostics, and treatments
 *   offered by the doctor in a clean, modern wrap of localized tag chips.
 */

// Import Flutter material library
import 'package:flutter/material.dart';
// Import layout design tokens, colors, and localization
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/entities/doctor_profile_entity.dart';

/// Procedures and clinical services chip wrap section.
class DoctorProceduresSection extends StatelessWidget {
  // Procedures list
  final List<ProcedureEntity> procedures_list;

  // Constant constructor
  const DoctorProceduresSection({
    super.key,
    required this.procedures_list,
  });

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final AppLocalizations localizations = AppLocalizations.of(context);

    if (procedures_list.isEmpty) {
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
          // Section Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Icons.healing_rounded,
                  size: 20.0,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(width: AppSpacing.space_m),
              Text(
                localizations.procedures_and_services,
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
          const SizedBox(height: AppSpacing.space_l),

          // Wrap of procedure chips
          Wrap(
            spacing: AppSpacing.space_s,
            runSpacing: AppSpacing.space_s,
            children: procedures_list.map((proc) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space_l,
                  vertical: AppSpacing.space_m,
                ),
                decoration: BoxDecoration(
                  color: is_dark
                      ? AppColors.inner_container_dark
                      : AppColors.slate_100,
                  borderRadius: BorderRadius.circular(AppSpacing.radius_xl),
                  border: Border.all(
                    color: is_dark
                        ? AppColors.border_dark
                        : AppColors.slate_200,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 15.0,
                      color: AppColors.primary_color,
                    ),
                    const SizedBox(width: 6.0),
                    Flexible(
                      child: Text(
                        proc.name,
                        style: TextStyle(
                          fontSize: AppSpacing.font_size_body_small,
                          fontWeight: FontWeight.w600,
                          color: is_dark
                              ? AppColors.text_dark_primary
                              : AppColors.text_light_primary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
    }
  }
}
