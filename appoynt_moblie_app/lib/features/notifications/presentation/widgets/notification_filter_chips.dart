/*
 * File Name: notification_filter_chips.dart
 * Author: Kholoud Khaled
 * Date of Creation: 15/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_spacing.dart,
 *   app_colors.dart, app_localizations.dart, notifications_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Horizontal scrollable filter bar rendering category chips
 *   with active state styling and unread count badges.
 */

// Import standard UI framework
import 'package:flutter/material.dart';
// Import layout design tokens
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
// Import central color palette tokens
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
// Import localization dictionary
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
// Import state and filter enum
import 'package:appoynt_mobile_app/features/notifications/presentation/cubit/notifications_state.dart';

// Local dimension constants strictly eliminating raw numbers
class _LocalDimensions {
  static const double chip_height = 36.0;
  static const double chip_radius = 18.0;
  static const double chip_padding_h = 14.0;
  static const double chip_padding_v = 6.0;
  static const double badge_size = 18.0;
  static const double badge_font_size = 10.0;
  static const double border_width = 1.0;
  static const double space_between_chips = 8.0;
}

// Reusable horizontal filter chips bar for notifications
class NotificationFilterChips extends StatelessWidget {
  // Currently active selected filter
  final NotificationFilter selected_filter;
  // Total unread notifications count for badge display
  final int unread_count;
  // Callback when a filter chip is tapped
  final ValueChanged<NotificationFilter> on_select_filter;

  // Constant constructor mapping properties
  const NotificationFilterChips({
    super.key,
    required this.selected_filter,
    required this.unread_count,
    required this.on_select_filter,
  });

  // Returns localized label for each filter enum
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
  // Build method drawing horizontal scrolling chips row
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    const List<NotificationFilter> filters = [
      NotificationFilter.all,
      NotificationFilter.unread,
      NotificationFilter.appointments,
      NotificationFilter.payments,
      NotificationFilter.prescriptions,
    ];

    return SizedBox(
      height: _LocalDimensions.chip_height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space_xl,
        ),
        itemCount: filters.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: _LocalDimensions.space_between_chips);
        },
        itemBuilder: (context, index) {
          final NotificationFilter filter = filters[index];
          final bool is_active = filter == selected_filter;
          final String label = _get_filter_label(filter, localizations);
          final bool show_unread_badge = (NotificationFilter.unread == filter && unread_count > 0);

          return Material(
            color: AppColors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(_LocalDimensions.chip_radius),
              onTap: () {
                on_select_filter(filter);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: _LocalDimensions.chip_padding_h,
                  vertical: _LocalDimensions.chip_padding_v,
                ),
                decoration: BoxDecoration(
                  color: is_active
                      ? AppColors.primary_color
                      : (is_dark
                          ? AppColors.surface_dark
                          : AppColors.background_light),
                  borderRadius: BorderRadius.circular(_LocalDimensions.chip_radius),
                  border: Border.all(
                    color: is_active
                        ? AppColors.primary_color
                        : (is_dark
                            ? AppColors.border_dark
                            : AppColors.border_light),
                    width: _LocalDimensions.border_width,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: AppSpacing.font_size_body_small,
                        fontWeight: is_active ? FontWeight.bold : FontWeight.w500,
                        color: is_active
                            ? AppColors.white
                            : (is_dark
                                ? AppColors.text_dark_secondary
                                : AppColors.text_light_secondary),
                      ),
                    ),
                    if (true == show_unread_badge) ...[
                      const SizedBox(width: AppSpacing.space_s),
                      Container(
                        width: _LocalDimensions.badge_size,
                        height: _LocalDimensions.badge_size,
                        decoration: BoxDecoration(
                          color: is_active ? AppColors.white : AppColors.primary_color,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$unread_count',
                            style: TextStyle(
                              fontSize: _LocalDimensions.badge_font_size,
                              fontWeight: FontWeight.bold,
                              color: is_active ? AppColors.primary_color : AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
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
