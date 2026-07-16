/*
 * File Name: global_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/05/2026
 * Version Information: V1.0.0
 * Dependencies: package:equatable/equatable.dart, package:flutter/material.dart,
 *   package:flutter_bloc/flutter_bloc.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Manages global configuration changes and notifies listening widgets.
 */

// Importing dart:ui to access system level platform locale features
import 'dart:ui';
// Importing standard equatable library dependency for value comparison helper
import 'package:equatable/equatable.dart';

// Importing flutter bloc package for state management
import 'package:flutter_bloc/flutter_bloc.dart';

// Declare state parts file mapping
part 'global_state.dart';

// Cubit manager processing global configuration states
class GlobalCubit extends Cubit<GlobalState> {
  // Constructor initializing state with the system/device language as default (BUG/RFE)
  GlobalCubit()
      : super(
          // Set state to initial GlobalState parameter configurations
          GlobalState(
            // Set the default locale to the device platform language code or fallback to English
            active_locale: PlatformDispatcher.instance.locale.languageCode.startsWith('ar')
                // Use Arabic locale if device language starts with ar
                ? const Locale('ar')
                // Otherwise use English locale as standard default fallback
                : const Locale('en'),
          ),
        );

  // Method to toggle the application's active language between English and Arabic
  void toggle_language() {
    // Determine the next locale target using a ternary language check with Yoda comparison style
    final Locale target_locale = 'en' == state.active_locale.languageCode
        // Set to Arabic if current is English
        ? const Locale('ar')
        // Set to English if current is Arabic
        : const Locale('en');

    // Emit the updated state with the new locale parameter settings
    emit(
      // Emit the new GlobalState configuration
      GlobalState(
        // Set the active locale parameter settings
        active_locale: target_locale,
      ),
    );
  }
}
