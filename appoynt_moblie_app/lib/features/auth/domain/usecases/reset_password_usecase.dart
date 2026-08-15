/*
 * File Name: reset_password_usecase.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:dartz/dartz.dart, failures.dart, usecase.dart, auth_repository.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 08/08/2026]
 * File Description: UseCase that executes the remote reset password update request.
 */

import 'package:appoynt_mobile_app/core/error/failures.dart';
import 'package:appoynt_mobile_app/core/usecases/usecase.dart';
import 'package:appoynt_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class ResetPasswordUseCase extends UseCase<void, ResetPasswordParams> {
  final AuthRepository repository;

  const ResetPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    return await repository.resetPassword(
      identifier: params.identifier,
      resetToken: params.resetToken,
      newPassword: params.newPassword,
      confirmPassword: params.confirmPassword,
    );
  }
}

class ResetPasswordParams extends Equatable {
  final String identifier;
  final String resetToken;
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordParams({
    required this.identifier,
    required this.resetToken,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [identifier, resetToken, newPassword, confirmPassword];
}
