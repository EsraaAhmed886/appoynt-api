/*
 * File Name: notification_item_card.dart
 * Author: Kholoud Khaled
 * Date of Creation: 15/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_spacing.dart,
 *   app_colors.dart, app_localizations.dart, app_notification.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 15/08/2026]
 * File Description: Custom card widget representing an individual notification item
 *   with type-specific icon badge, read/unread visual styling, and navigation handling.
 */

// Import standard UI framework
import 'package:flutter/material.dart';
// Import layout design tokens
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
// Import central color palette tokens
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
// Import localization dictionary
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
// Import domain entity
import 'package:appoynt_mobile_app/features/notifications/domain/entities/app_notification.dart';

// Local dimension constants strictly eliminating raw numbers
class _LocalDimensions {
  static const double card_radius = 16.0;
  static const double icon_container_size = 44.0;
  static const double icon_radius = 12.0;
  static const double icon_size = 22.0;
  static const double unread_dot_size = 8.0;
  static const double border_width = 1.0;
  static const double chevron_size = 20.0;
  static const double space_between_text = 4.0;
  static const double space_before_time = 6.0;
}

// Stateful/Stateless notification item card widget
class NotificationItemCard extends StatelessWidget {
  // Notification entity model
  final AppNotification notification;
  // Callback when notification card is tapped
  final VoidCallback on_tap;
  // Callback when user taps to navigate to the associated business entity
  final Function(AppNotification)? on_navigate_entity;

  // Constant constructor mapping required parameters
  const NotificationItemCard({
    super.key,
    required this.notification,
    required this.on_tap,
    this.on_navigate_entity,
  });

  // Resolves icon configuration (IconData, background color, icon color) based on NotificationType
  _IconConfig _get_icon_config(bool is_dark) {
    switch (notification.type) {
      case NotificationType.appointment_confirmed:
        return _IconConfig(
          icon: Icons.event_available_rounded,
          icon_color: AppColors.success,
          bg_color: AppColors.success.withValues(alpha: is_dark ? 0.20 : 0.12),
        );
      case NotificationType.appointment_reminder:
        return _IconConfig(
          icon: Icons.notifications_active_outlined,
          icon_color: AppColors.primary_color,
          bg_color:
              AppColors.primary_color.withValues(alpha: is_dark ? 0.20 : 0.12),
        );
      case NotificationType.appointment_rescheduled:
        return _IconConfig(
          icon: Icons.update_rounded,
          icon_color: AppColors.orange,
          bg_color: AppColors.orange.withValues(alpha: is_dark ? 0.20 : 0.12),
        );
      case NotificationType.payment_success:
        return _IconConfig(
          icon: Icons.payment_rounded,
          icon_color: AppColors.teal,
          bg_color: AppColors.teal.withValues(alpha: is_dark ? 0.20 : 0.12),
        );
      case NotificationType.payment_failed:
        return _IconConfig(
          icon: Icons.credit_card_off_rounded,
          icon_color: AppColors.error,
          bg_color: AppColors.error.withValues(alpha: is_dark ? 0.20 : 0.12),
        );
      case NotificationType.prescription_available:
        return _IconConfig(
          icon: Icons.medication_outlined,
          icon_color: AppColors.purple,
          bg_color: AppColors.purple.withValues(alpha: is_dark ? 0.20 : 0.12),
        );
    }
  }

  // Formats the notification creation timestamp into a clean localized time string
  String _format_timestamp(DateTime date, AppLocalizations localizations) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime item_date = DateTime(date.year, date.month, date.day);
    final int difference_days = today.difference(item_date).inDays;

    final String hour =
        (date.hour > 12 ? date.hour - 12 : (0 == date.hour ? 12 : date.hour))
            .toString()
            .padLeft(2, '0');
    final String minute = date.minute.toString().padLeft(2, '0');
    final String period = date.hour >= 12 ? 'PM' : 'AM';
    final String time_string = '$hour:$minute $period';

