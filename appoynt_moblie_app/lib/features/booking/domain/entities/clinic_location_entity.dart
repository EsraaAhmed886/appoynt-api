/*
 * File Name: clinic_location_entity.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: none
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Domain entity representing a clinic location and branch details
 *   where a doctor practices, including working days, hours, and consultation fee.
 */

/// Domain entity representing a specific medical clinic location.
class ClinicLocationEntity {
  // Unique clinic identifier
  final String clinic_id;
  // Clinic branch name
  final String name;
  // Physical street address / district
  final String address;
  // Consultation fee at this specific branch
  final double consultation_fee;
  // Billing currency code (e.g., EGP)
  final String currency;
  // List of active working days (e.g., ['Sat', 'Mon', 'Wed'] or ['Sun', 'Tue', 'Thu'])
  final List<String> working_days;
  // Working hours string (e.g., '09:00 AM - 05:00 PM')
  final String working_hours;
  // Local timezone identifier
  final String timezone;
  // Latitude coordinate
  final double? latitude;
  // Longitude coordinate
  final double? longitude;

  // Constant constructor
  const ClinicLocationEntity({
    required this.clinic_id,
    required this.name,
    required this.address,
    required this.consultation_fee,
    required this.currency,
    required this.working_days,
    required this.working_hours,
    required this.timezone,
    this.latitude,
    this.longitude,
  });

  /// Checks whether this clinic is open on the given weekday abbreviation.
  bool isOpenOn(String day_short_name) {
    return working_days.any(
      (day) => day.toLowerCase().startsWith(day_short_name.toLowerCase().substring(0, 3)),
    );
  }
}
