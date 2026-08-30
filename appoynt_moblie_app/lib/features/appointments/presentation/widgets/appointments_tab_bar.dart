import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
/*
 * File Name: appointments_tab_bar.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: flutter/material.dart, ../../../../core/localization/appointments_strings.dart, ../../data/models/appointment_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Custom segmented pill tab bar for switching between Upcoming, Completed, Cancelled, and All Appointments categories.
 */

import 'package:flutter/material.dart';
import '../../../../core/localization/appointments_strings.dart';
import '../../data/models/appointment_model.dart';

/// 4-Segmented pill tab selector for scoping appointments lists.
class AppointmentsTabBar extends StatelessWidget {
  final AppointmentTabType activeTab;
  final ValueChanged<AppointmentTabType> onTabSelected;

  const AppointmentsTabBar({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tabs = [
      AppointmentTabType.upcoming,
      AppointmentTabType.completed,
      AppointmentTabType.cancelled,
      AppointmentTabType.all,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = activeTab == tab;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _buildTabItem(context, tab, isSelected, isDark),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    AppointmentTabType tab,
    bool isSelected,
    bool isDark,
  ) {
    String labelKey;
    switch (tab) {
      case AppointmentTabType.upcoming:
        labelKey = 'tab_upcoming';
        break;
      case AppointmentTabType.completed:
        labelKey = 'tab_completed';
        break;
      case AppointmentTabType.cancelled:
        labelKey = 'tab_cancelled';
        break;
      case AppointmentTabType.all:
        labelKey = 'tab_all';
        break;
      default:
        labelKey = 'tab_upcoming';
        break;
    }

    final label = AppointmentsStrings.of(context, labelKey);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: () => onTabSelected(tab),
          borderRadius: BorderRadius.circular(24.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 9.0),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.sky600
                  : (isDark ? AppColors.slate800 : AppColors.slate100),
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(
                color: isSelected
                    ? AppColors.sky600
                    : (isDark ? AppColors.slate700 : AppColors.slate200),
                width: 1.0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.sky600.withValues(alpha: 0.25),
                        blurRadius: 8.0,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? AppColors.white
                    : (isDark ? AppColors.slate400 : AppColors.slate500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
