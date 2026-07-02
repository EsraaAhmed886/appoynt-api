/*
 * File Name: user_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: 
 *   - user_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 02/07/2026]
 * File Description:
 *   Data Transfer Object (DTO) for the User entity. Handles JSON mapping.
 */

import 'package:appoynt_mobile_app/features/auth/domain/entities/user_entity.dart'; // Base domain entity

/// Model representing a User with JSON serialization support.
class UserModel extends UserEntity {
  /// Constructor for UserModel.
  const UserModel({
    required super.id,
    required super.email,
    required super.first_name,
    required super.last_name,
    required super.phone_number,
    required super.token,
  });

  /// Factory method to create a UserModel instance from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      phone_number: json['phone'] as String,
      token: json['token'] as String,
    );
  }

  /// Converts the UserModel instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': first_name,
      'last_name': last_name,
      'phone': phone_number,
      'token': token,
    };
  }
}
