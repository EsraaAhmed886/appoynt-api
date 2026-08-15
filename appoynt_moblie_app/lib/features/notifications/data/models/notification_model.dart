/*
 * File Name: notification_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 15/08/2026
 * Version Information: V1.0.0
 * Dependencies: app_notification.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 15/08/2026]
 * File Description: Data transfer model for notifications with JSON serialization.
 */

// Import domain entity and type enum
import 'package:appoynt_mobile_app/features/notifications/domain/entities/app_notification.dart';

// Data model representing notification DTO with serialization capabilities
class NotificationModel extends AppNotification {
  // Constant constructor forwarding fields to domain entity superclass
  const NotificationModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    required super.created_at,
    required super.is_read,
    super.entity_id,
    super.entity_type,
    super.is_entity_available = true,
  });

  // Factory constructor parsing raw JSON map into NotificationModel instance
  factory NotificationModel.from_json(Map<String, dynamic> json) {
    // Parse raw notification type string to NotificationType enum
    final String raw_type = json['type'] as String? ?? 'appointment_reminder';
    NotificationType parsed_type = NotificationType.appointment_reminder;
    // Map raw type value to appropriate enum value
    if ('appointment_confirmed' == raw_type) {
      parsed_type = NotificationType.appointment_confirmed;
    } else if ('appointment_reminder' == raw_type) {
      parsed_type = NotificationType.appointment_reminder;
    } else if ('appointment_rescheduled' == raw_type) {
      parsed_type = NotificationType.appointment_rescheduled;
    } else if ('payment_success' == raw_type) {
      parsed_type = NotificationType.payment_success;
    } else if ('payment_failed' == raw_type) {
      parsed_type = NotificationType.payment_failed;
    } else if ('prescription_available' == raw_type) {
      parsed_type = NotificationType.prescription_available;
    } else {
      parsed_type = NotificationType.appointment_reminder;
    }

    // Parse created timestamp safely
    final String? raw_created = json['created_at'] as String?;
    final DateTime created_date = null != raw_created
        ? DateTime.tryParse(raw_created) ?? DateTime.now()
        : DateTime.now();

    // Construct model instance from parsed values
    return NotificationModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: parsed_type,
      created_at: created_date,
      is_read: true == (json['is_read'] as bool? ?? false),
      entity_id: json['entity_id'] as String?,
      entity_type: json['entity_type'] as String?,
      is_entity_available: true == (json['is_entity_available'] as bool? ?? true),
    );
  }

  // Converts model instance into a serializable JSON map
  Map<String, dynamic> to_json() {
    // Return structured map representation
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'created_at': created_at.toIso8601String(),
      'is_read': is_read,
      'entity_id': entity_id,
      'entity_type': entity_type,
      'is_entity_available': is_entity_available,
    };
  }
}
