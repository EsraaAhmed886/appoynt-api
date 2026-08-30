/*
 * File Name: ask_ai_dummy_view_test.dart
 * Author: Kholoud Khaled
 * Date of Creation: 29/08/2026
 * Version Information: V1.2.0
 * Dependencies: package:flutter/material.dart, package:flutter_test/flutter_test.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations_delegate.dart,
 *   package:appoynt_mobile_app/core/routing/routes.dart,
 *   package:appoynt_mobile_app/features/ask_ai/presentation/views/ask_ai_dummy_view.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 29/08/2026]
 * File Description: Widget tests for AskAiDummyView verifying UI rendering, feature cards, and navigation.
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations_delegate.dart';
import 'package:appoynt_mobile_app/core/routing/routes.dart';
import 'package:appoynt_mobile_app/features/ask_ai/presentation/views/ask_ai_dummy_view.dart';

void main() {
  Widget createTestWidget({Locale locale = const Locale('en')}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: app_localizations_delegates,
      supportedLocales: app_supported_locales,
      home: const AskAiDummyView(),
    );
  }

  group('AskAiDummyView Widget Tests', () {
    testWidgets('renders bot avatar, badges, title, feature cards and back button in English',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Ask AI Assistant'), findsOneWidget);
      expect(find.text('✨ Coming Soon'), findsOneWidget);
      expect(find.text('Appoynt AI Health Assistant'), findsOneWidget);
      expect(find.text('Symptom Consultation'), findsOneWidget);
      expect(find.text('Smart Booking & Follow-up'), findsOneWidget);
      expect(find.text('Back to Home'), findsOneWidget);
      expect(find.byIcon(Icons.smart_toy_rounded), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });

    testWidgets('renders localized copy in Arabic',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(locale: const Locale('ar')));
      await tester.pumpAndSettle();

      expect(find.text('مساعد الذكاء الاصطناعي'), findsOneWidget);
      expect(find.text('✨ ميزة قادمة قريباً'), findsOneWidget);
      expect(find.text('مساعد Appoynt الذكي'), findsOneWidget);
      expect(find.text('استشارات وتحليل أعراض'), findsOneWidget);
      expect(find.text('حجز ذكي ومتابعة مواعيد'), findsOneWidget);
      expect(find.text('العودة للرئيسية'), findsOneWidget);
    });

    testWidgets('tapping leading custom rounded card back button pops the view',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: app_localizations_delegates,
          supportedLocales: app_supported_locales,
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AskAiDummyView()),
                  );
                },
                child: const Text('Open AI'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open AI'));
      await tester.pumpAndSettle();

      expect(find.byType(AskAiDummyView), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(AskAiDummyView), findsNothing);
    });

    testWidgets('tapping Back to Home resets navigation to Routes.home',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: app_localizations_delegates,
          supportedLocales: app_supported_locales,
          routes: {
            Routes.home: (_) => const Scaffold(body: Text('Home Root View')),
          },
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AskAiDummyView()),
                  );
                },
                child: const Text('Open AI'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open AI'));
      await tester.pumpAndSettle();

      expect(find.byType(AskAiDummyView), findsOneWidget);

      final Finder backToHomeFinder = find.text('Back to Home');
      await tester.ensureVisible(backToHomeFinder);
      await tester.pumpAndSettle();

      await tester.tap(backToHomeFinder);
      await tester.pumpAndSettle();

      expect(find.text('Home Root View'), findsOneWidget);
      expect(find.byType(AskAiDummyView), findsNothing);
    });
  });
}
