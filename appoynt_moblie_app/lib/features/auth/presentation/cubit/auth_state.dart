/*
 * File Name: auth_state.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/05/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - auth_cubit.dart (Part of)
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Defines the states for the authentication BLoC/Cubit container.
 */

part of 'auth_cubit.dart'; // Linking this state definition to auth_cubit.dart

// Abstract base class representing all authentication states
abstract class AuthState extends Equatable {
  // Constant constructor for the abstract state
  const AuthState();

  @override
  // Array defining the properties checked in value comparisons
  List<Object?> get props {
    // Return empty list by default
    return [];
  }
}

// Initial state before authentication actions are triggered
class AuthInitial extends AuthState {}

// Loading state while login request is in progress
class AuthLoading extends AuthState {}

// Success state emitted on successful credential validation
class AuthSuccess extends AuthState {}

// Error state emitted when authentication attempts fail
class AuthError extends AuthState {
  // Descriptive warning error message details string
  final String error_message;

  // Constructor mapping the error message parameter
  const AuthError({required this.error_message});

  @override
  // Array defining value comparison variables to check updates
  List<Object?> get props {
    // Return error message parameter list
    return [error_message];
  }
}
