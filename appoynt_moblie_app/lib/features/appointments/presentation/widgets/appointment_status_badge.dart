import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
/*
 * File Name: appointment_status_badge.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: flutter/material.dart, ../../../../core/localization/appointments_strings.dart, ../../data/models/appointment_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Pill badge displaying appointment lifecycle status with contextual color palettes and localized label.
 */

import 'package:flutter/material.dart';
import '../../../../core/localization/appointments_strings.dart';
import '../../data/models/appointment_model.dart';

/// Contextual status pill badge for appointment items.
class AppointmentStatusBadge extends StatelessWidget {
  final AppointmentStatus status;

  const AppointmentStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Color border;
    String textKey;

    switch (status) {
      case AppointmentStatus.confirmed:
        bg = AppColors.successLight;
        fg = AppColors.emerald600;
        border = AppColors.emerald200;
        textKey = 'status_confirmed';
        break;
      case AppointmentStatus.upcoming:
        bg = AppColors.sky50;
        fg = AppColors.sky600;
        border = AppColors.sky200;
        textKey = 'status_upcoming';
        break;
      case AppointmentStatus.completed:
        bg = AppColors.slate100;
        fg = AppColors.slate600;
        border = AppColors.slate300;
        textKey = 'status_completed';
        break;
      case AppointmentStatus.cancelled:
        bg = AppColors.errorLight;
        fg = AppColors.red600;
        border = AppColors.red200;
        textKey = 'status_cancelled';
        break;
      case AppointmentStatus.missed:
        bg = AppColors.warningLight;
        fg = AppColors.amber600;
        border = AppColors.amber200;
        textKey = 'status_missed';
        break;
      default:
        bg = AppColors.sky50;
        fg = AppColors.sky600;
        border = AppColors.sky200;
        textKey = 'status_upcoming';
        break;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      bg = bg.withValues(alpha: 0.15);
      border = border.withValues(alpha: 0.3);
    } else {
      // No action needed
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: border, width: 1.0),
      ),
      child: Text(
        AppointmentsStrings.of(context, textKey),
        style: TextStyle(
          color: fg,
          fontSize: 11.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
