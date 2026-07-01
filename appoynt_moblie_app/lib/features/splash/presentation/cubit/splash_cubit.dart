/*
 * File Name: splash_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/06/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - package:flutter_bloc/flutter_bloc.dart
 *   - package:equatable/equatable.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 19/06/2026]
 * File Description: Cubit responsible for managing the initialization logic of the splash screen.
 */

// Importing flutter bloc package for core BLoC architecture classes
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing equatable package to enable simple object comparisons
import 'package:equatable/equatable.dart';
// Importing application dimensions and spacing constants definition
import 'package:appoynt_mobile_app/constants/app_spacing.dart';

// Declare parts file for the splash states configuration mapping
part 'splash_state.dart';

// Cubit responsible for orchestrating the initial loading logic of the splash view
class SplashCubit extends Cubit<SplashState> {
  // Constructor initializing the cubit with the initial state instance
  SplashCubit() : super(SplashInitial());

  // Logic to execute when the mobile application has successfully booted
  void app_started() async {
    // Wait for the defined splash delay representing startup loading tasks
    await Future.delayed(
      // Create duration instance utilizing central spacing constant
      const Duration(
        // Set delay in milliseconds
        milliseconds: AppSpacing.duration_splash_delay_ms,
      ),
    );

    // Emit the done state indicating readiness to route to the main screen
    emit(SplashDone());
  }
}
// End of splash_cubit.dart
