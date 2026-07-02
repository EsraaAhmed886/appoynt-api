/*
 * File Name: login_usecase.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: 
 *   - package:dartz/dartz.dart
 *   - package:appoynt_mobile_app/core/error/failures.dart
 *   - package:appoynt_mobile_app/core/usecases/usecase.dart
 *   - auth_repository.dart
 *   - user_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 02/07/2026]
 * File Description:
 *   Represents the login business logic action.
 */

import 'package:appoynt_mobile_app/core/error/failures.dart'; // Failure definitions
import 'package:appoynt_mobile_app/core/usecases/usecase.dart'; // Base use case class
import 'package:appoynt_mobile_app/features/auth/domain/entities/user_entity.dart'; // User entity
import 'package:appoynt_mobile_app/features/auth/domain/repositories/auth_repository.dart'; // Auth repository contract
import 'package:dartz/dartz.dart'; // Functional programming support
import 'package:equatable/equatable.dart'; // Value-based comparison

/// UseCase for performing user login.
class LoginUseCase extends UseCase<UserEntity, LoginParams> {
  /// Reference to the authentication repository.
  final AuthRepository repository;

  /// Constructor requiring the repository implementation.
  const LoginUseCase(this.repository);

  @override
  /// Executes the login process.
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return await repository.login(
      identifier: params.identifier,
      password: params.password,
    );
  }
}

/// Parameters required for the LoginUseCase.
class LoginParams extends Equatable {
  /// The user's email or phone number.
  final String identifier;
  /// The user's password.
  final String password;

  /// Constructor for LoginParams.
  const LoginParams({required this.identifier, required this.password});

  @override
  /// Properties used for comparison.
  List<Object?> get props {
    return [identifier, password];
  }
}
