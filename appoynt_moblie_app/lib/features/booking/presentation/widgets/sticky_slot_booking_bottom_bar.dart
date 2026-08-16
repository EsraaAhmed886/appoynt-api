/*
 * File Name: sticky_slot_booking_bottom_bar.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   doctor_slot_entity.dart, clinic_location_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Sticky bottom confirmation bar displaying the active slot summary,
 *   consultation fee, and Continue button guarded by active hold validation.
 */

// Import Flutter material framework
import 'package:flutter/material.dart';
// Import design tokens, colors, and entities
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/clinic_location_entity.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/doctor_slot_entity.dart';

/// Sticky bottom booking bar for the Choose Slots page.
class StickySlotBookingBottomBar extends StatelessWidget {
  // Active clinic location
  final ClinicLocationEntity clinic;
  // Selected slot entity
  final DoctorSlotEntity? selected_slot;
  // Whether an active hold is confirmed
  final bool has_active_hold;
  // Continue action callback
  final VoidCallback on_continue_pressed;

  // Constant constructor
  const StickySlotBookingBottomBar({
    super.key,
    required this.clinic,
    required this.selected_slot,
    required this.has_active_hold,
    required this.on_continue_pressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.space_xl,
        AppSpacing.space_m,
        AppSpacing.space_xl,
        MediaQuery.of(context).padding.bottom + AppSpacing.space_m,
      ),
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : AppColors.background_light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radius_xxl),
          topRight: Radius.circular(AppSpacing.radius_xxl),
        ),
        boxShadow: [
          BoxShadow(
            color: is_dark
                ? AppColors.black.withValues(alpha: 0.5)
                : AppColors.slate_200.withValues(alpha: 0.8),
            blurRadius: 16.0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Slot Summary & Fee Row
          if (selected_slot != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 16.0,
                      color: AppColors.primary_color,
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      selected_slot!.start_time,
                      style: TextStyle(
                        fontSize: AppSpacing.font_size_body_medium,
                        fontWeight: FontWeight.w700,
                        color: is_dark
                            ? AppColors.text_dark_primary
                            : AppColors.text_light_primary,
                      ),
                    ),
                  ],
                ),
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
            const SizedBox(height: AppSpacing.space_m),
          ],

          // Full Width Continue CTA
          SizedBox(
            width: double.infinity,
            height: 52.0,
            child: ElevatedButton(
              onPressed: has_active_hold ? on_continue_pressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary_color,
                disabledBackgroundColor: is_dark
                    ? AppColors.inner_container_dark
                    : AppColors.slate_200,
                foregroundColor: AppColors.white,
                disabledForegroundColor: is_dark
                    ? AppColors.text_dark_secondary.withValues(alpha: 0.4)
                    : AppColors.text_light_secondary.withValues(alpha: 0.4),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue to Confirmation',
                    style: TextStyle(
                      fontSize: AppSpacing.font_size_text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: AppSpacing.space_m),
                  Icon(Icons.arrow_forward_rounded, size: 18.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
