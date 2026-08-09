/*
 * File Name: auth_repository.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:dartz/dartz.dart, package:appoynt_mobile_app/core/error/failures.dart, user_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Abstract interface defining the contract for authentication-related
 *   data operations. Follows the Dependency Inversion principle.
 */

import 'package:appoynt_mobile_app/core/error/failures.dart'; // Failure definitions
import 'package:appoynt_mobile_app/features/auth/domain/entities/user_entity.dart'; // User entity
import 'package:appoynt_mobile_app/features/auth/data/models/register_response.dart'; // Register response model
import 'package:appoynt_mobile_app/features/auth/data/models/otp_challenge_response.dart'; // OTP challenge model
import 'package:appoynt_mobile_app/features/auth/data/models/otp_verification_response.dart'; // OTP verification model
import 'package:dartz/dartz.dart'; // Functional programming support

/// Abstract contract for authentication data management.
abstract class AuthRepository {
  /// Contract for user login.
  Future<Either<Failure, UserEntity>> login({
    required String identifier,
    required String password,
  });

  /// Contract for new user registration.
  Future<Either<Failure, RegisterResponse>> register({
    required String first_name,
    required String last_name,
    required String email,
    required String phone,
    required String password,
  });

  /// Contract for OTP verification.
  Future<Either<Failure, OtpVerificationResponse>> verifyOtp({
    required String challengeId,
    required String code,
  });

  /// Contract for resending OTP verification code.
  Future<Either<Failure, OtpChallengeResponse>> resendOtp({
    required String challengeId,
  });

  /// Contract for forgot password requests.
  Future<Either<Failure, OtpChallengeResponse>> forgotPassword({
    required String identifier,
  });

  /// Contract for resetting user password.
  Future<Either<Failure, void>> resetPassword({
    required String identifier,
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  });
}
