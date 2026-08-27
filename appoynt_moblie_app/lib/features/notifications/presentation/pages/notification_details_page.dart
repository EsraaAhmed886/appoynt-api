/*
 * File Name: notification_details_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 15/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_spacing.dart,
 *   app_colors.dart, app_localizations.dart, app_notification.dart,
 *   prescriptions_page.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Dedicated Notification Details screen displaying rich structured
 *   metadata, type illustration badge, and context-specific action CTAs.
 */

// Import standard UI framework
import 'package:flutter/material.dart';
// Import layout design tokens
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
// Import central color palette tokens
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/utils/custom_snackbar.dart';
// Import localization dictionary
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
// Import domain entity
import 'package:appoynt_mobile_app/features/notifications/domain/entities/app_notification.dart';
// Import prescription details destination
import 'package:appoynt_mobile_app/features/profile/presentation/pages/prescriptions_page.dart';

// Local dimension constants strictly eliminating raw numbers
class _LocalDimensions {
  static const double back_button_size = 40.0;
  static const double back_button_radius = 12.0;
  static const double back_icon_size = 20.0;
  static const double illustration_outer_size = 110.0;
  static const double illustration_inner_size = 80.0;
  static const double illustration_icon_size = 40.0;
  static const double card_radius = 16.0;
  static const double card_border_width = 1.0;
  static const double row_spacing = 14.0;
  static const double btn_height = 50.0;
  static const double btn_radius = 14.0;
  static const double space_between_buttons = 12.0;
  static const double status_badge_radius = 6.0;
  static const double status_badge_padding_h = 8.0;
  static const double status_badge_padding_v = 4.0;
}

// Notification Details Screen StatefulWidget
class NotificationDetailsPage extends StatelessWidget {
  // Notification entity model
  final AppNotification notification;

  // Constant constructor mapping required notification entity
  const NotificationDetailsPage({
    super.key,
    required this.notification,
  });

  // Resolves type-specific icon and color theme
  _DetailTheme _get_theme(bool is_dark) {
    switch (notification.type) {
      case NotificationType.appointment_confirmed:
        return _DetailTheme(
          icon: Icons.event_available_rounded,
          color: AppColors.success,
          bg_color: AppColors.success.withValues(alpha: is_dark ? 0.20 : 0.12),
        );
      case NotificationType.appointment_reminder:
        return _DetailTheme(
          icon: Icons.notifications_active_outlined,
          color: AppColors.primary_color,
          bg_color:
              AppColors.primary_color.withValues(alpha: is_dark ? 0.20 : 0.12),
        );
      case NotificationType.appointment_rescheduled:
        return _DetailTheme(
          icon: Icons.update_rounded,
          color: AppColors.orange,
          bg_color: AppColors.orange.withValues(alpha: is_dark ? 0.20 : 0.12),
        );
      case NotificationType.payment_success:
        return _DetailTheme(
          icon: Icons.payment_rounded,
          color: AppColors.teal,
          bg_color: AppColors.teal.withValues(alpha: is_dark ? 0.20 : 0.12),
        );
      case NotificationType.payment_failed:
        return _DetailTheme(
          icon: Icons.credit_card_off_rounded,
          color: AppColors.error,
          bg_color: AppColors.error.withValues(alpha: is_dark ? 0.20 : 0.12),
        );
      case NotificationType.prescription_available:
        return _DetailTheme(
          icon: Icons.medication_outlined,
          color: AppColors.purple,
          bg_color: AppColors.purple.withValues(alpha: is_dark ? 0.20 : 0.12),
        );
      default:
        return _DetailTheme(
          icon: Icons.notifications_rounded,
          color: AppColors.primary_color,
          bg_color:
              AppColors.primary_color.withValues(alpha: is_dark ? 0.20 : 0.12),
        );
    }
  }

  // Formats the timestamp to clean localized representation
  String _format_timestamp(DateTime date, AppLocalizations localizations) {
    final String hour =
        (date.hour > 12 ? date.hour - 12 : (0 == date.hour ? 12 : date.hour))
            .toString()
            .padLeft(2, '0');
    final String minute = date.minute.toString().padLeft(2, '0');
    final String period = date.hour >= 12 ? 'PM' : 'AM';
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
    final String month_str =
        (date.month >= 1 && date.month <= 12) ? months[date.month - 1] : '';
    return '${date.day} $month_str ${date.year}, $hour:$minute $period';
  }

  @override
  // Build method drawing the complete Notification Details hierarchy
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final _DetailTheme theme = _get_theme(is_dark);

