/*
 * File Name: change_clinic_bottom_sheet.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   clinic_location_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Modal bottom sheet allowing patients to select from available
 *   clinic branches with distinct working days, fees, and location addresses.
 */

// Import Flutter framework
import 'package:flutter/material.dart';
// Import design tokens, colors, and entities
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/clinic_location_entity.dart';

/// Modal bottom sheet for switching active clinic location.
class ChangeClinicBottomSheet extends StatelessWidget {
  // Available clinics list
  final List<ClinicLocationEntity> clinics;
  // Currently selected clinic
  final ClinicLocationEntity selected_clinic;
  // Selection callback
  final ValueChanged<ClinicLocationEntity> on_clinic_selected;

  // Constant constructor
  const ChangeClinicBottomSheet({
    super.key,
    required this.clinics,
    required this.selected_clinic,
    required this.on_clinic_selected,
  });

  /// Static helper to display the sheet.
  static Future<void> show({
    required BuildContext context,
    required List<ClinicLocationEntity> clinics,
    required ClinicLocationEntity selected_clinic,
    required ValueChanged<ClinicLocationEntity> on_clinic_selected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (sheet_context) {
        return ChangeClinicBottomSheet(
          clinics: clinics,
          selected_clinic: selected_clinic,
          on_clinic_selected: on_clinic_selected,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : AppColors.background_light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radius_xxl),
          topRight: Radius.circular(AppSpacing.radius_xxl),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.space_xl,
        AppSpacing.space_m,
        AppSpacing.space_xl,
        MediaQuery.of(context).padding.bottom + AppSpacing.space_xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 40.0,
            height: 4.5,
            decoration: BoxDecoration(
              color: is_dark ? AppColors.slate_600 : AppColors.slate_300,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          const SizedBox(height: AppSpacing.space_l),

          // Header: Title & Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Clinic Location',
                style: TextStyle(
                  fontSize: AppSpacing.font_size_title_medium,
                  fontWeight: FontWeight.w700,
                  color: is_dark
                      ? AppColors.text_dark_primary
                      : AppColors.text_light_primary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space_m),

          // List of Clinics
          ...clinics.map((clinic) {
            final bool is_selected = clinic.clinic_id == selected_clinic.clinic_id;

            return GestureDetector(
              onTap: () {
                on_clinic_selected(clinic);
                Navigator.of(context).pop();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.space_m),
                padding: const EdgeInsets.all(AppSpacing.space_l),
                decoration: BoxDecoration(
                  color: is_selected
                      ? AppColors.primary_color.withValues(alpha: is_dark ? 0.2 : 0.08)
                      : (is_dark ? AppColors.inner_container_dark : AppColors.slate_50),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: is_selected
                        ? AppColors.primary_color
                        : (is_dark ? AppColors.border_dark : AppColors.slate_200),
                    width: is_selected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    // Radio Selection Indicator
                    Container(
                      width: 22.0,
                      height: 22.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: is_selected
                            ? AppColors.primary_color
                            : AppColors.transparent,
                        border: Border.all(
                          color: is_selected
                              ? AppColors.primary_color
                              : (is_dark ? AppColors.slate_500 : AppColors.slate_300),
                          width: 2.0,
                        ),
                      ),
                      child: is_selected
                          ? const Icon(
                              Icons.check_rounded,
                              size: 14.0,
                              color: AppColors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: AppSpacing.space_m),

                    // Clinic Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            clinic.name,
                            style: TextStyle(
                              fontSize: AppSpacing.font_size_body_medium,
                              fontWeight: FontWeight.w700,
                              color: is_dark
                                  ? AppColors.text_dark_primary
                                  : AppColors.text_light_primary,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            clinic.address,
                            style: TextStyle(
                              fontSize: AppSpacing.font_size_caption,
                              color: is_dark
                                  ? AppColors.text_dark_secondary
                                  : AppColors.text_light_secondary,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Days: ${clinic.working_days.join(', ')}",
                                style: const TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.dummy_custom_green,
                                ),
                              ),
                              Text(
                                "${clinic.consultation_fee.toStringAsFixed(0)} ${clinic.currency}",
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary_color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
