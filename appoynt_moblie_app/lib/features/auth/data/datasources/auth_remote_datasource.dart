/*
 * File Name: auth_remote_datasource.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: 
 *   - package:dio/dio.dart
 *   - api_constants.dart
 *   - user_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 02/07/2026]
 * File Description:
 *   Handles all remote data operations related to authentication by communicating 
 *   directly with the backend API using the Dio client.
 */

import 'package:appoynt_mobile_app/core/api/api_constants.dart'; // Endpoints and base settings
import 'package:appoynt_mobile_app/features/auth/data/models/user_model.dart'; // User data model
import 'package:dio/dio.dart'; // Network client

/// Abstract contract for the authentication remote data source.
abstract class AuthRemoteDataSource {
  /// Remote contract for user login.
  Future<UserModel> login({
    required String identifier,
    required String password,
  });

  /// Remote contract for new user registration.
  Future<UserModel> register({
    required String first_name,
    required String last_name,
    required String email,
    required String phone,
    required String password,
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
    /// Sending a POST request to the login endpoint.
    final Response response = await dio.post(
      ApiConstants.login,
      data: {
        'identifier': identifier,
        'password': password,
      },
    );
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  /// Performs the remote registration request.
  Future<UserModel> register({
    required String first_name,
    required String last_name,
    required String email,
    required String phone,
    required String password,
  }) async {
    /// Sending a POST request to the registration endpoint.
    final Response response = await dio.post(
      ApiConstants.register,
      data: {
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
        'phone': phone,
        'password': password,
      },
    );
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
