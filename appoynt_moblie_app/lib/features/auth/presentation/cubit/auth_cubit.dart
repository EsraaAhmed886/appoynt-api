/*
 * File Name: auth_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.1.0
 * Dependencies: package:equatable/equatable.dart, package:flutter_bloc/flutter_bloc.dart,
 *   login_usecase.dart, register_usecase.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Manages the authentication states and business logic for the application.
 */

// Login logic
import 'package:appoynt_mobile_app/features/auth/domain/usecases/login_usecase.dart';
// Registration logic
import 'package:appoynt_mobile_app/features/auth/domain/usecases/register_usecase.dart';
// Verify OTP logic
import 'package:appoynt_mobile_app/features/auth/domain/usecases/verify_otp_usecase.dart';
// Resend OTP logic
import 'package:appoynt_mobile_app/features/auth/domain/usecases/resend_otp_usecase.dart';
// Forgot password logic
import 'package:appoynt_mobile_app/features/auth/domain/usecases/forgot_password_usecase.dart';
// Reset password logic
import 'package:appoynt_mobile_app/features/auth/domain/usecases/reset_password_usecase.dart';
// Secure storage
import 'package:appoynt_mobile_app/core/storage/token_storage.dart';
import 'package:appoynt_mobile_app/core/error/failures.dart';
// Value-based comparison
import 'package:equatable/equatable.dart';
// BLoC state management
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart'; // Linking the associated state file

