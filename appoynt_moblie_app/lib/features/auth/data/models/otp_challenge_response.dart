/*
 * File Name: otp_challenge_response.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Model representing the OTP challenge response containing the challenge ID.
 */

/// Data Transfer Object representing the challengeId response for OTP challenges.
class OtpChallengeResponse {
  final String challengeId;

  const OtpChallengeResponse({required this.challengeId});

  factory OtpChallengeResponse.fromJson(Map<String, dynamic> json) {
    return OtpChallengeResponse(
      challengeId: json['challengeId'] as String? ?? json['challenge_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'challengeId': challengeId,
    };
  }
}
