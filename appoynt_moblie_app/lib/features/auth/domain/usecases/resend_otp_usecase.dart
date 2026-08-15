/*
 * File Name: resend_otp_usecase.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:dartz/dartz.dart, failures.dart, usecase.dart, auth_repository.dart, otp_challenge_response.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 08/08/2026]
 * File Description: UseCase that executes the remote resend OTP request.
 */

import 'package:appoynt_mobile_app/core/error/failures.dart';
import 'package:appoynt_mobile_app/core/usecases/usecase.dart';
import 'package:appoynt_mobile_app/features/auth/data/models/otp_challenge_response.dart';
import 'package:appoynt_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class ResendOtpUseCase extends UseCase<OtpChallengeResponse, ResendOtpParams> {
  final AuthRepository repository;

  const ResendOtpUseCase(this.repository);

  @override
  Future<Either<Failure, OtpChallengeResponse>> call(ResendOtpParams params) async {
    return await repository.resendOtp(
      challengeId: params.challengeId,
    );
  }
}

class ResendOtpParams extends Equatable {
  final String challengeId;

  const ResendOtpParams({required this.challengeId});

  @override
  List<Object?> get props => [challengeId];
}