/// Cubit responsible for handling authentication-related operations.
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _login_usecase;
  final RegisterUseCase _register_usecase;
  final VerifyOtpUseCase _verify_otp_usecase;
  final ResendOtpUseCase _resend_otp_usecase;
  final ForgotPasswordUseCase _forgot_password_usecase;
  final ResetPasswordUseCase _reset_password_usecase;

  // Active validation state variables preserved during flows
  String? challengeId;
  String? identifier;
  String? resetToken;

  /// Constructor requiring the use case instances.
  AuthCubit(
    this._login_usecase,
    this._register_usecase,
    this._verify_otp_usecase,
    this._resend_otp_usecase,
    this._forgot_password_usecase,
    this._reset_password_usecase,
  ) : super(AuthInitial());

  /// Orchestrates the login process for a user.
  Future<void> login(String identifier, String password) async {
    debugPrint('--- [AuthCubit.login] Triggered for: $identifier ---');
    emit(AuthLoading());
    final result = await _login_usecase(
      LoginParams(identifier: identifier, password: password),
    );
    debugPrint('--- [AuthCubit.login] Result received: $result ---');
    result.fold(
      (failure) {
        final String errorMsg =
            failure is ServerFailure ? (failure.message_key ?? 'Login failed.') : 'Login failed.';
        debugPrint('--- [AuthCubit.login] Failure emitted: $errorMsg ---');
        emit(AuthError(errorMsg));
      },
      (user) async {
        debugPrint('--- [AuthCubit.login] Success user token: ${user.token} ---');
        // Securely persist active token
        await TokenStorage.save_access_token(user.token);
        emit(AuthSuccess());
      },
    );
  }

  /// Purges stored credentials and transitions user session to unauthenticated.
  Future<void> logout() async {
    debugPrint('--- [AuthCubit.logout] Triggered ---');
    // 1. Clear secure tokens first
    await TokenStorage.clear_access_token();
    // 2. Safely emit state if cubit is still active
    if (!isClosed) {
      // Emit unauthenticated state to propagate logout across the widget tree
      emit(AuthUnauthenticated());
    } else {
      // Cubit is closed — skip state emission silently
    }
  }

  // Forces the AuthUnauthenticated state without clearing tokens.
  // Called by SessionManager after the 401 interceptor has already cleared
  // tokens, ensuring the widget tree reflects the expired session state.
  void force_unauthenticated() {
    // Log the forced state transition for debugging diagnostics
    debugPrint('--- [AuthCubit.force_unauthenticated] Triggered by 401 ---');
    // Guard against emitting on a closed cubit to prevent state errors
    if (!isClosed) {
      // Emit unauthenticated state so BlocListeners respond to session expiry
      emit(AuthUnauthenticated());
    } else {
      // Cubit is already closed — skip state emission silently
    }
  }

  /// Orchestrates the registration process for a new user.
  Future<void> register({
    required String first_name,
    required String last_name,
    required String email,
    required String phone,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await _register_usecase(
      RegisterParams(
        first_name: first_name,
        last_name: last_name,
        email: email,
        phone: phone,
        password: password,
      ),
    );
    result.fold(
      (failure) {
        final String errorMsg =
            failure is ServerFailure ? (failure.message_key ?? 'Registration failed.') : 'Registration failed.';
        emit(AuthError(errorMsg));
      },
      (response) {
        challengeId = response.challengeId;
        identifier = phone;
        emit(RegisterSuccess(challengeId: response.challengeId));
      },
    );
  }

  /// Initiates the forgot password code request.
  Future<void> forgot_password(String phone) async {
    emit(AuthLoading());
    final result = await _forgot_password_usecase(
      ForgotPasswordParams(identifier: phone),
    );
    result.fold(
      (failure) {
        final String errorMsg =
            failure is ServerFailure ? (failure.message_key ?? 'Failed to send recovery code.') : 'Failed to send recovery code.';
        emit(AuthError(errorMsg));
      },
      (response) {
        challengeId = response.challengeId;
        identifier = phone;
        emit(ForgotPasswordSuccess(challengeId: response.challengeId));
      },
    );
  }

  /// Verifies the OTP code.
  Future<void> verify_otp(String code) async {
    emit(AuthLoading());
    final String activeChallenge = challengeId ?? '';
    if (activeChallenge.isEmpty) {
      emit(const AuthError('Verification challenge context lost.'));
      return;
    } else {
      // No action needed
    }

    final result = await _verify_otp_usecase(
      VerifyOtpParams(challengeId: activeChallenge, code: code),
    );
    result.fold(
      (failure) {
        final String errorMsg =
            failure is ServerFailure ? (failure.message_key ?? 'OTP verification failed.') : 'OTP verification failed.';
        emit(AuthError(errorMsg));
      },
      (response) {
        resetToken = response.passwordResetToken;
        emit(VerifyOtpSuccess(resetToken: response.passwordResetToken));
      },
    );
  }

  /// Resends verification OTP code.
  Future<void> resend_otp() async {
    final String activeChallenge = challengeId ?? '';
    if (activeChallenge.isEmpty) {
      emit(const AuthError('Verification challenge context lost.'));
      return;
    } else {
      // No action needed
    }

    final result = await _resend_otp_usecase(
      ResendOtpParams(challengeId: activeChallenge),
    );
    result.fold(
      (failure) {
        final String errorMsg =
            failure is ServerFailure ? (failure.message_key ?? 'Failed to resend code.') : 'Failed to resend code.';
        emit(AuthError(errorMsg));
      },
      (response) {
        challengeId = response.challengeId;
        // Keep initial identifier, emit a temporary initial state to stop loading
        emit(AuthInitial());
      },
    );
  }

  /// Updates the password of the registered user.
  Future<void> reset_password({
    required String new_password,
  }) async {
    emit(AuthLoading());
    final String activeIdentifier = identifier ?? '';
    final String activeToken = resetToken ?? '';

    if (activeIdentifier.isEmpty || activeToken.isEmpty) {
      if (!isClosed) {
        emit(const AuthError('Reset token or identifier context lost.'));
      } else {
        // No action needed
      }
      return;
    } else {
      // No action needed
    }

    try {
      final result = await _reset_password_usecase(
        ResetPasswordParams(
          identifier: activeIdentifier,
          resetToken: activeToken,
          newPassword: new_password,
          confirmPassword: new_password,
        ),
      );
      if (!isClosed) {
        result.fold(
          (failure) {
            final String errorMsg = failure is ServerFailure
                ? (failure.message_key ?? 'Password reset failed.')
                : 'Password reset failed.';
            emit(AuthError(errorMsg));
          },
          (_) {
            emit(ResetPasswordSuccess());
          },
        );
      } else {
        // No action needed
      }
    } catch (e) {
      if (!isClosed) {
        emit(const AuthError(
            'An unexpected error occurred during password reset'));
      } else {
        // No action needed
      }
    }
  }

  /// Resets the cubit to its initial state.
  void reset() {
    emit(AuthInitial());
  }
}
