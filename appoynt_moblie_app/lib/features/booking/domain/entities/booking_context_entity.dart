/*
 * File Name: booking_context_entity.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: none
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Domain entity encapsulating the complete contextual details
 *   required across the entire appointment reservation, hold, and confirmation lifecycle.
 */

/// Domain entity packaging the complete booking context.
class BookingContextEntity {
  // Doctor identifier
  final String doctor_id;
  // Doctor full name
  final String doctor_name;
  // Doctor specialty
  final String specialty;
  // Doctor profile image URL
  final String? profile_photo_url;
  // Clinic identifier
  final String clinic_id;
  // Clinic branch name
  final String clinic_name;
  // Clinic address
  final String clinic_address;
  // Medical service type identifier
  final String service_type_id;
  // Selected appointment date string (YYYY-MM-DD)
  final String selected_date;
  // Consultation fee
  final double consultation_fee;
  // Currency code
  final String currency;

  // Constant constructor
  const BookingContextEntity({
    required this.doctor_id,
    required this.doctor_name,
    required this.specialty,
    this.profile_photo_url,
    required this.clinic_id,
    required this.clinic_name,
    required this.clinic_address,
    required this.service_type_id,
    required this.selected_date,
    required this.consultation_fee,
    required this.currency,
  });
}
