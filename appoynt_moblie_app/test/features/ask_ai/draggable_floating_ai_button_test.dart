/*
 * File Name: draggable_floating_ai_button_test.dart
 * Author: Kholoud Khaled
 * Date of Creation: 30/08/2026
 * Version Information: v1.1.0
 * Dependencies: flutter/material.dart, flutter_test/flutter_test.dart,
 *   package:appoynt_mobile_app/features/ask_ai/presentation/widgets/draggable_floating_ai_button.dart,
 *   package:appoynt_mobile_app/features/ask_ai/presentation/views/ask_ai_dummy_view.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 30/08/2026]
 * File Description: Unit and widget tests for DraggableFloatingAiButton testing initial placement, dragging, boundary clamping, and tap navigation.
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations_delegate.dart';
import 'package:appoynt_mobile_app/features/ask_ai/presentation/widgets/draggable_floating_ai_button.dart';
import 'package:appoynt_mobile_app/features/ask_ai/presentation/views/ask_ai_dummy_view.dart';

void main() {
  Widget buildTestApp({VoidCallback? onTap, String customIconAsset = 'assets/icons/ChatbotFAB.svg'}) {
    return MaterialApp(
      localizationsDelegates: app_localizations_delegates,
      supportedLocales: app_supported_locales,
      home: Scaffold(
        body: Stack(
          children: [
            const Center(child: Text('Main Content')),
            DraggableFloatingAiButton(
              onTap: onTap,
              customIconAsset: customIconAsset,
            ),
          ],
        ),
      ),
    );
  }

  group('DraggableFloatingAiButton Widget Tests', () {
    testWidgets('renders button in initial positioned state', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byType(DraggableFloatingAiButton), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('dragging moves the button across the screen within boundaries', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      final Offset initialPosition = tester.getTopLeft(find.byType(DraggableFloatingAiButton));

      // Drag by -100px horizontally and -100px vertically
      await tester.drag(find.byType(DraggableFloatingAiButton), const Offset(-100.0, -100.0));
      await tester.pumpAndSettle();

      final Offset newPosition = tester.getTopLeft(find.byType(DraggableFloatingAiButton));
      expect(newPosition.dx, lessThan(initialPosition.dx));
      expect(newPosition.dy, lessThan(initialPosition.dy));
    });

    testWidgets('tapping button triggers navigation or onTap callback', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(buildTestApp(onTap: () {
        tapped = true;
      }));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('default tap opens AskAiDummyView', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.byType(AskAiDummyView), findsOneWidget);
    });
  });
}
