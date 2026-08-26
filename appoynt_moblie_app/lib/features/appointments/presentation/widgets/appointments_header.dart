import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
/*
 * File Name: appointments_header.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: flutter/material.dart, ../../../../core/localization/appointments_strings.dart, ../../../../core/routing/routes.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Top navigation header for the Appointments screen displaying screen title and notification bell with unread count badge.
 */

import 'package:flutter/material.dart';
import '../../../../core/localization/appointments_strings.dart';
import '../../../../core/routing/routes.dart';

/// Top header bar displaying screen title and notification bell with badge.
class AppointmentsHeader extends StatelessWidget {
  final int unreadNotificationsCount;
  final VoidCallback? onNotificationTap;

  const AppointmentsHeader({
    super.key,
    this.unreadNotificationsCount = 3,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Screen Title
          Text(
            AppointmentsStrings.of(context, 'appointments'),
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: isDark ? AppColors.white : AppColors.slate900,
            ),
          ),

          // Actions: Notification Bell ONLY
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.slate800 : AppColors.slate100,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.notifications_outlined,
                    size: 22.0,
                    color: isDark ? AppColors.slate400 : AppColors.slate600,
                  ),
                  onPressed: onNotificationTap ??
                      () => Navigator.pushNamed(context, Routes.notifications),
                  padding: EdgeInsets.zero,
                ),
              ),
              _build_notification_badge(isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _build_notification_badge(bool isDark) {
    if (unreadNotificationsCount > 0) {
      return Positioned(
        top: -2,
        right: -2,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: isDark ? AppColors.slate900 : AppColors.white,
              width: 1.5,
            ),
          ),
          constraints: const BoxConstraints(minWidth: 18.0, minHeight: 18.0),
          child: Center(
            child: Text(
              unreadNotificationsCount > 99 ? '99+' : unreadNotificationsCount.toString(),
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
