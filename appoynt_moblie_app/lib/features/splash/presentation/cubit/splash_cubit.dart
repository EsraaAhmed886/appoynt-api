/*
 * File Name: splash_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/06/2026
 * Version Information: V2.0.0
 * Dependencies:
 *   - package:flutter_bloc/flutter_bloc.dart
 *   - package:equatable/equatable.dart
 *   - get_user_profile_usecase.dart
 *   - service_locator.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Cubit responsible for managing the initialization logic of
 *   the splash screen. After the splash delay, triggers a fire-and-forget
 *   background profile preload so SharedPreferences cache is populated before
 *   the user navigates to the Profile screen, achieving zero-latency rendering.
 */

// Importing flutter bloc package for core BLoC architecture classes
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing equatable package to enable simple object comparisons
import 'package:equatable/equatable.dart';
// Importing application dimensions and spacing constants definition
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
// Importing service locator for GetUserProfileUseCase access
import 'package:appoynt_mobile_app/core/di/service_locator.dart';
// Importing GetUserProfileUseCase for background profile preloading
import 'package:appoynt_mobile_app/features/profile/domain/usecases/get_user_profile_usecase.dart';
// Importing Flutter foundation for debug logging support
import 'package:flutter/foundation.dart';
// Importing TokenStorage to guard preload behind authentication check
import 'package:appoynt_mobile_app/core/storage/token_storage.dart';

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

    // Fire-and-forget background profile preload AFTER splash is done.
    // This warms the SharedPreferences cache so the ProfilePage renders
    // instantly when the user first navigates to it post-authentication.
    _preload_profile_in_background();
  }

  // Silently preloads and caches the user profile in the background.
  // Called fire-and-forget after SplashDone — does NOT affect splash flow.
  void _preload_profile_in_background() async {
    // Guard: only attempt preload when an authenticated token is present
    final String? token = await TokenStorage.get_access_token();
    // Skip preload silently when no active authentication token is found
    if (null == token || token.isEmpty) {
      // User is not authenticated — skip profile preload to avoid 401
      debugPrint(
        '[SplashCubit] Profile preload skipped — '
        'no authentication token found.',
      );
      // Return early without attempting an API call
      return;
    } else {
      // Authentication token is present — proceed with background preload
    }
    // Attempt to fetch and auto-cache profile via the GetUserProfileUseCase
    try {
      // Call the use case which internally writes the result to local cache
      await get_it<GetUserProfileUseCase>().call();
      // Log successful preload to the debug console for diagnostics
      debugPrint(
        '[SplashCubit] Background profile preload completed successfully.',
      );
    } catch (preload_error) {
      // Preload failed — log but do not affect any UI state or emit errors
      debugPrint(
        '[SplashCubit] Background profile preload failed (non-fatal): '
        '$preload_error',
      );
    }
  }
}
// End of splash_cubit.dart
