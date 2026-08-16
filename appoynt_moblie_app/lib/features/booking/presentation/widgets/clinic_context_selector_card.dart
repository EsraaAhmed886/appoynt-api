/*
 * File Name: clinic_context_selector_card.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   clinic_location_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Top contextual card displaying the active clinic branch, address,
 *   fee, working days, and interactive "Change Clinic" modal trigger chip.
 */

// Import Flutter framework
import 'package:flutter/material.dart';
// Import design tokens, colors, and entities
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/clinic_location_entity.dart';

/// Context card displaying active clinic branch with switch button.
class ClinicContextSelectorCard extends StatelessWidget {
  // Currently active clinic branch
  final ClinicLocationEntity clinic;
  // Change clinic tap callback
  final VoidCallback on_change_clinic;

  // Constant constructor
  const ClinicContextSelectorCard({
    super.key,
    required this.clinic,
    required this.on_change_clinic,
  });

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.space_l),
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
                ? AppColors.black.withValues(alpha: 0.3)
                : AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Clinic Name & "Change Clinic" Action Chip
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Clinic Icon Badge
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.primary_color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Icon(
                  Icons.local_hospital_rounded,
                  color: AppColors.primary_color,
                  size: 20.0,
                ),
              ),
              const SizedBox(width: AppSpacing.space_m),

              // Clinic Title & Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clinic.name,
                      style: TextStyle(
                        fontSize: AppSpacing.font_size_body_medium + 1.0,
                        fontWeight: FontWeight.w700,
                        color: is_dark
                            ? AppColors.text_dark_primary
                            : AppColors.text_light_primary,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 13.0,
                          color: is_dark
                              ? AppColors.text_dark_secondary
                              : AppColors.text_light_secondary,
                        ),
                        const SizedBox(width: 3.0),
                        Expanded(
                          child: Text(
                            clinic.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: AppSpacing.font_size_caption,
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

              // Change Clinic Chip Button
              GestureDetector(
                onTap: on_change_clinic,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary_color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radius_l),
                    border: Border.all(
                      color: AppColors.primary_color.withValues(alpha: 0.3),
                      width: 1.0,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.swap_horiz_rounded,
                        size: 15.0,
                        color: AppColors.primary_color,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        'Change',
                        style: TextStyle(
                          fontSize: AppSpacing.font_size_caption,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary_color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space_m),

          // Divider
          Divider(
            height: 1.0,
            color: is_dark ? AppColors.border_dark : AppColors.slate_200,
          ),
          const SizedBox(height: AppSpacing.space_s + 2.0),

          // Row 2: Working Days & Consultation Fee
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Working Days Badge
              Row(
                children: [
                  const Icon(
                    Icons.event_available_rounded,
                    size: 14.0,
                    color: AppColors.dummy_custom_green,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    clinic.working_days.join(', '),
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

              // Fee Pill
              Text(
                "${clinic.consultation_fee.toStringAsFixed(0)} ${clinic.currency}",
                style: const TextStyle(
                  fontSize: AppSpacing.font_size_body_small,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary_color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
