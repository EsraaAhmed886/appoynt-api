/*
 * File Name: slot_hold_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: slot_hold_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Data model extending SlotHoldEntity with precise UTC DateTime
 *   parsing and JSON serialization for slot reservation hold responses.
 */

import 'package:appoynt_mobile_app/features/booking/domain/entities/slot_hold_entity.dart';

/// Data transfer model for slot reservation holds.
class SlotHoldModel extends SlotHoldEntity {
  const SlotHoldModel({
    required super.hold_token,
    required super.expires_at_utc,
    required super.slot_id,
    required super.clinic_id,
    required super.doctor_id,
    super.correlation_id,
  });

  /// Factory deserializer converting JSON Map into SlotHoldModel.
  factory SlotHoldModel.fromJson(Map<String, dynamic> json) {
    final String raw_expires_at = (json['expiresAtUtc'] ??
            json['expires_at_utc'] ??
            json['expiresAt'] ??
            json['expires_at'] ??
            '')
        .toString();

    DateTime expires_at;
    if (raw_expires_at.isNotEmpty) {
      try {
        expires_at = DateTime.parse(raw_expires_at).toUtc();
      } catch (_) {
        // Fallback default: 5 minutes from now UTC
        expires_at = DateTime.now().toUtc().add(const Duration(minutes: 5));
      }
    } else if (json['ttlSeconds'] != null || json['ttl_seconds'] != null) {
      final int ttl = (json['ttlSeconds'] ?? json['ttl_seconds'] ?? 300) as int;
      expires_at = DateTime.now().toUtc().add(Duration(seconds: ttl));
    } else {
      expires_at = DateTime.now().toUtc().add(const Duration(minutes: 5));
    }

    return SlotHoldModel(
      hold_token: (json['holdToken'] ?? json['hold_token'] ?? json['token'] ?? '').toString(),
      expires_at_utc: expires_at,
      slot_id: (json['slotId'] ?? json['slot_id'] ?? '').toString(),
      clinic_id: (json['clinicId'] ?? json['clinic_id'] ?? '').toString(),
      doctor_id: (json['doctorId'] ?? json['doctor_id'] ?? '').toString(),
      correlation_id: json['correlationId']?.toString() ?? json['correlation_id']?.toString(),
    );
  }

  /// Serializes SlotHoldModel into JSON Map.
  Map<String, dynamic> toJson() {
    return {
      'holdToken': hold_token,
      'expiresAtUtc': expires_at_utc.toIso8601String(),
      'slotId': slot_id,
      'clinicId': clinic_id,
      'doctorId': doctor_id,
      'correlationId': correlation_id,
    };
  }
}
