/*
 * File Name: notifications_repository_impl.dart
 * Author: Kholoud Khaled
 * Date of Creation: 15/08/2026
 * Version Information: V1.0.0
 * Dependencies: app_notification.dart, notifications_repository.dart,
 *   notifications_remote_data_source.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Concrete implementation of NotificationsRepository interface.
 */

// Import domain entity
import 'package:appoynt_mobile_app/features/notifications/domain/entities/app_notification.dart';
// Import domain repository contract
import 'package:appoynt_mobile_app/features/notifications/domain/repositories/notifications_repository.dart';
// Import remote data source
import 'package:appoynt_mobile_app/features/notifications/data/datasources/notifications_remote_data_source.dart';

// Concrete repository implementation managing notifications data operations
class NotificationsRepositoryImpl implements NotificationsRepository {
  // Remote data source dependency injected via constructor
  final NotificationsRemoteDataSource remote_data_source;

  // Constructor mapping remote data source dependency
  const NotificationsRepositoryImpl({
    required this.remote_data_source,
  });

  @override
  // Fetches paginated batch of notifications from remote data source
  Future<List<AppNotification>> get_notifications({
    required int page,
    required int page_size,
  }) async {
    try {
      // Forward call to remote data source
      return await remote_data_source.get_notifications(
        page: page,
        page_size: page_size,
      );
    } catch (e) {
      // Re-throw handled error to caller
      throw Exception('Failed to load notifications: $e');
    }
  }

  @override
  // Marks a single notification as read
  Future<void> mark_as_read(String notification_id) async {
    try {
      // Forward call to remote data source
      await remote_data_source.mark_as_read(notification_id);
    } catch (e) {
      // Re-throw handled error to caller
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  @override
  // Marks all user notifications as read
  Future<void> mark_all_as_read() async {
    try {
      // Forward call to remote data source
      await remote_data_source.mark_all_as_read();
    } catch (e) {
      // Re-throw handled error to caller
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  @override
  // Retrieves current total unread notifications count
  Future<int> get_unread_count() async {
    try {
      // Forward call to remote data source
      return await remote_data_source.get_unread_count();
    } catch (e) {
      // Return 0 on error
      return 0;
    }
  }
}
