/*
 * File Name: main.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/06/2026
 * Version Information: 1.0.0
 * Dependencies: flutter/material.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/06/2026]
 * File Description: Default counter app for Flutter setup, styled to follow repository guidelines.
 */

// Importing flutter material library for UI widgets
import 'package:flutter/material.dart';

// The main entry point function of the program
void main() {
  // Execute and run the root widget application
  runApp(const MyApp());
}

// Defining the MyApp class which represents the root widget
class MyApp extends StatelessWidget {
  // Constructor initializing the widget key
  const MyApp({super.key});

  // Build method creating the material application instance
  @override
  Widget build(BuildContext context) {
    // Return MaterialApp configured with theme and title
    return MaterialApp(
      // Setting the app title
      title: 'Flutter Demo',
      // Setting the light theme
      theme: ThemeData(
        // Configure color scheme using seed color
        colorScheme: ColorScheme.fromSeed(
          // Define seed color
          seedColor: Colors.deepPurple,
        ),
        // Enable material 3 design standard
        useMaterial3: true,
      ),
      // Defining the home landing page of the application
      home: const MyHomePage(
        // Set page title parameter
        title: 'Flutter Demo Home Page',
      ),
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
        // Set background color from color scheme
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Set title text widget
        title: Text(widget.title),
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
