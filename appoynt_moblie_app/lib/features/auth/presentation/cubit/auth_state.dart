/*
 * File Name: auth_state.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: auth_cubit.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Defines the various states for the authentication feature.
 */

part of 'auth_cubit.dart';

/// Abstract base class for all authentication states.
abstract class AuthState extends Equatable {
  /// Constant constructor for the abstract state.
  const AuthState();

  @override
  /// Properties for value comparison to enable efficient UI rebuilds.
  List<Object?> get props {
    return [];
  }
}

/// The initial state emitted when the auth feature is loaded.
class AuthInitial extends AuthState {}

/// State emitted while an authentication process is in progress.
class AuthLoading extends AuthState {}

/// State emitted when an authentication process is successfully completed.
class AuthSuccess extends AuthState {}

/// State emitted when an authentication process fails.
class AuthError extends AuthState {
  /// The descriptive error message.
  final String message;
  
  /// Constructor requiring an error message.
  const AuthError(this.message);

  @override
  /// Adding the message to props for state change detection.
  List<Object?> get props {
    return [message];
  }
}

/// State emitted when registration is successful and OTP validation is needed.
class RegisterSuccess extends AuthState {
  final String challengeId;
  const RegisterSuccess({required this.challengeId});

  @override
  List<Object?> get props => [challengeId];
}

/// State emitted when forgot password request initiates challenge.
class ForgotPasswordSuccess extends AuthState {
  final String challengeId;
  const ForgotPasswordSuccess({required this.challengeId});

  @override
  List<Object?> get props => [challengeId];
}

/// State emitted when OTP verification succeeds.
class VerifyOtpSuccess extends AuthState {
  final String? resetToken;
  const VerifyOtpSuccess({this.resetToken});

  @override
  List<Object?> get props => [resetToken];
}

/// State emitted when password reset succeeds.
class ResetPasswordSuccess extends AuthState {}

/// State emitted when a user is unauthenticated or has logged out.
class AuthUnauthenticated extends AuthState {}
