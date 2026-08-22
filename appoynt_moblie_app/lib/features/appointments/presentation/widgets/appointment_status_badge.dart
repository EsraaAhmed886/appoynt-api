/*
 * File Name: appointment_status_badge.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: flutter/material.dart, ../../../../core/localization/appointments_strings.dart, ../../data/models/appointment_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
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
        bg = const Color(0xFFECFDF5);
        fg = const Color(0xFF059669);
        border = const Color(0xFFA7F3D0);
        textKey = 'status_confirmed';
        break;
      case AppointmentStatus.upcoming:
        bg = const Color(0xFFF0F9FF);
        fg = const Color(0xFF0284C7);
        border = const Color(0xFFBAE6FD);
        textKey = 'status_upcoming';
        break;
      case AppointmentStatus.completed:
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF475569);
        border = const Color(0xFFCBD5E1);
        textKey = 'status_completed';
        break;
      case AppointmentStatus.cancelled:
        bg = const Color(0xFFFEF2F2);
        fg = const Color(0xFFDC2626);
        border = const Color(0xFFFECACA);
        textKey = 'status_cancelled';
        break;
      case AppointmentStatus.missed:
        bg = const Color(0xFFFFFBEB);
        fg = const Color(0xFFD97706);
        border = const Color(0xFFFDE68A);
        textKey = 'status_missed';
        break;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      bg = bg.withValues(alpha: 0.15);
      border = border.withValues(alpha: 0.3);
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
