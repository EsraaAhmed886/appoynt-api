/*
 * File Name: main.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/06/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - flutter/material.dart
 *   - package:appoynt_mobile_app/core/theme/modes/light_mode.dart
 *   - package:appoynt_mobile_app/core/theme/modes/dark_mode.dart
 *   - package:appoynt_mobile_app/core/theme/modes/theme_mode.dart
 *   - package:appoynt_mobile_app/features/splash/presentation/pages/splash_screen.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/06/2026]
 * File Description: Entry point of the Appoynt mobile application, configuring themes and initial splash route.
 */

// Importing central presentation and UI barrel exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing initial splash screen landing widget
import 'package:appoynt_mobile_app/features/splash/presentation/pages/splash_screen.dart';
// Importing flutter bloc package for state management provider scopes
import 'package:flutter_bloc/flutter_bloc.dart';

// Global notifier instance for managing application theme mode changes
final ThemeModeNotifier theme_mode_notifier = ThemeModeNotifier();

// The main entry point function of the mobile application
void main() async {
  // Ensure framework services and widget bindings are fully initialized before running async tasks
  WidgetsFlutterBinding.ensureInitialized();

  // Load the persisted theme configuration from secure local storage
  await theme_mode_notifier.load_theme_mode();

  // Execute and run the root widget application
  runApp(const MyApp());
}

// Defining the MyApp class which represents the root widget of the application
class MyApp extends StatelessWidget {
  // Constructor initializing the widget key
  const MyApp({super.key});

  // Build method creating the material application instance with listeners
  @override
  Widget build(BuildContext context) {
    // Return BlocProvider setting up global logic cubit on top of tree
    return BlocProvider<GlobalCubit>(
      // Create and initialize new global cubit instance
      create: (context) {
        // Return initialized global cubit
        return GlobalCubit();
      },
      // Bind Builder widget to execute next child builds
      child: BlocBuilder<GlobalCubit, GlobalState>(
        // Builder mapping the global settings to child app tree
        builder: (context, state) {
          // Return ListenableBuilder to rebuild MaterialApp when theme changes
          return ListenableBuilder(
            // Bind notifier dependency to the global theme mode notifier
            listenable: theme_mode_notifier,
            // Builder callback defining UI hierarchy around MaterialApp
            builder: (context, child) {
              // Return MaterialApp configured with theme tokens and initial page
              return MaterialApp(
                // Setting the application title name
                title: 'Appoynt',
                // Disable default debug banner indicator from top corner
                debugShowCheckedModeBanner: false,
                // Apply the active locale from the global state
                locale: state.active_locale,
                // Set light mode theme configuration import
                theme: light_mode_theme,
                // Set dark mode theme configuration import
                darkTheme: dark_mode_theme,
                // Bind active theme mode property value to dynamic state notifier
                // themeMode: theme_mode_notifier.current_theme_mode,
                themeMode: ThemeMode.light,
                // Set the localizations delegates to support custom bilingual engine translations
                localizationsDelegates: app_localizations_delegates,
                // Define supported locales list for the application context
                supportedLocales: app_supported_locales,
                // Defining the landing splash screen as the initial home page
                home: const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
// End of main.dart
