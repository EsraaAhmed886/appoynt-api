/*
 * File Name: auth_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: 
 *   - package:equatable/equatable.dart
 *   - package:flutter_bloc/flutter_bloc.dart
 *   - login_usecase.dart
 *   - register_usecase.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 02/07/2026]
 * File Description:
 *   Manages the authentication states and business logic for the application. 
 *   It handles user login and registration requests by interacting with the domain layer.
 */

import 'package:appoynt_mobile_app/features/auth/domain/usecases/login_usecase.dart'; // Login logic
import 'package:appoynt_mobile_app/features/auth/domain/usecases/register_usecase.dart'; // Registration logic
import 'package:equatable/equatable.dart'; // Value-based comparison
import 'package:flutter_bloc/flutter_bloc.dart'; // BLoC state management

part 'auth_state.dart'; // Linking the associated state file

/// Cubit responsible for handling authentication-related operations.
class AuthCubit extends Cubit<AuthState> {
  /// Reference to the login use case.
  final LoginUseCase _login_usecase;
  /// Reference to the registration use case.
  final RegisterUseCase _register_usecase;

  /// Constructor requiring the use case instances.
  AuthCubit(this._login_usecase, this._register_usecase) : super(AuthInitial());

  /// Orchestrates the login process for a user.
  /// [identifier] Can be an email or phone number.
  /// [password] The user's secret password.
  Future<void> login(String identifier, String password) async {
    /// Emitting the loading state to update the UI.
    emit(AuthLoading());

    /// Executing the login action through the domain layer.
    final result = await _login_usecase(
      LoginParams(identifier: identifier, password: password),
    );

    /// Handling the result of the login operation.
    result.fold(
      /// Emitting an error state if the login failed.
      (failure) {
        emit(const AuthError('Login failed. Please check your credentials.'));
      },
      /// Emitting a success state if the login was successful.
      (user) {
        emit(AuthSuccess());
      },
    );
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

    /// Executing the registration action through the domain layer.
    final result = await _register_usecase(
      RegisterParams(
        first_name: first_name,
        last_name: last_name,
        email: email,
        phone: phone,
        password: password,
      ),
    );

    /// Handling the result of the registration operation.
    result.fold(
      /// Emitting an error state if registration failed.
      (failure) {
        emit(const AuthError('Registration failed. Please try again.'));
      },
      /// Emitting a success state if registration was successful.
      (user) {
        emit(AuthSuccess());
      },
    );
  }

  /// Resets the cubit to its initial state.
  void reset() {
    emit(AuthInitial());
  }
}
