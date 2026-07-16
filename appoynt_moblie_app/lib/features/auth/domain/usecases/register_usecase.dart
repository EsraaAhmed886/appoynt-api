/*
 * File Name: register_usecase.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:dartz/dartz.dart, package:appoynt_mobile_app/core/error/failures.dart,
 *   package:appoynt_mobile_app/core/usecases/usecase.dart, auth_repository.dart, user_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Represents the registration business logic action.
 */

// Failure definitions
import 'package:appoynt_mobile_app/core/error/failures.dart';
// Base use case class
import 'package:appoynt_mobile_app/core/usecases/usecase.dart';
// User entity
import 'package:appoynt_mobile_app/features/auth/domain/entities/user_entity.dart';
// Auth repository contract
import 'package:appoynt_mobile_app/features/auth/domain/repositories/auth_repository.dart';
// Functional programming support
import 'package:dartz/dartz.dart';
// Value-based comparison
import 'package:equatable/equatable.dart';

/// UseCase for performing user registration.
class RegisterUseCase extends UseCase<UserEntity, RegisterParams> {
  /// Reference to the authentication repository.
  final AuthRepository repository;

  /// Constructor requiring the repository implementation.
  const RegisterUseCase(this.repository);

  @override
  /// Executes the registration process.
  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    return await repository.register(
      first_name: params.first_name,
      last_name: params.last_name,
      email: params.email,
      phone: params.phone,
      password: params.password,
    );
  }
}

/// Parameters required for the RegisterUseCase.
class RegisterParams extends Equatable {
  /// The user's first name
  final String first_name;
  /// The user's last name
  final String last_name;
  /// The user's email address
  final String email;
  /// The user's phone number
  final String phone;
  /// The user's password
  final String password;

  /// Constructor for RegisterParams.
  const RegisterParams({
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  /// Properties used for comparison.
  List<Object?> get props {
    return [first_name, last_name, email, phone, password];
  }
}
