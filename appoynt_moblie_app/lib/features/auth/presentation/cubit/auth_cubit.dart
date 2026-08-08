/*
 * File Name: auth_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.1.0
 * Dependencies: package:equatable/equatable.dart, package:flutter_bloc/flutter_bloc.dart,
 *   login_usecase.dart, register_usecase.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 23/07/2026]
 * File Description: Manages the authentication states and business logic for the application.
 */

// Login logic
import 'package:appoynt_mobile_app/features/auth/domain/usecases/login_usecase.dart';
// Registration logic
import 'package:appoynt_mobile_app/features/auth/domain/usecases/register_usecase.dart';
// Value-based comparison
import 'package:equatable/equatable.dart';
// BLoC state management
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart'; // Linking the associated state file

/// Cubit responsible for handling authentication-related operations.
class AuthCubit extends Cubit<AuthState> {
  /// Reference to the login use case.
  // ignore: unused_field
  final LoginUseCase _login_usecase;
  /// Reference to the registration use case.
  // ignore: unused_field
  final RegisterUseCase _register_usecase;

  // Static cache of registered user credentials to allow dynamic login of newly registered users (BUG/RFE)
  static String? _registered_email;
  static String? _registered_phone;
  static String? _registered_password;

  // Static cache for admin password to allow mock forgot password updates (BUG/RFE)
  static String _admin_password = "123asdASD!@#";

  /// Constructor requiring the use case instances.
  AuthCubit(this._login_usecase, this._register_usecase) : super(AuthInitial());

  /// Orchestrates the login process for a user.
  /// [identifier] Can be an email or phone number.
  /// [password] The user's secret password.
  Future<void> login(String identifier, String password) async {
    /// Emitting the loading state to update the UI.
    emit(AuthLoading());

    // TODO: START OF DUMMY LOGIN BYPASS - REMOVE ONCE FINAL HOME IS COMPLETED
    // Verify credentials match static criteria or memory cached registered credentials using Yoda style comparison
    final bool is_static_valid = ("admin@gmail.com" == identifier && _admin_password == password);
    final bool is_registered_valid = (null != _registered_password &&
        _registered_password == password &&
        (_registered_email == identifier || _registered_phone == identifier));

    // Handle valid credentials matching either admin or registered user
    if (is_static_valid || is_registered_valid) {
      // Simulate minor network delay for visual loading states
      await Future.delayed(
        // Duration parameter configuration
        const Duration(
          // Delay duration in milliseconds
          milliseconds: 500,
        ),
      );
      // Emit successful authentication state to trigger home screen routing
      emit(AuthSuccess());
      // Return early to skip use case processing
      return;
    } else {
      // Emit error state with instructions for invalid credentials
      emit(
        // Emit error state with instructions
        const AuthError('Invalid phone number or password.'),
      );
      // Return to terminate execution
      return;
    }
    // TODO: END OF DUMMY LOGIN BYPASS
  }

  /// Orchestrates the registration process for a new user.
  Future<void> register({
    required String first_name,
    required String last_name,
    required String email,
    required String phone,
    required String password,
  }) async {
    /// Emitting the loading state.
    emit(AuthLoading());

    // TODO: START OF DUMMY REGISTER BYPASS - REMOVE ONCE FINAL HOME IS COMPLETED
    // Cache the user's registration credentials to allow dynamic login of newly registered users
    _registered_email = email;
    _registered_phone = phone;
    _registered_password = password;

    // Simulate minor network delay for visual loading states
    await Future.delayed(
      // Duration parameter configuration
      const Duration(
        // Delay duration in milliseconds
        milliseconds: 500,
      ),
    );
    // Emit successful authentication state to trigger next flow / success routing
    emit(AuthSuccess());
    // Return early to skip use case processing
    return;
    // TODO: END OF DUMMY REGISTER BYPASS
  }

  /// Initiates the forgot password code request (mock bypass).
  /// [phone] The phone number to dispatch the reset code.
  Future<void> forgot_password(String phone) async {
    /// Emitting the loading state to update UI.
    emit(AuthLoading());

    // Verify phone format check exists or bypass directly
    if (phone.isNotEmpty) {
      // Simulate minor network delay for visual loading states
      await Future.delayed(
        // Duration parameter configuration
        const Duration(
          // Delay duration in milliseconds
          milliseconds: 500,
        ),
      );
      // Emit success state to allow OTP page transition
      emit(AuthSuccess());
      // Return early to skip use case processing
      return;
    } else {
      // Emit error state with instructions
      emit(
        // Emit error state
        const AuthError('Phone number cannot be empty.'),
      );
      // Return to terminate execution
      return;
    }
  }

  /// Verifies the OTP code (mock bypass).
  /// [code] The 6-digit verification code.
  Future<void> verify_otp(String code) async {
    /// Emitting the loading state to update UI.
    emit(AuthLoading());

    // Verify OTP code length matches exactly 6 digits using Yoda comparison
    if (6 == code.length) {
      // Simulate minor network delay for visual loading states
      await Future.delayed(
        // Duration parameter configuration
        const Duration(
          // Delay duration in milliseconds
          milliseconds: 500,
        ),
      );
      // Emit success state to allow page transition
      emit(AuthSuccess());
      // Return early to skip use case processing
      return;
    } else {
      // Emit error state with instructions
      emit(
        // Emit error state
        const AuthError('OTP code must be 6 digits.'),
      );
      // Return to terminate execution
      return;
    }
  }

  /// Updates the password of the registered user (mock reset password bypass).
  /// [new_password] The user's new security password choice.
  Future<void> reset_password({
    required String new_password,
  }) async {
    /// Emitting the loading state to update UI.
    emit(AuthLoading());

    // Verify password is not empty and complies with minimum length using Yoda comparison
    if (8 <= new_password.length) {
      // Simulate minor network delay for visual loading states
      await Future.delayed(
        // Duration parameter configuration
        const Duration(
          // Delay duration in milliseconds
          milliseconds: 500,
        ),
      );
      // If there is a registered user, update their cached password
      if (null != _registered_email) {
        // Assign new password to memory cached password
        _registered_password = new_password;
      } else {
        // Empty action block to satisfy compiler
      }
      // Update admin password as well so that if they reset admin password, it takes effect
      _admin_password = new_password;

      // Emit success state to allow success page routing
      emit(AuthSuccess());
      // Return early to skip use case processing
      return;
    } else {
      // Emit error state with instructions
      emit(
        // Emit error state
        const AuthError('Password must be at least 8 characters.'),
      );
      // Return to terminate execution
      return;
    }
  }

  /// Resets the cubit to its initial state.
  void reset() {
    emit(AuthInitial());
  }
}
