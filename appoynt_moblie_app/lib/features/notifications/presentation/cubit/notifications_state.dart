/*
 * File Name: notifications_state.dart
 * Author: Kholoud Khaled
 * Date of Creation: 15/08/2026
 * Version Information: V2.0.0
 * Dependencies: app_notification.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Defines the immutable state class, filter enum, and status enum for notifications.
 */

// Import domain entity
import 'package:appoynt_mobile_app/features/notifications/domain/entities/app_notification.dart';

// Enumeration of lifecycle loading states for the notifications screen
enum NotificationsStatus {
  // Initial state before any network request is triggered
  initial,
  // Initial loading state displaying shimmer skeleton placeholders
  loading,
  // Success state when notifications are loaded and ready to render
  success,
  // Failure state indicating a network or server communication error
  failure,
}

// Enumeration of supported notification category filter chips
enum NotificationFilter {
  // All notifications category
  all,
  // Only unread notifications
  unread,
  // Appointment confirmed, reminder, and reschedule events
  appointments,
  // Payment success and payment failed transactions
  payments,
  // Medical prescription events
  prescriptions,
}

// Immutable state model for the Notifications feature
class NotificationsState {
  // Current screen lifecycle status
  final NotificationsStatus status;
  // List of all fetched notification items
  final List<AppNotification> notifications;
  // Currently active filter chip selection
  final NotificationFilter selected_filter;
  // Total unread notifications count
  final int unread_count;
  // Current pagination page index
  final int current_page;
  // Flag indicating if more paginated records exist on server
  final bool has_more_data;
  // Flag indicating if a background pagination request is active
  final bool is_loading_more;
  // Flag verifying user authentication status
  final bool is_authenticated;
  // Optional user-facing error message
  final String? error_message;

  // Constant constructor initializing immutable state fields
  const NotificationsState({
    required this.status,
    required this.notifications,
    required this.selected_filter,
    required this.unread_count,
    required this.current_page,
    required this.has_more_data,
    required this.is_loading_more,
    required this.is_authenticated,
    this.error_message,
  });

  // Factory constructor creating the initial default state
  factory NotificationsState.initial() {
    return const NotificationsState(
      status: NotificationsStatus.initial,
      notifications: <AppNotification>[],
      selected_filter: NotificationFilter.all,
      unread_count: 0,
      current_page: 1,
      has_more_data: true,
      is_loading_more: false,
      is_authenticated: true,
      error_message: null,
    );
  }

  // Returns reactive list of notifications matching currently selected filter
  List<AppNotification> get filtered_notifications {
    switch (selected_filter) {
      case NotificationFilter.all:
        return notifications;
      case NotificationFilter.unread:
        return notifications.where((item) {
          return false == item.is_read;
        }).toList();
      case NotificationFilter.appointments:
        return notifications.where((item) {
          return NotificationType.appointment_confirmed == item.type ||
              NotificationType.appointment_reminder == item.type ||
              NotificationType.appointment_rescheduled == item.type;
        }).toList();
      case NotificationFilter.payments:
        return notifications.where((item) {
          return NotificationType.payment_success == item.type ||
              NotificationType.payment_failed == item.type;
        }).toList();
      case NotificationFilter.prescriptions:
        return notifications.where((item) {
          return NotificationType.prescription_available == item.type;
        }).toList();
      default:
        return notifications;
    }
  }

  // Creates a modified copy of the state with specified updated parameters
  NotificationsState copyWith({
    NotificationsStatus? status,
    List<AppNotification>? notifications,
    NotificationFilter? selected_filter,
    int? unread_count,
    int? current_page,
    bool? has_more_data,
    bool? is_loading_more,
    bool? is_authenticated,
    String? error_message,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      selected_filter: selected_filter ?? this.selected_filter,
      unread_count: unread_count ?? this.unread_count,
      current_page: current_page ?? this.current_page,
      has_more_data: has_more_data ?? this.has_more_data,
      is_loading_more: is_loading_more ?? this.is_loading_more,
      is_authenticated: is_authenticated ?? this.is_authenticated,
      error_message: error_message ?? this.error_message,
    );
  }
}
