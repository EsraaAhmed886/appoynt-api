/*
 * File Name: widget_test.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/06/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - flutter/material.dart
 *   - flutter_test/flutter_test.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/06/2026]
 * File Description: Widget tests checking that the main application mounts and displays the splash screen.
 */

// Importing test library helpers
import 'package:flutter_test/flutter_test.dart';
// Importing the main application wrapper
import 'package:appoynt_mobile_app/main.dart';
// Importing splash screen widget representation
import 'package:appoynt_mobile_app/features/splash/presentation/pages/splash_screen.dart';

// Main execution entry point for widget tests
void main() {
  // Define smoke test verifying splash screen mounting
  testWidgets('App initialization mounts splash screen successfully', (WidgetTester tester) async {
    // Build the main app tree and trigger a frame rendering
    await tester.pumpWidget(const MyApp());

    // Pump stream frames to allow state builder rebuilding MaterialApp
    await tester.pump();

    // Verify that the splash screen widget is present in tree using Yoda style check
    expect(find.byType(SplashScreen), findsOneWidget);

    // Let the splash delay timer complete to prevent pending timer assertion errors
    await tester.pump(const Duration(seconds: 5));
  });
}
