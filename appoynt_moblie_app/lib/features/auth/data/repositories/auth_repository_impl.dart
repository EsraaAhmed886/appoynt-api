/*
 * File Name: auth_repository_impl.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:dartz/dartz.dart, package:dio/dio.dart, failures.dart,
 *   auth_repository.dart, user_entity.dart, auth_remote_datasource.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Concrete implementation of the AuthRepository. It coordinates
 *   between remote data sources and maps results to domain entities or failures.
 */

import 'package:appoynt_mobile_app/core/error/failures.dart'; // Failure types
import 'package:appoynt_mobile_app/features/auth/data/datasources/auth_remote_datasource.dart'; // Remote data source
import 'package:appoynt_mobile_app/features/auth/domain/entities/user_entity.dart'; // Domain entity
import 'package:appoynt_mobile_app/features/auth/domain/repositories/auth_repository.dart'; // Repository contract
import 'package:appoynt_mobile_app/features/auth/data/models/register_response.dart'; // Register response model
import 'package:appoynt_mobile_app/features/auth/data/models/otp_challenge_response.dart'; // OTP challenge model
import 'package:appoynt_mobile_app/features/auth/data/models/otp_verification_response.dart'; // OTP verification model
import 'package:appoynt_mobile_app/features/auth/data/models/verify_otp_request_model.dart'; // Verify OTP request model
import 'package:dartz/dartz.dart'; // Functional error handling
import 'package:dio/dio.dart'; // Network client exceptions

/// Concrete implementation of the authentication data repository.
class AuthRepositoryImpl implements AuthRepository {
  /// Remote data source instance.
  final AuthRemoteDataSource remote_data_source;

  /// Constructor requiring the remote data source implementation.
  const AuthRepositoryImpl(this.remote_data_source);

  /// Utility parsing the dynamic API error payload from DioException.
  String _parse_error(DioException e) {
    String rawError = 'An unexpected server error occurred.';
    try {
      final data = e.response?.data;
      if (data is List) {
        final errors = data.map((item) {
          final Map<String, dynamic> err = item as Map<String, dynamic>;
          final String code = err['code'] as String? ?? '';
          return code;
        }).toList();
        rawError = errors.where((s) => s.isNotEmpty).join(', ');
      } else if (data is Map) {
        rawError = data['detail'] as String? ??
            data['title'] as String? ??
            'An error occurred';
      } else {
        // No action needed
      }
    } catch (_) {
      // Ignore parsing errors
    }
    return rawError;
  }

  @override
  /// Orchestrates the user login process.
  Future<Either<Failure, UserEntity>> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final user_model = await remote_data_source.login(
        identifier: identifier,
        password: password,
      );
      return Right(user_model);
    } on DioException catch (e) {
      return Left(ServerFailure(_parse_error(e)));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  /// Contract for registration.
  Future<Either<Failure, RegisterResponse>> register({
    required String first_name,
    required String last_name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final register_response = await remote_data_source.register(
        first_name: first_name,
        last_name: last_name,
        email: email,
        phone: phone,
        password: password,
      );
      return Right(register_response);
    } on DioException catch (e) {
      return Left(ServerFailure(_parse_error(e)));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  /// Contract for verifying OTP codes.
  Future<Either<Failure, OtpVerificationResponse>> verifyOtp({
    required String challengeId,
    required String code,
  }) async {
    try {
      final verify_response = await remote_data_source.verifyOtp(
        request: VerifyOtpRequestModel(
          challengeId: challengeId,
          code: code,
        ),
      );
      return Right(verify_response);
    } on DioException catch (e) {
      return Left(ServerFailure(_parse_error(e)));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  /// Contract for resending OTP verification challenge.
  Future<Either<Failure, OtpChallengeResponse>> resendOtp({
    required String challengeId,
  }) async {
    try {
      final challenge_response = await remote_data_source.resendOtp(
        challengeId: challengeId,
      );
      return Right(challenge_response);
    } on DioException catch (e) {
      return Left(ServerFailure(_parse_error(e)));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  /// Contract for requesting reset token.
  Future<Either<Failure, OtpChallengeResponse>> forgotPassword({
    required String identifier,
  }) async {
    try {
      final challenge_response = await remote_data_source.forgotPassword(
        identifier: identifier,
      );
      return Right(challenge_response);
    } on DioException catch (e) {
      return Left(ServerFailure(_parse_error(e)));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  /// Contract for password reset updates.
  Future<Either<Failure, void>> resetPassword({
    required String identifier,
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await remote_data_source.resetPassword(
        identifier: identifier,
        resetToken: resetToken,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(_parse_error(e)));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