    return Scaffold(
      backgroundColor:
          is_dark ? AppColors.background_dark : AppColors.scaffold_light,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header with Centered Title ──────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space_xl,
                vertical: AppSpacing.space_m,
              ),
              child: SizedBox(
                height: _LocalDimensions.back_button_size,
                child: Stack(
                  children: [
                    // Centered Header Title
                    Center(
                      child: Text(
                        localizations.notification_details_title,
                        style: TextStyle(
                          fontSize: AppSpacing.font_size_dialog_title,
                          fontWeight: FontWeight.bold,
                          color: is_dark
                              ? AppColors.text_dark_primary
                              : AppColors.text_light_primary,
                        ),
                      ),
                    ),
                    // Back Button Aligned to Leading Side
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: _LocalDimensions.back_button_size,
                        height: _LocalDimensions.back_button_size,
                        decoration: BoxDecoration(
                          color: is_dark
                              ? AppColors.surface_dark
                              : AppColors.background_light,
                          borderRadius: BorderRadius.circular(
                            _LocalDimensions.back_button_radius,
                          ),
                          border: Border.all(
                            color: is_dark
                                ? AppColors.border_dark
                                : AppColors.border_light,
                            width: 1.0,
                          ),
                        ),
                        child: Material(
                          color: AppColors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                              _LocalDimensions.back_button_radius,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Center(
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: _LocalDimensions.back_icon_size,
                                color: is_dark
                                    ? AppColors.text_dark_primary
                                    : AppColors.text_light_primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Scrollable Body Content ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space_xl,
                  vertical: AppSpacing.space_m,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppSpacing.space_m),
                    // Illustration Badge: Centered elevated circle
                    Container(
                      width: _LocalDimensions.illustration_outer_size,
                      height: _LocalDimensions.illustration_outer_size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.bg_color,
                      ),
                      child: Center(
                        child: Container(
                          width: _LocalDimensions.illustration_inner_size,
                          height: _LocalDimensions.illustration_inner_size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.color.withValues(
                              alpha: is_dark ? 0.35 : 0.22,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              theme.icon,
                              size: _LocalDimensions.illustration_icon_size,
                              color: theme.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space_xl),

                    // Notification Title Text
                    Text(
                      notification.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppSpacing.font_size_dialog_title,
                        fontWeight: FontWeight.bold,
                        color: is_dark
                            ? AppColors.text_dark_primary
                            : AppColors.text_light_primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space_s),

                    // Formatted Timestamp Subtitle
                    Text(
                      _format_timestamp(notification.created_at, localizations),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppSpacing.font_size_body_small,
                        color: is_dark
                            ? AppColors.text_dark_secondary
                            : AppColors.text_light_secondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space_l),

                    // Description text box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.space_l),
                      decoration: BoxDecoration(
                        color: is_dark
                            ? AppColors.surface_dark
                            : AppColors.background_light,
                        borderRadius: BorderRadius.circular(
                          _LocalDimensions.card_radius,
                        ),
                        border: Border.all(
                          color: is_dark
                              ? AppColors.border_dark
                              : AppColors.border_light,
                          width: _LocalDimensions.card_border_width,
                        ),
                      ),
                      child: Text(
                        notification.description,
                        style: TextStyle(
                          fontSize: AppSpacing.font_size_body_medium,
                          color: is_dark
                              ? AppColors.text_dark_primary
                              : AppColors.text_light_primary,
                          height: 1.45,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space_l),

                    // Detail Structured Key-Value Info Card
                    _build_structured_info_card(
                        context, is_dark, localizations),
                    const SizedBox(height: AppSpacing.space_xxl),

                    // ── Primary Action CTA Button ─────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: _LocalDimensions.btn_height,
                      child: ElevatedButton(
                        onPressed: () {
                          _handle_primary_cta(context, localizations);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary_color,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              _LocalDimensions.btn_radius,
                            ),
                          ),
                          elevation: 0.0,
                        ),
                        child: Text(
                          _get_primary_cta_label(localizations),
                          style: const TextStyle(
                            fontSize: AppSpacing.font_size_body_medium,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // ── Secondary Action CTA (Add to Calendar for Appointments)
                    if (_is_appointment_event(notification.type)) ...[
                      const SizedBox(
                          height: _LocalDimensions.space_between_buttons),
                      TextButton(
                        onPressed: () {
                          CustomSnackBar.success(
                            context,
                            localizations
                                .notification_details_calendar_added,
                            duration: const Duration(seconds: 2),
                          );
                        },
                        child: Text(
                          localizations.notification_details_add_to_calendar,
                          style: const TextStyle(
                            fontSize: AppSpacing.font_size_body_medium,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary_color,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.space_xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Checks if notification type is appointment related
  bool _is_appointment_event(NotificationType type) {
    return NotificationType.appointment_confirmed == type ||
        NotificationType.appointment_reminder == type ||
        NotificationType.appointment_rescheduled == type;
  }

  // Returns primary CTA text label
  String _get_primary_cta_label(AppLocalizations localizations) {
    if ('prescription' == notification.entity_type) {
      return localizations.notification_details_view_prescription;
    } else {
      return localizations.notification_details_view_appointment;
    }
  }

  // Handles primary action CTA press
  void _handle_primary_cta(
      BuildContext context, AppLocalizations localizations) {
    if (false == notification.is_entity_available ||
        null == notification.entity_id) {
      CustomSnackBar.error(
        context,
        localizations.notifications_unavailable_entity,
        duration: const Duration(seconds: 2),
      );
      return;
    } else {
      if ('prescription' == notification.entity_type) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const PrescriptionsPage(),
          ),
        );
      } else {
        CustomSnackBar.info(
          context,
          '${notification.title}: ${notification.description}',
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  // Builds structured key-value card with metadata rows
  Widget _build_structured_info_card(
    BuildContext context,
    bool is_dark,
    AppLocalizations localizations,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.space_l),
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : AppColors.background_light,
        borderRadius: BorderRadius.circular(_LocalDimensions.card_radius),
        border: Border.all(
          color: is_dark ? AppColors.border_dark : AppColors.border_light,
          width: _LocalDimensions.card_border_width,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.notification_details_section_info,
            style: TextStyle(
              fontSize: AppSpacing.font_size_body_medium,
              fontWeight: FontWeight.bold,
              color: is_dark
                  ? AppColors.text_dark_primary
                  : AppColors.text_light_primary,
            ),
          ),
          const SizedBox(height: AppSpacing.space_m),
          const Divider(height: 1.0),
          const SizedBox(height: AppSpacing.space_m),

          // Render rows based on notification category
          if (_is_appointment_event(notification.type)) ...[
            _build_info_row(localizations.notification_details_doctor,
                'Dr. Sara Hassan', is_dark),
            _build_info_row(localizations.notification_details_specialty,
                'Cardiology', is_dark),
            _build_info_row(localizations.notification_details_location,
                'New Cairo Medical Center', is_dark),
            _build_info_row(localizations.notification_details_date,
                'Today, 15 Aug 2026', is_dark),
            _build_info_row(
                localizations.notification_details_time, '04:30 PM', is_dark),
          ] else if (NotificationType.payment_success == notification.type ||
              NotificationType.payment_failed == notification.type) ...[
            _build_info_row(localizations.notification_details_amount,
                'EGP 450.00', is_dark),
            _build_info_row(localizations.notification_details_transaction_id,
                '#TXN-884210', is_dark),
            _build_status_row(
              localizations.notification_details_status,
              NotificationType.payment_success == notification.type
                  ? localizations.notification_details_status_completed
                  : localizations.notification_details_status_failed,
              NotificationType.payment_success == notification.type
                  ? AppColors.success
                  : AppColors.error,
              is_dark,
            ),
          ] else ...[
            _build_info_row(localizations.notification_details_doctor,
                'Dr. Youssef Nabil', is_dark),
            _build_info_row('Medication', 'Amoxicillin 500mg', is_dark),
            _build_info_row(localizations.notification_details_date,
                '15 Aug 2026', is_dark),
            _build_status_row(
              localizations.notification_details_status,
              localizations.notification_details_status_completed,
              AppColors.success,
              is_dark,
            ),
          ],
        ],
      ),
    );
  }

  // Helper drawing standard key-value row
  Widget _build_info_row(String label, String value, bool is_dark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: _LocalDimensions.row_spacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppSpacing.font_size_body_small,
              color: is_dark
                  ? AppColors.text_dark_secondary
                  : AppColors.text_light_secondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: AppSpacing.font_size_body_small,
              fontWeight: FontWeight.w600,
              color: is_dark
                  ? AppColors.text_dark_primary
                  : AppColors.text_light_primary,
            ),
          ),
        ],
      ),
    );
  }

  // Helper drawing status badge row
  Widget _build_status_row(
      String label, String status, Color color, bool is_dark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: _LocalDimensions.row_spacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppSpacing.font_size_body_small,
              color: is_dark
                  ? AppColors.text_dark_secondary
                  : AppColors.text_light_secondary,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: _LocalDimensions.status_badge_padding_h,
              vertical: _LocalDimensions.status_badge_padding_v,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: is_dark ? 0.22 : 0.12),
              borderRadius: BorderRadius.circular(
                _LocalDimensions.status_badge_radius,
              ),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: AppSpacing.font_size_caption,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper container for detail theme colors
class _DetailTheme {
  final IconData icon;
  final Color color;
  final Color bg_color;

  const _DetailTheme({
    required this.icon,
    required this.color,
    required this.bg_color,
  });
}
