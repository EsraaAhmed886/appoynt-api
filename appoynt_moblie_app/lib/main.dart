/*
 * File Name: main.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/06/2026
 * Version Information: V1.0.0
 * Dependencies: flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/splash/presentation/pages/splash_screen.dart,
 *   package:appoynt_mobile_app/core/widgets/connectivity_wrapper.dart,
 *   package:appoynt_mobile_app/core/di/service_locator.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Entry point of the Appoynt mobile application,
 *   configuring themes and initial splash route.
 */

// Importing central presentation and UI barrel exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing initial splash screen landing widget
import 'package:appoynt_mobile_app/features/splash/presentation/pages/splash_screen.dart';
// Importing global connectivity state wrapper widget representation
import 'package:appoynt_mobile_app/core/widgets/connectivity_wrapper.dart';
// Importing dependency injection service locator setup representation
import 'package:appoynt_mobile_app/core/di/service_locator.dart';
// Importing session manager for global navigator key and 401 logout flow
import 'package:appoynt_mobile_app/core/services/session_manager.dart';
// Importing flutter bloc package for state management provider scopes
import 'package:flutter_bloc/flutter_bloc.dart';

// Global notifier instance for managing application theme mode changes
final ThemeModeNotifier theme_mode_notifier = ThemeModeNotifier();

// The main entry point function of the mobile application
void main() async {
  // Ensure framework services and widget bindings are fully initialized before running async tasks
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the service locator dependencies container
  await setup_service_locator();

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
                themeMode: theme_mode_notifier.current_theme_mode,
                // Set the localizations delegates to support custom bilingual engine translations
                localizationsDelegates: app_localizations_delegates,
                // Define supported locales list for the application context
                supportedLocales: app_supported_locales,
                // Defining the landing splash screen as the initial home page
                home: const SplashScreen(),
                // Configure routes generator to map route settings
                onGenerateRoute: AppRouter.generateRoute,
                // Bind the global navigator key from SessionManager to enable
                // context-free navigation triggered by the 401 Dio interceptor
                navigatorKey: SessionManager.instance.navigator_key,
                // Wrapping the navigator to globally show NoInternetPage when offline
                builder: (context, child) {
                  // Return dynamic connectivity widget wrapping children
                  return ConnectivityWrapper(child: child!);
                },
              );
            },
          );
        },
      ),
    );
  }
}
// End of main.dart
