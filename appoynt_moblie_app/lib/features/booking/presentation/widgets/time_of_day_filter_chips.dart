/*
 * File Name: time_of_day_filter_chips.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V2.0.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   doctor_slot_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Non-scrollable equal-width segmented control bar for filtering
 *   appointment time slots into All, Morning, and Evening periods.
 */

// Import Flutter material framework
import 'package:flutter/material.dart';
// Import design tokens, colors, and entity enums
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/doctor_slot_entity.dart';

/// Non-scrollable equal-width segmented filter bar.
class TimeOfDayFilterChips extends StatelessWidget {
  // Current active filter (null = All)
  final SlotTimeOfDay? active_filter;
  // Filter changed callback
  final ValueChanged<SlotTimeOfDay?> on_filter_changed;

  // Constant constructor
  const TimeOfDayFilterChips({
    super.key,
    required this.active_filter,
    required this.on_filter_changed,
  });

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: is_dark ? AppColors.surface_dark : AppColors.slate_100,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(
            color: is_dark ? AppColors.border_dark : AppColors.slate_200,
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            // 1. All Slots
            Expanded(
              child: _build_segment_button(
                label: 'All Slots',
                icon: Icons.access_time_rounded,
                is_selected: active_filter == null,
                on_tap: () => on_filter_changed(null),
                is_dark: is_dark,
              ),
            ),
            const SizedBox(width: 4.0),

            // 2. Morning Slots
            Expanded(
              child: _build_segment_button(
                label: 'Morning',
                icon: Icons.wb_sunny_rounded,
                is_selected: active_filter == SlotTimeOfDay.morning,
                on_tap: () => on_filter_changed(SlotTimeOfDay.morning),
                is_dark: is_dark,
              ),
            ),
            const SizedBox(width: 4.0),

            // 3. Evening Slots
            Expanded(
              child: _build_segment_button(
                label: 'Evening',
                icon: Icons.nightlight_round,
                is_selected: active_filter == SlotTimeOfDay.afternoon_evening,
                on_tap: () => on_filter_changed(SlotTimeOfDay.afternoon_evening),
                is_dark: is_dark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _build_segment_button({
    required String label,
    required IconData icon,
    required bool is_selected,
    required VoidCallback on_tap,
    required bool is_dark,
  }) {
    return GestureDetector(
      onTap: on_tap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 9.0),
        decoration: BoxDecoration(
          color: is_selected
              ? AppColors.primary_color
              : AppColors.transparent,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: is_selected
              ? [
                  BoxShadow(
                    color: AppColors.primary_color.withValues(alpha: 0.3),
                    blurRadius: 6.0,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 14.0,
                  color: is_selected
                      ? AppColors.white
                      : (is_dark
                          ? AppColors.text_dark_secondary
                          : AppColors.text_light_secondary),
                ),
                const SizedBox(width: 5.0),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppSpacing.font_size_caption + 0.5,
                    fontWeight: is_selected ? FontWeight.w700 : FontWeight.w600,
                    color: is_selected
                        ? AppColors.white
                        : (is_dark
                            ? AppColors.text_dark_primary
                            : AppColors.text_light_primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
