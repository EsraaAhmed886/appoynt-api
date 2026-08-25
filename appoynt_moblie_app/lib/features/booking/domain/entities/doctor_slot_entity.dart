/*
 * File Name: doctor_slot_entity.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: none
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Domain entity and enums representing an individual time slot
 *   for a doctor's clinic schedule, including status, period, and start/end times.
 */

/// Time of day categorization enum for filtering.
enum SlotTimeOfDay {
  morning,
  afternoon_evening,
}

/// Status of an individual appointment slot.
enum SlotStatus {
  available,
  booked,
  held,
  unavailable,
  locked,
}

/// Domain entity representing a single booking slot.
class DoctorSlotEntity {
  // Unique slot identifier
  final String slot_id;
  // Start time in 12h format (e.g. '09:00 AM')
  final String start_time;
  // End time in 12h format (e.g. '09:30 AM')
  final String end_time;
  // Time period categorization
  final SlotTimeOfDay time_of_day;
  // Current slot availability status
  final SlotStatus status;

  // Constant constructor
  const DoctorSlotEntity({
    required this.slot_id,
    required this.start_time,
    required this.end_time,
    required this.time_of_day,
    required this.status,
  });

  /// Convenience getter for whether slot can be booked
  bool get is_available => status == SlotStatus.available;
}
