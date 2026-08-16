/*
 * File Name: otp_verification_response.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Model representing the verification details returned after verifying the OTP code.
 */

/// Data Transfer Object representing verification status details.
class OtpVerificationResponse {
  final bool phoneNumberConfirmed;
  final String? passwordResetToken;

  const OtpVerificationResponse({
    required this.phoneNumberConfirmed,
    this.passwordResetToken,
  });

  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerificationResponse(
      phoneNumberConfirmed: json['phoneNumberConfirmed'] as bool? ?? json['phone_number_confirmed'] as bool? ?? false,
      passwordResetToken: json['passwordResetToken'] as String? ?? json['password_reset_token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumberConfirmed': phoneNumberConfirmed,
      if (null != passwordResetToken) 'passwordResetToken': passwordResetToken,
    };
  }
}
