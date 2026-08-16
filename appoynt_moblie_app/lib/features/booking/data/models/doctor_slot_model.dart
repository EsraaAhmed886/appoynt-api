/*
 * File Name: doctor_slot_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: doctor_slot_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Data model extending DoctorSlotEntity with enum parsers
 *   and JSON serialization/deserialization for doctor time slot endpoints.
 */

import 'package:appoynt_mobile_app/features/booking/domain/entities/doctor_slot_entity.dart';

/// Data transfer model for doctor appointment slots.
class DoctorSlotModel extends DoctorSlotEntity {
  const DoctorSlotModel({
    required super.slot_id,
    required super.start_time,
    required super.end_time,
    required super.time_of_day,
    required super.status,
  });

  /// Factory deserializer converting JSON Map into DoctorSlotModel.
  factory DoctorSlotModel.fromJson(Map<String, dynamic> json) {
    final String raw_status =
        (json['status'] ?? json['slotStatus'] ?? 'available')
            .toString()
            .toLowerCase();
    SlotStatus status;
    switch (raw_status) {
      case 'booked':
        status = SlotStatus.booked;
        break;
      case 'held':
      case 'reserved':
        status = SlotStatus.held;
        break;
      case 'unavailable':
      case 'disabled':
        status = SlotStatus.unavailable;
        break;
      case 'locked':
        status = SlotStatus.locked;
        break;
      case 'available':
      default:
        status = SlotStatus.available;
        break;
    }

    final String raw_time_of_day =
        (json['timeOfDay'] ?? json['time_of_day'] ?? '')
            .toString()
            .toLowerCase();
    final String start_time_str =
        (json['startTime'] ?? json['start_time'] ?? json['time'] ?? '09:00 AM')
            .toString();

    SlotTimeOfDay time_of_day;
    if (raw_time_of_day.contains('morning') ||
        start_time_str.toUpperCase().contains('AM') &&
            !start_time_str.startsWith('12')) {
      time_of_day = SlotTimeOfDay.morning;
    } else {
      time_of_day = SlotTimeOfDay.afternoon_evening;
    }

    return DoctorSlotModel(
      slot_id:
          (json['slotId'] ?? json['slot_id'] ?? json['id'] ?? '').toString(),
      start_time: start_time_str,
      end_time: (json['endTime'] ?? json['end_time'] ?? '').toString(),
      time_of_day: time_of_day,
      status: status,
    );
  }

  /// Serializes DoctorSlotModel into JSON Map.
  Map<String, dynamic> toJson() {
    return {
      'slotId': slot_id,
      'startTime': start_time,
      'endTime': end_time,
      'timeOfDay': time_of_day.name,
      'status': status.name,
    };
  }
}
