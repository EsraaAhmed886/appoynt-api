/*
 * File Name: horizontal_calendar_date_strip.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   clinic_location_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Fluid horizontal date selector strip with 14-day timeline,
 *   active day dots, automatic closed-day disabling, and fluid selection animations.
 */

// Import Flutter material framework
import 'package:flutter/material.dart';
// Import design tokens, colors, and entities
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/clinic_location_entity.dart';

/// Horizontal 14-day calendar selector strip.
class HorizontalCalendarDateStrip extends StatelessWidget {
  // Selected date
  final DateTime selected_date;
  // Active clinic location context (to check open working days)
  final ClinicLocationEntity clinic;
  // Date selection callback
  final ValueChanged<DateTime> on_date_selected;

  // Constant constructor
  const HorizontalCalendarDateStrip({
    super.key,
    required this.selected_date,
    required this.clinic,
    required this.on_date_selected,
  });

  static const List<String> _day_names = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<String> _month_names = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final DateTime now = DateTime.now();

    return SizedBox(
      height: 86.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
        itemCount: 14,
        itemBuilder: (context, index) {
          final DateTime date = now.add(Duration(days: index));
          final String day_name = _day_names[date.weekday - 1];
          final String month_name = _month_names[date.month - 1];
          final bool is_open = clinic.isOpenOn(day_name);

          final bool is_selected = selected_date.year == date.year &&
              selected_date.month == date.month &&
              selected_date.day == date.day;

          return GestureDetector(
            onTap: is_open ? () => on_date_selected(date) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 62.0,
              margin: const EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                color: is_selected
                    ? AppColors.primary_color
                    : (!is_open
                        ? (is_dark
                            ? AppColors.inner_container_dark.withValues(alpha: 0.4)
                            : AppColors.slate_100.withValues(alpha: 0.6))
                        : (is_dark
                            ? AppColors.inner_container_dark
                            : AppColors.slate_50)),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: is_selected
                      ? AppColors.primary_color
                      : (!is_open
                          ? AppColors.transparent
                          : (is_dark ? AppColors.border_dark : AppColors.slate_200)),
                  width: is_selected ? 1.5 : 1.0,
                ),
                boxShadow: is_selected
                    ? [
                        BoxShadow(
                          color: AppColors.primary_color.withValues(alpha: 0.35),
                          blurRadius: 8.0,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Opacity(
                opacity: is_open ? 1.0 : 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Weekday Name
                    Text(
                      index == 0 ? 'Today' : day_name,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: is_selected
                            ? AppColors.white
                            : (is_dark
                                ? AppColors.text_dark_secondary
                                : AppColors.text_light_secondary),
                      ),
                    ),
                    const SizedBox(height: 3.0),

                    // Day Number
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w800,
                        color: is_selected
                            ? AppColors.white
                            : (is_dark
                                ? AppColors.text_dark_primary
                                : AppColors.text_light_primary),
                      ),
                    ),

                    // Month or Closed indicator
                    Text(
                      is_open ? month_name : 'Closed',
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: is_open ? FontWeight.w500 : FontWeight.w700,
                        color: is_selected
                            ? AppColors.white.withValues(alpha: 0.9)
                            : (is_open
                                ? (is_dark
                                    ? AppColors.text_dark_secondary
                                    : AppColors.text_light_secondary)
                                : AppColors.amber),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
