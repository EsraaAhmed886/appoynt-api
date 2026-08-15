/*
 * File Name: verify_otp_usecase.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:dartz/dartz.dart, failures.dart, usecase.dart, auth_repository.dart, otp_verification_response.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 08/08/2026]
 * File Description: UseCase that executes the remote OTP verification request.
 */

import 'package:appoynt_mobile_app/core/error/failures.dart';
import 'package:appoynt_mobile_app/core/usecases/usecase.dart';
import 'package:appoynt_mobile_app/features/auth/data/models/otp_verification_response.dart';
import 'package:appoynt_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class VerifyOtpUseCase extends UseCase<OtpVerificationResponse, VerifyOtpParams> {
  final AuthRepository repository;

  const VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, OtpVerificationResponse>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(
      challengeId: params.challengeId,
      code: params.code,
    );
  }
}

class VerifyOtpParams extends Equatable {
  final String challengeId;
  final String code;

  const VerifyOtpParams({required this.challengeId, required this.code});

  @override
  List<Object?> get props => [challengeId, code];
}
