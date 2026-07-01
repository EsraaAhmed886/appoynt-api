/*
 * File Name: splash_state.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/06/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - package:appoynt_mobile_app/features/splash/presentation/cubit/splash_cubit.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 19/06/2026]
 * File Description: Defines the states for the SplashCubit state machine.
 */

// Bind this file as a part of the splash cubit parent scope library
part of 'splash_cubit.dart';

// Base class representing all potential state outputs of the splash flow
abstract class SplashState extends Equatable {
  // Const constructor configuration for state instances
  const SplashState();

  // Override getter mapping comparison properties
  @override
  List<Object> get props {
    // Return empty list as default property values
    return const [];
  }
}

// Initial default state of the splash view indicating loading has started
class SplashInitial extends SplashState {
  // Override getter mapping comparison properties
  @override
  List<Object> get props {
    // Return empty list as default property values
    return const [];
  }
}

// Final state emitted indicating splash loading and animations are complete
class SplashDone extends SplashState {
  // Override getter mapping comparison properties
  @override
  List<Object> get props {
    // Return empty list as default property values
    return const [];
  }
}
// End of splash_state.dart
