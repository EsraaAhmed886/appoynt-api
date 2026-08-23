/*
 * File Name: clinic_location_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: clinic_location_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Data model extending ClinicLocationEntity with robust JSON
 *   serialization and deserialization handling null safety and dynamic backend fields.
 */

import 'package:appoynt_mobile_app/features/booking/domain/entities/clinic_location_entity.dart';

/// Data transfer model for clinic locations.
class ClinicLocationModel extends ClinicLocationEntity {
  const ClinicLocationModel({
    required super.clinic_id,
    required super.name,
    required super.address,
    required super.consultation_fee,
    required super.currency,
    required super.working_days,
    required super.working_hours,
    required super.timezone,
    super.latitude,
    super.longitude,
  });

  /// Factory deserializer converting JSON Map into ClinicLocationModel.
  factory ClinicLocationModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> raw_days = json['workingDays'] as List<dynamic>? ??
        json['working_days'] as List<dynamic>? ??
        json['days'] as List<dynamic>? ??
        ['Sat', 'Mon', 'Wed'];

    return ClinicLocationModel(
      clinic_id: (json['clinicId'] ?? json['clinic_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? json['clinicName'] ?? json['clinic_name'] ?? 'Main Clinic').toString(),
      address: (json['address'] ?? json['location'] ?? '').toString(),
      consultation_fee: (json['consultationFee'] ?? json['consultation_fee'] ?? json['fee'] ?? 500.0) is num
          ? (json['consultationFee'] ?? json['consultation_fee'] ?? json['fee'] ?? 500.0).toDouble()
          : (double.tryParse((json['consultationFee'] ?? json['consultation_fee'] ?? '500').toString()) ?? 500.0),
      currency: (json['currency'] ?? 'EGP').toString(),
      working_days: raw_days.map((e) => e.toString()).toList(),
      working_hours: (json['workingHours'] ?? json['working_hours'] ?? '09:00 AM - 05:00 PM').toString(),
      timezone: (json['timezone'] ?? 'Africa/Cairo').toString(),
      latitude: json['latitude'] is num ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] is num ? (json['longitude'] as num).toDouble() : null,
    );
  }

  /// Serializes ClinicLocationModel into JSON Map.
  Map<String, dynamic> toJson() {
    return {
      'clinicId': clinic_id,
      'name': name,
      'address': address,
      'consultationFee': consultation_fee,
      'currency': currency,
      'workingDays': working_days,
      'workingHours': working_hours,
      'timezone': timezone,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
