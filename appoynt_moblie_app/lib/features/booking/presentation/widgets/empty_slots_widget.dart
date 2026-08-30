/*
 * File Name: empty_slots_widget.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   app_localizations.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 30/08/2026]
 * File Description: Empty state presentation widget displayed when no time slots match
 *   the selected date or filter, featuring a "Check Next Available Date" action button.
 */

// Import Flutter material framework
import 'package:flutter/material.dart';
// Import design tokens and colors
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';

/// Empty state widget for slots list.
class EmptySlotsWidget extends StatelessWidget {
  // Callback when patient taps "Check Next Available Date"
  final VoidCallback on_next_date_tap;

  // Constant constructor
  const EmptySlotsWidget({
    super.key,
    required this.on_next_date_tap,
  });

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.space_xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              color: AppColors.primary_color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_busy_rounded,
              size: 34.0,
              color: AppColors.primary_color,
            ),
          ),
          const SizedBox(height: AppSpacing.space_l),
          Text(
            localizations.no_available_slots,
            style: TextStyle(
              fontSize: AppSpacing.font_size_title_medium,
              fontWeight: FontWeight.w700,
              color: is_dark
                  ? AppColors.text_dark_primary
                  : AppColors.text_light_primary,
            ),
          ),
          const SizedBox(height: AppSpacing.space_s),
          Text(
            localizations.all_slots_booked_msg,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppSpacing.font_size_body_small,
              height: 1.4,
              color: is_dark
                  ? AppColors.text_dark_secondary
                  : AppColors.text_light_secondary,
            ),
          ),
          const SizedBox(height: AppSpacing.space_xl),
          OutlinedButton.icon(
            onPressed: on_next_date_tap,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary_color,
              side: const BorderSide(color: AppColors.primary_color),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space_xl,
                vertical: AppSpacing.space_m,
              ),
            ),
            icon: const Icon(Icons.arrow_forward_rounded, size: 16.0),
            label: Text(
              localizations.check_next_date,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
