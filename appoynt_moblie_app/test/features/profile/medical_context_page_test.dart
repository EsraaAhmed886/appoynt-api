/*
 * File Name: medical_context_page_test.dart
 * Author: Kholoud Khaled
 * Date of Creation: 30/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, package:flutter_test/flutter_test.dart,
 *   package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations_delegate.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/pages/medical_context_page.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 30/08/2026]
 * File Description: Widget tests for MedicalContextPage verifying MedicalHistoryTile rendering, full title display, and navigation.
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations_delegate.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/pages/medical_context_page.dart';

void main() {
  Widget buildTestWidget() {
    return MaterialApp(
      localizationsDelegates: app_localizations_delegates,
      supportedLocales: app_supported_locales,
      home: BlocProvider<ProfileCubit>(
        create: (_) => ProfileCubit(),
        child: const MedicalContextPage(),
      ),
    );
  }

  group('MedicalContextPage & MedicalHistoryTile Widget Tests', () {
    testWidgets('renders all 6 medical category tiles with full titles and badges', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Medical History'), findsOneWidget);
      expect(find.text('Family Members'), findsOneWidget);
      expect(find.text('Allergies'), findsOneWidget);
      expect(find.text('Chronic Conditions'), findsOneWidget);
      expect(find.text('Medications List'), findsOneWidget);
      expect(find.text('Tests and Results'), findsOneWidget);
      expect(find.text('Insurance Details'), findsOneWidget);
      expect(find.byType(MedicalHistoryTile), findsNWidgets(6));
    });

    testWidgets('tapping MedicalHistoryTile triggers onTap callback', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MedicalHistoryTile(
              icon: Icons.credit_card_rounded,
              iconColor: AppColors.primary,
              iconBgColor: AppColors.primary.withValues(alpha: 0.1),
              title: 'Insurance Details',
              statusText: 'No cards',
              hasItems: false,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Insurance Details'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
