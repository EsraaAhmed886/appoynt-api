/*
 * File Name: session_manager.dart
 * Author: Kholoud Khaled
 * Date of Creation: 10/08/2026
 * Version Information: V2.0.0
 * Dependencies: package:flutter/material.dart, package:get_it/get_it.dart,
 *   token_storage.dart, auth_cubit.dart, routes.dart, error_handler.dart, app_colors.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 27/08/2026]
 * File Description: Singleton service that owns the global NavigatorKey and
 *   orchestrates the full HTTP 401 session-expiry flow: token purge, AuthCubit
 *   state reset, navigation to LoginPage, and user-facing SnackBar feedback.
 *   Designed as a context-free utility so it can be called from the Dio
 *   interceptor layer without requiring a BuildContext.
 */

// Importing async library for stream controller support
import 'dart:async';
// Importing Flutter material package for NavigatorState and SnackBar
import 'package:flutter/material.dart';
// Importing GetIt for service-locator access to AuthCubit singleton
import 'package:get_it/get_it.dart';
// Importing error handler for mapping error keys to human-readable strings
import 'package:appoynt_mobile_app/core/error/error_handler.dart';
// Importing app colors for design system styling
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
// Importing secure token storage layer for purging tokens on session expiry
import 'package:appoynt_mobile_app/core/storage/token_storage.dart';
// Importing route name constants for navigating to login screen
import 'package:appoynt_mobile_app/core/routing/routes.dart';
// Importing AuthCubit to emit unauthenticated state on session expiry
import 'package:appoynt_mobile_app/features/auth/presentation/cubit/auth_cubit.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SESSION MANAGER
// ─────────────────────────────────────────────────────────────────────────────

// Singleton service orchestrating the full 401 session expiry logout flow
class SessionManager {
  // Private constructor preventing direct external instantiation
  SessionManager._();

  // Singleton instance of the SessionManager class
  static final SessionManager instance = SessionManager._();

  // Global navigator key shared with MaterialApp for context-free navigation
  final GlobalKey<NavigatorState> navigator_key =
      GlobalKey<NavigatorState>(debugLabel: 'session_manager_nav_key');

  // Guard flag preventing duplicate logout flows from concurrent 401 responses
  bool _is_handling_expiry = false;

  // Orchestrates the complete session expiry response triggered by HTTP 401
  Future<void> handle_session_expired({
    // Localized message to display in the session expiry SnackBar
    required String localized_message,
  }) async {
    // Prevent re-entrant calls from multiple concurrent 401 responses
    if (_is_handling_expiry) {
      // A session expiry flow is already in progress — skip duplicate handling
      return;
    } else {
      // Mark expiry handling as active to block concurrent calls
      _is_handling_expiry = true;
    }

    // Resolve human-readable error text to prevent raw key exposure
    final String clean_message = ErrorHandler.mapBackendErrorKey(localized_message);

    // STEP 1: Purge all locally stored authentication tokens immediately
    await TokenStorage.clear_access_token();

    // STEP 2: Emit AuthUnauthenticated state through the AuthCubit singleton
    try {
      // Retrieve the registered AuthCubit singleton from the service locator
      final AuthCubit auth_cubit = GetIt.instance<AuthCubit>();
      // Guard against emitting on a closed cubit instance
      if (!auth_cubit.isClosed) {
        // Trigger the unauthenticated state to propagate to all BlocListeners
        auth_cubit.force_unauthenticated();
      } else {
        // AuthCubit is already closed — skip state emission silently
      }
    } catch (lookup_error) {
      // GetIt lookup failed — AuthCubit may not yet be registered
      debugPrint(
        '[SessionManager] AuthCubit lookup failed during 401 handling: '
        '$lookup_error',
      );
    }

    // STEP 3: Navigate to the Login screen, clearing the full navigation stack
    final NavigatorState? nav = navigator_key.currentState;
    // Guard against navigation when the navigator is not yet mounted
    if (null != nav) {
      // Push login route and remove all previous routes from the back stack
      nav.pushNamedAndRemoveUntil(
        // Target login route name constant
        Routes.login,
        // Remove all routes below to prevent back-navigation to protected screens
        (Route<dynamic> route) => false,
      );
    } else {
      // Navigator is not yet available — skip navigation step silently
      debugPrint(
        '[SessionManager] Navigator not available — '
        'cannot redirect to Login on 401.',
      );
    }

    // STEP 4: Show a localized session expiry SnackBar to inform the user
    final BuildContext? overlay_context =
        navigator_key.currentContext;
    // Guard against showing SnackBar when context is not mounted
    if (null != overlay_context) {
      // Ensure SnackBar is displayed after the navigation transition completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Retrieve the ScaffoldMessenger from the navigator overlay context
        ScaffoldMessenger.of(overlay_context).showSnackBar(
          // Configure SnackBar with session expiry message and styling
          SnackBar(
            // Display the clean localized session expiry message string
            content: Text(clean_message),
            // Auto-dismiss after 3 seconds for non-intrusive UX
            duration: const Duration(seconds: 3),
            // Style with error color to signal an important state change
            backgroundColor: AppColors.error,
            // Action allowing the user to manually dismiss the message
            action: SnackBarAction(
              // Dismiss action label
              label: 'OK',
              // White label color for contrast on the red background
              textColor: AppColors.white,
              // Callback to dismiss the SnackBar on tap
              onPressed: () {
                // Hide the SnackBar when the user taps the action button
                ScaffoldMessenger.of(overlay_context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      });
    } else {
      // No mounted context available — skip the SnackBar notification silently
      debugPrint(
        '[SessionManager] No mounted context — '
        'cannot show session expired SnackBar.',
      );
    }

    // STEP 5: Reset the re-entrant guard flag after a safe cooldown delay
    await Future.delayed(const Duration(seconds: 3));
    // Reset the flag so future 401s can be handled after the cooldown
    _is_handling_expiry = false;
  }
}

