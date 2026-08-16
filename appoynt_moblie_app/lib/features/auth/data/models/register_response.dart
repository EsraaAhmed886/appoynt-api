/*
 * File Name: register_response.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Model representing the registration response containing userId and challengeId.
 */

/// Data Transfer Object representing the user signup response fields.
class RegisterResponse {
  final String userId;
  final String challengeId;

  const RegisterResponse({
    required this.userId,
    required this.challengeId,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      challengeId: json['challengeId'] as String? ?? json['challenge_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'challengeId': challengeId,
    };
  }
}
