/*
 * File Name: main.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/06/2026
 * Version Information: 1.0.0
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
          // Set light mode theme configuration import
          theme: light_mode_theme,
          // Set dark mode theme configuration import
          darkTheme: dark_mode_theme,
          // Bind active theme mode property value to dynamic state notifier
          themeMode: ThemeMode.dark,
          // Set the localizations delegates to support custom bilingual engine translations
          localizationsDelegates: app_localizations_delegates,
          // Define supported locales list for the application context
          supportedLocales: app_supported_locales,
          // Defining the landing splash screen as the initial home page
          home: const SplashScreen(),
        );
      },
    );
  }
}

// Defining MyHomePage widget to display the counter UI
class MyHomePage extends StatefulWidget {
  // Constructor initializing the widget key and title parameter
  const MyHomePage({super.key, required this.title});

  // Page title variable definition
  final String title;

  // Creating the state instance for MyHomePage
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Defining state class for MyHomePage widget
class _MyHomePageState extends State<MyHomePage> {
  // Declaring counter integer variable initialized to zero
  int counter_value = 0;

  // Function to increment the counter value
  void increment_counter() {
    // Call setState to refresh visual elements
    setState(() {
      // Increment the counter state variable
      counter_value++;
    });
  }

  // Build method rendering the counter page layout
  @override
  Widget build(BuildContext context) {
    // Return scaffold container for page layout
    return Scaffold(
      // Configure top navigation app bar
      appBar: AppBar(
        // Set title text widget
        title: Text(widget.title),
        // List of widgets placed in app bar action area
        actions: [
          // Icon button to toggle between light and dark themes
          IconButton(
            // Set callback function when button is clicked
            onPressed: () {
              // Retrieve current theme mode from notifier
              final ThemeMode current = theme_mode_notifier.current_theme_mode;
              // Check if current theme is dark mode using Yoda comparison
              if (ThemeMode.dark == current) {
                // Set theme mode to light mode
                theme_mode_notifier.set_theme_mode(ThemeMode.light);
              }
              // Else check if current theme is light mode using Yoda comparison
              else if (ThemeMode.light == current) {
                // Set theme mode to dark mode
                theme_mode_notifier.set_theme_mode(ThemeMode.dark);
              }
              // Else fall back case representing system theme state
              else {
                // Toggle theme mode to dark mode as default action
                theme_mode_notifier.set_theme_mode(ThemeMode.dark);
              }
            },
            // Icon representing brightness selection state
            icon: const Icon(Icons.brightness_6),
          ),
        ],
      ),
      // Center layout container for the main body
      body: Center(
        // Column layout for vertical elements placement
        child: Column(
          // Center items vertically
          mainAxisAlignment: MainAxisAlignment.center,
          // List of widgets inside the column
          children: <Widget>[
            // Label displaying instructional static text
            const Text(
              // The text string shown above the counter
              'You have pushed the button this many times:',
            ),
            // Text widget presenting the current counter value
            Text(
              // Interpolating counter value string representation
              '$counter_value',
              // Visual text style settings from theme
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      // Floating button to trigger increment action
      floatingActionButton: FloatingActionButton(
        // Action event callback function reference
        onPressed: increment_counter,
        // Tooltip description of button
        tooltip: 'Increment',
        // Child icon widget
        child: const Icon(Icons.add),
      ),
    );
  }
}
// End of main.dart
