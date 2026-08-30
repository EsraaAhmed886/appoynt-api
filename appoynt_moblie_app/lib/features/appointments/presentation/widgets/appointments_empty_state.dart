import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
/*
 * File Name: appointments_empty_state.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: flutter/material.dart, ../../../../core/localization/appointments_strings.dart, ../../data/models/appointment_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Contextual empty state placeholder widget adapting to active tab category, search queries, or active filter states.
 */

import 'package:flutter/material.dart';
import '../../../../core/localization/appointments_strings.dart';
import '../../data/models/appointment_model.dart';

/// Contextual empty state view displaying appropriate illustrations, titles, and CTAs.
class AppointmentsEmptyState extends StatelessWidget {
  final AppointmentTabType tab;
  final bool isSearching;
  final bool isFiltering;
  final VoidCallback? onActionTap;

  const AppointmentsEmptyState({
    super.key,
    required this.tab,
    this.isSearching = false,
    this.isFiltering = false,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    IconData icon;
    String titleKey;
    String subtitleKey;
    bool showCta = false;

    if (isSearching) {
      icon = Icons.search_off_rounded;
      titleKey = 'no_search_results';
      subtitleKey = 'no_search_results';
    } else if (isFiltering) {
      icon = Icons.filter_alt_off_rounded;
      titleKey = 'no_filter_results';
      subtitleKey = 'no_filter_results';
    } else {
      switch (tab) {
        case AppointmentTabType.upcoming:
          icon = Icons.event_available_rounded;
          titleKey = 'no_upcoming';
          subtitleKey = 'no_upcoming_sub';
          showCta = true;
          break;
        case AppointmentTabType.completed:
          icon = Icons.task_alt_rounded;
          titleKey = 'no_completed';
          subtitleKey = 'no_completed_sub';
          break;
        case AppointmentTabType.cancelled:
          icon = Icons.event_busy_rounded;
          titleKey = 'no_cancelled';
          subtitleKey = 'no_cancelled_sub';
          break;
        case AppointmentTabType.all:
          icon = Icons.calendar_month_rounded;
          titleKey = 'no_all';
          subtitleKey = 'no_all_sub';
          showCta = true;
          break;
        default:
          icon = Icons.event_available_rounded;
          titleKey = 'no_upcoming';
          subtitleKey = 'no_upcoming_sub';
          showCta = true;
          break;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Container with Soft Glow
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: AppColors.sky600.withValues(alpha: isDark ? 0.15 : 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 38.0,
                color: AppColors.sky600,
              ),
            ),
            const SizedBox(height: 18.0),

            // Title
            Text(
              AppointmentsStrings.of(context, titleKey),
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.slate900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),

            // Subtitle
            Text(
              AppointmentsStrings.of(context, subtitleKey),
              style: TextStyle(
                fontSize: 13.0,
                height: 1.4,
                color: isDark ? AppColors.slate400 : AppColors.slate500,
              ),
              textAlign: TextAlign.center,
            ),

            _build_cta_button(showCta, context),
          ],
        ),
      ),
    );
  }

  /// Builds call-to-action button if applicable.
  Widget _build_cta_button(bool showCta, BuildContext context) {
    if (showCta) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20.0),
          ElevatedButton.icon(
            onPressed: onActionTap,
            icon: const Icon(Icons.add_rounded, size: 18.0),
            label: Text(
              AppointmentsStrings.of(context, 'book_now'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sky600,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
