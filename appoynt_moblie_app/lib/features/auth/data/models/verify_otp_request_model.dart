/*
 * File Name: verify_otp_request_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Model representing the OTP verification request body payload.
 */

/// Data Transfer Object representing verification parameters sent to the backend.
class VerifyOtpRequestModel {
  final String challengeId;
  final String code;

  const VerifyOtpRequestModel({
    required this.challengeId,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'challengeId': challengeId,
      'code': code,
    };
  }
}