    if (0 == difference_days) {
      return time_string;
    } else if (1 == difference_days) {
      return '${localizations.notifications_section_yesterday}, $time_string';
    } else {
      final String month_name = _get_month_name(date.month);
      return '${date.day} $month_name ${date.year}, $time_string';
    }
  }

  // Returns month abbreviation name
  String _get_month_name(int month) {
    const List<String> months = [
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
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    } else {
      return '';
    }
  }

  @override
  // Build method drawing card layout with dynamic styling based on read/unread state
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final _IconConfig icon_cfg = _get_icon_config(is_dark);
    final bool is_unread = false == notification.is_read;

    // Card background color: Subtle blue tint for unread, neutral/surface for read
    final Color card_bg = is_unread
        ? (is_dark
            ? AppColors.primary_color.withValues(alpha: 0.12)
            : AppColors.primary_color.withValues(alpha: 0.06))
        : (is_dark ? AppColors.surface_dark : AppColors.background_light);

    // Card border color
    final Color border_color = is_unread
        ? AppColors.primary_color.withValues(alpha: is_dark ? 0.30 : 0.20)
        : (is_dark ? AppColors.border_dark : AppColors.border_light);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.space_m),
      decoration: BoxDecoration(
        color: card_bg,
        borderRadius: BorderRadius.circular(_LocalDimensions.card_radius),
        border: Border.all(
          color: border_color,
          width: _LocalDimensions.border_width,
        ),
      ),
      child: Material(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(_LocalDimensions.card_radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(_LocalDimensions.card_radius),
          onTap: () {
            on_tap();
            if (null != on_navigate_entity) {
              on_navigate_entity!(notification);
            } else {
              // No entity navigation callback supplied
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space_l),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type-Based Icon Badge Container
                Container(
                  width: _LocalDimensions.icon_container_size,
                  height: _LocalDimensions.icon_container_size,
                  decoration: BoxDecoration(
                    color: icon_cfg.bg_color,
                    borderRadius: BorderRadius.circular(
                      _LocalDimensions.icon_radius,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      icon_cfg.icon,
                      color: icon_cfg.icon_color,
                      size: _LocalDimensions.icon_size,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.space_l),
                // Notification text content (Title, Description, Timestamp)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Text
                      Text(
                        notification.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppSpacing.font_size_body_medium,
                          fontWeight:
                              is_unread ? FontWeight.bold : FontWeight.w600,
                          color: is_dark
                              ? AppColors.text_dark_primary
                              : AppColors.text_light_primary,
                        ),
                      ),
                      const SizedBox(
                          height: _LocalDimensions.space_between_text),
                      // Description Text
                      Text(
                        notification.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppSpacing.font_size_body_small,
                          fontWeight: FontWeight.normal,
                          color: is_dark
                              ? AppColors.text_dark_secondary
                              : AppColors.text_light_secondary,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(
                          height: _LocalDimensions.space_before_time),
                      // Timestamp Text
                      Text(
                        _format_timestamp(
                            notification.created_at, localizations),
                        style: TextStyle(
                          fontSize: AppSpacing.font_size_caption,
                          color: is_dark
                              ? AppColors.text_dark_secondary
                              : AppColors.text_light_secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.space_m),
                // Trailing indicator: Blue unread dot or neutral chevron
                if (true == is_unread)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.space_xs),
                    child: Container(
                      width: _LocalDimensions.unread_dot_size,
                      height: _LocalDimensions.unread_dot_size,
                      decoration: const BoxDecoration(
                        color: AppColors.primary_color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.space_xs),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color:
                          is_dark ? AppColors.icon_dark : AppColors.icon_light,
                      size: _LocalDimensions.chevron_size,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper container class holding icon display configurations
class _IconConfig {
  final IconData icon;
  final Color icon_color;
  final Color bg_color;

  const _IconConfig({
    required this.icon,
    required this.icon_color,
    required this.bg_color,
  });
}
