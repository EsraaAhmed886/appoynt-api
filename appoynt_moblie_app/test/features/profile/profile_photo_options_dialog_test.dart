/*
 * File Name: profile_photo_options_dialog_test.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:flutter_test/flutter_test.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/widgets/profile_photo_options_dialog.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations_delegate.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Unit and widget verification tests for ProfilePhotoOptionsDialog.
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/widgets/profile_photo_options_dialog.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations_delegate.dart';

void main() {
  Widget createTestWidget({
    required Widget child,
    Locale locale = const Locale('en'),
  }) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: app_localizations_delegates,
      supportedLocales: app_supported_locales,
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('ProfilePhotoOptionsDialog Widget Tests', () {
    testWidgets(
        'renders all 3 options including Delete Photo when hasExistingPhoto is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: ProfilePhotoOptionsDialog(
            hasExistingPhoto: true,
            onGalleryTap: () {},
            onCameraTap: () {},
            onDeleteTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Update Profile Photo'), findsOneWidget);
      expect(find.text('Choose from Gallery'), findsOneWidget);
      expect(find.text('Take a Photo'), findsOneWidget);
      expect(find.text('Delete Photo'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      expect(find.byIcon(Icons.photo_library_outlined), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);
    });

    testWidgets('hides Delete Photo option when hasExistingPhoto is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: ProfilePhotoOptionsDialog(
            hasExistingPhoto: false,
            onGalleryTap: () {},
            onCameraTap: () {},
            onDeleteTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Update Profile Photo'), findsOneWidget);
      expect(find.text('Choose from Gallery'), findsOneWidget);
      expect(find.text('Take a Photo'), findsOneWidget);
      expect(find.text('Delete Photo'), findsNothing);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets(
        'triggers onGalleryTap callback when gallery option is tapped',
        (WidgetTester tester) async {
      bool galleryTapped = false;

      await tester.pumpWidget(
        createTestWidget(
          child: ProfilePhotoOptionsDialog(
            hasExistingPhoto: true,
            onGalleryTap: () {
              galleryTapped = true;
            },
            onCameraTap: () {},
            onDeleteTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Choose from Gallery'));
      await tester.pumpAndSettle();

      expect(galleryTapped, isTrue);
    });

    testWidgets(
        'triggers onCameraTap callback when camera option is tapped',
        (WidgetTester tester) async {
      bool cameraTapped = false;

      await tester.pumpWidget(
        createTestWidget(
          child: ProfilePhotoOptionsDialog(
            hasExistingPhoto: true,
            onGalleryTap: () {},
            onCameraTap: () {
              cameraTapped = true;
            },
            onDeleteTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Take a Photo'));
      await tester.pumpAndSettle();

      expect(cameraTapped, isTrue);
    });

    testWidgets(
        'triggers onDeleteTap callback when delete option is tapped',
        (WidgetTester tester) async {
      bool deleteTapped = false;

      await tester.pumpWidget(
        createTestWidget(
          child: ProfilePhotoOptionsDialog(
            hasExistingPhoto: true,
            onGalleryTap: () {},
            onCameraTap: () {},
            onDeleteTap: () {
              deleteTapped = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete Photo'));
      await tester.pumpAndSettle();

      expect(deleteTapped, isTrue);
    });

    testWidgets('renders Arabic translations correctly when locale is ar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          locale: const Locale('ar'),
          child: ProfilePhotoOptionsDialog(
            hasExistingPhoto: true,
            onGalleryTap: () {},
            onCameraTap: () {},
            onDeleteTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('تحديث الصورة الشخصية'), findsOneWidget);
      expect(find.text('اختيار من المعرض'), findsOneWidget);
      expect(find.text('التقاط صورة'), findsOneWidget);
      expect(find.text('حذف الصورة الحالية'), findsOneWidget);
      expect(find.text('إلغاء'), findsOneWidget);
    });

    testWidgets('static show method opens bottom sheet and displays dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                ProfilePhotoOptionsDialog.show(
                  context,
                  hasExistingPhoto: true,
                  onGalleryTap: () {},
                  onCameraTap: () {},
                  onDeleteTap: () {},
                );
              },
              child: const Text('Open Dialog'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(ProfilePhotoOptionsDialog), findsOneWidget);
      expect(find.text('Update Profile Photo'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(ProfilePhotoOptionsDialog), findsNothing);
    });
  });
}
