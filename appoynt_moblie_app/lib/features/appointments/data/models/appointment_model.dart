/*
 * File Name: appointment_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: none
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Defines the core data models, status enums, consultation types, and refund eligibility rules for patient appointments.
 */

/// Represents the active tab category for appointments scoping.
enum AppointmentTabType {
  upcoming,
  completed,
  cancelled,
  all,
}

/// Represents the lifecycle status of an individual appointment.
enum AppointmentStatus {
  upcoming,
  confirmed,
  completed,
  cancelled,
  missed,
}

/// Represents the medium or format of the consultation.
enum AppointmentType {
  inClinic,
  onlineVideo,
}

/// Represents the calculated refund tier upon appointment cancellation.
enum RefundEligibility {
  full,
  partial,
  none,
}

/// Data model representing a complete patient appointment encounter.
class AppointmentModel {
  final String id;
  final String doctorId;
  final String doctorName;
  final String? doctorSpecialty;
  final String? doctorImageUrl;
  final double? doctorRating;
  final int? doctorReviewsCount;
  final bool isDoctorVerified;
  final String clinicId;
  final String clinicName;
  final String? clinicAddress;
  final DateTime scheduledDateTime;
  final DateTime endDateTime;
  final AppointmentStatus status;
  final AppointmentType type;
  final String? consultationFee;
  final String? onlineCallUrl;
  final String? cancellationReason;
  final DateTime? cancelledAt;

  const AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    this.doctorSpecialty,
    this.doctorImageUrl,
    this.doctorRating,
    this.doctorReviewsCount,
    this.isDoctorVerified = false,
    required this.clinicId,
    required this.clinicName,
    this.clinicAddress,
    required this.scheduledDateTime,
    required this.endDateTime,
    required this.status,
    required this.type,
    this.consultationFee,
    this.onlineCallUrl,
    this.cancellationReason,
    this.cancelledAt,
  });

  /// Calculates refund eligibility based on elapsed time before consultation start.
  RefundEligibility get refundEligibility {
    final now = DateTime.now();
    final difference = scheduledDateTime.difference(now);

    if (difference.isNegative || difference.inMinutes < 15) {
      return RefundEligibility.none;
    } else if (difference.inHours >= 24) {
      return RefundEligibility.full;
    } else {
      return RefundEligibility.partial;
    }
  }

  /// Checks if cancellation is permitted (> 15 minutes before scheduled start).
  bool get canCancel {
    final now = DateTime.now();
    final difference = scheduledDateTime.difference(now);
    return !difference.isNegative && difference.inMinutes >= 15;
  }

  /// Checks if the patient can join the online video call.
  /// Allowed strictly within 10 minutes prior to scheduled start until consultation end time.
  bool canJoinCall([DateTime? referenceTime]) {
    if (type != AppointmentType.onlineVideo || status == AppointmentStatus.cancelled) {
      return false;
    } else {
      final now = referenceTime ?? DateTime.now();
      final joinWindowStart = scheduledDateTime.subtract(const Duration(minutes: 10));
      return (now.isAfter(joinWindowStart) || now.isAtSameMomentAs(joinWindowStart)) &&
          now.isBefore(endDateTime);
    }
  }

  /// Creates a modified clone of this appointment.
  AppointmentModel copyWith({
    String? id,
    String? doctorId,
    String? doctorName,
    String? doctorSpecialty,
    String? doctorImageUrl,
    double? doctorRating,
    int? doctorReviewsCount,
    bool? isDoctorVerified,
    String? clinicId,
    String? clinicName,
    String? clinicAddress,
    DateTime? scheduledDateTime,
    DateTime? endDateTime,
    AppointmentStatus? status,
    AppointmentType? type,
    String? consultationFee,
    String? onlineCallUrl,
    String? cancellationReason,
    DateTime? cancelledAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialty: doctorSpecialty ?? this.doctorSpecialty,
      doctorImageUrl: doctorImageUrl ?? this.doctorImageUrl,
      doctorRating: doctorRating ?? this.doctorRating,
      doctorReviewsCount: doctorReviewsCount ?? this.doctorReviewsCount,
      isDoctorVerified: isDoctorVerified ?? this.isDoctorVerified,
      clinicId: clinicId ?? this.clinicId,
      clinicName: clinicName ?? this.clinicName,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      status: status ?? this.status,
      type: type ?? this.type,
      consultationFee: consultationFee ?? this.consultationFee,
      onlineCallUrl: onlineCallUrl ?? this.onlineCallUrl,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      cancelledAt: cancelledAt ?? this.cancelledAt,
    );
  }
}
