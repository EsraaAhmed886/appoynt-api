/*
 * File Name: custom_snackbar_test.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:flutter_test/flutter_test.dart,
 *   package:appoynt_mobile_app/core/utils/custom_snackbar.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Unit and widget verification tests for the animated top banner and toast notification system.
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoynt_mobile_app/core/utils/custom_snackbar.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';

void main() {
  Widget createTestableWidget({required Widget child}) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('CustomSnackBar Top Toast Tests', () {
    testWidgets('CustomSnackBar.success renders animated top toast with success styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => CustomSnackBar.success(context, 'Success message'),
              child: const Text('Show Success'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Success'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Success message'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

      // Verify Container background styling
      final containerFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          final decoration = widget.decoration as BoxDecoration;
          return decoration.color == AppColors.successBg;
        } else {
          return false;
        }
      });
      expect(containerFinder, findsOneWidget);

      // Settle animations
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    });

    testWidgets('CustomSnackBar.error renders animated top toast with error styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => CustomSnackBar.error(context, 'Error occurred'),
              child: const Text('Show Error'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Error'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Error occurred'), findsOneWidget);
      expect(find.byIcon(Icons.cancel_rounded), findsOneWidget);

      // Verify Container background styling
      final containerFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          final decoration = widget.decoration as BoxDecoration;
          return decoration.color == AppColors.errorBg;
        } else {
          return false;
        }
      });
      expect(containerFinder, findsOneWidget);

      // Settle animations
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    });

    testWidgets('CustomSnackBar.warning renders with warning styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => CustomSnackBar.warning(context, 'Warning note'),
              child: const Text('Show Warning'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Warning'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Warning note'), findsOneWidget);
      expect(find.byIcon(Icons.warning_rounded), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    });

    testWidgets('CustomSnackBar.info renders with info styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => CustomSnackBar.info(context, 'Info details'),
              child: const Text('Show Info'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Info'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Info details'), findsOneWidget);
      expect(find.byIcon(Icons.info_rounded), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    });

    testWidgets('CustomSnackBar dismisses upon user tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => CustomSnackBar.info(
                context,
                'Tap to dismiss',
                duration: const Duration(seconds: 10),
              ),
              child: const Text('Show Dismissible'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dismissible'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Tap to dismiss'), findsOneWidget);

      // Tap on the toast to dismiss
      await tester.tap(find.text('Tap to dismiss'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.text('Tap to dismiss'), findsNothing);
    });

    testWidgets('CustomSnackBar triggers action callback when action button is tapped',
        (WidgetTester tester) async {
      bool actionTriggered = false;

      await tester.pumpWidget(
        createTestableWidget(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => CustomSnackBar.show(
                context,
                message: 'Action message',
                type: SnackBarType.info,
                actionLabel: 'UNDO',
                onAction: () {
                  actionTriggered = true;
                },
              ),
              child: const Text('Show Action Toast'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Action Toast'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('UNDO'), findsOneWidget);

      await tester.tap(find.text('UNDO'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(actionTriggered, isTrue);
    });
  });
}
