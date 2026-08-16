/*
 * File Name: clinic_context_selector_card.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V2.0.0
 * Dependencies: package:flutter/material.dart, package:url_launcher/url_launcher.dart,
 *   app_colors.dart, app_spacing.dart, clinic_location_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Modern medical-grade clinic context card featuring a 44x44 icon badge,
 *   direct "View on Map" external launcher, fee pill, working days, and "Change" action.
 */

// Import Flutter material and URL launcher frameworks
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// Import design tokens, colors, and entities
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/clinic_location_entity.dart';

/// Context card displaying active clinic branch with map launch and change action.
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

  Future<void> _launch_map(BuildContext context) async {
    final Uri map_uri = Uri.parse(
      'https://maps.google.com/?q=${clinic.latitude},${clinic.longitude}',
    );
    try {
      final bool launched = await launchUrl(
        map_uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        final Uri search_uri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(clinic.address)}',
        );
        await launchUrl(search_uri, mode: LaunchMode.externalApplication);
      } else {
        // No action needed
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open map application.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // No action needed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.space_l + 2.0),
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : AppColors.background_light,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: is_dark ? AppColors.border_dark : AppColors.slate_200,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: is_dark
                ? AppColors.black.withValues(alpha: 0.35)
                : AppColors.black.withValues(alpha: 0.05),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: 44x44 Clinic Icon Badge, Details, and "Change" Action Chip
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Clinic Icon Container (44w x 44h)
              Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color: AppColors.primary_color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Icon(
                  Icons.local_hospital_rounded,
                  color: AppColors.primary_color,
                  size: 24.0,
                ),
              ),
              const SizedBox(width: AppSpacing.space_m + 2.0),

              // Clinic Title & Address
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clinic.name,
                      style: TextStyle(
                        fontSize: AppSpacing.font_size_body_medium + 1.5,
                        fontWeight: FontWeight.w800,
                        color: is_dark
                            ? AppColors.text_dark_primary
                            : AppColors.text_light_primary,
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14.0,
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
                              fontSize: AppSpacing.font_size_caption + 0.5,
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
              const SizedBox(width: 6.0),

              // Change Clinic Chip Button
              GestureDetector(
                onTap: on_change_clinic,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 6.0,
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
          const SizedBox(height: AppSpacing.space_m + 2.0),

          // Divider
          Divider(
            height: 1.0,
            color: is_dark ? AppColors.border_dark : AppColors.slate_200,
          ),
          const SizedBox(height: AppSpacing.space_m),

          // Row 2: Working Days & Map Action + Consultation Fee
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Working Days & Map Trigger
              Row(
                children: [
                  const Icon(
                    Icons.event_available_rounded,
                    size: 15.0,
                    color: AppColors.dummy_custom_green,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    clinic.working_days.join(', '),
                    style: TextStyle(
                      fontSize: AppSpacing.font_size_caption + 0.5,
                      fontWeight: FontWeight.w600,
                      color: is_dark
                          ? AppColors.text_dark_secondary
                          : AppColors.text_light_secondary,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  // Dedicated "View on Map" Link Chip
                  GestureDetector(
                    onTap: () => _launch_map(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7.0,
                        vertical: 3.0,
                      ),
                      decoration: BoxDecoration(
                        color: is_dark
                            ? AppColors.inner_container_dark
                            : AppColors.slate_100,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.directions_rounded,
                            size: 12.0,
                            color: is_dark
                                ? AppColors.text_dark_secondary
                                : AppColors.text_light_secondary,
                          ),
                          const SizedBox(width: 3.0),
                          Text(
                            'Map',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
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

              // Fee Pill
              Text(
                "${clinic.consultation_fee.toStringAsFixed(0)} ${clinic.currency}",
                style: const TextStyle(
                  fontSize: AppSpacing.font_size_body_medium,
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
