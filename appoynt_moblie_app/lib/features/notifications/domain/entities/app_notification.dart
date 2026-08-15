/*
 * File Name: app_notification.dart
 * Author: Kholoud Khaled
 * Date of Creation: 15/08/2026
 * Version Information: V1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 15/08/2026]
 * File Description: Defines the domain entity and type enum for patient notifications.
 */

// Enumeration of supported notification categories across the application
enum NotificationType {
  // Appointment confirmed event
  appointment_confirmed,
  // Appointment reminder alert
  appointment_reminder,
  // Appointment rescheduled update
  appointment_rescheduled,
  // Payment transaction success
  payment_success,
  // Payment transaction failed
  payment_failed,
  // New medical prescription available
  prescription_available,
}

// Domain entity representing an individual notification record
class AppNotification {
  // Unique notification identifier string
  final String id;
  // Notification title text (max 100 characters)
  final String title;
  // Notification description content (max 250 characters)
  final String description;
  // Category classification type of the notification
  final NotificationType type;
  // Timestamp when the notification was created
  final DateTime created_at;
  // Flag indicating whether the notification has been read
  final bool is_read;
  // Optional related business entity identifier (e.g. appointment or prescription id)
  final String? entity_id;
  // Optional target entity model type string (e.g. 'appointment', 'prescription')
  final String? entity_type;
  // Flag verifying if the related entity is actively available for navigation
  final bool is_entity_available;

  // Constant constructor initializing immutable notification attributes
  const AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.created_at,
    required this.is_read,
    this.entity_id,
    this.entity_type,
    this.is_entity_available = true,
  });

  // Creates a copy of the notification with optional updated fields
  AppNotification copyWith({
    String? id,
    String? title,
    String? description,
    NotificationType? type,
    DateTime? created_at,
    bool? is_read,
    String? entity_id,
    String? entity_type,
    bool? is_entity_available,
  }) {
    // Return modified clone instance
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      created_at: created_at ?? this.created_at,
      is_read: is_read ?? this.is_read,
      entity_id: entity_id ?? this.entity_id,
      entity_type: entity_type ?? this.entity_type,
      is_entity_available: is_entity_available ?? this.is_entity_available,
    );
  }
}
