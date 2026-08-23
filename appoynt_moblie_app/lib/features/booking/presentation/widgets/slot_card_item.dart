/*
 * File Name: slot_card_item.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   doctor_slot_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Card component representing a single time slot across available,
 *   holding (spinner), held/selected (primary checkmark), and booked states with FittedBox
 *   scaling protecting against vertical RenderFlex overflow.
 */

// Import Flutter material framework
import 'package:flutter/material.dart';
// Import design tokens, colors, and entities
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/doctor_slot_entity.dart';

/// Individual slot card item.
class SlotCardItem extends StatelessWidget {
  // Slot domain entity
  final DoctorSlotEntity slot;
  // Whether this slot is selected & held
  final bool is_selected;
  // Whether this slot is currently undergoing hold acquisition
  final bool is_loading;
  // Tap callback
  final VoidCallback on_tap;

  // Constant constructor
  const SlotCardItem({
    super.key,
    required this.slot,
    required this.is_selected,
    required this.is_loading,
    required this.on_tap,
  });

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final bool is_available = slot.is_available;

    return GestureDetector(
      onTap: is_available && !is_loading ? on_tap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: is_selected
              ? AppColors.primary_color
              : (!is_available
                  ? (is_dark
                      ? AppColors.inner_container_dark.withValues(alpha: 0.3)
                      : AppColors.slate_100.withValues(alpha: 0.6))
                  : (is_dark
                      ? AppColors.inner_container_dark
                      : AppColors.white)),
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(
            color: is_selected
                ? AppColors.primary_color
                : (!is_available
                    ? AppColors.transparent
                    : (is_dark ? AppColors.border_dark : AppColors.slate_200)),
            width: is_selected ? 1.5 : 1.0,
          ),
          boxShadow: is_selected
              ? [
                  BoxShadow(
                    color: AppColors.primary_color.withValues(alpha: 0.3),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: is_loading
            ? const Center(
                child: SizedBox(
                  width: 18.0,
                  height: 18.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: AppColors.primary_color,
                  ),
                ),
              )
            : Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (is_selected) ...[
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 14.0,
                              color: AppColors.white,
                            ),
                            const SizedBox(width: 4.0),
                          ],
                          Text(
                            slot.start_time,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: AppSpacing.font_size_caption + 0.5,
                              fontWeight: is_selected
                                  ? FontWeight.w800
                                  : FontWeight.w700,
                              color: is_selected
                                  ? AppColors.white
                                  : (!is_available
                                      ? (is_dark
                                          ? AppColors.text_dark_secondary
                                              .withValues(alpha: 0.5)
                                          : AppColors.text_light_secondary
                                              .withValues(alpha: 0.5))
                                      : (is_dark
                                          ? AppColors.text_dark_primary
                                          : AppColors.text_light_primary)),
                            ),
                          ),
                        ],
                      ),
                      if (!is_available) ...[
                        const SizedBox(height: 2.0),
                        Text(
                          'Booked',
                          style: TextStyle(
                            fontSize: 9.5,
                            height: 1.1,
                            fontWeight: FontWeight.w600,
                            color: is_dark
                                ? AppColors.text_dark_secondary
                                    .withValues(alpha: 0.4)
                                : AppColors.text_light_secondary
                                    .withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
