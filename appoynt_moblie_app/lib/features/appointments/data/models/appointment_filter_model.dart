/*
 * File Name: appointment_filter_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: ./appointment_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Defines the filter options criteria for filtering appointments by date range, specialty, clinic, and consultation type.
 */

import 'appointment_model.dart';

/// Data model representing applied filters on the active appointments tab.
class AppointmentFilter {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? specialty;
  final String? clinicName;
  final AppointmentType? type;

  const AppointmentFilter({
    this.startDate,
    this.endDate,
    this.specialty,
    this.clinicName,
    this.type,
  });

  /// Checks if any filter parameter is actively selected.
  bool get isActive =>
      startDate != null ||
      endDate != null ||
      (specialty != null && specialty!.isNotEmpty) ||
      (clinicName != null && clinicName!.isNotEmpty) ||
      type != null;

  /// Counts the number of active filter parameters for the UI badge counter.
  int get activeFiltersCount {
    int count = 0;
    if (startDate != null || endDate != null) count++;
    if (specialty != null && specialty!.isNotEmpty) count++;
    if (clinicName != null && clinicName!.isNotEmpty) count++;
    if (type != null) count++;
    return count;
  }

  /// Creates a modified copy of this filter.
  AppointmentFilter copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? specialty,
    String? clinicName,
    AppointmentType? type,
    bool clearDates = false,
    bool clearSpecialty = false,
    bool clearClinic = false,
    bool clearType = false,
  }) {
    return AppointmentFilter(
      startDate: clearDates ? null : (startDate ?? this.startDate),
      endDate: clearDates ? null : (endDate ?? this.endDate),
      specialty: clearSpecialty ? null : (specialty ?? this.specialty),
      clinicName: clearClinic ? null : (clinicName ?? this.clinicName),
      type: clearType ? null : (type ?? this.type),
    );
  }

  /// Evaluates whether an appointment satisfies all criteria of this filter.
  bool matches(AppointmentModel appointment) {
    if (startDate != null) {
      final startOfDay = DateTime(startDate!.year, startDate!.month, startDate!.day);
      if (appointment.scheduledDateTime.isBefore(startOfDay)) {
        return false;
      }
    }
    if (endDate != null) {
      final endOfDay = DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59);
      if (appointment.scheduledDateTime.isAfter(endOfDay)) {
        return false;
      }
    }
    if (specialty != null && specialty!.isNotEmpty) {
      if (appointment.doctorSpecialty?.toLowerCase() != specialty!.toLowerCase()) {
        return false;
      }
    }
    if (clinicName != null && clinicName!.isNotEmpty) {
      if (!appointment.clinicName.toLowerCase().contains(clinicName!.toLowerCase())) {
        return false;
      }
    }
    if (type != null) {
      if (appointment.type != type) {
        return false;
      }
    }
    return true;
  }
}
