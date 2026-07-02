/*
 * File Name: auth_repository_impl.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: 
 *   - package:dartz/dartz.dart
 *   - package:dio/dio.dart
 *   - failures.dart
 *   - auth_repository.dart
 *   - user_entity.dart
 *   - auth_remote_datasource.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 02/07/2026]
 * File Description:
 *   Concrete implementation of the AuthRepository. It coordinates between 
 *   remote data sources and maps results to domain entities or failures.
 */

import 'package:appoynt_mobile_app/core/error/failures.dart'; // Failure types
import 'package:appoynt_mobile_app/features/auth/data/datasources/auth_remote_datasource.dart'; // Remote data source
import 'package:appoynt_mobile_app/features/auth/domain/entities/user_entity.dart'; // Domain entity
import 'package:appoynt_mobile_app/features/auth/domain/repositories/auth_repository.dart'; // Repository contract
import 'package:dartz/dartz.dart'; // Functional error handling
import 'package:dio/dio.dart'; // Network client exceptions

/// Concrete implementation of the authentication data repository.
class AuthRepositoryImpl implements AuthRepository {
  /// Reference to the remote data source.
  final AuthRemoteDataSource remote_data_source;

  /// Constructor requiring the remote data source implementation.
  const AuthRepositoryImpl(this.remote_data_source);

  @override
  /// Orchestrates the user login process.
  Future<Either<Failure, UserEntity>> login({
    required String identifier,
    required String password,
  }) async {
    try {
      /// Fetching user data from the remote source.
      final user_model = await remote_data_source.login(
        identifier: identifier,
        password: password,
      );
      
      /// Returning the success result as a domain entity.
      return Right(user_model);
    } on DioException {
      /// Mapping network-related exceptions to domain failures.
      return const Left(ServerFailure());
    } catch (e) {
      /// Handling unexpected errors as general server failures.
      return const Left(ServerFailure());
    }
  }

  @override
  /// Contract for registration.
  Future<Either<Failure, UserEntity>> register({
    required String first_name,
    required String last_name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      /// Sending registration data to the remote source.
      final user_model = await remote_data_source.register(
        first_name: first_name,
        last_name: last_name,
        email: email,
        phone: phone,
        password: password,
      );
      
      /// Returning the success result as a domain entity.
      return Right(user_model);
    } on DioException {
      /// Mapping network-related exceptions to domain failures.
      return const Left(ServerFailure());
    } catch (e) {
      /// Handling unexpected errors as general server failures.
      return const Left(ServerFailure());
    }
  }
}
