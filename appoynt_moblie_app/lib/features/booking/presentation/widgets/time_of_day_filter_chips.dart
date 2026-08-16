/*
 * File Name: time_of_day_filter_chips.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   doctor_slot_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Filter pill selector allowing patients to filter time slots
 *   by All, Morning (sun icon), and Afternoon/Evening (moon icon).
 */

// Import Flutter material framework
import 'package:flutter/material.dart';
// Import design tokens, colors, and entity enums
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/doctor_slot_entity.dart';

/// Filter chips row for slot periods.
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

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
      child: Row(
        children: [
          // 1. All
          _build_filter_chip(
            label: 'All Slots',
            icon: Icons.access_time_rounded,
            is_selected: active_filter == null,
            on_tap: () => on_filter_changed(null),
            is_dark: is_dark,
          ),
          const SizedBox(width: 8.0),

          // 2. Morning
          _build_filter_chip(
            label: 'Morning',
            icon: Icons.wb_sunny_rounded,
            is_selected: active_filter == SlotTimeOfDay.morning,
            on_tap: () => on_filter_changed(SlotTimeOfDay.morning),
            is_dark: is_dark,
          ),
          const SizedBox(width: 8.0),

          // 3. Afternoon & Evening
          _build_filter_chip(
            label: 'Afternoon & Evening',
            icon: Icons.nightlight_round,
            is_selected: active_filter == SlotTimeOfDay.afternoon_evening,
            on_tap: () => on_filter_changed(SlotTimeOfDay.afternoon_evening),
            is_dark: is_dark,
          ),
        ],
      ),
    );
  }

  Widget _build_filter_chip({
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
        padding: const EdgeInsets.symmetric(
          horizontal: 14.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          color: is_selected
              ? AppColors.primary_color
              : (is_dark ? AppColors.inner_container_dark : AppColors.slate_100),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: is_selected
                ? AppColors.primary_color
                : (is_dark ? AppColors.border_dark : AppColors.slate_200),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14.0,
              color: is_selected
                  ? AppColors.white
                  : (is_dark ? AppColors.text_dark_secondary : AppColors.text_light_secondary),
            ),
            const SizedBox(width: 6.0),
            Text(
              label,
              style: TextStyle(
                fontSize: AppSpacing.font_size_caption,
                fontWeight: is_selected ? FontWeight.w700 : FontWeight.w600,
                color: is_selected
                    ? AppColors.white
                    : (is_dark ? AppColors.text_dark_primary : AppColors.text_light_primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
