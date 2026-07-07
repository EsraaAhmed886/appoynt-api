/*
 * File Name: user_entity.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: 
 *   - package:equatable/equatable.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 02/07/2026]
 * File Description:
 *   Defines the core User entity for the domain layer. This is a pure Dart 
 *   class that represents the data structure of a user within the business logic.
 */

import 'package:equatable/equatable.dart'; // Value-based comparison

/// Pure domain entity representing a User in the system.
class UserEntity extends Equatable {
  /// Unique identifier for the user.
  final String id;
  /// The user's primary email address.
  final String email;
  /// The user's first name.
  final String first_name;
  /// The user's last name.
  final String last_name;
  /// The user's phone number.
  final String phone_number;
  /// The authentication token provided by the backend.
  final String token;

  /// Constant constructor for the immutable UserEntity.
  const UserEntity({
    required this.id,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.phone_number,
    required this.token,
  });

  @override
  /// Properties used for comparison.
  List<Object?> get props {
    return [id, email, first_name, last_name, phone_number, token];
  }
}
