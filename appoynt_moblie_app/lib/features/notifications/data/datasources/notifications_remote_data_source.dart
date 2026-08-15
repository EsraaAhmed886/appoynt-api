/*
 * File Name: notifications_remote_data_source.dart
 * Author: Kholoud Khaled
 * Date of Creation: 15/08/2026
 * Version Information: V1.0.0
 * Dependencies: app_notification.dart, notification_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 15/08/2026]
 * File Description: Remote data source contract and mock database implementation
 *   serving paginated notifications, read state updates, and unread counts.
 */

// Import domain entity
import 'package:appoynt_mobile_app/features/notifications/domain/entities/app_notification.dart';
// Import data model
import 'package:appoynt_mobile_app/features/notifications/data/models/notification_model.dart';

// Abstract contract for remote notifications operations
abstract class NotificationsRemoteDataSource {
  // Fetch paginated notifications list from server
  Future<List<AppNotification>> get_notifications({
    required int page,
    required int page_size,
  });

  // Mark single notification as read on remote server
  Future<void> mark_as_read(String notification_id);

  // Mark all notifications as read on remote server
  Future<void> mark_all_as_read();

  // Get current total unread notifications count from server
  Future<int> get_unread_count();
}

// Concrete mock implementation of NotificationsRemoteDataSource
class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  // In-memory mock database of notifications initialized with realistic test data
  static final List<NotificationModel> _mock_db = [
    // ── TODAY'S NOTIFICATIONS ─────────────────────────────────
    NotificationModel(
      id: 'notif_001',
      title: 'Appointment Confirmed',
      description: 'Your consultation with Dr. Sarah Jenkins is confirmed for today at 4:30 PM.',
      type: NotificationType.appointment_confirmed,
      created_at: DateTime.now().subtract(const Duration(hours: 2)),
      is_read: false,
      entity_id: 'doc_101',
      entity_type: 'appointment',
      is_entity_available: true,
    ),
    NotificationModel(
      id: 'notif_002',
      title: 'New Prescription Available',
      description: 'Dr. Youssef Nabil has issued a digital prescription for your recent visit.',
      type: NotificationType.prescription_available,
      created_at: DateTime.now().subtract(const Duration(hours: 4, minutes: 15)),
      is_read: false,
      entity_id: 'rx_201',
      entity_type: 'prescription',
      is_entity_available: true,
    ),
    NotificationModel(
      id: 'notif_003',
      title: 'Payment Successful',
      description: 'Payment of EGP 450.00 for Consultation #AP-8842 was completed successfully.',
      type: NotificationType.payment_success,
      created_at: DateTime.now().subtract(const Duration(hours: 6)),
      is_read: false,
      entity_id: 'pay_301',
      entity_type: 'payment',
      is_entity_available: true,
    ),

    // ── YESTERDAY'S NOTIFICATIONS ─────────────────────────────
    NotificationModel(
      id: 'notif_004',
      title: 'Upcoming Appointment Reminder',
      description: 'Reminder: You have an appointment tomorrow with Dr. Mona El-Sayed at 11:00 AM.',
      type: NotificationType.appointment_reminder,
      created_at: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      is_read: false,
      entity_id: 'doc_102',
      entity_type: 'appointment',
      is_entity_available: true,
    ),
    NotificationModel(
      id: 'notif_005',
      title: 'Appointment Rescheduled',
      description: 'Your appointment with Dr. Tarek Mansour has been moved to Thursday at 2:00 PM.',
      type: NotificationType.appointment_rescheduled,
      created_at: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
      is_read: true,
      entity_id: 'doc_103',
      entity_type: 'appointment',
      is_entity_available: true,
    ),

    // ── EARLIER NOTIFICATIONS ─────────────────────────────────
    NotificationModel(
      id: 'notif_006',
      title: 'Payment Failed',
      description: 'Transaction #PAY-9921 for EGP 600.00 was declined. Please check your card.',
      type: NotificationType.payment_failed,
      created_at: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
      is_read: true,
      entity_id: 'pay_302',
      entity_type: 'payment',
      is_entity_available: true,
    ),
    NotificationModel(
      id: 'notif_007',
      title: 'Prescription Refill Expired',
      description: 'Prescription #RX-102 has expired. Please contact your doctor for a refill.',
      type: NotificationType.prescription_available,
      created_at: DateTime.now().subtract(const Duration(days: 5, hours: 6)),
      is_read: true,
      entity_id: 'rx_202',
      entity_type: 'prescription',
      is_entity_available: false,
    ),
    NotificationModel(
      id: 'notif_008',
      title: 'Appointment Completed',
      description: 'Thank you for visiting Dr. Hany Farid. Check your test results in profile.',
      type: NotificationType.appointment_confirmed,
      created_at: DateTime.now().subtract(const Duration(days: 7, hours: 1)),
      is_read: true,
      entity_id: 'doc_104',
      entity_type: 'appointment',
      is_entity_available: true,
    ),
    NotificationModel(
      id: 'notif_009',
      title: 'Lab Results Ready',
      description: 'Your blood test results from Cairo Scan Lab are now ready for viewing.',
      type: NotificationType.prescription_available,
      created_at: DateTime.now().subtract(const Duration(days: 10, hours: 4)),
      is_read: true,
      entity_id: 'lab_401',
      entity_type: 'test_result',
      is_entity_available: true,
    ),
    NotificationModel(
      id: 'notif_010',
      title: 'Welcome to Appoynt',
      description: 'Explore verified doctors, instant clinic booking, and medical records.',
      type: NotificationType.appointment_reminder,
      created_at: DateTime.now().subtract(const Duration(days: 14)),
      is_read: true,
      entity_id: null,
      entity_type: null,
      is_entity_available: true,
    ),
  ];

  @override
  // Retrieves paginated list of notifications with simulated network delay
  Future<List<AppNotification>> get_notifications({
    required int page,
    required int page_size,
  }) async {
    // Simulate network latency of 300 milliseconds
    await Future.delayed(const Duration(milliseconds: 300));
    // Calculate 0-based starting index for pagination
    final int start_index = (page - 1) * page_size;
    // Return empty list if start index exceeds total mock count
    if (start_index >= _mock_db.length) {
      return <AppNotification>[];
    } else {
      // Calculate bounding end index
      final int end_index = (start_index + page_size > _mock_db.length)
          ? _mock_db.length
          : start_index + page_size;
      // Slice and return sublist of items
      return _mock_db.sublist(start_index, end_index);
    }
  }

  @override
  // Updates local mock state for a single notification to marked as read
  Future<void> mark_as_read(String notification_id) async {
    // Simulate network latency of 100 milliseconds
    await Future.delayed(const Duration(milliseconds: 100));
    // Find target item index in mock database
    final int index = _mock_db.indexWhere((item) => item.id == notification_id);
    if (-1 != index) {
      final NotificationModel current = _mock_db[index];
      // Update item with read status set to true
      _mock_db[index] = NotificationModel(
        id: current.id,
        title: current.title,
        description: current.description,
        type: current.type,
        created_at: current.created_at,
        is_read: true,
        entity_id: current.entity_id,
        entity_type: current.entity_type,
        is_entity_available: current.is_entity_available,
      );
    } else {
      // Target item not found in mock store
    }
  }

  @override
  // Updates all mock notifications in memory to read status
  Future<void> mark_all_as_read() async {
    // Simulate network latency of 150 milliseconds
    await Future.delayed(const Duration(milliseconds: 150));
    // Iterate through all records and set is_read to true
    for (int i = 0; i < _mock_db.length; i++) {
      final NotificationModel current = _mock_db[i];
      _mock_db[i] = NotificationModel(
        id: current.id,
        title: current.title,
        description: current.description,
        type: current.type,
        created_at: current.created_at,
        is_read: true,
        entity_id: current.entity_id,
        entity_type: current.entity_type,
        is_entity_available: current.is_entity_available,
      );
    }
  }

  @override
  // Calculates total unread items in mock database
  Future<int> get_unread_count() async {
    // Count items where is_read is false
    final int count = _mock_db.where((item) => false == item.is_read).length;
    return count;
  }
}
