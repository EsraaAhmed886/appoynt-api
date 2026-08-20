/*
 * File Name: user_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: user_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Data Transfer Object (DTO) for the User entity. Handles JSON mapping.
 */

// Base domain entity
import 'dart:convert';
import 'package:appoynt_mobile_app/features/auth/domain/entities/user_entity.dart';

import 'package:flutter/foundation.dart';

/// Model representing a User with JSON serialization support and JWT payload claims extraction.
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

  /// Factory method to create a UserModel instance from a JWT access token.
  factory UserModel.fromToken(String token) {
    try {
      final claims = _decode_jwt(token);
      final String id = claims['nameid'] ??
          claims['sub'] ??
          claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] ??
          '';
      final String email = claims['email'] ??
          claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'] ??
          '';
      final String firstName = claims['given_name'] ??
          claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname'] ??
          '';
      final String lastName = claims['family_name'] ??
          claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname'] ??
          '';
      final String phone = claims['phone'] ??
          claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/mobilephone'] ??
          '';

      return UserModel(
        id: id,
        email: email,
        first_name: firstName,
        last_name: lastName,
        phone_number: phone,
        token: token,
      );
    } catch (e, stackTrace) {
      debugPrint('--- [UserModel.fromToken] Error decoding JWT: $e ---');
      debugPrint(stackTrace.toString());
      // Fallback empty model
      return UserModel(
        id: '',
        email: '',
        first_name: '',
        last_name: '',
        phone_number: '',
        token: token,
      );
    }
  }

  /// Helper decoding standard JWT payloads using safe base64 decoding normalization.
  static Map<String, dynamic> _decode_jwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) {
        return {};
      } else {
        // No action needed
      }
      final String payload = parts[1];
      final String normalized = base64.normalize(payload);
      final String decoded = utf8.decode(base64.decode(normalized));
      return json.decode(decoded) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  /// Factory method to create a UserModel instance from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      first_name: json['first_name'] as String? ?? '',
      last_name: json['last_name'] as String? ?? '',
      phone_number: json['phone'] as String? ?? '',
      token: json['token'] as String? ?? '',
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
