/*
 * File Name: auth_remote_datasource.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:dio/dio.dart, api_constants.dart, user_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Handles all remote data operations related to authentication
 *   by communicating directly with the backend API using the Dio client.
 */

import 'package:appoynt_mobile_app/core/api/api_constants.dart'; // Endpoints and base settings
import 'package:appoynt_mobile_app/features/auth/data/models/user_model.dart'; // User data model
import 'package:appoynt_mobile_app/features/auth/data/models/register_response.dart'; // Register response model
import 'package:appoynt_mobile_app/features/auth/data/models/otp_challenge_response.dart'; // OTP challenge model
import 'package:appoynt_mobile_app/features/auth/data/models/otp_verification_response.dart'; // OTP verification model
import 'package:appoynt_mobile_app/features/auth/data/models/verify_otp_request_model.dart'; // Verify OTP request model
import 'package:dio/dio.dart'; // Network client

/// Abstract contract for the authentication remote data source.
abstract class AuthRemoteDataSource {
  /// Remote contract for user login.
  Future<UserModel> login({
    required String identifier,
    required String password,
  });

  /// Remote contract for new user registration.
  Future<RegisterResponse> register({
    required String first_name,
    required String last_name,
    required String email,
    required String phone,
    required String password,
  });

  /// Remote contract for OTP verification challenge.
  Future<OtpVerificationResponse> verifyOtp({
    required VerifyOtpRequestModel request,
  });

  /// Remote contract for resending OTP verification code.
  Future<OtpChallengeResponse> resendOtp({
    required String challengeId,
  });

  /// Remote contract for forgot password OTP requests.
  Future<OtpChallengeResponse> forgotPassword({
    required String identifier,
  });

  /// Remote contract for resetting user password.
  Future<void> resetPassword({
    required String identifier,
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  });
}

/// Concrete implementation of the authentication remote data source using Dio.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// Reference to the configured Dio client.
  final Dio dio;

  /// Constructor requiring the Dio instance.
  const AuthRemoteDataSourceImpl(this.dio);

  @override
  /// Performs the remote login request.
  Future<UserModel> login({
    required String identifier,
    required String password,
  }) async {
    final Response response = await dio.post(
      ApiConstants.login,
      data: {
        'identifier': identifier,
        'password': password,
      },
    );
    final String token = response.data['accessToken'] as String? ?? '';
    return UserModel.fromToken(token);
  }

  @override
  /// Performs the remote registration request.
  Future<RegisterResponse> register({
    required String first_name,
    required String last_name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final Response response = await dio.post(
      ApiConstants.register,
      data: {
        'firstName': first_name,
        'lastName': last_name,
        'email': email,
        'phoneNumber': phone,
        'password': password,
        'confirmPassword': password,
      },
    );
    return RegisterResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  /// Verifies OTP code using a challenge ID.
  Future<OtpVerificationResponse> verifyOtp({
    required VerifyOtpRequestModel request,
  }) async {
    final Response response = await dio.post(
      ApiConstants.verify_otp,
      data: request.toJson(),
    );
    return OtpVerificationResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  /// Requests a fresh verification challenge code.
  Future<OtpChallengeResponse> resendOtp({
    required String challengeId,
  }) async {
    final Response response = await dio.post(
      ApiConstants.resend_otp,
      data: {
        'challengeId': challengeId,
      },
    );
    return OtpChallengeResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  /// Requests a password reset challenge code.
  Future<OtpChallengeResponse> forgotPassword({
    required String identifier,
  }) async {
    final Response response = await dio.post(
      ApiConstants.forgot_password,
      data: {
        'identifier': identifier,
      },
    );
    return OtpChallengeResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  /// Resets a user's password utilizing the validation token.
  Future<void> resetPassword({
    required String identifier,
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await dio.post(
      ApiConstants.reset_password,
      data: {
        'identifier': identifier,
        'resetToken': resetToken,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );
  }
}
