import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
/*
 * File Name: notification_filter_chips.dart
 * Author: Kholoud Khaled
 * Date of Creation: 15/08/2026
 * Version Information: V1.0.0
 * Dependencies: flutter/material.dart, app_localizations.dart, notifications_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Horizontal scrollable filter bar replicating the exact Appointments tab bar visual styling and active/inactive chip states for notifications.
 */

import 'package:flutter/material.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
import 'package:appoynt_mobile_app/features/notifications/presentation/cubit/notifications_state.dart';

/// Reusable horizontal filter bar for notifications matching the Appointments tab design.
class NotificationFilterChips extends StatelessWidget {
  final NotificationFilter selected_filter;
  final int unread_count;
  final ValueChanged<NotificationFilter> on_select_filter;

  const NotificationFilterChips({
    super.key,
    required this.selected_filter,
    required this.unread_count,
    required this.on_select_filter,
  });

  String _get_filter_label(NotificationFilter filter, AppLocalizations localizations) {
    switch (filter) {
      case NotificationFilter.all:
        return localizations.notifications_filter_all;
      case NotificationFilter.unread:
        return localizations.notifications_filter_unread;
      case NotificationFilter.appointments:
        return localizations.notifications_filter_appointments;
      case NotificationFilter.payments:
        return localizations.notifications_filter_payments;
      case NotificationFilter.prescriptions:
        return localizations.notifications_filter_prescriptions;
      default:
        return localizations.notifications_filter_all;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    const List<NotificationFilter> filters = [
      NotificationFilter.all,
      NotificationFilter.unread,
      NotificationFilter.appointments,
      NotificationFilter.payments,
      NotificationFilter.prescriptions,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: filters.map((filter) {
          final bool isSelected = filter == selected_filter;
          final String label = _get_filter_label(filter, localizations);
          final bool showBadge = (NotificationFilter.unread == filter && unread_count > 0);

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Material(
                color: AppColors.transparent,
                child: InkWell(
                  onTap: () => on_select_filter(filter),
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected
                                ? AppColors.white
                                : (isDark ? AppColors.slate400 : AppColors.slate500),
                          ),
                        ),
                        if (showBadge) ...[
                          const SizedBox(width: 6.0),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.white : AppColors.sky600,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              unread_count > 99 ? '99+' : '$unread_count',
                              style: TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? AppColors.sky600 : AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
