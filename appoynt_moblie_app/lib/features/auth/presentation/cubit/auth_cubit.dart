/*
 * File Name: auth_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/05/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - package:equatable/equatable.dart
 *   - package:flutter_bloc/flutter_bloc.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Manages the authentication state changes and business logic.
 */

// Importing standard value comparison helper from Equatable
import 'package:equatable/equatable.dart';
// Importing BLoC framework state management cubit base class
import 'package:flutter_bloc/flutter_bloc.dart';

// Declare parts state file mapping
part 'auth_state.dart';

// Cubit controller processing authentication business flow states
class AuthCubit extends Cubit<AuthState> {
  // Constructor initializing the cubit with the initial AuthInitial state
  AuthCubit()
      : super(
          // Set state to initial AuthInitial instance
          AuthInitial(),
        );

  // Method executing the user authentication workflow
  Future<void> login(String user_identifier, String user_password) async {
    // Emit loading state indicator to render action spinners in UI
    emit(AuthLoading());

    // Artificial delay to simulate network roundtrip API calls (two seconds)
    await Future.delayed(
      // Set duration parameter
      const Duration(seconds: 2),
    );

    // Emit successful state indicator to trigger redirects or success flows
    emit(AuthSuccess());
  }

  // Method to reset the cubit state back to initial settings
  void reset_state() {
    // Emit initial auth state
    emit(AuthInitial());
  }
}
