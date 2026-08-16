/*
 * File Name: notifications_repository.dart
 * Author: Kholoud Khaled
 * Date of Creation: 15/08/2026
 * Version Information: V1.0.0
 * Dependencies: app_notification.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Defines the abstract domain repository contract for notifications.
 */

// Import domain entity
import 'package:appoynt_mobile_app/features/notifications/domain/entities/app_notification.dart';

// Abstract interface defining notification data access operations
abstract class NotificationsRepository {
  // Fetches a paginated batch of notifications
  Future<List<AppNotification>> get_notifications({
    required int page,
    required int page_size,
  });

  // Marks a single notification as read by its unique identifier
  Future<void> mark_as_read(String notification_id);

  // Marks all notifications in the user account as read
  Future<void> mark_all_as_read();

  // Retrieves the current total unread notifications count
  Future<int> get_unread_count();
}
