/*
 * File Name: slot_hold_entity.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: none
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Domain entity representing a temporary lock/hold placed on
 *   a doctor's time slot while the user proceeds through the booking checkout workflow.
 */

/// Domain entity representing an active temporary slot reservation hold.
class SlotHoldEntity {
  // Temporary cryptographic or UUID hold token
  final String hold_token;
  // Exact UTC expiration timestamp for server-synced countdown calculation
  final DateTime expires_at_utc;
  // Associated slot identifier
  final String slot_id;
  // Associated clinic location identifier
  final String clinic_id;
  // Associated doctor identifier
  final String doctor_id;
  // Client request correlation identifier
  final String? correlation_id;

  // Constant constructor
  const SlotHoldEntity({
    required this.hold_token,
    required this.expires_at_utc,
    required this.slot_id,
    required this.clinic_id,
    required this.doctor_id,
    this.correlation_id,
  });

  /// Calculates the remaining seconds before the hold expires against current UTC time.
  int get remaining_seconds {
    final DateTime now_utc = DateTime.now().toUtc();
    final int diff = expires_at_utc.difference(now_utc).inSeconds;
    return diff > 0 ? diff : 0;
  }

  /// Whether the hold has expired.
  bool get is_expired => remaining_seconds <= 0;
}
