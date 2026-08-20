/*
 * File Name: forgot_password_usecase.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:dartz/dartz.dart, failures.dart, usecase.dart, auth_repository.dart, otp_challenge_response.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: UseCase that executes the remote forgot password OTP request.
 */

import 'package:appoynt_mobile_app/core/error/failures.dart';
import 'package:appoynt_mobile_app/core/usecases/usecase.dart';
import 'package:appoynt_mobile_app/features/auth/data/models/otp_challenge_response.dart';
import 'package:appoynt_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class ForgotPasswordUseCase extends UseCase<OtpChallengeResponse, ForgotPasswordParams> {
  final AuthRepository repository;

  const ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, OtpChallengeResponse>> call(ForgotPasswordParams params) async {
    return await repository.forgotPassword(
      identifier: params.identifier,
    );
  }
}

class ForgotPasswordParams extends Equatable {
  final String identifier;

  const ForgotPasswordParams({required this.identifier});

  @override
  List<Object?> get props => [identifier];
}
